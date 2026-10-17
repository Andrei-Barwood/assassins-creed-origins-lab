# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep03MayAmunWalkBesideYou < OriginsLab::BaseScenario
      def episode_id
        "03_que_amon_vaya_contigo"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 6, role: :medjay, status: :alive },
          relationships: { hepzefa: :loyal_friend, aya: :beloved_wife },
          belongings: [:medjay_badge]
        )
        hepzefa = Character.new(
          id: :hepzefa,
          name: "Hepzefa",
          attributes: { hp: 100, role: :guardian_of_siwa, status: :alive },
          relationships: { bayek: :brother_in_arms },
          belongings: [:fire_sword]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "siwa_gate_departure",
          location: "Puertas de Siwa",
          time_period: "49 a.C. - Primavera",
          drachmas: 900,
          level: 7,
          trinkets_count: 14,
          characters: { bayek: bayek, hepzefa: hepzefa },
          inventory: [:medjay_badge],
          flags: {}
        )
      end

      def execute_scenario
        _scene_gate = Scene.new(id: :siwa_gate_departure, title: "Despedida en las Puertas de Siwa", location: "Siwa")
        scene_desert = Scene.new(id: :mareotis_desert_crossing, title: "Cruce del Desierto de Mareotis", location: "Desierto de Mareotis")
        scene_desert.add_precondition("Bayek debe haber hecho el juramento de despedida") do |ws|
          ws.flag?(:farewell_vow_taken)
        end

        emit("story.farewell_recorded", actor: :bayek, target: :hepzefa, data: { vow: "Purificaré la tierra de la Orden antes de volver a mirar hacia Siwa." })
        @state.set_flag(:farewell_vow_taken, true)

        transition_to(scene_desert, new_location: "Lago Mareotis", new_time: "48 a.C.")
        emit("story.region_unlocked", actor: :bayek, data: { region: "Lago Mareotis" })

        @state.set_flag(:mareotis_unlocked, true)
        @state.level_up(1)
        @state.add_trinket(6)
      end

      def generate_summary
        "Episodio 03 completado: Bayek se despide de Hepzefa y cruza el Desierto de Mareotis rumbo a Alejandría para encontrarse con Aya."
      end

      def spoilers
        [
          "Hepzefa cuida de Siwa y morirá trágicamente mucho después a manos de Flavius Metellus ('El León').",
          "Aya ya ha empezado a forjar contactos con la realeza en Alejandría."
        ]
      end

      def easter_eggs
        [
          "Círculo de piedras de Amón en Siwa: el inicio de los recuerdos interactivos con Khemu mirando las estrellas."
        ]
      end

      def mitigations
        [
          "Sincronizar la atalaya solitaria del Desierto de Mareotis para habilitar viaje rápido de regreso a Siwa.",
          "Completar 'Lady of Slaughter' en Yamu para obtener el Atuendo de Sejmet y subir a nivel 8 antes de entrar a Alejandría."
        ]
      end

      def side_quests
        ["Hidden Tax", "Ambush in the Temple", "Ulterior Votive", "Lady of Slaughter", "Taste of Her Sting", "Book of the Dead"]
      end

      def trophies
        ["reduce_reuse_recycle", "where_my_black_flag"]
      end
    end
  end
end
