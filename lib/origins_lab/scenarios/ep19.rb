# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep19LastOfTheMedjay < OriginsLab::BaseScenario
      def episode_id
        "19_el_ultimo_medjay"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 36, role: :founder_hidden_ones, status: :alive },
          relationships: { aya: :co_founder_eternal_love },
          belongings: [:hidden_blade, :eagle_skull_amulet]
        )
        aya = Character.new(
          id: :aya,
          name: "Aya de Alejandría",
          attributes: { hp: 100, level: 36, role: :founder_hidden_ones, status: :alive },
          relationships: { bayek: :parting_comrade },
          belongings: [:dual_blades]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "alexandria_shoreline_parting",
          location: "Costas del Mediterráneo en Alejandría",
          time_period: "47 a.C.",
          drachmas: 15000,
          level: 36,
          hidden_blade_level: 10,
          trinkets_count: 14,
          characters: { bayek: bayek, aya: aya },
          inventory: [:hidden_blade],
          flags: { khemu_avenged: true }
        )
      end

      def execute_scenario
        _scene_beach = Scene.new(id: :alexandria_shoreline_parting, title: "La Playa del Destino", location: "Alejandría")
        scene_creed = Scene.new(id: :birth_of_hidden_ones, title: "Nacimiento de los Ocultos", location: "Alejandría")
        scene_creed.add_precondition("Bayek y Aya deben haber aceptado su separación por la causa") do |ws|
          ws.flag?(:marriage_concluded)
        end

        emit("story.parting_vows", actor: :bayek, target: :aya, data: {
          dialogue: "Aya de Alejandría ha muerto. Bayek de Siwa ya no existe. Solo quedan los Ocultos."
        })
        @state.set_flag(:marriage_concluded, true)

        # El nacimiento del logo en la arena
        transition_to(scene_creed)
        @state.set_flag(:hidden_ones_founded, true)
        @state.set_flag(:assassin_insignia_born, true)

        emit("story.insignia_revealed", actor: :bayek, data: {
          gesture: "Bayek arroja el amuleto del cráneo de águila de Khemu a la arena mojada",
          symbol: "Al levantarlo, la impronta en la arena crea el logotipo de los Asesinos",
          creed: "Nada es verdad, todo está permitido. Trabajamos en la oscuridad para servir a la luz."
        })

        @state.level_up(1)
        @state.add_trinket(5)
      end

      def generate_summary
        "Episodio 19 completado: En las playas de Alejandría, Bayek y Aya se despiden para siempre y fundan 'Los Ocultos'. El cráneo de águila de Khemu crea el emblema de la Hermandad en la arena."
      end

      def spoilers
        [
          "Aya decide zarpar hacia Roma para erradicar las ramas europeas de la Orden.",
          "Bayek permanece en Egipto organizando las oficinas secretas de los Ocultos en Menfis, Sinaí y Tebas."
        ]
      end

      def easter_eggs
        [
          "El origen canónico del icónico logotipo de la saga Assassin's Creed: la silueta inversa del cráneo de un águila en la arena egipcia."
        ]
      end

      def mitigations
        [
          "Completar la misión 'Siete Granjeros' en el Nomos de Uab para desbloquear el trofeo 'Seven Farmers' antes de avanzar.",
          "Asegurarse de no dejar pendientes de viaje rápido en el Delta."
        ]
      end

      def side_quests
        ["Seven Farmers", "The Love Dilemma"]
      end

      def trophies
        ["seven_farmers"]
      end
    end
  end
end
