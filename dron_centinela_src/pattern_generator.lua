--[[============================================================================
  pattern_generator.lua
  Generación e Inyección de Patrones Tácticos de 96 Líneas (Markov MPC)
  Basado en Capítulos 2, 3 y 4 de la tesis del Dron Centinela
============================================================================]]--

local M = {}

local TRACK_NAMES = {
  AMEN = "TAC_AMEN_MPC",
  MALLET = "TAC_SEISILLO_MALLET",
  RADAR = "TAC_FMCW_RADAR",
  TELEMETRY = "TAC_EKF_TELEMETRY"
}

local TRACK_COLORS = {
  AMEN = { 0xF5, 0x2D, 0x56 },      -- Magenta táctico
  MALLET = { 0x00, 0xD2, 0xFF },    -- Cyan sónico
  RADAR = { 0x26, 0xFF, 0x75 },     -- Verde microondas
  TELEMETRY = { 0xFF, 0xBA, 0x00 }  -- Ámbar EKF
}

-- Busca o crea una pista dedicada asegurando columnas visibles
local function get_or_create_track(song, name, color)
  for idx, tr in ipairs(song.tracks) do
    if tr.name == name then
      tr.visible_note_columns = math.max(1, tr.visible_note_columns)
      tr.visible_effect_columns = math.max(1, tr.visible_effect_columns)
      return idx, tr
    end
  end

  local insert_idx = song.sequencer_track_count + 1
  local tr = song:insert_track_at(insert_idx)
  if not tr then
    tr = song.tracks[insert_idx]
  end
  if tr then
    tr.name = name
    if color then
      tr.color = color
    end
    tr.visible_note_columns = 1
    tr.visible_effect_columns = 1
  end
  return insert_idx, tr
end

-- Inicializa el entorno métrico canónico (72 BPM, 12 LPB, 16 TPL) y crea las 4 pistas tácticas
function M.init_canonical_environment(params)
  local song = renoise.song()
  if not song then return false, "No hay proyecto activo en Renoise." end

  song:describe_undo("Dron Sentinela: Inicializar Entorno Canónico")

  -- 1. Fijar métrica temporal de combate
  local bpm = math.floor(params.get("T1031") or 72)
  local lpb = math.floor(params.get("T1032") or 12)
  local tpl = math.floor(params.get("T1033") or 16)

  song.transport.bpm = bpm
  song.transport.lpb = lpb
  song.transport.tpl = tpl

  -- 2. Asegurar pistas de combate
  local amen_idx, _ = get_or_create_track(song, TRACK_NAMES.AMEN, TRACK_COLORS.AMEN)
  local mallet_idx, _ = get_or_create_track(song, TRACK_NAMES.MALLET, TRACK_COLORS.MALLET)
  local radar_idx, _ = get_or_create_track(song, TRACK_NAMES.RADAR, TRACK_COLORS.RADAR)
  local telem_idx, _ = get_or_create_track(song, TRACK_NAMES.TELEMETRY, TRACK_COLORS.TELEMETRY)

  -- 3. Configurar longitud del patrón actual a 96 líneas
  local cur_pattern_idx = song.selected_pattern_index
  local pat = song.patterns[cur_pattern_idx]
  local markov_len = math.floor(params.get("T1071") or 96)
  if pat then
    pat.number_of_lines = markov_len
  end

  local msg = string.format("Entorno Canónico fijado: %d BPM, %d LPB (Delta t = %.2f ms, 14.4 Hz), 4 pistas tácticas listas.",
    bpm, lpb, 60000 / (bpm * lpb))
  renoise.app():show_status(msg)
  return true, msg
end

