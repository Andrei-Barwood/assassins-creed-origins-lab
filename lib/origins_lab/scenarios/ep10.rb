# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep10TheHyenasDen < OriginsLab::BaseScenario
      def episode_id
        "10_la_madriguera_de_la_hiena"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 18, role: :medjay, status: :alive },
          relationships: { khaliset: :target_hyena },
          belongings: [:hidden_blade, :predator_bow]
        )
        khaliset = Character.new(
          id: :khaliset,
          name: "Khaliset (La Hiena)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: {},
          belongings: [:hyena_mask, :fire_arrows, :silica_shards]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "giza_pyramid_khufu",
          location: "Pirámide de Keops en Guiza",
          time_period: "48 a.C.",
          drachmas: 3800,
          level: 18,
          hidden_blade_level: 4,
          trinkets_count: 62,
          characters: { bayek: bayek, khaliset: khaliset },
          inventory: [:hidden_blade, :predator_bow],
          flags: {}
        )
      end

      def execute_scenario
        _scene_tomb = Scene.new(id: :giza_pyramid_khufu, title: "Cámara Ancestral de Keops", location: "Guiza")
        scene_storm = Scene.new(id: :sandstorm_hyena_duel, title: "Tormenta de Arena de Guiza", location: "Meseta de Guiza")
        scene_storm.add_precondition("Bayek debe haber descubierto el ritual de resurrección de Khaliset") do |ws|
          ws.flag?(:resurrection_ritual_discovered)
        end

        emit("story.tomb_explored", actor: :bayek, data: { tomb: "Pirámide de Keops", finding: "Cuerpo momificado de la hija de Khaliset (Esris)" })
        @state.set_flag(:resurrection_ritual_discovered, true)

        # Duelo en la tormenta de arena
        transition_to(scene_storm)
        hyena = @state.character(:khaliset)
        hyena.kill!
        @state.eliminate_target(:the_hyena)
        @state.set_flag(:hyena_eliminated, true)
        @state.add_item(:hyena_mask)

        emit("combat.assassination_executed", actor: :bayek, target: :khaliset, data: {
          arena: "Tormenta de arena cegadora",
          companion_threat: "Manada de hienas salvajes",
          tragedy: "Khaliset buscaba devolverle la vida a su hija con tecnología Isu"
        })

        @state.level_up(1)
        @state.add_trinket(6)
        @state.unlock_trophy(:house_from_here)
      end

      def generate_summary
        "Meseta de Guiza, 48 a.C. Las milenarias Pir\u00E1mides de Keops, Kefr\u00E9n y Micerino se alzan monumentales bajo el viento implacable del desierto. Bayek sigue el rastro de profanaciones de tumbas hasta la guarida de Khaliset, 'La Hiena'. Descendiendo a las profundidades secretas de la Gran Pir\u00E1mide de Keops, Bayek descubre un espect\u00E1culo escalofriante: la c\u00E1mara sarc\u00F3fago est\u00E1 iluminada por monolitos Isu activos con S\u00EDlice y rodeada de cad\u00E1veres de prisioneros sacrificados. Khaliset, una madre enloquecida por el dolor de haber perdido a su peque\u00F1a hija Esris, intenta descifrar los textos precursores para resucitarla. Bayek la persigue hacia la superficie en medio de una violenta tormenta de arena, abatiendo a sus hienas guardianas y dando fin a su desquiciada tragedia."
      end

      def spoilers
        [
          "La manipulaci\u00F3n de los artefactos Isu por la Orden: Khaliset no actuaba por avaricia territorial, sino manipulada por la Orden, quienes le prometieron que los artefactos de la Primera Civilizaci\u00F3n ten\u00EDan el poder de regresar a los muertos del Duat. Esto establece que los artefactos Isu no son magia divina, sino tecnolog\u00EDa cu\u00E1ntica incomprendida.",
          "El paralelismo entre Bayek y Khaliset: Ambos son padres destrozados por el duelo de perder a sus hijos. Durante el rito funerario de la pluma, Bayek le confiesa conmovido que comprende su dolor pero que la muerte no puede revertirse a costa de la sangre de inocentes.",
          "La red de S\u00EDlice en las pir\u00E1mides: En esta misi\u00F3n se introduce el mineral Isu 'S\u00EDlice' (Silica), el recurso brillante dorado necesario para activar los Seis Mecanismos Antiguos y conseguir la legendaria Armadura Isu."
        ]
      end

      def easter_eggs
        [
          "La c\u00E1mara secreta de la Gran Pir\u00E1mide: Ubisoft model\u00F3 la Gran Pir\u00E1mide con un gran vac\u00EDo interior sobre la Gran Galer\u00EDa meses antes de que los cient\u00EDficos del proyecto ScanPyramids confirmaran en la vida real la existencia del gran vac\u00EDo en noviembre de 2017.",
          "El cementerio de momias de perros: En las inmediaciones de la tumba de Khufu se encuentra un cementerio canino donde los antiguos egipcios momificaban hienas y chacales como ofrenda al dios Anubis."
        ]
      end

      def mitigations
        [
          "Combate en la tormenta de arena contra Khaliset: Khaliset utiliza un arco de cazador con flechas de fuego y se oculta en la niebla de arena mientras sus hienas alfa flanquean a Bayek. Usar a Senu para marcar su silueta a trav\u00E9s de la tormenta y equipar un escudo con 100% de resistencia a proyectiles."
        ]
      end

      def side_quests
        ["Thick Skin", "What's Yours Is Mine"]
      end

      def trophies
        ["house_from_here", "reduce_reuse_recycle"]
      end
    end
  end
end
