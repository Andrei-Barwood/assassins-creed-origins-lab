--[[============================================================================
  live_tracker_modulator.lua
  Motor de Ejecución Táctica en Tiempo Real (Tracker en Movimiento)
  Basado en la integración estocástica continua-discreta del Dron Centinela
============================================================================]]--

local EKF = require("ekf_engine")

local M = {}

M.is_active = false
M.last_line = -1
M.last_seq = -1
M.current_telemetry = {}
M.gui_notifier = nil

local IACC_CYCLE = { 0.15, 0.85, 0.50, 0.10, 0.90, 0.50 }
local iacc_index = 1

function M.toggle(params)
  M.is_active = not M.is_active
  if M.is_active then
    EKF.init()
    M.last_line = -1
    renoise.app():show_status(">> DRON CENTINELA: Motor táctico en vivo ACTIVADO <<")
  else
    renoise.app():show_status(">> DRON CENTINELA: Motor táctico en vivo DESACTIVADO <<")
  end
  return M.is_active
end

function M.set_gui_notifier(fn)
  M.gui_notifier = fn
end

-- Llamado en cada ciclo de app_idle_observable
function M.on_idle(params)
  local song = renoise.song()
  if not song then return end

  local transport = song.transport
  local is_playing = transport.playing

  if not M.is_active then
    if M.gui_notifier then
      M.gui_notifier({
        is_active = false,
        is_playing = is_playing,
        line = is_playing and transport.playback_pos.line or 1,
        sequence = is_playing and transport.playback_pos.sequence or 1,
        telemetry = EKF.telemetry
      })
    end
    return
  end

  if not is_playing then
    if M.gui_notifier then
      M.gui_notifier({
        is_active = true,
        is_playing = false,
        line = transport.playback_pos.line,
        sequence = transport.playback_pos.sequence,
        telemetry = EKF.telemetry
      })
    end
    return
  end

  -- El tracker está en movimiento: Verificar avance de línea
  local pos = transport.playback_pos
  if pos.line ~= M.last_line or pos.sequence ~= M.last_seq then
    M.last_line = pos.line
    M.last_seq = pos.sequence

    -- 1. Calcular Delta t real de la línea actual
    local bpm = transport.bpm
    local lpb = transport.lpb
    local dt_ms = 60000.0 / (bpm * lpb)

    -- 2. Ejecutar paso del Filtro de Kalman Extendido (EKF 12D)
    local telem = EKF.step(dt_ms, params)
    M.current_telemetry = telem

    -- 3. APLICAR MODULACIONES TÁCTICAS EN EL TRACKER EN MOVIMIENTO
    local zero_based_line = pos.line - 1

    -- (A) Modulación Binaural IACC en vivo (Colapso Haas a 14.4 Hz)
    local use_iacc = (params.get("T1064") or 1) == 1
    if use_iacc and (zero_based_line % 2 == 0) then
      iacc_index = (iacc_index % #IACC_CYCLE) + 1
      local target_pan = IACC_CYCLE[iacc_index]
      -- Modula el paneo de la pista de mazos si existe
      for _, tr in ipairs(song.tracks) do
        if tr.name == "TAC_SEISILLO_MALLET" then
          tr.panning.value = target_pan
          break
        end
      end
    end

    -- (B) Acoplamiento Dinámico EKF a Potencia BLDC (Comando 0Lxx)
    local bldc_weight = (params.get("T1045") or 0x64) / 255.0
    local norm_innov = math.min(1.0, telem.innovation_norm / 10.0)
    for _, tr in ipairs(song.tracks) do
      if tr.name == "TAC_FMCW_RADAR" then
        -- Modula volumen entre 0.6 y 0.95 en base a la innovación del blanco
        local target_vol = 0.60 + 0.35 * (norm_innov * bldc_weight)
        tr.volume.value = target_vol
        break
      end
    end

    -- (C) Telemetría viva a la interfaz gráfica
    if M.gui_notifier then
      M.gui_notifier({
        is_active = true,
        is_playing = true,
        line = pos.line,
        sequence = pos.sequence,
        dt_ms = dt_ms,
        telemetry = telem,
        iacc_phase = (iacc_index == 1 and "L (-100%)" or (iacc_index == 2 and "R (+100%)" or "C (0%)"))
      })
    end
  end
end

return M
