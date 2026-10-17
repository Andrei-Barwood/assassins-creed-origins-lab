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
        "Episodio 12 completado: La búsqueda de las cuentas del Cocodrilo concluye en la tragedia más atroz de Egipto: la pequeña Shadya es arrojada al fondo del lago atada a una piedra."
      end

      def spoilers
        [
          "El asesinato de Shadya es el punto de no retorno emocional para Bayek, desatando una cacería despiadada.",
          "Berenike, una anciana matrona griega respetada, es la mente sádica detrás de 'El Cocodrilo'."
        ]
      end

      def easter_eggs
        [
          "Bucear en el lago de Faiyum permite encontrar ruinas sumergidas con reliquias de la era del Reino Medio."
        ]
      end

      def mitigations
        [
          "Cazar en los pantanos de Faiyum para maximizar las bolsas de herramientas y carcaj de flechas antes del asedio a Krokodilopolis.",
          "Completar 'Murder in the Temple' y 'The Bride' para subir a nivel 28."
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
