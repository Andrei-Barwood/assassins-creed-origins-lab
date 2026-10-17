--[[============================================================================
  tactical_params.lua
  Matriz de 48 Parámetros Tácticos - Dron Sentinela mm (MITRE ATT&CK)
  Basado en: 'Estocástica Biomecánica y Fusión de Sensores: Análisis Predictivo'
============================================================================]]--

local M = {}

M.TACTICS = {
  { id = "TA0001", code = "RECON", name = "TA0001: RECONNAISSANCE & FMCW SENSOR FUSION", desc = "Adquisición mmWave (77-81 GHz) e inmunidad ante camuflaje termo-óptico y metamateriales." },
  { id = "TA0002", code = "TARGETING", name = "TA0002: TARGETING & EKF 12D KINEMATICS", desc = "Filtrado predictivo de Kalman extendido en espacio de estados de 12D con Gauss-Markov (tau)." },
  { id = "TA0003", code = "CHRONO", name = "TA0003: CHRONOMETRICS (72 BPM / 12 LPB)", desc = "Discretización temporal canónica a 69.44 ms/línea y reloj de servosistemas a 14.4 Hz." },
  { id = "TA0004", code = "HEX-ISOMORPH", name = "TA0004: HEXADECIMAL COMMAND ISOMORPHISM", desc = "Mapeo biyectivo entre comandos tracker (0Sxx, 0Rxy, 01xx, 05xx, B0xx) y física cinemática." },
  { id = "TA0005", code = "MODAL-SYNTH", name = "TA0005: MODAL SYNTHESIS (Euler-Bernoulli)", desc = "Síntesis física de percusión de mazos acústicos con ley de contacto no lineal de Hertz." },
  { id = "TA0006", code = "NEURO-PSYOPS", name = "TA0006: NEURO-ACOUSTIC PSYOPS & IACC", desc = "Seisillo biomecánico a 7.2 Hz, colapso del efecto Haas y valle inquietante con jitter 0.000 ms." },
  { id = "TA0007", code = "GRANULAR-MPC", name = "TA0007: GRANULAR MPC (Amen Break 96L)", desc = "Ventana de Markov de 96 líneas (6.66 s) y chopping granular para control locomotor cuadrúpedo." },
  { id = "TA0008", code = "EVASION", name = "TA0008: STOCHASTIC EVASION & BALLISTICS", desc = "Supresión de periodicidad de marcha, saltos de Lévy y divergencia de CEP ante artillería balística." }
}

