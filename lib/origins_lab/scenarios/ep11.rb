# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep11TheLizardsFace < OriginsLab::BaseScenario
      def episode_id
        "11_el_rostro_del_lagarto"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 20, role: :medjay, status: :alive },
          relationships: { hetepi: :target_lizard },
          belongings: [:hidden_blade]
        )
        hetepi = Character.new(
          id: :hetepi,
          name: "Sumo Sacerdote Hetepi (El Lagarto)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: {},
          belongings: [:lizard_mask, :blue_scarf, :poison_vial]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "memphis_temple_of_ptah",
          location: "Templo de Ptah en Menfis",
          time_period: "48 a.C.",
          drachmas: 4500,
          level: 20,
          hidden_blade_level: 5,
          trinkets_count: 68,
          characters: { bayek: bayek, hetepi: hetepi },
          inventory: [:hidden_blade],
          flags: {}
        )
      end

      def execute_scenario
        _scene_temple = Scene.new(id: :memphis_temple_of_ptah, title: "Templo de Ptah", location: "Menfis")
        scene_duat = Scene.new(id: :duat_apep_hallucination, title: "El Sueño del Duat", location: "El Más Allá")
        scene_duat.add_precondition("Hetepi debe haber sido desenmascarado y ejecutado") do |ws|
          ws.flag?(:hetepi_eliminated)
        end

        emit("story.investigate_plague", actor: :bayek, data: { clue: "Toro Apis envenenado con arsénico" })

        # Identificación correcta del sacerdote enmascarado
        het = @state.character(:hetepi)
        het.kill!
        @state.eliminate_target(:the_lizard)
        @state.set_flag(:hetepi_eliminated, true)
        @state.add_item(:lizard_mask)

        emit("combat.assassination_executed", actor: :bayek, target: :hetepi, data: {
          identification: "Sacerdote del pañuelo azul que tose por el humo venenoso",
          location: "Atrio sagrado del Templo de Ptah"
        })

        # Visión en el Duat combatiendo contra Apep
        transition_to(scene_duat)
        emit("story.vision_duat", actor: :bayek, data: { vision: "Batalla mística contra la serpiente gigante Apep en la barca solar" })

        @state.level_up(1)
        @state.add_trinket(6)
        @state.unlock_trophy(:raging_bulls)
      end

      def generate_summary
        "Menfis, 48 a.C. La capital espiritual y antigua metr\u00F3polis del Bajo Egipto se desmorona: el aire huele a carne podrida, las aguas del Nilo est\u00E1n contaminadas y el buey sagrado Apis agoniza en su templo. Bayek investiga la maldici\u00F3n de 'El Lagarto'. Tras descubrir que la esposa del Sumo Sacerdote Pasherenptah ha sufrido abortos provocados por brebajes envenenados, Bayek es guiado por los sacerdotes a un trance ritual: su esp\u00EDritu desciende a las aguas tenebrosas del Duat a bordo de la barca solar de Ra, enfrent\u00E1ndose en un duelo tit\u00E1nico a la serpiente c\u00F3smica Apep. Al despertar, Bayek descubre que 'El Lagarto' es Hetepi, uno de los sacerdotes m\u00E1s respetados del Templo de Ptah, distinguido por una bufanda azul y una tos seca persistente."
      end

      def spoilers
        [
          "El envenenamiento del linaje de Menfis: Hetepi utilizaba plomo molido y toxinas de v\u00EDboras en los alimentos y aceites de unci\u00F3n del clero para debilitar la resistencia de los sacerdotes tradicionales y entregar el control del culto a la Orden de los Antiguos.",
          "El simbolismo de la batalla contra Apep: La batalla on\u00EDrica contra Apep representa la lucha existencial de Bayek contra la desesperanza y la corrupci\u00F3n moral. El 'Arco de Luz' entregado en el sue\u00F1o es una met\u00E1fora de la pureza de la justicia que el Medjay debe mantener.",
          "El m\u00E9todo de identificaci\u00F3n de Hetepi: En el patio del templo hay cinco sacerdotes id\u00E9nticos en atuendo blanco. Matar al sacerdote equivocado desata penalizaciones; la clave deductiva proporcionada por Pasherenptah es identificar al \u00FAnico sacerdote que tose continuamente y viste una bufanda de lino te\u00F1ida de azul oscuro."
        ]
      end

      def easter_eggs
        [
          "El embalsamamiento del buey Apis: En la misi\u00F3n secundaria 'Pr\u00E1ctica Mortuoria' en Menfis se puede observar el proceso hist\u00F3rico exacto de momificaci\u00F3n del toro sagrado Apis, que requer\u00EDa 70 d\u00EDas y tinas colosales de sal de natr\u00F3n.",
          "Los murales de Ptah: El Templo de Ptah exhibe bajorrelieves que narran la creaci\u00F3n del universo a trav\u00E9s del pensamiento y la palabra del dios Ptah, un concepto teol\u00F3gico id\u00E9ntico al 'Logos' de los fil\u00F3sofos griegos."
        ]
      end

      def mitigations
        [
          "Identificaci\u00F3n limpia de Hetepi: NO atacar a los sacerdotes al azar en el templo de Ptah. Subir a las vigas del techo, usar a Senu en modo estacionario y esperar 30 segundos observando a los sospechosos hasta localizar al que tose y escupe sangre sobre el altar."
        ]
      end

      def side_quests
        ["Odor Most Foul", "Blood in the Water", "The Baker's Dilemma", "Children of Anubis"]
      end

      def trophies
        ["raging_bulls", "reduce_reuse_recycle"]
      end
    end
  end
end
