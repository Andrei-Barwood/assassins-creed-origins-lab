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
        "Episodio 08 completado: Taharqa se gana la confianza de Bayek combatiendo a su lado en Sais, para luego drogar su copa y revelar que él es 'El Escarabajo'."
      end

      def spoilers
        [
          "Taharqa es respetado en Sais como un héroe local que construye templos, ocultando que entierra vivos a los rebeldes.",
          "El hijo de Taharqa, Kawab, idolatra a su padre sin sospechar de sus crímenes."
        ]
      end

      def easter_eggs
        [
          "En la villa de Taharqa hay estatuas de Khepri, el dios escarabajo que renace del fango."
        ]
      end

      def mitigations
        [
          "Asegurar la habilidad 'Segundo Aire' para regenerar adrenalina antes del combate en las aldeas del Delta.",
          "Completar 'Conflicts of Interest' para obtener 1250 XP adicionales antes de la emboscada."
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
