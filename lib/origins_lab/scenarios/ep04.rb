# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep04AyaInAlexandria < OriginsLab::BaseScenario
      def episode_id
        "04_aya_en_alejandria"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 9, role: :medjay, status: :alive },
          relationships: { aya: :beloved_wife },
          belongings: [:medjay_badge]
        )
        aya = Character.new(
          id: :aya,
          name: "Aya de Alejandría",
          attributes: { hp: 100, level: 10, role: :agent_of_cleopatra, status: :alive },
          relationships: { bayek: :beloved_husband, cleopatra: :patron },
          belongings: [:hidden_blade]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "alexandria_serapis_monument",
          location: "Monumento de Serapis en Alejandría",
          time_period: "48 a.C.",
          drachmas: 1200,
          level: 9,
          hidden_blade_level: 0,
          trinkets_count: 22,
          characters: { bayek: bayek, aya: aya },
          inventory: [:medjay_badge],
          flags: {}
        )
      end

      def execute_scenario
        _scene_reunion = Scene.new(id: :alexandria_serapis_monument, title: "Monumento de Serapis", location: "Alejandría")
        scene_blade = Scene.new(id: :underground_hideout_blade, title: "Cámara Secreta de Aya", location: "Alejandría")
        scene_blade.add_precondition("Bayek y Aya deben haberse reencontrado") do |ws|
          ws.flag?(:aya_reunited)
        end

        emit("story.reunion_recorded", actor: :bayek, target: :aya, data: { dialogue: "Mi corazón late de nuevo en Alejandría." })
        @state.set_flag(:aya_reunited, true)

        # Entrega de la legendaria Hoja Oculta
        transition_to(scene_blade)
        aya = @state.character(:aya)
        aya.remove_belonging(:hidden_blade)
        @state.character(:bayek).add_belonging(:hidden_blade)
        @state.upgrade_hidden_blade!
        @state.add_item(:hidden_blade)

        # Aya confirma la eliminación de Actaeon y Ktesos
        @state.eliminate_target(:the_vulture)
        @state.eliminate_target(:the_ram)

        emit("story.item_acquired", actor: :bayek, target: :aya, data: { item: "Hoja Oculta", origin: "Arma utilizada por Darío en el siglo V a.C." })
        emit("story.targets_reported", actor: :aya, data: { eliminated: ["Actaeon (El Buitre)", "Ktesos (El Carnero)"] })

        @state.set_flag(:hidden_blade_acquired, true)
        @state.level_up(1)
        @state.add_trinket(5)
      end

      def generate_summary
        "Episodio 04 completado: Bayek se reúne con Aya en Alejandría y recibe la legendaria Hoja Oculta de Darío. Aya confirma la muerte de Actaeon y Ktesos."
      end

      def spoilers
        [
          "La hoja oculta perteneció originalmente a Darío, quien la usó para matar al rey persa Jerjes I.",
          "Aya ya trabaja al servicio directo de la reina exiliada Cleopatra VII."
        ]
      end

      def easter_eggs
        [
          "La estatua de Darío en la cámara secreta presagia las tumbas de los Asesinos Legendarios vistas en Assassin's Creed II.",
          "Rollos en la biblioteca mencionan las profecías del Oráculo de Siwa sobre Alejandro Magno."
        ]
      end

      def mitigations
        [
          "Priorizar de inmediato la mejora del brazalete de la hoja oculta para evitar que los capitanes sobrevivan al sigilo.",
          "Completar 'The Odyssey' y 'Serapis Unites' antes de iniciar misiones de conflicto abierto."
        ]
      end

      def side_quests
        ["The Odyssey", "Serapis Unites", "A Tithe By Any Other Name", "The Accidental Philosopher"]
      end

      def trophies
        ["reduce_reuse_recycle", "handy_man"]
      end
    end
  end
end
