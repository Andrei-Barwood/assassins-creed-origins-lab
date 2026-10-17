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
        "Episodio 07 completado: Cleopatra VII revela que la Orden la gobiernan cuatro monstruos (El Escarabajo, La Hiena, El Lagarto y El Cocodrilo) y nombra a Bayek su Medjay oficial."
      end

      def spoilers
        [
          "Cleopatra usa a Bayek y Aya para eliminar a sus enemigos políticos.",
          "Cleopatra planea secretamente traicionarlos para pactar con Julio César y Roma."
        ]
      end

      def easter_eggs
        [
          "El Hipódromo de Canopo rinde homenaje a la película Ben-Hur de 1959, con mecánicas de cuadriga y colisiones cinemáticas."
        ]
      end

      def mitigations
        [
          "Orden óptimo para cazar a las cuatro bestias: 1° Escarabajo (Nv 15), 2° Hiena (Nv 19), 3° Lagarto (Nv 21), 4° Cocodrilo (Nv 25).",
          "Ganar el torneo de cuadrigas en Canopo para desbloquear el trofeo 'Ben-Hur'."
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
