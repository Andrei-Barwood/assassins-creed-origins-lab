# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep06EndOfTheSnake < OriginsLab::BaseScenario
      def episode_id
        "06_el_fin_de_la_serpiente"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 11, role: :medjay, status: :alive },
          relationships: { eudoros: :target_snake },
          belongings: [:hidden_blade]
        )
        eudoros = Character.new(
          id: :eudoros,
          name: "Eudoros (La Serpiente)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: {},
          belongings: [:snake_papyrus]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "alexandria_bathhouse",
          location: "Baños Públicos de Alejandría",
          time_period: "48 a.C.",
          drachmas: 1800,
          level: 11,
          hidden_blade_level: 2,
          trinkets_count: 34,
          characters: { bayek: bayek, eudoros: eudoros },
          inventory: [:hidden_blade],
          flags: {}
        )
      end

      def execute_scenario
        _scene_baths = Scene.new(id: :alexandria_bathhouse, title: "Termas de Vapor", location: "Baños Públicos de Alejandría")
        scene_severing = Scene.new(id: :ritual_ring_finger_severed, title: "El Dedo Cercenado", location: "Alejandría")
        scene_severing.add_precondition("Eudoros debe haber sido ejecutado") do |ws|
          ws.flag?(:eudoros_eliminated)
        end

        emit("story.infiltrate_baths", actor: :bayek, data: { stealth: "Entrada por tragaluz de ventilación" })

        # Ejecución en el vapor y pérdida del dedo anular
        eud = @state.character(:eudoros)
        eud.kill!
        @state.eliminate_target(:the_snake)
        @state.set_flag(:eudoros_eliminated, true)

        # Trágico sacrificio del dedo
        @state.set_flag(:ring_finger_lost, true)
        emit("combat.assassination_executed", actor: :bayek, target: :eudoros, data: {
          weapon: "Hoja Oculta",
          sacrifice: "Dedo anular izquierdo cercenado por el resorte de la hoja en el forcejeo",
          creed_legacy: "Se instaura el rito de iniciación milenario de los Asesinos"
        })

        transition_to(scene_severing)
        @state.level_up(1)
        @state.add_trinket(4)
      end

      def generate_summary
        "Episodio 06 completado: Eudoros 'La Serpiente' es ejecutado en los baños de vapor. Bayek pierde accidentalmente su dedo anular izquierdo, originando el rito de la Hermandad."
      end

      def spoilers
        [
          "El mecanismo no refinado de la primera hoja oculta requería perder el dedo anular para desplegarse sin resistencia.",
          "Eudoros revela que él no era la cabeza de la Serpiente, sino un simple engranaje de la Orden."
        ]
      end

      def easter_eggs
        [
          "Conexión directa con Altaïr Ibn-La'Ahad (AC1), quien también carecía del dedo anular antes de rediseñar la hoja en su Códice."
        ]
      end

      def mitigations
        [
          "Entrar exclusivamente por el tejado superior para no alertar a los guardias de las termas.",
          "No saquear cofres con Aya durante misiones de historia para evitar bugs con 'Old Habits'."
        ]
      end

      def side_quests
        ["Symposiasts", "Wrath of the Poets"]
      end

      def trophies
        ["reduce_reuse_recycle", "handy_man"]
      end
    end
  end
end
