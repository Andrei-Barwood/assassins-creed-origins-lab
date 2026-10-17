--[[============================================================================
  ekf_engine.lua
  Filtro de Kalman Extendido (EKF) de 12 Dimensiones & Dinámica de Gauss-Markov
  Basado en Capítulos 1.3 y 1.4 de la tesis del Dron Centinela
============================================================================]]--

local M = {}

-- Compatibilidad universal atan2 (Lua 5.1 / LuaJIT / Lua 5.3+)
local function atan2(y, x)
  if math.atan2 then
    return math.atan2(y, x)
  else
    return math.atan(y, x)
  end
end

-- Estado cinemático 12D:
-- 1: x,  2: y,  3: z  (Posición cartesiana, m)
-- 4: vx, 5: vy, 6: vz (Velocidad lineal, m/s)
-- 7: ax, 8: ay, 9: az (Aceleración, m/s²)
-- 10: jx, 11: jy, 12: jz (Sobre-aceleración / Jerk, m/s³)

M.state = {
  x = 120.0, y = 85.0, z = 45.0,
  vx = -12.5, vy = 8.2, vz = -1.5,
  ax = 2.4, ay = -1.8, az = 0.5,
  jx = -0.8, jy = 1.2, jz = -0.3
}

-- Covarianza del error de estimación P (diagonal inicial)
M.P_diag = {
  10.0, 10.0, 10.0,
  5.0,  5.0,  5.0,
  2.0,  2.0,  2.0,
  1.0,  1.0,  1.0
}

-- Telemetría de la última actualización
M.telemetry = {
  range = 0,
  azimuth_deg = 0,
  elevation_deg = 0,
  doppler_radial_vel = 0,
  jerk_magnitude = 0,
  innovation_norm = 0,
  kalman_gain_norm = 0,
  covariance_trace = 0,
  adversary_cep = 0,
  levy_jump = false
}

function M.init()
  M.state.x = 150.0 + (math.random() * 20 - 10)
  M.state.y = 90.0 + (math.random() * 20 - 10)
  M.state.z = 50.0 + (math.random() * 10 - 5)
  M.state.vx = -15.0
  M.state.vy = 10.0
  M.state.vz = -2.0
  M.state.ax = 1.5
  M.state.ay = -1.0
  M.state.az = 0.2
  M.state.jx = 0.0
  M.state.jy = 0.0
  M.state.jz = 0.0

  for i = 1, 12 do
    M.P_diag[i] = (i <= 3) and 10.0 or ((i <= 6) and 5.0 or ((i <= 9) and 2.0 or 1.0))
  end
end

-- Simulación de número pseudo-aleatorio Gaussiano (Box-Muller)
local function random_gaussian(mean, std)
  local u1 = math.max(1e-7, math.random())
  local u2 = math.random()
  local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2)
  return mean + z0 * std
end

