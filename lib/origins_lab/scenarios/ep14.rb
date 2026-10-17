# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep14WayOfTheGabiniani < OriginsLab::BaseScenario
      def episode_id
        "14_el_camino_de_los_gabiniani"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 30, role: :medjay, status: :alive },
          relationships: { cleopatra: :sovereign },
          belongings: [:hidden_blade]
        )
        apollodorus = Character.new(
          id: :apollodorus,
          name: "Apolodoro",
          attributes: { hp: 100, role: :spymaster, status: :alive },
          relationships: { cleopatra: :trusted_advisor },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "alexandria_palace_gardens",
          location: "Palacio Real de Alejandría",
          time_period: "47 a.C.",
          drachmas: 7500,
          level: 30,
          hidden_blade_level: 8,
          trinkets_count: 88,
          characters: { bayek: bayek, apollodorus: apollodorus },
          inventory: [:hidden_blade],
          flags: { four_beasts_eliminated: true }
        )
      end

      def execute_scenario
        _scene_palace = Scene.new(id: :alexandria_palace_gardens, title: "Jardines del Palacio Real", location: "Alejandría")
        scene_council = Scene.new(id: :war_council_cleopatra, title: "Consejo de Guerra de Cleopatra", location: "Alejandría")
        scene_council.add_precondition("Bayek debe haber desmantelado las avanzadas de los Gabiniani") do |ws|
          ws.flag?(:gabiniani_outposts_destroyed)
        end

        emit("story.investigate_military", actor: :bayek, data: { threat: "Fuerzas romanas mercenarias Gabiniani ocupan la ciudad" })
        @state.set_flag(:gabiniani_outposts_destroyed, true)

        # Consejo con Cleopatra: Se descubren los nombres de Septimius y Pothinus
        transition_to(scene_council)
        @state.set_flag(:supreme_leaders_revealed, true)
        emit("story.intel_gathered", actor: :apollodorus, data: {
          supreme_masters: ["Lucius Septimius (El Chacal)", "Eunuco Pothinus (El Escorpión)"]
        })

        @state.level_up(1)
        @state.add_trinket(5)
      end

      def generate_summary
        "Episodio 14 completado: Se desmantela la avanzada de los soldados Gabiniani y se revela la cúpula suprema: Lucius Septimius 'El Chacal' y el eunuco Pothinus 'El Escorpión'."
      end

      def spoilers
        [
          "Los Gabiniani son legionarios romanos traidores que sirven al eunuco Pothinus.",
          "Julio César está navegando hacia Alejandría en persecución de Pompeyo el Grande."
        ]
      end

      def easter_eggs
        [
          "Papiros en los barracones Gabiniani describen el asesinato de Pompeyo decapitado en la playa ante Ptolomeo XIII."
        ]
      end

      def mitigations
        [
          "ALERTA CRÍTICA: Completar todas las misiones secundarias pendientes en Alejandría antes de activar la siguiente misión de Aya, ya que la ciudad entra en estado de asedio militar.",
          "Asegurar un mínimo de nivel 31 antes de proceder."
        ]
      end

      def side_quests
        ["Phylakitai in the Eye", "Cat's Cradle"]
      end

      def trophies
        ["reduce_reuse_recycle"]
      end
    end
  end
end
