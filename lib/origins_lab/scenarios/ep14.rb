# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep14WayOfTheGabiniani < OriginsLab::BaseScenario
      def episode_id
        "14_el_camino_de_los_gabiniani"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 30, role: :medjay, status: :alive },
          relationships: { cleopatra: :sovereign },
          belongings: [:hidden_blade]
        )
        apollodorus = Character.new(
          id: :apollodorus,
          name: "Apolodoro",
          attributes: { hp: 100, role: :spymaster, status: :alive },
          relationships: { cleopatra: :trusted_advisor },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "alexandria_palace_gardens",
          location: "Palacio Real de Alejandría",
          time_period: "47 a.C.",
          drachmas: 7500,
          level: 30,
          hidden_blade_level: 8,
          trinkets_count: 88,
          characters: { bayek: bayek, apollodorus: apollodorus },
          inventory: [:hidden_blade],
          flags: { four_beasts_eliminated: true }
        )
      end

      def execute_scenario
        _scene_palace = Scene.new(id: :alexandria_palace_gardens, title: "Jardines del Palacio Real", location: "Alejandría")
        scene_council = Scene.new(id: :war_council_cleopatra, title: "Consejo de Guerra de Cleopatra", location: "Alejandría")
        scene_council.add_precondition("Bayek debe haber desmantelado las avanzadas de los Gabiniani") do |ws|
          ws.flag?(:gabiniani_outposts_destroyed)
        end

        emit("story.investigate_military", actor: :bayek, data: { threat: "Fuerzas romanas mercenarias Gabiniani ocupan la ciudad" })
        @state.set_flag(:gabiniani_outposts_destroyed, true)

        # Consejo con Cleopatra: Se descubren los nombres de Septimius y Pothinus
        transition_to(scene_council)
        @state.set_flag(:supreme_leaders_revealed, true)
        emit("story.intel_gathered", actor: :apollodorus, data: {
          supreme_masters: ["Lucius Septimius (El Chacal)", "Eunuco Pothinus (El Escorpión)"]
        })

        @state.level_up(1)
        @state.add_trinket(5)
      end

      def generate_summary
        "Alejandr\u00EDa, 47 a.C. La capital de Egipto se encuentra al borde de la insurrecci\u00F3n armada. Los Gabiniani, un regimiento amotinado de legionarios romanos desertores dejados por Aulo Gabinio en el 55 a.C., han tomado el control de los cuarteles mar\u00EDtimos y conspiran con el eunuco Pothinus para asesinar a Cleopatra antes de que pueda reunirse con Julio C\u00E9sar. Bayek se infiltra en las fortificaciones costeras, sabotea los dep\u00F3sitos de brea y ejecuta en duelo singular al mercenario romano Venator. En el palacio real, Cleopatra celebra un consejo de guerra de emergencia: la flota romana de C\u00E9sar ha sido avistada en el horizonte y el destino de Egipto pende de un hilo."
      end

      def spoilers
        [
          "Los Gabiniani como mercenarios de la Orden: Los desertores romanos de Gabinio adoptaron costumbres helen\u00EDsticas y egipcias, pero conservaron la disciplina militar de las legiones, convirti\u00E9ndose en el ej\u00E9rcito privado de la Orden de los Antiguos en Alejandr\u00EDa.",
          "El plan de asesinato de Venator: Venator pretend\u00EDa usar catapultas con proyectiles de brea incendiaria para prender fuego a la flota romana mientras atracaba en el Gran Puerto, culpando a Cleopatra de la masacre para justificar una invasi\u00F3n total de Egipto.",
          "La fractura en la corte de Ptolomeo XIII: El joven rey fara\u00F3n es una marioneta asustada controlada enteramente por Pothinus ('El Escorpi\u00F3n') y el general Septimius ('El Chacal')."
        ]
      end

      def easter_eggs
        [
          "El Gran Puerto de Alejandr\u00EDa (Portus Magnus): La reconstrucci\u00F3n del puerto incluye las esclusas mar\u00EDtimas y la isla de Antirhodos, donde se situaba el palacio privado de Cleopatra que en la actualidad yace sumergido a diez metros bajo el mar.",
          "La menci\u00F3n de Pompeyo el Grande: En las cartas militares se menciona la decapitaci\u00F3n traicionera de Pompeyo Magno en las playas de Pelusio por orden de Pothinus para congraciarse con C\u00E9sar."
        ]
      end

      def mitigations
        [
          "Defensa contra los lanceros Gabiniani: Los legionarios Gabiniani utilizan formaciones de escudo y jabalinas pilum. No intentar romper su guardia frontal con espadas ligeras; usar hachas de combate pesadas con la habilidad 'Rompe-Escudos' o arcos depredadores desde las terrazas."
        ]
      end

      def side_quests
        ["Phylakitai in the Eye", "Cat's Cradle"]
      end

      def trophies
        ["reduce_reuse_recycle"]
      end
    end
  end
end
