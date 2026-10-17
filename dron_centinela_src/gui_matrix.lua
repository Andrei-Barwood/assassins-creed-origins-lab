--[[============================================================================
  gui_matrix.lua
  Interfaz Gráfica Renoise - Matriz Táctica MITRE ATT&CK Dron Centinela
  Basado en: 'Estocástica Biomecánica y Fusión de Sensores: Análisis Predictivo'
============================================================================]]--

local params = require("tactical_params")
local pattern_gen = require("pattern_generator")
local modulator = require("live_tracker_modulator")

local M = {}

local dialog = nil
local vb = nil
local current_tactic_tab = 1

-- Actualiza todos los controles de la UI tras cargar un preset o reiniciar
function M.refresh_ui_values()
  if not vb or not dialog or not dialog.visible then return end

  for _, p in ipairs(params.PARAMETERS) do
    local s_view = vb.views["slider_" .. p.id]
    local v_view = vb.views["vbox_" .. p.id]
    if s_view then s_view.value = p.value end
    if v_view then v_view.value = p.value end
  end
end

-- Callback de telemetría en tiempo real desde live_tracker_modulator
function M.on_telemetry_update(data)
  if not vb or not dialog or not dialog.visible then return end

  local lbl_engine = vb.views["lbl_engine_status"]
  local lbl_tracker = vb.views["lbl_tracker_status"]
  local lbl_pos = vb.views["lbl_playback_pos"]
  local lbl_ekf = vb.views["lbl_ekf_telemetry"]
  local lbl_psyops = vb.views["lbl_psyops_telemetry"]
  local lbl_locomotion = vb.views["lbl_locomotion_telemetry"]

  if lbl_engine then
    lbl_engine.text = data.is_active and "MOTOR TÁCTICO: [ EN LÍNEA / ACTIVO ]" or "MOTOR TÁCTICO: [ DESACTIVADO / STANDBY ]"
  end

  if lbl_tracker then
    lbl_tracker.text = data.is_playing and "TRACKER: [ EN MOVIMIENTO (14.4 Hz) ]" or "TRACKER: [ DETENIDO ]"
  end

  if lbl_pos then
    lbl_pos.text = string.format("Secuencia: %02d | Línea: %02d / 96 | Delta t: %.2f ms",
      data.sequence or 1, data.line or 1, data.dt_ms or 69.44)
  end

  if data.telemetry then
    local t = data.telemetry
    if lbl_ekf then
      lbl_ekf.text = string.format("EKF 12D -> R: %.1fm | Az: %.1f° | Dopp: %.1fm/s | Jerk: %.2fm/s³ | Nu: %.2f | Gain: %.2f",
        t.range or 0, t.azimuth_deg or 0, t.doppler_radial_vel or 0, t.jerk_magnitude or 0, t.innovation_norm or 0, t.kalman_gain_norm or 0)
    end
    if lbl_psyops then
      lbl_psyops.text = string.format("PSICOACÚSTICA -> Seisillo: 7.20 Hz | Jitter: 0.000 ms | IACC Fase: %s | Haas: %d%%",
        data.iacc_phase or "C (0%)", math.floor(params.get("T1065") or 85))
    end
    if lbl_locomotion then
      lbl_locomotion.text = string.format("LOCOMOCIÓN MPC -> Amen Slicing 96L | CEP Enemigo: %.1fm %s | P-Trace: %.2f",
        t.adversary_cep or 22.4, t.levy_jump and "[LÉVY FLIGHT DETECTADO]" or "", t.covariance_trace or 0)
    end
  end
end

