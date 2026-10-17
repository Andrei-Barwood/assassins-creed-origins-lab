# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep17TheAftermath < OriginsLab::BaseScenario
      def episode_id
        "17_las_secuelas"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 33, role: :vengeful_medjay, status: :alive },
          relationships: { flavius: :true_grandmaster_enemy },
          belongings: [:hidden_blade]
        )
        apollodorus = Character.new(
          id: :apollodorus,
          name: "Apolodoro",
          attributes: { hp: 10, role: :dying_informant, status: :dying },
          relationships: {},
          belongings: []
        )
        hepzefa = Character.new(
          id: :hepzefa,
          name: "Hepzefa",
          attributes: { hp: 0, role: :martyr_friend, status: :deceased },
          relationships: { bayek: :eternal_brother },
          belongings: [:hepzefa_sword]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "alexander_tomb_bloodbath",
          location: "Tumba de Alejandro Magno",
          time_period: "47 a.C.",
          drachmas: 11000,
          level: 33,
          hidden_blade_level: 9,
          trinkets_count: 5,
          characters: { bayek: bayek, apollodorus: apollodorus, hepzefa: hepzefa },
          inventory: [:hidden_blade],
          flags: {}
        )
      end

      def execute_scenario
        _scene_tomb = Scene.new(id: :alexander_tomb_bloodbath, title: "Masacre en la Tumba de Alejandro", location: "Alejandría")
        scene_siwa_mourning = Scene.new(id: :siwa_hepzefa_funeral, title: "Duelo en Siwa", location: "Siwa")
        scene_siwa_mourning.add_precondition("Bayek debe haber descubierto la traición de Flavius") do |ws|
          ws.flag?(:flavius_revealed_as_lion)
        end

        emit("story.tomb_crime_scene", actor: :bayek, data: { location: "Soma de Alejandro Magno saqueada" })

        # Muerte de Apolodoro y revelación de Flavius Metellus como 'El León'
        apol = @state.character(:apollodorus)
        apol.kill!
        @state.set_flag(:flavius_revealed_as_lion, true)
        emit("story.truth_revealed", actor: :bayek, target: :apollodorus, data: {
          grandmaster: "General romano Flavius Metellus ('El León')",
          stolen_relics: "La Manzana del Edén y el Cetro de Edén marchan hacia la cripta de Siwa"
        })

        # Regreso a Siwa: Hallazgo del cuerpo de Hepzefa
        transition_to(scene_siwa_mourning, new_location: "Siwa")
        @state.set_flag(:hepzefa_buried, true)
        @state.add_item(:hepzefas_sword)

        emit("story.martyrdom_recorded", actor: :bayek, data: {
          casualty: "Hepzefa asesinado brutalmente por Flavius",
          legacy: "Bayek recoge la Espada Ígnea de Hepzefa para el pesaje final"
        })

        @state.level_up(1)
        @state.add_trinket(4)
      end

      def generate_summary
        "Episodio 17 completado: Apolodoro agoniza en la tumba saqueada de Alejandro revelando que Flavius Metellus es 'El León'. En Siwa, Bayek encuentra a Hepzefa asesinado y empuña su espada de fuego."
      end

      def spoilers
        [
          "Flavius Metellus, general en jefe de César, fue el hombre que ordenó el asesinato de Khemu en Siwa.",
          "Flavius utiliza la Manzana de Edén para someter mentalmente a las poblaciones del oeste."
        ]
      end

      def easter_eggs
        [
          "La espada de fuego de Hepzefa ('Hepzefa's Sword') es una de las armas más icónicas y poderosas del juego."
        ]
      end

      def mitigations
        [
          "Equipar la espada de fuego de Hepzefa de inmediato: su atributo de combustión pasiva interrumpe los combos de los legionarios romanos.",
          "Mejorar el escudo al nivel máximo antes de entrar en Cirenaica."
        ]
      end

      def side_quests
        ["The Demise of Flavius", "Found Honor"]
      end

      def trophies
        ["done_learning"]
      end
    end
  end
end
