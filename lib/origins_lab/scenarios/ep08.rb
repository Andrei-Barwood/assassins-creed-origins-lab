# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep08TheScarabsSting < OriginsLab::BaseScenario
      def episode_id
        "08_la_picadura_del_escarabajo"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 14, role: :medjay, status: :alive },
          relationships: { taharqa: :honorable_host },
          belongings: [:hidden_blade]
        )
        taharqa = Character.new(
          id: :taharqa,
          name: "Taharqa",
          attributes: { hp: 100, role: :sais_noble, status: :alive },
          relationships: { bayek: :feigned_friend },
          belongings: [:drugged_wine]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "sais_taharqa_villa",
          location: "Sais / Delta del Nilo",
          time_period: "48 a.C.",
          drachmas: 2800,
          level: 14,
          hidden_blade_level: 3,
          trinkets_count: 48,
          characters: { bayek: bayek, taharqa: taharqa },
          inventory: [:hidden_blade],
          flags: {}
        )
      end

      def execute_scenario
        _scene_sais = Scene.new(id: :sais_taharqa_villa, title: "Villa de Taharqa", location: "Sais")
        scene_betrayal = Scene.new(id: :drugged_wine_toast, title: "Brindis Envenenado", location: "Sais")
        scene_betrayal.add_precondition("Bayek debe haber defendido la aldea con Taharqa") do |ws|
          ws.flag?(:village_defended)
        end

        emit("story.ally_recruited", actor: :bayek, target: :taharqa, data: { pretext: "Defensa conjunta contra bandidos del Delta" })
        @state.set_flag(:village_defended, true)

        # La traición de Taharqa
        transition_to(scene_betrayal)
        @state.set_flag(:bayek_drugged, true)
        @state.set_flag(:taharqa_is_scarab, true)

        emit("story.betrayal_recorded", actor: :taharqa, target: :bayek, data: {
          substance: "Vino narcótico",
          revelation: "Taharqa es 'El Escarabajo' y ordena enterrar a Bayek en las dunas"
        })

        @state.level_up(1)
        @state.add_trinket(5)
      end

      def generate_summary
        "Sais / Delta del Nilo, 48 a.C. Bayek viaja al f\u00E9rtil y pantanoso Delta del Nilo para desenmascarar a 'El Escarabajo'. En Sais, la poblaci\u00F3n vive aterrorizada por los soldados que entierran a los disidentes vivos en las arenas del desierto. Bayek contacta a la familia del noble Ghupa y rescata a este \u00FAltimo en un campamento militar, solo para descubrir con horror que los torturadores le han extirpado la lengua para impedir que revele el nombre del verdugo. Bayek es acogido cordialmente por el yerno de Ghupa, Taharqa, un carism\u00E1tico maestro constructor que se ofrece a ayudar al Medjay. Sin embargo, durante una cena de aparente camarader\u00EDa, Taharqa ofrece una copa de vino envenenada con estramonio: Bayek pierde el conocimiento mientras Taharqa sonr\u00EDe fr\u00EDamente."
      end

      def spoilers
        [
          "La identidad de 'El Escarabajo': Taharqa es 'El Escarabajo'. Oculto tras una fachada de filantrop\u00EDa y proyectos de construcci\u00F3n de templos para el pueblo, Taharqa es el arquitecto del terror de la Orden en el Delta, eliminando a cualquiera que se oponga a la recaudaci\u00F3n de impuestos forzados.",
          "La tragedia del silencio de Ghupa: Ghupa intentaba desesperadamente alertar a Bayek sobre su propio yerno con gestos desesperados, pero la hospitalidad fingida de Taharqa enga\u00F1\u00F3 los sentidos del Medjay.",
          "El estramonio del Nilo: La droga utilizada por Taharqa no buscaba matar a Bayek en la mesa, sino someterlo a la tortura ceremonial predilecta de El Escarabajo: el entierro en vida en las dunas de Let\u00F3polis para que el sol y las hienas consuman su cuerpo."
        ]
      end

      def easter_eggs
        [
          "El culto a Neit en Sais: Sais era el centro neur\u00E1lgico del culto a la diosa guerrera tejedora Neit. En la ciudad pueden encontrarse tejedoras de lino que entonan plegarias sobre c\u00F3mo Neit teji\u00F3 el mundo a partir de las aguas primordiales del Nun.",
          "La fauna agresiva del Delta: En los canales de Sais los hipop\u00F3tamos y cocodrilos tienen un comportamiento territorial agresivo codificado para atacar tanto a soldados ptolemaicos como a aldeanos."
        ]
      end

      def mitigations
        [
          "Preparaci\u00F3n previa a la copa envenenada: Antes de hablar con Taharqa en su villa para brindar, asegurarse de haber gastado todos los puntos de habilidad y sincronizado las atalayas de Sais. El episodio siguiente despojar\u00E1 temporalmente a Bayek de su equipo y montura."
        ]
      end

      def side_quests
        ["Conflicts of Interest", "Smoke Over Water", "All Eyes on Us"]
      end

      def trophies
        ["reduce_reuse_recycle"]
      end
    end
  end
end