-- Construcción de la tarjeta de control para un parámetro individual
local function build_parameter_card(p)
  local is_integer_param = (p.step == 1 and p.max > 1)
  local decimals = (p.step < 0.1) and 2 or ((p.step < 1) and 1 or 0)

  return vb:column {
    style = "group",
    margin = 4,
    spacing = 2,
    width = 370,

    vb:row {
      vb:text { text = "[" .. p.id .. "] " .. p.name, font = "bold", width = 230 },
      vb:text { text = tostring(p.unit), font = "italic", width = 50, align = "right" },
      vb:valuebox {
        id = "vbox_" .. p.id,
        min = p.min,
        max = p.max,
        value = p.value,
        steps = { p.step, p.step * 5 },
        tostring = function(val)
          return string.format("%." .. decimals .. "f", val)
        end,
        tonumber = function(str)
          return tonumber(str) or p.value
        end,
        width = 70,
        notifier = function(val)
          params.set(p.id, val)
          local s = vb.views["slider_" .. p.id]
          if s and math.abs(s.value - val) > 1e-4 then
            s.value = val
          end
        end
      }
    },

    vb:row {
      vb:slider {
        id = "slider_" .. p.id,
        min = p.min,
        max = p.max,
        value = p.value,
        width = 355,
        notifier = function(val)
          params.set(p.id, val)
          local v = vb.views["vbox_" .. p.id]
          if v and math.abs(v.value - val) > 1e-4 then
            v.value = val
          end
        end
      }
    },

    vb:text { text = p.desc, font = "normal", width = 355 },
    vb:text { text = "Mapeo Tracker: " .. p.fx_map, font = "italic", width = 355 }
  }
end

-- Construye la vista de una táctica específica
local function build_tactic_view(tactic_index)
  local tactic_info = params.TACTICS[tactic_index]
  local tactic_params = {}
  for _, p in ipairs(params.PARAMETERS) do
    if p.tactic == tactic_index then
      table.insert(tactic_params, p)
    end
  end

  local col1_views = { spacing = 4 }
  local col2_views = { spacing = 4 }

  for i, p in ipairs(tactic_params) do
    if i <= 3 then
      table.insert(col1_views, build_parameter_card(p))
    else
      table.insert(col2_views, build_parameter_card(p))
    end
  end

  local col1 = vb:column(col1_views)
  local col2 = vb:column(col2_views)

  return vb:column {
    id = "panel_tactic_" .. tactic_index,
    visible = (tactic_index == current_tactic_tab),
    margin = 4,
    spacing = 6,

    vb:column {
      style = "panel",
      margin = 6,
      width = 760,
      vb:text { text = tactic_info.name, font = "bold", width = 740 },
      vb:text { text = tactic_info.desc, font = "normal", width = 740 }
    },

    vb:row {
      spacing = 6,
      col1,
      col2
    }
  }
end

