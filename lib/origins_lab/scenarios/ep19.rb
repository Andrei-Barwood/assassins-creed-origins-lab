# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep19LastOfTheMedjay < OriginsLab::BaseScenario
      def episode_id
        "19_el_ultimo_medjay"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 36, role: :founder_hidden_ones, status: :alive },
          relationships: { aya: :co_founder_eternal_love },
          belongings: [:hidden_blade, :eagle_skull_amulet]
        )
        aya = Character.new(
          id: :aya,
          name: "Aya de Alejandría",
          attributes: { hp: 100, level: 36, role: :founder_hidden_ones, status: :alive },
          relationships: { bayek: :parting_comrade },
          belongings: [:dual_blades]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "alexandria_shoreline_parting",
          location: "Costas del Mediterráneo en Alejandría",
          time_period: "47 a.C.",
          drachmas: 15000,
          level: 36,
          hidden_blade_level: 10,
          trinkets_count: 14,
          characters: { bayek: bayek, aya: aya },
          inventory: [:hidden_blade],
          flags: { khemu_avenged: true }
        )
      end

      def execute_scenario
        _scene_beach = Scene.new(id: :alexandria_shoreline_parting, title: "La Playa del Destino", location: "Alejandría")
        scene_creed = Scene.new(id: :birth_of_hidden_ones, title: "Nacimiento de los Ocultos", location: "Alejandría")
        scene_creed.add_precondition("Bayek y Aya deben haber aceptado su separación por la causa") do |ws|
          ws.flag?(:marriage_concluded)
        end

        emit("story.parting_vows", actor: :bayek, target: :aya, data: {
          dialogue: "Aya de Alejandría ha muerto. Bayek de Siwa ya no existe. Solo quedan los Ocultos."
        })
        @state.set_flag(:marriage_concluded, true)

        # El nacimiento del logo en la arena
        transition_to(scene_creed)
        @state.set_flag(:hidden_ones_founded, true)
        @state.set_flag(:assassin_insignia_born, true)

        emit("story.insignia_revealed", actor: :bayek, data: {
          gesture: "Bayek arroja el amuleto del cráneo de águila de Khemu a la arena mojada",
          symbol: "Al levantarlo, la impronta en la arena crea el logotipo de los Asesinos",
          creed: "Nada es verdad, todo está permitido. Trabajamos en la oscuridad para servir a la luz."
        })

        @state.level_up(1)
        @state.add_trinket(5)
      end

      def generate_summary
        "Playas de Alejandr\u00EDa, 47 a.C. En una playa desierta al atardecer frente al romper de las olas de Alejandr\u00EDa, Bayek y Aya se re\u00FAnen para su \u00FAltimo encuentro como marido y mujer. Reconocen con madurez desgarradora que el matrimonio que compart\u00EDan muri\u00F3 el mismo d\u00EDa que enterraron a Khemu: el amor conyugal ya no puede contener la magnitud de la causa que han desatado. Deciden fundar una hermandad secreta consagrada a combatir a los tiranos desde las sombras: 'Los Ocultos' (The Hidden Ones). Formulan su credo inmortal: 'Trabajamos en la oscuridad para servir a la luz'. Al abrazarse por \u00FAltima vez, Bayek extrae de su bolsa el collar con el cr\u00E1neo de \u00E1guila de Khemu y lo arroja a la arena; al levantarlo Aya, la calavera deja grabada en la arena una hendidura perfecta que se convierte en el emblema milenario de la Hermandad de Asesinos."
      end

      def spoilers
        [
          "El nacimiento del s\u00EDmbolo de los Asesinos: El icono can\u00F3nico de la Hermandad de Asesinos que perdurar\u00E1 por miles de a\u00F1os no es un s\u00EDmbolo matem\u00E1tico ni una letra griega; es la huella invertida dejada en la arena de Egipto por el cr\u00E1neo fosilizado del \u00E1guila de Khemu.",
          "La divisi\u00F3n geogr\u00E1fica de los Ocultos: Bayek se queda en Egipto para consolidar la hermandad en el valle del Nilo, mientras que Aya asume la misi\u00F3n m\u00E1s peligrosa: viajar al coraz\u00F3n del Imperio Romano para extirpar los tent\u00E1culos de la Orden en el Senado de Roma.",
          "El dogma fundacional: En esta conversaci\u00F3n en la playa se establecen los tres principios del Credo de los Asesinos: apartar la hoja de la carne del inocente, ocultarse a plena vista y no comprometer jam\u00E1s a la Hermandad."
        ]
      end

      def easter_eggs
        [
          "La carta marina de Roma: Aya muestra a Bayek un mapa n\u00E1utico donde est\u00E1n marcadas las costas de Ostia y el r\u00EDo T\u00EDber, trazando la ruta que conducir\u00E1 al desenlace final del juego en Roma.",
          "El tema musical 'Ezio's Family': Durante la escena donde el cr\u00E1neo de \u00E1guila toca la arena y nace el emblema, la banda sonora modula hacia una emotiva y solemne interpretaci\u00F3n con la\u00FAd egipcio del c\u00E9lebre tema 'Ezio's Family' de Jesper Kyd, sellando la continuidad musical de toda la franquicia."
        ]
      end

      def mitigations
        [
          "Punto de no retorno hacia Roma: Tras este episodio, el juego ofrece la opci\u00F3n de zarpar hacia Roma. Aunque no se pierde el progreso del mundo abierto (se puede regresar a Egipto libremente en el post-juego), se recomienda tener el nivel 36 antes de abordar la nave para no sufrir penalizaciones en las misiones de Aya en la capital imperial."
        ]
      end

      def side_quests
        ["Seven Farmers", "The Love Dilemma"]
      end

      def trophies
        ["seven_farmers"]
      end
    end
  end
end
