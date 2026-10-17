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
        "Episodio 10 completado: Khaliset 'La Hiena' es ejecutada en medio de una tormenta de arena en Guiza tras descubrir su intento desesperado de resucitar a su hija mediante tecnología Isu."
      end

      def spoilers
        [
          "El dolor de Khaliset por su hija Esris es un espejo exacto del dolor de Bayek por Khemu.",
          "La cámara de Keops es uno de los puntos clave que conducen a la Cripta Isu bajo la Esfinge."
        ]
      end

      def easter_eggs
        [
          "La cripta bajo la Gran Esfinge con el mapa estelar holográfico que desbloquea la Armadura Isu de tecnología luminosa.",
          "Subir al pico más alto del Desierto Negro otorga el trofeo 'I Can See My House From Here!'."
        ]
      end

      def mitigations
        [
          "Estrategia contra Khaliset: Usar Arco de Depredador con flechas teledirigidas para localizarla a través de la tormenta de arena.",
          "Recoger Sílice en todas las galerías de la pirámide de Keops para la armadura Isu secreta."
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