function M.show_dialog()
  if dialog and dialog.visible then
    dialog:show()
    return
  end

  vb = renoise.ViewBuilder()
  modulator.set_gui_notifier(M.on_telemetry_update)

  -- Selector de tácticas (8 Tácticas en estilo MITRE ATT&CK Matrix)
  local tactic_tabs_items = {
    "1. RECON (FMCW)",
    "2. TARGETING (EKF)",
    "3. CHRONO (72/12)",
    "4. HEX COMMANDS",
    "5. MODAL SYNTH",
    "6. NEURO-PSYOPS",
    "7. GRANULAR MPC",
    "8. EVASION & BAL"
  }

  local panels_list = { width = 770 }
  for t = 1, 8 do
    table.insert(panels_list, build_tactic_view(t))
  end
  local tactic_panels = vb:column(panels_list)

  local preset_items = {}
  for i, pr in ipairs(params.PRESETS) do
    table.insert(preset_items, pr.name)
  end

  local content = vb:column {
    margin = 8,
    spacing = 6,
    width = 780,

    -- Encabezado Militar / Cibernético
    vb:column {
      style = "panel",
      margin = 6,
      width = 770,
      vb:horizontal_aligner {
        mode = "justify",
        vb:text { text = "DRON CENTINELA mm — MATRIZ TÁCTICA MITRE ATT&CK", font = "bold" },
        vb:text { text = "CANÓNICO: 72 BPM | 12 LPB | 14.4 Hz | 96 LÍNEAS", font = "italic" }
      },
      vb:text {
        text = "Fusión Sensorial mmWave, Filtro EKF 12D, Seisillo Biomecánico & Chopping Granular Amen Break",
        font = "normal"
      }
    },

    -- Barra de Estado & Telemetría Dinámica en Vivo
    vb:column {
      style = "group",
      margin = 6,
      spacing = 2,
      width = 770,
      vb:row {
        vb:text { id = "lbl_engine_status", text = "MOTOR TÁCTICO: [ DESACTIVADO / STANDBY ]", font = "bold", width = 360 },
        vb:text { id = "lbl_tracker_status", text = "TRACKER: [ DETENIDO ]", font = "bold", width = 380, align = "right" }
      },
      vb:text { id = "lbl_playback_pos", text = "Secuencia: 00 | Línea: 00 / 96 | Delta t: 69.44 ms", font = "mono", width = 750 },
      vb:text { id = "lbl_ekf_telemetry", text = "EKF 12D -> R: 150.0m | Az: 30.0° | Dopp: -12.0m/s | Jerk: 0.00m/s³ | Nu: 0.00 | Gain: 0.65", font = "mono", width = 750 },
      vb:text { id = "lbl_psyops_telemetry", text = "PSICOACÚSTICA -> Seisillo: 7.20 Hz | Jitter: 0.000 ms | IACC Fase: C (0%) | Haas: 85%", font = "mono", width = 750 },
      vb:text { id = "lbl_locomotion_telemetry", text = "LOCOMOCIÓN MPC -> Amen Slicing 96L | CEP Enemigo: 22.4m | P-Trace: 18.00", font = "mono", width = 750 }
    },

    -- Botones de Acción Global & Presets Tácticos
    vb:row {
      spacing = 6,
      vb:button {
        text = "INICIALIZAR ENTORNO CANÓNICO",
        tooltip = "Configura tempo a 72 BPM, 12 LPB, 16 TPL y crea las 4 pistas tácticas del Dron Centinela.",
        width = 240,
        notifier = function()
          pattern_gen.init_canonical_environment(params)
        end
      },
      vb:button {
        text = "INYECTAR PATRÓN 96 LÍNEAS",
        tooltip = "Inyecta comandos exactos de la tesis: 0Sxx, 0Rxy, Seisillo 7.2Hz con paneo IACC y barrido radar.",
        width = 240,
        notifier = function()
          pattern_gen.inject_tactical_pattern(params)
        end
      },
      vb:button {
        text = "MOTOR EN VIVO (TOGGLE)",
        tooltip = "Activa/Desactiva la ejecución y modulación continua mientras el tracker esté en movimiento.",
        width = 260,
        notifier = function()
          local active = modulator.toggle(params)
          local lbl = vb.views["lbl_engine_status"]
          if lbl then
            lbl.text = active and "MOTOR TÁCTICO: [ EN LÍNEA / ACTIVO ]" or "MOTOR TÁCTICO: [ DESACTIVADO / STANDBY ]"
          end
        end
      }
    },

    -- Selector de Presets
    vb:row {
      spacing = 6,
      vb:text { text = "Misión / Preset Táctico:", font = "bold", width = 160 },
      vb:popup {
        items = preset_items,
        value = 1,
        width = 460,
        notifier = function(idx)
          params.apply_preset(idx)
          M.refresh_ui_values()
          renoise.app():show_status("Preset aplicado: " .. params.PRESETS[idx].name)
        end
      },
      vb:button {
        text = "Reset Default",
        width = 120,
        notifier = function()
          params.apply_preset(1)
          M.refresh_ui_values()
        end
      }
    },

    vb:space { height = 4 },

    -- Selector de Pestañas MITRE ATT&CK
    vb:switch {
      items = tactic_tabs_items,
      value = current_tactic_tab,
      width = 770,
      notifier = function(new_idx)
        current_tactic_tab = new_idx
        for t = 1, 8 do
          local p = vb.views["panel_tactic_" .. t]
          if p then
            p.visible = (t == new_idx)
          end
        end
      end
    },

    -- Contenedor de las 8 Tácticas y 48 Parámetros
    tactic_panels
  }

  dialog = renoise.app():show_custom_dialog(
    "Dron Sentinela mm — Matriz Táctica MITRE ATT&CK",
    content
  )
end

return M
