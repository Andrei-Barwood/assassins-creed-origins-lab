--[[============================================================================
  main.lua
  Dron Sentinela mm — Matriz Táctica MITRE ATT&CK para Renoise
  Cátedra de Cibernética Teórica y Síntesis Estocástica
============================================================================]]--

local params = require("tactical_params")
local pattern_gen = require("pattern_generator")
local modulator = require("live_tracker_modulator")
local gui = require("gui_matrix")

--------------------------------------------------------------------------------
-- Inicialización de Observables
--------------------------------------------------------------------------------

-- Bucle de fondo para modulación continua cuando el tracker esté en movimiento
local function on_app_idle()
  modulator.on_idle(params)
end

if not renoise.tool().app_idle_observable:has_notifier(on_app_idle) then
  renoise.tool().app_idle_observable:add_notifier(on_app_idle)
end

-- Reinicio de estado al crear o abrir una nueva canción
local function on_new_document()
  modulator.last_line = -1
  modulator.last_seq = -1
end

if not renoise.tool().app_new_document_observable:has_notifier(on_new_document) then
  renoise.tool().app_new_document_observable:add_notifier(on_new_document)
end

--------------------------------------------------------------------------------
-- Registro en Menús de Renoise
--------------------------------------------------------------------------------

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Dron Sentinela - Matriz Táctica MITRE ATT&CK...",
  invoke = function()
    gui.show_dialog()
  end
}

renoise.tool():add_menu_entry {
  name = "Pattern Editor:Dron Sentinela:Abrir Matriz Táctica (48 Parámetros)...",
  invoke = function()
    gui.show_dialog()
  end
}

renoise.tool():add_menu_entry {
  name = "Pattern Editor:Dron Sentinela:Inicializar Entorno Canónico (72 BPM / 12 LPB)",
  invoke = function()
    pattern_gen.init_canonical_environment(params)
  end
}

renoise.tool():add_menu_entry {
  name = "Pattern Editor:Dron Sentinela:Inyectar Patrón Táctico de 96 Líneas",
  invoke = function()
    pattern_gen.inject_tactical_pattern(params)
  end
}

renoise.tool():add_menu_entry {
  name = "Pattern Editor:Dron Sentinela:Toggle Motor Táctico en Vivo",
  invoke = function()
    modulator.toggle(params)
  end
}

--------------------------------------------------------------------------------
-- Registro de Atajos de Teclado (Keybindings)
--------------------------------------------------------------------------------

renoise.tool():add_keybinding {
  name = "Global:Tools:Dron Sentinela Tactical Matrix",
  invoke = function()
    gui.show_dialog()
  end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Tools:Inject Dron Sentinela 96-Line Pattern",
  invoke = function()
    pattern_gen.inject_tactical_pattern(params)
  end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Tools:Toggle Dron Sentinela Live Engine",
  invoke = function()
    modulator.toggle(params)
  end
}

print("[Dron Sentinela mm] Herramienta cargada con éxito. 48 Parámetros MITRE ATT&CK listos.")
