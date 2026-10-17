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
        "Alejandr\u00EDa / Siwa, 47 a.C. Bayek y Aya se infiltran en el mausoleo subterr\u00E1neo de Alejandro Magno para investigar los movimientos de los romanos. En el interior encuentran una masacre: los guardias de Cleopatra han sido masacrados y Apolodoro yace desangr\u00E1ndose en el suelo. Con sus \u00FAltimas fuerzas, Apolodoro revela la verdad m\u00E1s oscura: el respetado general romano Flavius Metellus es 'El Le\u00F3n', l\u00EDder supremo de la Orden de los Antiguos. Flavius y Septimius han robado el legendario Cetro Isu de la tumba de Alejandro y la Manzana del Ed\u00E9n de Siwa, marchando hacia el oasis natal de Bayek. Bayek cabalga a toda velocidad hacia Siwa, solo para encontrar el templo en ruinas y el cad\u00E1ver torturado de su amado hermano de armas, Hepzefa. Sobre el cuerpo inerte de su amigo, Bayek derrama l\u00E1grimas de sangre y renueva su voto de exterminio."
      end

      def spoilers
        [
          "Flavius como 'El Le\u00F3n': Flavius Metellus era el cerebro supremo detr\u00E1s de la tragedia de Khemu. Fue Flavius quien orden\u00F3 secuestrar al ni\u00F1o en Siwa en el 49 a.C. y quien desvi\u00F3 la mano de Bayek en la cripta.",
          "El martirio de Hepzefa: Hepzefa resisti\u00F3 torturas atroces con fuego sin revelar la ubicaci\u00F3n de los textos sagrados de la cripta Isu de Siwa. Su sacrificio permiti\u00F3 que Bayek pudiera llegar a tiempo para evitar que Flavius abriera el mecanismo primordial.",
          "La combinaci\u00F3n del Cetro y la Manzana: En el lore de Assassin's Creed, cuando el Cetro de Ed\u00E9n y la Manzana del Ed\u00E9n se unen, otorgan a su portador el poder de controlar la voluntad de ej\u00E9rcitos enteros y proyectar campos de fuerza impenetrables."
        ]
      end

      def easter_eggs
        [
          "La tumba real de Alejandro Magno (Soma): La localizaci\u00F3n de la tumba de Alejandro es uno de los mayores enigmas de la arqueolog\u00EDa moderna. El juego ubica su cripta de alabastro bajo las calles de Alejandr\u00EDa, con su cuerpo preservado en un sarc\u00F3fago de cristal sumergido en miel.",
          "La espada ceremonial de Hepzefa: Bayek recoge la espada de bronce con fuego de Hepzefa, la cual se convierte en una de las armas legendarias m\u00E1s poderosas del juego ('La Hoja de Hepzefa', que prende fuego instant\u00E1neamente a los enemigos al golpear)."
        ]
      end

      def mitigations
        [
          "Obtenci\u00F3n de la Hoja de Hepzefa: Completar el funeral de Hepzefa otorga esta espada \u00FAnica. Es fundamental acudir de inmediato al herrero de Siwa para subirla a nivel 35 antes de partir hacia Kyrenaika para enfrentar a Flavius."
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
