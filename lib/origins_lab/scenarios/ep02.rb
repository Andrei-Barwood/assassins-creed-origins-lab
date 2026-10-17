# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep02TheFalseSiwan < OriginsLab::BaseScenario
      def episode_id
        "02_el_falso_siwan"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 3, role: :medjay, status: :alive },
          relationships: { medunamun: :sworn_enemy },
          belongings: [:medjay_badge, :hunter_bow]
        )
        medunamun = Character.new(
          id: :medunamun,
          name: "Medunamun (El Ibis)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: {},
          belongings: [:apple_of_eden, :ibis_mask]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "temple_of_amun_siwa",
          location: "Templo de Amón en Siwa",
          time_period: "49 a.C.",
          drachmas: 500,
          level: 4,
          trinkets_count: 8,
          characters: { bayek: bayek, medunamun: medunamun },
          inventory: [:medjay_badge],
          flags: {}
        )
      end

      def execute_scenario
        _scene_temple = Scene.new(id: :temple_of_amun_siwa, title: "Templo de Amón", location: "Siwa")
        scene_aftermath = Scene.new(id: :liberation_of_siwa, title: "Siwa Liberada", location: "Siwa")
        scene_aftermath.add_precondition("Medunamun debe haber sido eliminado") do |ws|
          ws.flag?(:medunamun_eliminated)
        end

        emit("story.infiltrate_temple", actor: :bayek, data: { target: "Medunamun" })

        # Ejecución brutal de Medunamun
        medunamun = @state.character(:medunamun)
        medunamun.kill!
        @state.eliminate_target(:the_ibis)
        @state.set_flag(:medunamun_eliminated, true)
        @state.add_item(:ibis_mask)

        emit("combat.assassination_executed", actor: :bayek, target: :medunamun, data: { weapon: "Orbe Isu", consequence: "Cráneo destrozado contra el artefacto" })

        transition_to(scene_aftermath)
        @state.set_flag(:siwa_liberated, true)
        @state.level_up(1)
        @state.add_trinket(5)
      end

      def generate_summary
        "Episodio 02 completado: Medunamun 'El Ibis' es ejecutado en el Templo de Amón. Siwa es liberada de la tiranía local."
      end

      def spoilers
        [
          "Medunamun utilizaba el Fruto del Edén dorado como pisapapeles sin comprender su verdadero poder.",
          "Fue Medunamun quien sostuvo a Khemu contra la puerta de la cripta cuando ocurrió la tragedia."
        ]
      end

      def easter_eggs
        [
          "El sarcófago dentro del templo de Amón posee grabados Isu que predicen la alineación de las 12 constelaciones celestes."
        ]
      end

      def mitigations
        [
          "Acceder por los tejados del Templo de Amón usando Senu para marcar a los 6 guardias acorazados de élite.",
          "Completar la misión 'The Healer' con Rabiah para recibir medicinas que mitigan veneno."
        ]
      end

      def side_quests
        ["The Healer", "Prisoners in the Temple"]
      end

      def trophies
        ["first_steps", "reduce_reuse_recycle"]
      end
    end
  end
end
