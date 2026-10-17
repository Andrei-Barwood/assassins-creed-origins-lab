# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep18TheFinalWeighing < OriginsLab::BaseScenario
      def episode_id
        "18_el_pesaje_final"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 35, role: :avenger_medjay, status: :alive },
          relationships: { khemu: :avenged_son, flavius: :grandmaster_lion },
          belongings: [:hidden_blade, :hepzefas_sword]
        )
        flavius = Character.new(
          id: :flavius,
          name: "Flavius Metellus (El León)",
          attributes: { hp: 100, role: :grandmaster_order, status: :alive },
          relationships: {},
          belongings: [:apple_of_eden, :lion_mask]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "cyrene_acropolis_temple",
          location: "Acrópolis de Cirene en Kyrenaika",
          time_period: "47 a.C.",
          drachmas: 13000,
          level: 35,
          hidden_blade_level: 10,
          trinkets_count: 10,
          characters: { bayek: bayek, flavius: flavius },
          inventory: [:hidden_blade, :hepzefas_sword],
          flags: {}
        )
      end

      def execute_scenario
        _scene_acropolis = Scene.new(id: :cyrene_acropolis_temple, title: "Acrópolis de Cirene", location: "Cirene")
        scene_weighing = Scene.new(id: :duat_final_weighing, title: "El Pesaje del Corazón", location: "El Más Allá")
        scene_weighing.add_precondition("Flavius debe haber sido derrotado") do |ws|
          ws.flag?(:flavius_eliminated)
        end

        emit("story.infiltrate_acropolis", actor: :bayek, data: { city: "Cirene", state: "Población paralizada por el pulso de la Manzana de Edén" })

        # Combate supremo contra Flavius con la Manzana
        flav = @state.character(:flavius)
        flav.kill!
        @state.eliminate_target(:the_lion)
        @state.set_flag(:flavius_eliminated, true)
        @state.add_item(:apple_of_eden)

        emit("combat.boss_battle_victory", actor: :bayek, target: :flavius, data: {
          weapon: "Espada Ígnea de Hepzefa & Hoja Oculta",
          artifact_neutralized: "Manzana de Edén",
          dialogue_flavius: "El orden prevalecerá... la humanidad anhela un señor."
        })

        # Escena mística del pesaje final: el reencuentro en el Duat con Khemu
        transition_to(scene_weighing)
        @state.set_flag(:khemu_avenged, true)
        emit("story.khemu_peace_recorded", actor: :bayek, data: {
          peace: "El alma de Khemu descansa libre en el Campo de Cañas (Aaru)",
          closure: "La venganza de sangre ha terminado; ahora comienza la causa"
        })

        @state.level_up(1)
        @state.add_trinket(6)
      end

      def generate_summary
        "Episodio 18 completado: Duelo supremo en la Acrópolis de Cirene. Bayek vence las ilusiones de la Manzana de Edén y ejecuta a Flavius 'El León', vengando a su hijo Khemu."
      end

      def spoilers
        [
          "Flavius confiesa la doctrina proto-templaria: el libre albedrío es un veneno y solo el control absoluto trae la paz.",
          "Con la muerte de Flavius, el alma de Khemu finalmente cruza al Aaru (los Campos Elíseos egipcios)."
        ]
      end

      def easter_eggs
        [
          "El templo de Zeus en Cirene muestra frescos que representan batallas entre humanos primitivos y los dioses Isu."
        ]
      end

      def mitigations
        [
          "Estrategia contra Flavius: Cuando teleporta y lanza ondas de ceguera, rodar hacia los lados y castigar con armas rápidas para romper su canalización de la Manzana.",
          "Desbloquear el trofeo 'I'm Done Learning' adquiriendo una habilidad de maestro en el árbol de guerrero."
        ]
      end

      def side_quests
        ["Absolute Power", "The Flea of Cyrene", "Shadows of Apollo", "His Secret Service"]
      end

      def trophies
        ["done_learning"]
      end
    end
  end
end
