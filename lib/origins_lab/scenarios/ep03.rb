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
        "Siwa / Desierto de Mareotis, 49 a.C. Con Siwa liberada temporalmente pero herida en lo profundo, Bayek se despide de Hepzefa en las imponentes puertas fortificadas de la ciudadela. Con un arco de caza bendecido por su amigo y provisiones m\u00EDnimas, el Medjay emprende la solitaria traves\u00EDa a trav\u00E9s del implacable Desierto de Mareotis. Al caer la noche bajo un cielo tachonado de estrellas ancestrales, Bayek contempla las dunas infinitas, consciente de que deja atr\u00E1s su hogar terrenal para internarse en el avispero cosmopolita de Alejandr\u00EDa, donde su amada esposa Aya persigue los siguientes eslabones de la Orden."
      end

      def spoilers
        [
          "El pacto silencioso de Hepzefa: Hepzefa jura quedarse en Siwa para reconstruir la resistencia civil y proteger la tumba de Khemu. Este sacrificio sellar\u00E1 su destino tr\u00E1gico m\u00E1s adelante en la historia, cuando los l\u00EDderes romanos de la Orden regresen para arrasar el oasis.",
          "La carta oculta de Aya: Antes de partir, Hepzefa entrega a Bayek una misiva encriptada enviada por Aya desde Alejandr\u00EDa mediante marineros mercantes. Aya advierte que la Orden en la capital tiene tent\u00E1culos en la corte real de Ptolomeo XIII y que dos de sus miembros ya han sido ejecutados por su propia mano."
        ]
      end

      def easter_eggs
        [
          "El espejismo del \u00E1rbol en el Lago Mareotis: Al cruzar las dunas entre Siwa y Mareotis en horas de mediod\u00EDa, se detona uno de los primeros espejismos del desierto: un \u00E1rbol sic\u00F3moro floreciente que desaparece al aproximarse a menos de diez pasos.",
          "El Templo de Sejmet en Yamu: El templo a orillas del lago est\u00E1 dedicado a la diosa leona de la guerra y la sanaci\u00F3n. All\u00ED se celebra el festival de la cerveza te\u00F1ida de rojo, recordando el mito donde Ra embriag\u00F3 a Sejmet para evitar el exterminio de la humanidad."
        ]
      end

      def mitigations
        [
          "Brecha de nivel en el Lago Mareotis: El Lago Mareotis exige nivel 8 a 10. No avanzar por la calzada principal sin haber completado las secundarias de Yamu ('Emboscada en el Templo' y 'Sabor de su Picadura'), las cuales otorgan m\u00E1s de 2,500 XP y equipamiento azul excepcional.",
          "Caza de flamencos y cocodrilos en las marismas: Recolectar cuero blando de los flamencos y cuero duro de los cocodrilos en las orillas de Mareotis para subir el Brazal a nivel 2 (+20% da\u00F1o cuerpo a cuerpo) antes de pisar suelo alejandrino."
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
