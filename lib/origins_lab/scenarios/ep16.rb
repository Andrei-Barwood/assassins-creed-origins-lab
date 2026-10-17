# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep16TheBattleOfTheNile < OriginsLab::BaseScenario
      def episode_id
        "16_la_batalla_del_nilo"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 32, role: :medjay, status: :alive },
          relationships: { caesar: :fragile_ally },
          belongings: [:hidden_blade, :javelins]
        )
        pothinus = Character.new(
          id: :pothinus,
          name: "Eunuco Pothinus (El Escorpión)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: {},
          belongings: [:war_elephant, :scorpion_mask]
        )
        septimius = Character.new(
          id: :septimius,
          name: "Lucius Septimius (El Chacal)",
          attributes: { hp: 100, role: :order_general, status: :alive },
          relationships: { caesar: :future_advisor },
          belongings: [:mace_and_chain]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "nile_chariot_chase",
          location: "Delta del Nilo",
          time_period: "47 a.C.",
          drachmas: 9000,
          level: 32,
          hidden_blade_level: 9,
          trinkets_count: 96,
          characters: { bayek: bayek, pothinus: pothinus, septimius: septimius },
          inventory: [:hidden_blade],
          flags: {}
        )
      end

      def execute_scenario
        _scene_chariot = Scene.new(id: :nile_chariot_chase, title: "Persecución en Carruaje", location: "Delta del Nilo")
        scene_palace_betrayal = Scene.new(id: :cleopatra_caesar_betrayal, title: "La Gran Traición", location: "Palacio de Alejandría")
        scene_palace_betrayal.add_precondition("Pothinus debe haber sido eliminado en la batalla") do |ws|
          ws.flag?(:pothinus_eliminated)
        end

        emit("combat.chariot_battle", actor: :bayek, data: { vehicle: "Carruaje de César", weapon: "Jabalinas explosivas contra elefantes de guerra" })

        # Ejecución de Pothinus
        pot = @state.character(:pothinus)
        pot.kill!
        @state.eliminate_target(:the_scorpion)
        @state.set_flag(:pothinus_eliminated, true)
        @state.add_item(:scorpion_mask)
        emit("combat.assassination_executed", actor: :bayek, target: :pothinus, data: { weapon: "Hoja Oculta", target: "El Escorpión montado en elefante" })

        # Combate contra Septimius e intervención de César
        transition_to(scene_palace_betrayal)
        @state.set_flag(:septimius_spared_by_caesar, true)
        @state.set_flag(:cleopatra_betrayal_confirmed, true)

        emit("story.political_betrayal", actor: :bayek, data: {
          opponents: ["Julio César", "Cleopatra VII"],
          injustice: "César detiene la ejecución de Septimius y lo nombra consejero romano",
          consequence: "Bayek y Aya son expulsados del palacio y repudiados"
        })

        @state.level_up(1)
        @state.add_trinket(4)

        # Si se superan 100 baratijas, ejecutar la venta de mitigación
        if @state.trinkets_count >= 100
          @state.sell_trinkets_all!
        end
      end

      def generate_summary
        "Delta del Nilo, 47 a.C. La Batalla del Nilo desata el caos total entre las legiones de C\u00E9sar y el ej\u00E9rcito de Ptolomeo XIII. Bayek y C\u00E9sar huyen en una cuadriga blindada mientras el dictador romano dispara jabalinas explosivas contra los carros enemigos que los persiguen por la ribera. En el coraz\u00F3n de la batalla campal, Bayek derriba al gigantesco elefante de guerra de Pothinus ('El Escorpi\u00F3n') y ejecuta al eunuco sobre su montura ca\u00EDda. A continuaci\u00F3n, Bayek derrota en un combate a muerte al sanguinario comandante Lucius Septimius ('El Chacal'). Sin embargo, cuando Bayek alza su espada para decapitarlo, C\u00E9sar interviene y ordena un alto el fuego: otorga amnist\u00EDa a Septimius para incorporarlo a su corte militar. Cleopatra respalda la decisi\u00F3n de C\u00E9sar, traicionando el juramento hecho a los Medjay."
      end

      def spoilers
        [
          "La gran traici\u00F3n de Cleopatra y C\u00E9sar: Cleopatra abandona toda lealtad hacia Bayek y Aya al obtener el trono de Egipto respaldada por las legiones romanas. Para mantener la estabilidad del imperio, C\u00E9sar perdona a los cabecillas de la Orden, demostrando que la pol\u00EDtica imperialista de Roma y la Orden de los Antiguos persiguen el mismo fin de dominaci\u00F3n absoluta.",
          "La muerte de Pothinus: Pothinus muere convencido de que actu\u00F3 por el bien de Egipto para protegerlo de la codicia romana. Con su muerte, el fara\u00F3n ni\u00F1o Ptolomeo XIII huye a caballo hacia el Nilo, donde es devorado por cocodrilos seg\u00FAn el relato hist\u00F3rico de Alejandr\u00EDa.",
          "La semilla del divorcio de Aya y Bayek: Ver a Cleopatra coronarse emperatriz mientras abraza a los asesinos de su pueblo quiebra definitivamente la fe de Aya en los monarcas terrenales."
        ]
      end

      def easter_eggs
        [
          "El cruce del r\u00EDo con elefantes de guerra: La escena del elefante derribado en el lodo del Nilo rinde homenaje a los grabados de la batalla del Nilo donde las tropas ptolemaicas fueron empujadas a los marjales por las legiones romanas.",
          "La corona doble de las Dos Tierras: La ceremonia de coronaci\u00F3n de Cleopatra muestra la imposici\u00F3n del Pchent (la corona blanca del Alto Egipto unida a la corona roja del Bajo Egipto) por primera vez con bendici\u00F3n de senadores romanos."
        ]
      end

      def mitigations
        [
          "Estrategia contra el Elefante de Pothinus: El elefante tiene una barra de vida independiente y embiste continuamente. Rodar hacia los laterales para evitar la pisada frontal y disparar con arco ligero a las patas traseras descubiertas de armadura para acumular adrenalina r\u00E1pidamente."
        ]
      end

      def side_quests
        ["Rebel Strike"]
      end

      def trophies
        ["reduce_reuse_recycle"]
      end
    end
  end
end