-- Ejecuta un paso del EKF sincronizado con el intervalo Delta t de la línea tracker
function M.step(dt_ms, params)
  local dt = (dt_ms or 69.44) / 1000.0 -- Segundos
  local tau = params.get("T1021") or 2.0
  local Q_val = params.get("T1022") or 0.15
  local R_val = params.get("T1023") or 0.05
  local K_user = params.get("T1024") or 0.65
  local use_joseph = (params.get("T1025") or 1) == 1
  local alpha_levy = params.get("T1082") or 1.45

  -- Detección de perturbación por salto de Lévy (distribución de colas pesadas)
  local u = math.random()
  local levy_occurred = false
  local levy_scale = 1.0
  if u < 0.08 then -- Probabilidad de salto de Lévy en el transiente
    levy_occurred = true
    levy_scale = (1.0 / math.max(0.01, u)) ^ (1.0 / alpha_levy)
    if levy_scale > 15.0 then levy_scale = 15.0 end
  end
  M.telemetry.levy_jump = levy_occurred

  -- 1. FASE DE PREDICCIÓN TEMPORAL (Gauss-Markov en Jerk + Cinemática Taylor)
  local decay = math.max(0.0, 1.0 - (dt / tau))
  local q_noise = math.sqrt(Q_val * dt) * levy_scale

  -- Evolución estocástica de Jerk
  M.state.jx = decay * M.state.jx + random_gaussian(0, q_noise)
  M.state.jy = decay * M.state.jy + random_gaussian(0, q_noise)
  M.state.jz = decay * M.state.jz + random_gaussian(0, q_noise * 0.5)

  -- Integración de Aceleración
  M.state.ax = M.state.ax + M.state.jx * dt
  M.state.ay = M.state.ay + M.state.jy * dt
  M.state.az = M.state.az + M.state.jz * dt

  -- Integración de Velocidad
  M.state.vx = M.state.vx + M.state.ax * dt + 0.5 * M.state.jx * dt * dt
  M.state.vy = M.state.vy + M.state.ay * dt + 0.5 * M.state.jy * dt * dt
  M.state.vz = M.state.vz + M.state.az * dt + 0.5 * M.state.jz * dt * dt

  -- Integración de Posición
  M.state.x = M.state.x + M.state.vx * dt + 0.5 * M.state.ax * dt * dt + (1.0 / 6.0) * M.state.jx * dt^3
  M.state.y = M.state.y + M.state.vy * dt + 0.5 * M.state.ay * dt * dt + (1.0 / 6.0) * M.state.jy * dt^3
  M.state.z = M.state.z + M.state.vz * dt + 0.5 * M.state.az * dt * dt + (1.0 / 6.0) * M.state.jz * dt^3

  -- Propagación a priori de la covarianza de error P
  for i = 1, 12 do
    M.P_diag[i] = M.P_diag[i] + Q_val * dt
  end

  -- 2. MEDICIÓN SIMULADA DEL TRANSCAPTOR FMCW mmWave (Esféricas: r, theta, phi, Doppler)
  local r = math.sqrt(M.state.x^2 + M.state.y^2 + M.state.z^2)
  local r_xy = math.sqrt(M.state.x^2 + M.state.y^2)
  if r < 0.1 then r = 0.1 end
  if r_xy < 0.1 then r_xy = 0.1 end

  local theta = atan2(M.state.y, M.state.x)
  local phi = atan2(M.state.z, r_xy)
  local doppler = (M.state.x * M.state.vx + M.state.y * M.state.vy + M.state.z * M.state.vz) / r

  -- Medición con ruido gaussiano del sensor
  local r_noise = math.sqrt(R_val)
  local z_meas_r = r + random_gaussian(0, r_noise * 2.0)
  local z_meas_theta = theta + random_gaussian(0, r_noise * 0.01)
  local z_meas_phi = phi + random_gaussian(0, r_noise * 0.01)
  local z_meas_doppler = doppler + random_gaussian(0, r_noise * 0.5)

  -- 3. RESIDUO DE INNOVACIÓN nu_k
  local nu_r = z_meas_r - r
  local nu_theta = z_meas_theta - theta
  local nu_phi = z_meas_phi - phi
  local nu_doppler = z_meas_doppler - doppler

  local innovation_norm = math.sqrt(nu_r^2 + (nu_theta * r)^2 + (nu_phi * r)^2 + nu_doppler^2)

  -- 4. GANANCIA DE KALMAN Y ACTUALIZACIÓN A POSTERIORI
  -- Ponderación adaptativa: Ganancia óptima K modulada por K_user
  local k_gain = K_user * (M.P_diag[1] / (M.P_diag[1] + R_val + 1e-4))
  if k_gain > 0.95 then k_gain = 0.95 end

  -- Corrección de posición y velocidad por innovación
  M.state.x = M.state.x + k_gain * nu_r * math.cos(theta) * math.cos(phi)
  M.state.y = M.state.y + k_gain * nu_r * math.sin(theta) * math.cos(phi)
  M.state.z = M.state.z + k_gain * nu_r * math.sin(phi)
  M.state.vx = M.state.vx + k_gain * nu_doppler * math.cos(theta)
  M.state.vy = M.state.vy + k_gain * nu_doppler * math.sin(theta)

  -- 5. ACTUALIZACIÓN DE COVARIANZA (Forma simétrica de Joseph)
  for i = 1, 12 do
    if use_joseph then
      -- Forma de Joseph: (I - KH)*P*(I - KH)' + K*R*K' (mantiene positividad estricta)
      local one_minus_kh = (1.0 - k_gain * 0.5)
      M.P_diag[i] = one_minus_kh * M.P_diag[i] * one_minus_kh + (k_gain^2) * R_val
    else
      M.P_diag[i] = (1.0 - k_gain) * M.P_diag[i]
    end
    if M.P_diag[i] < 1e-4 then M.P_diag[i] = 1e-4 end
  end

  -- Traza de covarianza
  local cov_trace = 0
  for i = 1, 12 do cov_trace = cov_trace + M.P_diag[i] end

  -- Cálculo de Error Circular Probable (CEP) inducido al enemigo
  -- Basado en la magnitud del Jerk, saltos de Lévy y desintonización estocástica
  local jerk_mag = math.sqrt(M.state.jx^2 + M.state.jy^2 + M.state.jz^2)
  local base_cep = params.get("T1083") or 22.4
  local adversary_cep = base_cep * (1.0 + (jerk_mag / 5.0) * (levy_occurred and 2.5 or 1.0))

  -- Actualizar telemetría pública
  M.telemetry.range = r
  M.telemetry.azimuth_deg = math.deg(theta)
  M.telemetry.elevation_deg = math.deg(phi)
  M.telemetry.doppler_radial_vel = doppler
  M.telemetry.jerk_magnitude = jerk_mag
  M.telemetry.innovation_norm = innovation_norm
  M.telemetry.kalman_gain_norm = k_gain
  M.telemetry.covariance_trace = cov_trace
  M.telemetry.adversary_cep = adversary_cep

  return M.telemetry
end

return M