-- Definición exhaustiva de los 48 parámetros
M.PARAMETERS = {
  -- TÁCTICA 1: RECONNAISSANCE (FMCW mmWave 77-81 GHz)
  { id = "T1011", tactic = 1, name = "Portadora FMCW mmWave", min = 77.0, max = 81.0, value = 77.0, step = 0.1, unit = "GHz",
    desc = "Frecuencia de emisión de microondas. Inmune a camuflaje termo-óptico de grafeno.", fx_map = "Nota base / Transposición oscilador radar" },
  { id = "T1012", tactic = 1, name = "Ancho de Barrido FMCW", min = 1.0, max = 4.0, value = 4.0, step = 0.1, unit = "GHz",
    desc = "Banda de modulación chirp. Determina la resolución métrica de distancia.", fx_map = "Profundidad de Pitch Slide 01xx / 02xx" },
  { id = "T1013", tactic = 1, name = "Penetración Dieléctrica", min = 0.1, max = 5.0, value = 0.2, step = 0.05, unit = "dB/km",
    desc = "Atenuación específica ante aerosoles de fósforo blanco y grafito bélico.", fx_map = "Filtro paso bajo / Resonancia dieléctrica" },
  { id = "T1014", tactic = 1, name = "Duración de Chirp Tc", min = 10, max = 100, value = 50, step = 1, unit = "μs",
    desc = "Período temporal de la rampa lineal de modulación de radiofrecuencia.", fx_map = "Micro-retardo de ráfaga y sub-tick delay" },
  { id = "T1015", tactic = 1, name = "Bins FFT Range-Doppler", min = 64, max = 512, value = 256, step = 64, unit = "bins",
    desc = "Resolución del análisis espectral de velocidad radial y distancia.", fx_map = "Segmentación de búfer 09xx / 0Sxx (256 sectores)" },
  { id = "T1016", tactic = 1, name = "Canales MIMO AoA (MUSIC)", min = 2, max = 16, value = 8, step = 1, unit = "canales",
    desc = "Elementos virtuales para cálculo interferométrico del ángulo de llegada.", fx_map = "Dispersión polifónica y apertura estéreo" },

  -- TÁCTICA 2: TARGETING (EKF 12D KINEMATICS)
  { id = "T1021", tactic = 2, name = "Constante de Maniobra Tau", min = 0.5, max = 10.0, value = 2.0, step = 0.1, unit = "s",
    desc = "Constante de tiempo de correlación de sobre-aceleración (Gauss-Markov).", fx_map = "Inercia de envolvente y persistencia de modulación" },
  { id = "T1022", tactic = 2, name = "Varianza de Ruido Q (Jerk)", min = 0.01, max = 1.00, value = 0.15, step = 0.01, unit = "m²/s⁵",
    desc = "Densidad espectral del ruido de proceso de sobre-aceleración.", fx_map = "Desviación estocástica de offsets y notas" },
  { id = "T1023", tactic = 2, name = "Varianza de Medición R", min = 0.01, max = 0.50, value = 0.05, step = 0.01, unit = "var",
    desc = "Incertidumbre térmica y de fase en los transceptores de radar.", fx_map = "Micro-jitter aleatorio e interpolación" },
  { id = "T1024", tactic = 2, name = "Ganancia de Kalman Kk", min = 0.0, max = 1.0, value = 0.65, step = 0.01, unit = "coef",
    desc = "Ponderación entre predicción inercial y residuo de medición nu_k.", fx_map = "Peso de modulación directa en automatizaciones" },
  { id = "T1025", tactic = 2, name = "Forma Simétrica Joseph", min = 0, max = 1, value = 1, step = 1, unit = "bool",
    desc = "Garantiza definición positiva de covarianza P ante redondeo flotante.", fx_map = "Estabilizador numérico de bucle de control" },
  { id = "T1026", tactic = 2, name = "Gating de Innovación Nu", min = 1.0, max = 10.0, value = 3.5, step = 0.1, unit = "sigma",
    desc = "Umbral Chi-cuadrado para descartar contramedidas electrónicas enemigas.", fx_map = "Filtro supresor de disparos anómalos" },

  -- TÁCTICA 3: CHRONOMETRICS (72 BPM / 12 LPB)
  { id = "T1031", tactic = 3, name = "Tempo Canónico Maestro", min = 32, max = 180, value = 72, step = 1, unit = "BPM",
    desc = "Tempo canónico militar de la matriz estocástica (transport.bpm).", fx_map = "transport.bpm directo en Renoise" },
  { id = "T1032", tactic = 3, name = "Líneas por Pulso (LPB)", min = 4, max = 32, value = 12, step = 1, unit = "LPB",
    desc = "Cuantización vertical que genera exactamente 69.44 ms por línea.", fx_map = "transport.lpb directo en Renoise" },
  { id = "T1033", tactic = 3, name = "Ticks por Línea (TPL)", min = 1, max = 16, value = 16, step = 1, unit = "TPL",
    desc = "Subdivisión interna que produce micro-ticks de 4.34 milisegundos.", fx_map = "transport.tpl directo en Renoise" },
  { id = "T1034", tactic = 3, name = "Duración de Línea Delta t", min = 10.0, max = 200.0, value = 69.44, step = 0.01, unit = "ms",
    desc = "Paso discreto de cálculo inercial (60000 / (BPM * LPB)).", fx_map = "Período temporal del paso matricial" },
  { id = "T1035", tactic = 3, name = "Micro-retardo Hex Sub-tick", min = 0x00, max = 0xFF, value = 0x80, step = 1, unit = "hex",
    desc = "Alineación sub-temporal de 00 a FF (0 a 69.17 ms sin alterar el reloj).", fx_map = "Columna Delay de la línea en tracker" },
  { id = "T1036", tactic = 3, name = "Frecuencia Servosistemas", min = 5.0, max = 50.0, value = 14.4, step = 0.1, unit = "Hz",
    desc = "Ancho de banda pasante de orientación de toberas y gimbales (1/Delta t).", fx_map = "Tasa de refresco del bucle en vivo" },

  -- TÁCTICA 4: HEX COMMAND ISOMORPHISM
  { id = "T1041", tactic = 4, name = "Vector B0xx: Interrupción", min = 0x00, max = 0x10, value = 0x00, step = 1, unit = "hex",
    desc = "Salto de patrón inmediato ante fijación de radar adversario.", fx_map = "Comando B0xx en columna de efectos" },
  { id = "T1042", tactic = 4, name = "Vector 01xx/02xx: Chirp Jam", min = 0x01, max = 0x40, value = 0x18, step = 1, unit = "hex",
    desc = "Barrido lineal continuo para interferencia de enlaces enemigos.", fx_map = "Pitch Slide Up 01xx / Down 02xx" },
  { id = "T1043", tactic = 4, name = "Vector 03xx/05xx: Gimbal Glide", min = 0x01, max = 0x7F, value = 0x24, step = 1, unit = "hex",
    desc = "Aceleración angular yaw/pitch sin fatiga estructural del fuselaje.", fx_map = "Glide continuo de tono 03xx / 05xx" },
  { id = "T1044", tactic = 4, name = "Vector 09xx: Apertura Correlador", min = 0x00, max = 0xFF, value = 0x40, step = 1, unit = "hex",
    desc = "Ventana de recepción FMCW para filtrar retornos fuera de rango.", fx_map = "Sample Offset porcentual 09xx" },
  { id = "T1045", tactic = 4, name = "Vector 0Lxx: Acople EKF-BLDC", min = 0x00, max = 0xFF, value = 0x64, step = 1, unit = "hex",
    desc = "Enlace de innovación RMSE a potencia motora de propulsores.", fx_map = "Modulación de destino de envolvente 0Lxx" },
  { id = "T1046", tactic = 4, name = "Vector 0Rxy: Retrigger Fricción", min = 0x01, max = 0x7F, value = 0x32, step = 1, unit = "hex",
    desc = "Micro-pulsos de par actuador para recuperación de tracción por corte.", fx_map = "Retrigger 0Rxy con modulación x e intervalo y" },

  -- TÁCTICA 5: MODAL SYNTHESIS (Euler-Bernoulli & Hertz)
  { id = "T1051", tactic = 5, name = "Exponente de Hertz (p)", min = 1.0, max = 2.5, value = 1.5, step = 0.05, unit = "exp",
    desc = "No linealidad elástica en la fuerza de impacto del mazo virtual.", fx_map = "Curva de velocidad dinámica de percusión" },
  { id = "T1052", tactic = 5, name = "Rigidez Elástica k", min = 1.0, max = 100.0, value = 45.0, step = 1.0, unit = "kN/m^p",
    desc = "Constante de contacto Hertziano. Regula dureza del impacto.", fx_map = "Corte de frecuencia inicial del mazo" },
  { id = "T1053", tactic = 5, name = "Amortiguamiento Viscoelástico", min = 0.01, max = 1.00, value = 0.12, step = 0.01, unit = "coef",
    desc = "Disipación de energía viscosa en la deformación del percutor.", fx_map = "Decaimiento (Decay) de los parciales" },
  { id = "T1054", tactic = 5, name = "Inarmonicidad Modal (Ratios)", min = 1.0, max = 8.0, value = 2.75, step = 0.05, unit = "ratio",
    desc = "Relación de frecuencias secundarias no enteras (2.75x, 5.48x de barra).", fx_map = "Afinación inarmónica de osciladores" },
  { id = "T1055", tactic = 5, name = "Material Resonador", min = 1, max = 3, value = 1, step = 1, unit = "mat",
    desc = "1: Palisandro Honduras (cálido), 2: Duraluminio (metálico), 3: Latón.", fx_map = "Selección de tímbrica y brillo modal" },
  { id = "T1056", tactic = 5, name = "Dispersión Impact Chomp", min = 0.0, max = 1.0, value = 0.35, step = 0.02, unit = "mix",
    desc = "Micro-ruido de fricción inicial de fieltro (pistas de organicidad).", fx_map = "Inyección de ruido blanco en transiente de ataque" },

  -- TÁCTICA 6: NEURO-PSYOPS & IACC
  { id = "T1061", tactic = 6, name = "Cadencia Seisillo Biomecánico", min = 3.6, max = 14.4, value = 7.2, step = 0.1, unit = "Hz",
    desc = "Disparo exacto cada 2 líneas a 12 LPB (7.2 pulsos por segundo).", fx_map = "Paso métrico de notas de mazo en líneas pares" },
  { id = "T1062", tactic = 6, name = "Jitter Determinista (Uncanny)", min = 0.0, max = 0.0, value = 0.0, step = 0.0, unit = "ms",
    desc = "Jitter temporal estrictamente 0.000 ms. Desata disonancia cognitiva.", fx_map = "Cuantización matemática absoluta sin histéresis" },
  { id = "T1063", tactic = 6, name = "Rise Time del Transiente", min = 1, max = 20, value = 3, step = 1, unit = "ms",
    desc = "Tiempo de subida inferior a 12 ms para activar Acoustic Startle Reflex.", fx_map = "Ataque instantáneo sin suavizado de fase" },
  { id = "T1064", tactic = 6, name = "Conmutación Espacial IACC", min = 0, max = 1, value = 1, step = 1, unit = "bool",
    desc = "Alterna panorama binaural a 14.4 transiciones/segundo.", fx_map = "Valores de paneo 0x10, 0x70, 0x40, fase opuesta" },
  { id = "T1065", tactic = 6, name = "Colapso del Efecto Haas", min = 0, max = 100, value = 85, step = 1, unit = "%",
    desc = "Destruye la capacidad del complejo olivar de triangular el dron.", fx_map = "Profundidad de inversión temporal interaural" },
  { id = "T1066", tactic = 6, name = "Índice Disonancia Neuro-Acústica", min = 0, max = 127, value = 96, step = 1, unit = "lvl",
    desc = "Presión psicoacústica sostenida en teatro de operaciones.", fx_map = "Volumen dinámico del canal de contramedidas" },

  -- TÁCTICA 7: GRANULAR MPC (Amen Break 96L)
  { id = "T1071", tactic = 7, name = "Ventana de Markov (Horizonte)", min = 16, max = 256, value = 96, step = 16, unit = "líneas",
    desc = "Horizonte cerrado de 96 líneas = 8 pulsos = 6.66 s para algoritmo MPC.", fx_map = "number_of_lines del patrón táctico en Renoise" },
  { id = "T1072", tactic = 7, name = "Sector 0S00: Bombo / GRF", min = 0x00, max = 0x1F, value = 0x00, step = 1, unit = "hex",
    desc = "Contacto de fuerza con el suelo (Ground Reaction Force) y avance.", fx_map = "Sample Offset 0S00 en golpes de bombo" },
  { id = "T1073", tactic = 7, name = "Sector 0S40: Caja / Choque", min = 0x20, max = 0x5F, value = 0x40, step = 1, unit = "hex",
    desc = "Amortiguamiento viscoelástico activo en aterrizaje de extremidad.", fx_map = "Sample Offset 0S40 en transientes de caja" },
  { id = "T1074", tactic = 7, name = "Sector 0S80: Contratiempo", min = 0x60, max = 0x9F, value = 0x80, step = 1, unit = "hex",
    desc = "Bombo desplazado para tracción asimétrica y quiebre de inercia.", fx_map = "Sample Offset 0S80 en síncopa de compás 2" },
  { id = "T1075", tactic = 7, name = "Sector 0Sc0: Redoble / Swing", min = 0xA0, max = 0xDF, value = 0xC0, step = 1, unit = "hex",
    desc = "Transientes asimétricos de pata oscilante en búsqueda de apoyo.", fx_map = "Sample Offset 0Sc0 en cierre de ventana" },
  { id = "T1076", tactic = 7, name = "Ghost Notes / Encoders", min = 0x01, max = 0x30, value = 0x1A, step = 1, unit = "hex",
    desc = "Micro-intensidades de palpación de terreno en fase de vuelo distal.", fx_map = "Volumen bajo en notas fantasma intermedias" },

  -- TÁCTICA 8: STOCHASTIC EVASION & BALLISTICS
  { id = "T1081", tactic = 8, name = "Supresión Autocorrelación", min = 0, max = 100, value = 95, step = 1, unit = "%",
    desc = "Colapso de picos periódicos hacia ruido blanco de marcha.", fx_map = "Aleatorización micro-métrica de zancada" },
  { id = "T1082", tactic = 8, name = "Saltos de Lévy (Alfa)", min = 1.0, max = 2.0, value = 1.45, step = 0.05, unit = "alfa",
    desc = "Difusión no gaussiana que quiebra algoritmos de guía proporcional.", fx_map = "Inyección de micro-desfases en transientes" },
  { id = "T1083", tactic = 8, name = "Divergencia CEP Enemigo", min = 1.0, max = 50.0, value = 22.4, step = 0.5, unit = "m",
    desc = "Error Circular Probable inducido a cañones balísticos hostiles.", fx_map = "Estimador de degradación de puntería enemiga" },
  { id = "T1084", tactic = 8, name = "Antirresonancia Chasis", min = 0, max = 1, value = 1, step = 1, unit = "bool",
    desc = "Desintonización armónica para evitar fatiga destructiva de titanio.", fx_map = "Supresión de acoplamiento modal en líneas de bajo" },
  { id = "T1085", tactic = 8, name = "Micro-par Cizallante (0Rxy)", min = 0x01, max = 0x7F, value = 0x32, step = 1, unit = "hex",
    desc = "Retrigger anti-deslizamiento ante pérdida de fricción estática.", fx_map = "Disparo de comando 0R32 de emergencia" },
  { id = "T1086", tactic = 8, name = "Estado Autónomo de Combate", min = 1, max = 4, value = 2, step = 1, unit = "modo",
    desc = "1: STANDBY/PATROL, 2: INTERCEPT_FMCW, 3: PSYOPS_SEISILLO, 4: EVASION_LEVY", fx_map = "Orquestador global de intercepción táctica" }
}

