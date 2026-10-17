# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep15BladeOfTheGoddess < OriginsLab::BaseScenario
      def episode_id
        "15_la_hoja_de_la_diosa"
      end

      def main_actor
        :aya
      end

      def default_initial_state
        aya = Character.new(
          id: :aya,
          name: "Aya de Alejandría",
          attributes: { hp: 100, level: 31, role: :naval_commander, status: :alive },
          relationships: { cleopatra: :sovereign_queen, caesar: :target_ally },
          belongings: [:dual_blades]
        )
        caesar = Character.new(
          id: :caesar,
          name: "Julio César",
          attributes: { hp: 100, role: :roman_dictator, status: :alive },
          relationships: { cleopatra: :seduced_ally },
          belongings: [:golden_laurel]
        )
        cleopatra = Character.new(
          id: :cleopatra,
          name: "Cleopatra VII",
          attributes: { hp: 100, role: :restored_pharaoh, status: :alive },
          relationships: { caesar: :consort },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "alexandria_harbor_carpet",
          location: "Puerto Real y Palacio de Alejandría",
          time_period: "47 a.C.",
          drachmas: 8000,
          level: 31,
          trinkets_count: 93,
          characters: { aya: aya, caesar: caesar, cleopatra: cleopatra },
          inventory: [:dual_blades],
          flags: {}
        )
      end

      def execute_scenario
        _scene_carpet = Scene.new(id: :alexandria_harbor_carpet, title: "La Alfombra de Cleopatra", location: "Palacio de Alejandría")
        scene_pharos = Scene.new(id: :pharos_lighthouse_naval_assault, title: "El Faro de Alejandría", location: "Faro de Alejandría")
        scene_pharos.add_precondition("Cleopatra debe haberse presentado ante Julio César") do |ws|
          ws.flag?(:caesar_met_cleopatra)
        end

        emit("story.carpet_infiltration", actor: :aya, target: :cleopatra, data: {
          strategy: "Infiltrar a Cleopatra enrollada dentro de una alfombra persa en los aposentos de César"
        })
        @state.set_flag(:caesar_met_cleopatra, true)

        # Asalto naval al Faro y encendido de la gran señal ígnea
        transition_to(scene_pharos)
        @state.set_flag(:pharos_signal_ignited, true)
        @state.set_flag(:alexander_tomb_accessed, true)

        emit("combat.naval_victory", actor: :aya, data: {
          action: "Destrucción de la flota ptolemaica y encendido del fuego sagrado en el Faro"
        })
        emit("story.tomb_discovery", actor: :aya, data: {
          tomb: "Soma de Alejandro Magno",
          relics: "Orbe y Cetro Isu descansaban en el féretro de oro"
        })

        @state.level_up(1)
        @state.add_trinket(3)
      end

      def generate_summary
        "Alejandr\u00EDa / Mar Mediterr\u00E1neo, 47 a.C. En una de las secuencias m\u00E1s legendarias de la antig\u00FCedad, Aya toma el mando de las operaciones encubiertas. A bordo de la fal\u00FAa de Apolodoro bajo un manto de niebla marina, Aya envuelve a Cleopatra en una lujosa alfombra persa y la introduce clandestinamente a trav\u00E9s del puerto hasta los aposentos privados de Julio C\u00E9sar en el Palacio Real. C\u00E9sar queda cautivado por la audacia de la reina. Cuando la flota de Ptolomeo cerca el palacio, Aya zarpa al Mediterr\u00E1neo comandando una trirreme, hunde las naves egipcias en un combate naval feroz y escala el colosal Faro de Alejandr\u00EDa bajo una lluvia de catapultas, encendiendo la pira dorada en su c\u00FAspide para guiar el asalto de las legiones de C\u00E9sar."
      end

      def spoilers
        [
          "El mito de la alfombra de Cleopatra: El juego recrea con precisi\u00F3n hist\u00F3rica la an\u00E9cdota narrada por Plutarco en sus 'Vidas Paralelas', mostrando a Cleopatra emergiendo de la alfombra atada para exigir la alianza de Roma.",
          "El control temporal de Aya: En este episodio el jugador toma el control de Aya. Como se establece en las reglas de mitigaci\u00F3n, las ubicaciones del mapa y cofres descubiertos durante esta misi\u00F3n NO se guardan en el registro de Bayek.",
          "La fascinaci\u00F3n de C\u00E9sar por los orbes de poder: Al conocer a Aya y Bayek, C\u00E9sar muestra un inter\u00E9s desmedido por los 'fetiches de los dioses' que la Orden busca recolectar, anticipando su vinculaci\u00F3n final con los Antiguos."
        ]
      end

      def easter_eggs
        [
          "El Faro de Alejandr\u00EDa (Una de las 7 Maravillas del Mundo Antiguo): Con m\u00E1s de 100 metros de altura, su reconstrucci\u00F3n arquitect\u00F3nica con m\u00E1rmol blanco, espejos c\u00F3ncavos de bronce pulido y la estatua de Poseid\u00F3n en la c\u00FAspide es uno de los mayores logros t\u00E9cnicos del juego.",
          "El salto de fe desde la c\u00FAspide del Faro: Realizar el salto de fe desde la punta del faro hacia el mar Mediterr\u00E1neo es el salto con mayor tiempo de ca\u00EDda libre de toda la saga Assassin's Creed."
        ]
      end

      def mitigations
        [
          "Combate naval con la trirreme de Aya: Mantener los remos en avance constante para evitar ser embestido en los flancos por los brulotes incendiarios. Disparar andanadas de flechas incendiarias a los timones enemigos y usar las catapultas de cubierta solo cuando los barcos queden atravesados a tiro de borda."
        ]
      end

      def side_quests
        ["Higher Education"]
      end

      def trophies
        ["reduce_reuse_recycle"]
      end
    end
  end
end
