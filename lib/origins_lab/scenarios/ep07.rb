# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep07MeetingCleopatra < OriginsLab::BaseScenario
      def episode_id
        "07_el_encuentro_con_cleopatra"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 12, role: :medjay, status: :alive },
          relationships: { aya: :beloved_wife },
          belongings: [:hidden_blade]
        )
        cleopatra = Character.new(
          id: :cleopatra,
          name: "Cleopatra VII",
          attributes: { hp: 100, role: :queen_in_exile, status: :alive },
          relationships: { aya: :protege, bayek: :appointed_medjay },
          belongings: [:royal_diadem]
        )
        apollodorus = Character.new(
          id: :apollodorus,
          name: "Apolodoro el Fiel",
          attributes: { hp: 100, role: :spymaster, status: :alive },
          relationships: { cleopatra: :loyal_agent },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "kanopos_villa_cleopatra",
          location: "Villa Real de Canopo",
          time_period: "48 a.C.",
          drachmas: 2200,
          level: 12,
          hidden_blade_level: 2,
          trinkets_count: 40,
          characters: { bayek: bayek, cleopatra: cleopatra, apollodorus: apollodorus },
          inventory: [:hidden_blade],
          flags: {}
        )
      end

      def execute_scenario
        _scene_audience = Scene.new(id: :kanopos_villa_cleopatra, title: "Audiencia Secreta", location: "Villa de Canopo")
        scene_investiture = Scene.new(id: :egypt_medjay_investiture, title: "El Medjay de Egipto", location: "Nomos de Canopo")
        scene_investiture.add_precondition("Cleopatra debe haber revelado a las 4 bestias de la Orden") do |ws|
          ws.flag?(:four_beasts_revealed)
        end

        emit("story.royal_audience", actor: :bayek, target: :cleopatra, data: { presenter: "Apolodoro" })

        # Revelación de los cuatro líderes de la Orden
        @state.set_flag(:four_beasts_revealed, true)
        emit("story.conspiracy_unveiled", actor: :cleopatra, data: {
          targets: [
            "El Escarabajo (Sais / Delta)",
            "La Hiena (Guiza)",
            "El Lagarto (Menfis)",
            "El Cocodrilo (Faiyum)"
          ],
          manipulation: "Ptolomeo XIII es una marioneta de la Orden"
        })

        # Nombramiento de Bayek como Medjay de Egipto
        transition_to(scene_investiture)
        @state.set_flag(:appointed_egypt_medjay, true)
        emit("story.title_granted", actor: :cleopatra, target: :bayek, data: { title: "Medjay de todo Egipto" })

        @state.level_up(1)
        @state.add_trinket(6)
        @state.unlock_trophy(:ben_hur)
      end

      def generate_summary
        "Nomos de Canopo, 48 a.C. En la opulenta villa costera de Apolodoro, Bayek y Aya son introducidos en secreto ante la reina depuesta, Cleopatra VII Thea Filop\u00E1tor. Cleopatra, con una elocuencia magn\u00E9tica y vestimentas doradas de la diosa Isis, expone la guerra civil contra su hermano menor Ptolomeo XIII y c\u00F3mo la Orden de los Antiguos manipula la corte como t\u00EDteres. Reconociendo el valor y linaje de Bayek, Cleopatra restituye formalmente el t\u00EDtulo ancestral de los protectores reales: nombra a Bayek y Aya como 'Los Medjay de todo Egipto'. Con el patrocinio regio, Bayek recibe una nueva lista de cuatro altos jerarcas de la Orden que asolan las provincias del reino."
      end

      def spoilers
        [
          "Cleopatra como manipuladora magistral: La reina utiliza h\u00E1bilmente el dolor de Bayek por la muerte de Khemu para convertirlo en su fuerza de choque personal. Aunque se presenta como salvadora de las tradiciones egipcias, su \u00FAnica meta es el trono ptolemaico a cualquier costo pol\u00EDtico.",
          "La revelaci\u00F3n de las Cuatro Bestias de la Orden: Cleopatra y Apolodoro revelan los nombres en clave de los cuatro tiranos provinciales: 'El Escarabajo' (Delta del Nilo), 'La Hiena' (Meseta de Guiza), 'El Lagarto' (Menfis) y 'El Cocodrilo' (Oasis de Faiyum).",
          "El distanciamiento emocional entre Bayek y Aya: Mientras Bayek acepta la investidura con la esperanza de restaurar la paz en su tierra, Aya se entrega por completo a la causa pol\u00EDtica de Cleopatra, comenzando la brecha ideol\u00F3gica que terminar\u00E1 fracturando su matrimonio."
        ]
      end

      def easter_eggs
        [
          "El Hip\u00F3dromo de Canopo: Junto a la villa de Apolodoro se encuentra el hip\u00F3dromo, donde se compite en carreras de cuadrigas. El comentarista griego cita frases que homenajean a la pel\u00EDcula cl\u00E1sica Ben-Hur (1959).",
          "La belleza legendaria de Cleopatra: El modelo de personaje de Cleopatra combina rasgos greco-macedonios y cosm\u00E9ticos egipcios tradicionales a base de galena negra y malaquita verde, reflejando su doble condici\u00F3n de reina helen\u00EDstica y faraona divina."
        ]
      end

      def mitigations
        [
          "Apertura del mapa global de Egipto: Este episodio desbloquea el viaje r\u00E1pido a m\u00FAltiples regiones. Se recomienda encarecidamente NO viajar directamente a Guiza (nivel 19) o Menfis (nivel 21); la ruta cronol\u00F3gica y matem\u00E1tica \u00F3ptima es avanzar primero hacia el Delta del Nilo y Sais (nivel 15) para evitar el penalizador de da\u00F1o por brecha de nivel."
        ]
      end

      def side_quests
        ["The Weasel", "The Hungry River", "Old Times", "Wild Ride", "The Matriarch"]
      end

      def trophies
        ["ben_hur", "reduce_reuse_recycle"]
      end
    end
  end
end
