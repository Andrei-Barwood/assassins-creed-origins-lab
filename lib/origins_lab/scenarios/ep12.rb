# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep12TheCrocodilesScales < OriginsLab::BaseScenario
      def episode_id
        "12_las_escamas_del_cocodrilo"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 24, role: :medjay, status: :alive },
          relationships: { shadya: :protector_friend, hotephres: :rebel_informant },
          belongings: [:hidden_blade]
        )
        shadya = Character.new(
          id: :shadya,
          name: "Pequeña Shadya",
          attributes: { hp: 100, age: :child, status: :alive },
          relationships: { bayek: :hero_uncle },
          belongings: [:account_ledger]
        )
        hotephres = Character.new(
          id: :hotephres,
          name: "Hotephres",
          attributes: { hp: 100, role: :grecian_official, status: :alive },
          relationships: { shadya: :daughter },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "faiyum_villa_karanis",
          location: "Karanis en el Oasis de Faiyum",
          time_period: "48 a.C.",
          drachmas: 5200,
          level: 24,
          hidden_blade_level: 6,
          trinkets_count: 74,
          characters: { bayek: bayek, shadya: shadya, hotephres: hotephres },
          inventory: [:hidden_blade],
          flags: {}
        )
      end

      def execute_scenario
        _scene_karanis = Scene.new(id: :faiyum_villa_karanis, title: "Karanis", location: "Faiyum")
        scene_lake = Scene.new(id: :faiyum_lake_tragedy, title: "Fondo del Lago de Faiyum", location: "Faiyum")
        scene_lake.add_precondition("Bayek debe haber buscado a Shadya en el muelle") do |ws|
          ws.flag?(:shadya_abducted)
        end

        emit("story.investigate_corruption", actor: :bayek, data: { region: "Faiyum", ally: "Hotephres y la pequeña Shadya" })
        @state.set_flag(:shadya_abducted, true)

        # Trágico asesinato de Shadya
        transition_to(scene_lake)
        sh = @state.character(:shadya)
        sh.kill!
        @state.set_flag(:shadya_drowned, true)

        emit("story.tragedy_recorded", actor: :bayek, target: :shadya, data: {
          crime: "Atada a una piedra pesada y arrojada al fondo del lago por orden de Berenike",
          emotional_impact: "Bayek recupera el cuerpo inerte sumergido en las aguas de Faiyum",
          consequence: "Furia incontrolable del Medjay hacia 'El Cocodrilo'"
        })

        @state.level_up(1)
        @state.add_trinket(5)
      end

      def generate_summary
        "Oasis de Faiyum, 48 a.C. El f\u00E9rtil oasis de Faiyum, joya agr\u00EDcola de Egipto, sufre la codicia de terratenientes griegos comandados por 'El Cocodrilo'. Bayek se al\u00EDa con Hotephres y su esposa Khenut para recuperar la libreta de cuentas confidencial que detalla las confiscaciones ilegales de tierras. La libreta es custodiada por la peque\u00F1a Shadya, una ni\u00F1a hu\u00E9rfana de mirada pura y coraz\u00F3n valiente. Sin embargo, los esbirros de la Orden interceptan a la peque\u00F1a. Bayek llega al muelle del lago de Faiyum y presencia la escena m\u00E1s desgarradora de su traves\u00EDa: los soldados han arrojado a Shadya a las profundidades del lago atada con cuerdas a una pesada piedra de molino. Bayek se sumerge en las aguas heladas y rescata el cuerpo sin vida de la ni\u00F1a, rompiendo en llanto sobre la orilla."
      end

      def spoilers
        [
          "La muerte de Shadya como catalizador emocional: Este suceso es considerado el punto de inflexi\u00F3n m\u00E1s dram\u00E1tico de toda la trama de Assassin's Creed Origins. El asesinato despiadado de una ni\u00F1a indefensa reabre la herida de Khemu y convence a Bayek de que los l\u00EDderes de la Orden carecen por completo de humanidad y deben ser purgados sin piedad ni juicio.",
          "La identidad de 'El Cocodrilo': La libreta de cuentas recuperada revela que 'El Cocodrilo' es Berenike, una arist\u00F3crata de origen ptolemaico que financia las campa\u00F1as militares de Ptolomeo XIII a cambio del monopolio de la producci\u00F3n de trigo de Faiyum.",
          "La venganza de Khenut: Tras la muerte de Shadya, la madre adoptiva Khenut entrega a Bayek su propia daga ceremonial, rog\u00E1ndole que no deje un solo hueso sano en el cuerpo de Berenike."
        ]
      end

      def easter_eggs
        [
          "La mu\u00F1eca de Shadya: Si tras completar la misi\u00F3n el jugador bucea en el punto exacto donde Shadya fue ahogada, se encuentra en el lecho marino una peque\u00F1a mu\u00F1eca de trapo y madera junto a la piedra de molino rota.",
          "La arquitectura de Krokodilopolis: La ciudad fue fundada bajo el patrocinio del dios cocodrilo Sobek. En los estanques sagrados pueden verse sacerdotes alimentando cocodrilos enjoyados con carne de cordero marinada en vino con miel."
        ]
      end

      def mitigations
        [
          "Combate naval en el lago de Faiyum: Durante la b\u00FAsqueda de la libreta, varias fal\u00FAas y trirremes patrullan el lago. No combatir nadando en el agua; abordar una embarcaci\u00F3n menor y usar flechas de fuego contra las velas enemigas para incendiarlas a distancia."
        ]
      end

      def side_quests
        ["Murder in the Temple", "The Bride", "The Sickness", "Sobek's Gold"]
      end

      def trophies
        ["circle_of_life", "reduce_reuse_recycle"]
      end
    end
  end
end
