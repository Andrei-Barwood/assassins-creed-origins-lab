# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep02TheFalseSiwan < OriginsLab::BaseScenario
      def episode_id
        "02_el_falso_siwan"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 3, role: :medjay, status: :alive },
          relationships: { medunamun: :sworn_enemy },
          belongings: [:medjay_badge, :hunter_bow]
        )
        medunamun = Character.new(
          id: :medunamun,
          name: "Medunamun (El Ibis)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: {},
          belongings: [:apple_of_eden, :ibis_mask]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "temple_of_amun_siwa",
          location: "Templo de Amón en Siwa",
          time_period: "49 a.C.",
          drachmas: 500,
          level: 4,
          trinkets_count: 8,
          characters: { bayek: bayek, medunamun: medunamun },
          inventory: [:medjay_badge],
          flags: {}
        )
      end

      def execute_scenario
        _scene_temple = Scene.new(id: :temple_of_amun_siwa, title: "Templo de Amón", location: "Siwa")
        scene_aftermath = Scene.new(id: :liberation_of_siwa, title: "Siwa Liberada", location: "Siwa")
        scene_aftermath.add_precondition("Medunamun debe haber sido eliminado") do |ws|
          ws.flag?(:medunamun_eliminated)
        end

        emit("story.infiltrate_temple", actor: :bayek, data: { target: "Medunamun" })

        # Ejecución brutal de Medunamun
        medunamun = @state.character(:medunamun)
        medunamun.kill!
        @state.eliminate_target(:the_ibis)
        @state.set_flag(:medunamun_eliminated, true)
        @state.add_item(:ibis_mask)

        emit("combat.assassination_executed", actor: :bayek, target: :medunamun, data: { weapon: "Orbe Isu", consequence: "Cráneo destrozado contra el artefacto" })

        transition_to(scene_aftermath)
        @state.set_flag(:siwa_liberated, true)
        @state.level_up(1)
        @state.add_trinket(5)
      end

      def generate_summary
        "Siwa, 49 a.C. En el monumental Templo de Am\u00F3n, Medunamun 'El Ibis' somete a la poblaci\u00F3n nativa a interrogatorios brutales mientras intenta forzar el despertar del Orbe de Ed\u00E9n incautado a la familia de Bayek. Infiltr\u00E1ndose entre las columnatas sagradas al caer el crep\u00FAsculo, Bayek neutraliza a los guardias ceremoniales y confronta al sacerdote traidor. En un cl\u00EDmax de furia ciega, Bayek arrebata el Orbe Isu de manos de Medunamun y lo utiliza como una maza contundente de piedra dorada, reventando el cr\u00E1neo del Ibis contra las losas del altar y liberando finalmente a su oasis natal de la tiran\u00EDa."
      end

      def spoilers
        [
          "El despertar fallido del Orbe de Ed\u00E9n: Medunamun ignoraba que los artefactos de la Primera Civilizaci\u00F3n requieren linajes gen\u00E9ticos compatibles con alta concentraci\u00F3n de triple h\u00E9lice de ADN Isu. Pese a torturar durante meses a sacerdotes y aldeanos, el artefacto se mantuvo inerte en sus manos, reduci\u00E9ndose a un fetiche dorado que termin\u00F3 siendo el instrumento f\u00EDsico de su propia ejecuci\u00F3n.",
          "La red de tortura en la Casa de la Vida: Documentos hallados en los aposentos de Medunamun prueban que la Orden de los Antiguos no actuaba de manera aislada en Siwa: manten\u00EDa correspondencia cifrada con Alejandr\u00EDa dirigida a 'La Serpiente', solicitando refuerzos navales y destacamentos de mercenarios para asegurar las rutas de caravanas.",
          "La herida psicol\u00F3gica de Bayek: Tras la muerte de Medunamun, Bayek experimenta su primera crisis de identidad. Liberar Siwa no borra el recuerdo del cad\u00E1ver ensangrentado de Khemu ni alivia la culpa de haber empu\u00F1ado la daga que seg\u00F3 su vida. La venganza se torna su \u00FAnica raz\u00F3n de existencia."
        ]
      end

      def easter_eggs
        [
          "El eco de los c\u00E1nticos de Am\u00F3n: Al entrar a la cella interior del templo de Am\u00F3n, si el jugador apaga las antorchas, se escuchan susurros corales en egipcio antiguo que recitan fragmentos del Papiro de Ani del Libro de los Muertos.",
          "El atuendo tradicional de Medjay: El traje original de Bayek lleva el emblema de pluma de avestruz de Ma'at en el broche del hombro derecho, marcando la tradici\u00F3n de los guerreros nubios y egipcios que proteg\u00EDan al fara\u00F3n desde el Imperio Antiguo (2500 a.C.)."
        ]
      end

      def mitigations
        [
          "Infiltraci\u00F3n vertical en el Templo de Am\u00F3n: Evitar la entrada principal fuertemente custodiada por lanceros ptolemaicos. Escalar el muro perimetral norte por los andamios de madera de los obreros; esto sit\u00FAa a Bayek directamente sobre las vigas del techo de la cella para ejecutar un derribo a\u00E9reo sobre Medunamun.",
          "Optimizaci\u00F3n de puntos de habilidad iniciales: Invertir el primer punto de habilidad obtenido al alcanzar nivel 2 en 'Regeneraci\u00F3n' (Rama del Guerrero) y el segundo en 'Flecha Guiada' o 'Disparo Cargado' (Rama del Cazador) para eliminar guardias de atalaya de un solo impacto a la cabeza."
        ]
      end

      def side_quests
        ["The Healer", "Prisoners in the Temple"]
      end

      def trophies
        ["first_steps", "reduce_reuse_recycle"]
      end
    end
  end
end
