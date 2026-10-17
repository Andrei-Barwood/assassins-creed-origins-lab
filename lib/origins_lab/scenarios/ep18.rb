# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep18TheFinalWeighing < OriginsLab::BaseScenario
      def episode_id
        "18_el_pesaje_final"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 35, role: :avenger_medjay, status: :alive },
          relationships: { khemu: :avenged_son, flavius: :grandmaster_lion },
          belongings: [:hidden_blade, :hepzefas_sword]
        )
        flavius = Character.new(
          id: :flavius,
          name: "Flavius Metellus (El León)",
          attributes: { hp: 100, role: :grandmaster_order, status: :alive },
          relationships: {},
          belongings: [:apple_of_eden, :lion_mask]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "cyrene_acropolis_temple",
          location: "Acrópolis de Cirene en Kyrenaika",
          time_period: "47 a.C.",
          drachmas: 13000,
          level: 35,
          hidden_blade_level: 10,
          trinkets_count: 10,
          characters: { bayek: bayek, flavius: flavius },
          inventory: [:hidden_blade, :hepzefas_sword],
          flags: {}
        )
      end

      def execute_scenario
        _scene_acropolis = Scene.new(id: :cyrene_acropolis_temple, title: "Acrópolis de Cirene", location: "Cirene")
        scene_weighing = Scene.new(id: :duat_final_weighing, title: "El Pesaje del Corazón", location: "El Más Allá")
        scene_weighing.add_precondition("Flavius debe haber sido derrotado") do |ws|
          ws.flag?(:flavius_eliminated)
        end

        emit("story.infiltrate_acropolis", actor: :bayek, data: { city: "Cirene", state: "Población paralizada por el pulso de la Manzana de Edén" })

        # Combate supremo contra Flavius con la Manzana
        flav = @state.character(:flavius)
        flav.kill!
        @state.eliminate_target(:the_lion)
        @state.set_flag(:flavius_eliminated, true)
        @state.add_item(:apple_of_eden)

        emit("combat.boss_battle_victory", actor: :bayek, target: :flavius, data: {
          weapon: "Espada Ígnea de Hepzefa & Hoja Oculta",
          artifact_neutralized: "Manzana de Edén",
          dialogue_flavius: "El orden prevalecerá... la humanidad anhela un señor."
        })

        # Escena mística del pesaje final: el reencuentro en el Duat con Khemu
        transition_to(scene_weighing)
        @state.set_flag(:khemu_avenged, true)
        emit("story.khemu_peace_recorded", actor: :bayek, data: {
          peace: "El alma de Khemu descansa libre en el Campo de Cañas (Aaru)",
          closure: "La venganza de sangre ha terminado; ahora comienza la causa"
        })

        @state.level_up(1)
        @state.add_trinket(6)
      end

      def generate_summary
        "Kyrenaika / Acr\u00F3polis de Cirene, 47 a.C. Bayek persigue a Flavius Metellus hasta la opulenta Acr\u00F3polis de Cirene en las monta\u00F1as de Kyrenaika. Flavius, embriagado de poder divino, ha activado la Manzana del Ed\u00E9n: la acr\u00F3polis se encuentra sumida en una distorsi\u00F3n espacio-temporal donde los ciudadanos deambulan congelados como estatuas doradas. En el templo de Zeus, se libra la batalla definitiva. Flavius manipula la luz, proyecta copias fantasmales de s\u00ED mismo y distorsiona la gravedad. Con una determinaci\u00F3n sobrehumana forjada en el dolor, Bayek resiste las ilusiones, burla las proyecciones y clava su espada en el coraz\u00F3n de Flavius. En el tr\u00E1nsito del Duat, Bayek se despide espiritualmente de Khemu: la balanza de Ma'at pesa el coraz\u00F3n del ni\u00F1o contra la pluma de la verdad, y Khemu asciende libre hacia los campos de ca\u00F1as de Aaru. La venganza de Siwa se ha consumado."
      end

      def spoilers
        [
          "La liberaci\u00F3n del alma de Khemu: Con la muerte de Flavius ('El Le\u00F3n'), Bayek cumple el juramento que inici\u00F3 su cruzada. Khemu finalmente encuentra descanso eterno en el Duat, lo que permite a Bayek abandonar su sed destructiva de venganza personal y transformar su lucha en un prop\u00F3sito universal de protecci\u00F3n de la libertad humana.",
          "La ilusi\u00F3n de Flavius y el Fruto del Ed\u00E9n: Flavius cre\u00EDa ser un dios viviente destinado a instaurar un 'nuevo orden mundial' donde la humanidad obedeciera sin libre albedr\u00EDo. Sus delirios anticipan la ideolog\u00EDa de los Templarios modernos de Abstergo.",
          "La recuperaci\u00F3n de la Manzana del Ed\u00E9n: Bayek asegura la Manzana de Ed\u00E9n, confiando su custodia temporal a los rebeldes del desierto para evitar que caiga nuevamente en manos de los monarcas ptolemaicos o senadores romanos."
        ]
      end

      def easter_eggs
        [
          "La arquitectura griega de Cirene: Kyrenaika muestra un marcado estilo arquitect\u00F3nico hel\u00E9nico cl\u00E1sico y romano provincial, con teatros excavados en la roca, ba\u00F1os monumentales y mosaicos que difieren profundamente del Egipto fara\u00F3nico tradicional.",
          "La constelaci\u00F3n del Escorpi\u00F3n y el Le\u00F3n: Durante la batalla en el Duat, las constelaciones en el firmamento giran en espiral alrededor de la figura de Khemu, representando el tr\u00E1nsito celestial del fara\u00F3n hacia las estrellas imperecederas (Ikhemu-sek)."
        ]
      end

      def mitigations
        [
          "Fase 2 de Flavius con la Manzana de Ed\u00E9n: Cuando Flavius pierde el 50% de su vida, se vuelve intangible y genera 3 clones de sombra que atacan simult\u00E1neamente. Rodar hacia atr\u00E1s para agrupar a los clones y usar una bomba de humo para aturdirlos al un\u00EDsono, permitiendo ejecutar a Flavius real cuando reaparece en el centro del altar."
        ]
      end

      def side_quests
        ["Absolute Power", "The Flea of Cyrene", "Shadows of Apollo", "His Secret Service"]
      end

      def trophies
        ["done_learning"]
      end
    end
  end
end
