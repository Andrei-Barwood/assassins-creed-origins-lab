# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep15BladeOfTheGoddess < OriginsLab::BaseScenario
      def episode_id
        "15_la_hoja_de_la_diosa"
      end

      def main_actor
        :aya
      end

      def default_initial_state
        aya = Character.new(
          id: :aya,
          name: "Aya de Alejandría",
          attributes: { hp: 100, level: 31, role: :naval_commander, status: :alive },
          relationships: { cleopatra: :sovereign_queen, caesar: :target_ally },
          belongings: [:dual_blades]
        )
        caesar = Character.new(
          id: :caesar,
          name: "Julio César",
          attributes: { hp: 100, role: :roman_dictator, status: :alive },
          relationships: { cleopatra: :seduced_ally },
          belongings: [:golden_laurel]
        )
        cleopatra = Character.new(
          id: :cleopatra,
          name: "Cleopatra VII",
          attributes: { hp: 100, role: :restored_pharaoh, status: :alive },
          relationships: { caesar: :consort },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "alexandria_harbor_carpet",
          location: "Puerto Real y Palacio de Alejandría",
          time_period: "47 a.C.",
          drachmas: 8000,
          level: 31,
          trinkets_count: 93,
          characters: { aya: aya, caesar: caesar, cleopatra: cleopatra },
          inventory: [:dual_blades],
          flags: {}
        )
      end

      def execute_scenario
        _scene_carpet = Scene.new(id: :alexandria_harbor_carpet, title: "La Alfombra de Cleopatra", location: "Palacio de Alejandría")
        scene_pharos = Scene.new(id: :pharos_lighthouse_naval_assault, title: "El Faro de Alejandría", location: "Faro de Alejandría")
        scene_pharos.add_precondition("Cleopatra debe haberse presentado ante Julio César") do |ws|
          ws.flag?(:caesar_met_cleopatra)
        end

        emit("story.carpet_infiltration", actor: :aya, target: :cleopatra, data: {
          strategy: "Infiltrar a Cleopatra enrollada dentro de una alfombra persa en los aposentos de César"
        })
        @state.set_flag(:caesar_met_cleopatra, true)

        # Asalto naval al Faro y encendido de la gran señal ígnea
        transition_to(scene_pharos)
        @state.set_flag(:pharos_signal_ignited, true)
        @state.set_flag(:alexander_tomb_accessed, true)

        emit("combat.naval_victory", actor: :aya, data: {
          action: "Destrucción de la flota ptolemaica y encendido del fuego sagrado en el Faro"
        })
        emit("story.tomb_discovery", actor: :aya, data: {
          tomb: "Soma de Alejandro Magno",
          relics: "Orbe y Cetro Isu descansaban en el féretro de oro"
        })

        @state.level_up(1)
        @state.add_trinket(3)
      end

      def generate_summary
        "Episodio 15 completado: Jugando como Aya. Cleopatra se presenta ante Julio César emergiendo de una alfombra. Asalto naval al Faro de Alejandría y hallazgo de los artefactos en la Tumba de Alejandro Magno."
      end

      def spoilers
        [
          "La tumba de Alejandro Magno custodiaba una Manzana del Edén y el Cetro de la Primera Civilización.",
          "César queda deslumbrado por Cleopatra y ordena a sus legiones intervenir en la guerra civil egipcia."
        ]
      end

      def easter_eggs
        [
          "Recreación cinematográfica exacta del mito de la alfombra registrado por el historiador Plutarco.",
          "El Faro de Alejandría como una de las Siete Maravillas del Mundo Antiguo plenamente escalable."
        ]
      end

      def mitigations
        [
          "PREVENCIÓN: Recordar que Aya no comparte el árbol de habilidades ni el inventario de arcos de Bayek. Usar esquivas rápidas y parry en el Faro.",
          "No desviarse del objetivo de la misión para evitar desincronizaciones."
        ]
      end

      def side_quests
        ["Higher Education"]
      end

      def trophies
        ["reduce_reuse_recycle"]
      end
    end
  end
end
