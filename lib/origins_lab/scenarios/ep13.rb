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
        "Krokodilopolis / Villa de Faiyum, 48 a.C. Para acercarse a los c\u00EDrculos \u00EDntimos de Berenike, Bayek se inscribe como gladiador en la colosal Arena de Krokodilopolis junto a su antigua amiga de Siwa, la feroz cazadora nubia Kensa. Tras superar rondas brutales y abatir a los temidos 'Hermanos Galos' bajo el rugido de la multitud, Bayek descubre que Kensa ha sido contratada como guardaespaldas personal de Berenike. Esa misma noche, Bayek se infiltra en la fortificada villa de Berenike. Kensa interpone su escudo para proteger a su patrona, obligando a un duelo a muerte entre hermanos de armas. Bayek vence a Kensa y ejecuta a Berenike en su propio lecho, clav\u00E1ndole la Hoja Oculta mientras le susurra: 'Esto es por Shadya'."
      end

      def spoilers
        [
          "La ca\u00EDda moral de Kensa: Kensa simboliza lo que Bayek pudo haber sido si hubiera puesto sus habilidades al servicio del mejor postor en lugar de defender la justicia del Medjay. Su muerte en la villa es una tragedia inevitable de lealtades enfrentadas.",
          "El desmantelamiento de las Cuatro Bestias: Con la muerte de Berenike, los cuatro l\u00EDderes territoriales de la Orden (Escarabajo, Hiena, Lagarto y Cocodrilo) han sido purgados. Sin embargo, Bayek recibe un mensaje urgente de Apolodoro: la guerra civil ha estallado en Alejandr\u00EDa con la llegada inminente de la flota romana de Julio C\u00E9sar."
        ]
      end

      def easter_eggs
        [
          "El trofeo 'Are You Not Entertained?': El nombre del trofeo de la arena de Krokodilopolis es una referencia directa a la ic\u00F3nica frase de M\u00E1ximo D\u00E9cimo Meridio en la pel\u00EDcula Gladiator (2000) de Ridley Scott.",
          "Los gladiadores galos y celtas: Hist\u00F3ricamente, Ptolomeo introdujo prisioneros de guerra galos tras las campa\u00F1as del Mediterr\u00E1neo para combatir en anfiteatros como entretenimiento ex\u00F3tico."
        ]
      end

      def mitigations
        [
          "T\u00E1ctica contra los Hermanos Galos en la Arena: El hermano m\u00E1s grande usa un garrote pesado imparable, mientras que el m\u00E1s \u00E1gil arroja jabalinas. Concentrar todo el fuego de flechas ligeras y ataques de sobrecarga en el hermano menor para eliminar la amenaza a distancia antes de encarar al gigante."
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