-- Mapa rápido por ID
M.PARAM_MAP = {}
for i, p in ipairs(M.PARAMETERS) do
  M.PARAM_MAP[p.id] = p
end

-- Presets Tácticos Preconfigurados
M.PRESETS = {
  {
    name = "1. Patrulla Estocástica Estándar",
    desc = "Régimen nominal de vigilancia. Tempo canónico 72 BPM, 12 LPB, EKF equilibrado y seisillo suave.",
    values = {
      T1011 = 77.0, T1012 = 2.0, T1014 = 50, T1021 = 3.0, T1022 = 0.08, T1024 = 0.50,
      T1031 = 72, T1032 = 12, T1033 = 16, T1055 = 1, T1061 = 7.2, T1064 = 1, T1065 = 60,
      T1071 = 96, T1081 = 80, T1082 = 1.70, T1086 = 1
    }
  },
  {
    name = "2. Intercepción Radar FMCW 77 GHz",
    desc = "Fijación activa mmWave. Chirp de 4 GHz, EKF con alta ganancia Kalman K y barrido RF de interferencia.",
    values = {
      T1011 = 77.0, T1012 = 4.0, T1015 = 256, T1021 = 1.2, T1022 = 0.25, T1024 = 0.85,
      T1042 = 0x20, T1043 = 0x38, T1045 = 0x80, T1064 = 1, T1071 = 96, T1082 = 1.45, T1086 = 2
    }
  },
  {
    name = "3. Ataque Psicoacústico (Colapso Haas / IACC)",
    desc = "Neutralización sensorial no letal. Seisillo modal de mazos a 7.2 Hz sin jitter, colapso Haas y Startle Reflex.",
    values = {
      T1051 = 1.5, T1052 = 60.0, T1054 = 2.75, T1056 = 0.60, T1061 = 7.2, T1062 = 0.0,
      T1063 = 2, T1064 = 1, T1065 = 100, T1066 = 120, T1071 = 96, T1086 = 3
    }
  },
  {
    name = "4. Evasión Balística Amen Break (Saltos de Lévy)",
    desc = "Deconstrucción extrema del Amen Break (0Sxx/0Rxy). Supresión total de periodicidad y divergencia de CEP enemigo.",
    values = {
      T1046 = 0x42, T1071 = 96, T1072 = 0x00, T1073 = 0x40, T1074 = 0x80, T1075 = 0xC0,
      T1076 = 0x22, T1081 = 100, T1082 = 1.20, T1083 = 35.0, T1085 = 0x42, T1086 = 4
    }
  },
  {
    name = "5. Combate Hiper-Dinámico (Jerk Máximo)",
    desc = "Fusión cinemática total. Sobre-aceleración extrema, toberas de 14.4 Hz al límite e interrupción B000 activa.",
    values = {
      T1012 = 4.0, T1021 = 0.8, T1022 = 0.50, T1024 = 0.90, T1041 = 0x01, T1042 = 0x30,
      T1043 = 0x50, T1045 = 0xC8, T1065 = 90, T1082 = 1.30, T1083 = 45.0, T1086 = 2
    }
  }
}

function M.get(id)
  local p = M.PARAM_MAP[id]
  return p and p.value or nil
end

function M.set(id, val)
  local p = M.PARAM_MAP[id]
  if p then
    if val < p.min then val = p.min end
    if val > p.max then val = p.max end
    p.value = val
    return p.value
  end
  return nil
end

function M.apply_preset(index)
  local preset = M.PRESETS[index]
  if not preset then return false end
  for k, v in pairs(preset.values) do
    M.set(k, v)
  end
  return true
end

return M
