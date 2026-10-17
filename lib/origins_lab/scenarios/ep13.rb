# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep13TheCrocodilesJaws < OriginsLab::BaseScenario
      def episode_id
        "13_las_fauces_del_cocodrilo"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 27, role: :gladiator_medjay, status: :alive },
          relationships: { kensa: :childhood_friend, berenike: :target_crocodile },
          belongings: [:hidden_blade, :gladiator_axe]
        )
        berenike = Character.new(
          id: :berenike,
          name: "Berenike (El Cocodrilo)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: {},
          belongings: [:crocodile_mask]
        )
        kensa = Character.new(
          id: :kensa,
          name: "Kensa de Siwa",
          attributes: { hp: 100, role: :gladiator_champion, status: :alive },
          relationships: { bayek: :friend_turned_bodyguard },
          belongings: [:dual_swords]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "krokodilopolis_arena",
          location: "Arena de Krokodilopolis",
          time_period: "48 a.C.",
          drachmas: 6000,
          level: 27,
          hidden_blade_level: 7,
          trinkets_count: 81,
          characters: { bayek: bayek, berenike: berenike, kensa: kensa },
          inventory: [:hidden_blade],
          flags: { shadya_drowned: true }
        )
      end

      def execute_scenario
        _scene_arena = Scene.new(id: :krokodilopolis_arena, title: "Arena de Gladiadores", location: "Krokodilopolis")
        scene_villa = Scene.new(id: :berenike_villa_execution, title: "Villa de Berenike", location: "Faiyum")
        scene_villa.add_precondition("Bayek debe haberse coronado campeón de la Arena") do |ws|
          ws.flag?(:arena_champion_crowned)
        end

        emit("story.arena_entered", actor: :bayek, data: { purpose: "Infiltración gladiatoria para alcanzar a Berenike" })

        # Combate en la Arena y victoria sobre los Hermanos Galos
        @state.set_flag(:arena_champion_crowned, true)
        emit("combat.arena_victory", actor: :bayek, data: { opponents: "Hermanos Galos", title: "Campeón de Krokodilopolis" })

        # Asalto a la villa y ejecución de Berenike
        transition_to(scene_villa)
        ber = @state.character(:berenike)
        ber.kill!
        @state.eliminate_target(:the_crocodile)
        @state.set_flag(:crocodile_eliminated, true)
        @state.add_item(:crocodile_mask)

        emit("combat.assassination_executed", actor: :bayek, target: :berenike, data: {
          justice_for: "Shadya",
          tragic_conflict: "Kensa muere o es derrotada defendiendo a su patrona"
        })

        @state.level_up(1)
        @state.add_trinket(5)
        @state.unlock_trophy(:are_you_not_entertained)
      end

      def generate_summary
        "Episodio 13 completado: Bayek se corona campeón en la Arena de Krokodilopolis y ejecuta a Berenike 'El Cocodrilo' en su villa, haciendo justicia por la pequeña Shadya."
      end

      def spoilers
        [
          "Kensa, la mejor amiga de la infancia de Bayek en Siwa, trabaja como guardaespaldas pagada por Berenike y se interpone en la venganza.",
          "Con la caída de Berenike, los cuatro lugartenientes principales de la Orden han sido aniquilados."
        ]
      end

      def easter_eggs
        [
          "La Arena de Krokodilopolis rinde tributo directo a Gladiator, con arenas sangrientas y ovaciones imperiales."
        ]
      end

      def mitigations
        [
          "En la arena, usar el ataque cargado con armas pesadas para romper la postura de escudos dobles de los gladiadores galos.",
          "Desbloquear el trofeo 'Are You Not Entertained?' completando todos los combates de la arena."
        ]
      end

      def side_quests
        ["Sobek's Gold", "Rebel Alliance", "The Sickness"]
      end

      def trophies
        ["are_you_not_entertained", "reduce_reuse_recycle"]
      end
    end
  end
end