-- Inyecta la matriz completa de 96 líneas con comandos hexadecimales en el patrón seleccionado
function M.inject_tactical_pattern(params)
  local song = renoise.song()
  if not song then return false, "No hay canción activa." end

  song:describe_undo("Dron Sentinela: Inyectar Matriz Táctica 96L")

  local pat_idx = song.selected_pattern_index
  local pat = song.patterns[pat_idx]
  if not pat then return false, "Patrón no encontrado." end

  local num_lines = math.floor(params.get("T1071") or 96)
  pat.number_of_lines = num_lines

  -- Asegurar pistas
  local amen_idx, _ = get_or_create_track(song, TRACK_NAMES.AMEN, TRACK_COLORS.AMEN)
  local mallet_idx, _ = get_or_create_track(song, TRACK_NAMES.MALLET, TRACK_COLORS.MALLET)
  local radar_idx, _ = get_or_create_track(song, TRACK_NAMES.RADAR, TRACK_COLORS.RADAR)
  local telem_idx, _ = get_or_create_track(song, TRACK_NAMES.TELEMETRY, TRACK_COLORS.TELEMETRY)

  local tr_amen = pat:track(amen_idx)
  local tr_mallet = pat:track(mallet_idx)
  local tr_radar = pat:track(radar_idx)
  local tr_telem = pat:track(telem_idx)

  -- Limpiar líneas existentes en las 4 pistas
  for l = 1, num_lines do
    tr_amen:line(l):clear()
    tr_mallet:line(l):clear()
    tr_radar:line(l):clear()
    tr_telem:line(l):clear()
  end

  ------------------------------------------------------------------------------
  -- 1. PISTA AMEN BREAK CHOPEADO (LOCOMOCIÓN CUADRÚPEDA ASIMÉTRICA)
  ------------------------------------------------------------------------------
  local s_kick = string.format("%02X", math.floor(params.get("T1072") or 0x00))
  local s_snare = string.format("%02X", math.floor(params.get("T1073") or 0x40))
  local s_offset_kick = string.format("%02X", math.floor(params.get("T1074") or 0x80))
  local s_roll = string.format("%02X", math.floor(params.get("T1075") or 0xC0))
  local ghost_vol = math.floor(params.get("T1076") or 0x1A)
  local retrigger_code = string.format("%02X", math.floor(params.get("T1046") or 0x32))

  -- Eventos clave de zancada en la ventana de 96 líneas
  local amen_events = {
    [1]  = { note = "C-4", fx_num = "0S", fx_amt = s_kick, desc = "Bombo / GRF" },
    [7]  = { note = "C-4", vol = ghost_vol, delay = 0x40, desc = "Ghost note" },
    [13] = { note = "C-4", vol = ghost_vol + 4, delay = 0x80, desc = "Ghost note" },
    [25] = { note = "C-4", fx_num = "0S", fx_amt = s_snare, desc = "Caja / Choque" },
    [37] = { note = "C-4", vol = ghost_vol, delay = 0x20, desc = "Ride feeler" },
    [43] = { note = "C-4", vol = ghost_vol + 2, delay = 0x60, desc = "Ghost note" },
    [49] = { note = "C-4", fx_num = "0S", fx_amt = s_offset_kick, desc = "Bombo asimétrico" },
    [55] = { note = "C-4", vol = ghost_vol, delay = 0x40, desc = "Ghost note" },
    [61] = { note = "C-4", fx_num = "0S", fx_amt = s_snare, desc = "Caja respuesta" },
    [73] = { note = "C-4", fx_num = "0S", fx_amt = s_roll, desc = "Redoble roll" },
    [75] = { note = "C-4", fx_num = "0R", fx_amt = retrigger_code, desc = "Retrigger 0Rxy" },
    [85] = { note = "C-4", fx_num = "0S", fx_amt = "C2", desc = "Roll sincopado" },
    [87] = { note = "C-4", fx_num = "0R", fx_amt = "92", desc = "Retrigger cresc." },
    [96] = { note = "C-4", vol = 0x40, delay = 0xFE, fx_num = "0R", fx_amt = "11", desc = "Cierre horizonte" }
  }

  for line_num, ev in pairs(amen_events) do
    if line_num <= num_lines then
      local line = tr_amen:line(line_num)
      local ncol = line:note_column(1)
      local ecol = line:effect_column(1)
      if ev.note then ncol.note_string = ev.note end
      if ev.vol then ncol.volume_value = ev.vol end
      if ev.delay then ncol.delay_value = ev.delay end
      if ev.fx_num then ecol.number_string = ev.fx_num end
      if ev.fx_amt then ecol.amount_string = ev.fx_amt end
    end
  end

  ------------------------------------------------------------------------------
  -- 2. PISTA SEISILLO BIOMECÁNICO (SÍNTESIS MODAL & COLAPSO IACC/HAAS)
  ------------------------------------------------------------------------------
  -- Frecuencia 7.2 Hz = Activación estricta cada 2 líneas (líneas impares 1-indexed: 1, 3, 5, 7, ... 95)
  -- Paneo alternante a 14.4 transiciones/s para demoler la triangulación del complejo olivar superior
  local modal_pitches = { "D-3", "F-3", "A-3", "C-4", "E-4", "G-4", "D-4", "A-4" }
  local pan_patterns = {
    0x10, -- Extremo izquierdo
    0x70, -- Extremo derecho
    0x40, -- Centro focal
    0x10, -- Extremo izquierdo con inversión
    0x70, -- Extremo derecho con inversión
    0x40  -- Centro
  }

  local sixillo_step = 2
  local note_idx = 1
  for l = 1, num_lines, sixillo_step do
    local line = tr_mallet:line(l)
    local ncol = line:note_column(1)
    local ecol = line:effect_column(1)

    ncol.note_string = modal_pitches[((note_idx - 1) % #modal_pitches) + 1]
    ncol.volume_value = math.floor(params.get("T1066") or 96)

    -- Colapso IACC: Alternancia binaural
    local pan_val = pan_patterns[((math.floor((l - 1) / 2)) % #pan_patterns) + 1]
    ncol.panning_value = pan_val

    -- Inyección de micro-deslizamiento pitch slide para desorientación de fase
    if (l % 12 == 7) then
      ecol.number_string = "01"
      ecol.amount_string = "04"
    elseif (l % 12 == 1) then
      ecol.number_string = "02"
      ecol.amount_string = "04"
    end

    note_idx = note_idx + 1
  end

  ------------------------------------------------------------------------------
  -- 3. PISTA RADAR FMCW (BARRIDO CHIRP 77-81 GHz & CONTRAMEDIDAS)
  ------------------------------------------------------------------------------
  local radar_sweep = string.format("%02X", math.floor(params.get("T1042") or 0x18))
  local radar_corr = string.format("%02X", math.floor(params.get("T1044") or 0x40))
  local radar_bldc = string.format("%02X", math.floor(params.get("T1045") or 0x64))

  local radar_events = {
    [1]  = { note = "A-4", fx_num = "01", fx_amt = radar_sweep }, -- Rampa ascendente chirp
    [25] = { note = "A-4", fx_num = "02", fx_amt = radar_sweep }, -- Rampa descendente chirp
    [49] = { note = "A-4", fx_num = "09", fx_amt = radar_corr },  -- Ventana correlador FMCW
    [73] = { note = "A-4", fx_num = "0L", fx_amt = radar_bldc },  -- Enlace EKF a BLDC
    [95] = { note = "OFF" }
  }

  for line_num, ev in pairs(radar_events) do
    if line_num <= num_lines then
      local line = tr_radar:line(line_num)
      local ncol = line:note_column(1)
      local ecol = line:effect_column(1)
      if ev.note then ncol.note_string = ev.note end
      if ev.fx_num then ecol.number_string = ev.fx_num end
      if ev.fx_amt then ecol.amount_string = ev.fx_amt end
    end
  end

  ------------------------------------------------------------------------------
  -- 4. PISTA TELEMETRÍA EKF / SUB-BASS GRF (CINEMÁTICA Y EVASIÓN)
  ------------------------------------------------------------------------------
  local gimbal_slew = string.format("%02X", math.floor(params.get("T1043") or 0x24))
  local interrupt_b0 = string.format("%02X", math.floor(params.get("T1041") or 0x00))

  local telem_events = {
    [1]  = { note = "C-2", vol = 0x7F, desc = "Impulso GRF Inicial" },
    [25] = { note = "G-1", vol = 0x68, desc = "Estabilización Gimbal" },
    [49] = { note = "D-2", vol = 0x75, desc = "Vector Asimétrico" },
    [73] = { note = "F-2", vol = 0x70, fx_num = "05", fx_amt = gimbal_slew, desc = "Portamento Gimbal" },
    [96] = { fx_num = "B0", fx_amt = interrupt_b0, desc = "Salto de Interrupción B0xx" }
  }

  for line_num, ev in pairs(telem_events) do
    if line_num <= num_lines then
      local line = tr_telem:line(line_num)
      local ncol = line:note_column(1)
      local ecol = line:effect_column(1)
      if ev.note then ncol.note_string = ev.note end
      if ev.vol then ncol.volume_value = ev.vol end
      if ev.fx_num then ecol.number_string = ev.fx_num end
      if ev.fx_amt then ecol.amount_string = ev.fx_amt end
    end
  end

  local msg = string.format("Matriz Táctica inyectada: Patrón %d (%d líneas). Amen Chopped, Seisillo 7.2Hz, FMCW Radar y EKF Telemetría listos.",
    pat_idx - 1, num_lines)
  renoise.app():show_status(msg)
  return true, msg
end

return M
