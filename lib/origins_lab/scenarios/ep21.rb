# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep21BirthOfTheCreedRome < OriginsLab::BaseScenario
      def episode_id
        "21_nacimiento_del_credo_roma"
      end

      def main_actor
        :aya
      end

      def default_initial_state
        aya = Character.new(
          id: :aya,
          name: "Amunet (Aya)",
          attributes: { hp: 100, level: 38, role: :mentor_of_rome, status: :alive },
          relationships: { brutus: :co_conspirator, caesar: :tyrant_target },
          belongings: [:hidden_blade]
        )
        caesar = Character.new(
          id: :caesar,
          name: "Julio César (Padre de la Comprensión)",
          attributes: { hp: 100, role: :dictator_perpetuo, status: :alive },
          relationships: {},
          belongings: [:toga_senatus]
        )
        layla = Character.new(
          id: :layla,
          name: "Layla Hassan",
          attributes: { hp: 100, role: :modern_animus_pioneer, status: :alive },
          relationships: { william_miles: :new_mentor },
          belongings: [:portable_animus_rig]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "rome_senate_curia",
          location: "Curia del Senado de Pompeyo en Roma",
          time_period: "15 de marzo del 44 a.C. (Idus de Marzo)",
          drachmas: 25000,
          level: 38,
          trinkets_count: 22,
          characters: { aya: aya, caesar: caesar, layla: layla },
          inventory: [:hidden_blade],
          flags: { septimius_eliminated: true }
        )
      end

      def execute_scenario
        _scene_senate = Scene.new(id: :rome_senate_curia, title: "Curia del Senado", location: "Roma")
        scene_letter = Scene.new(id: :letter_to_bayek_amunet, title: "La Carta de Amunet", location: "Roma / Alejandría")
        scene_modern = Scene.new(id: :modern_day_qattara_cave, title: "Cueva de Qattara (Presente)", location: "Depresión de Qattara")

        scene_letter.add_precondition("Julio César debe haber sido ejecutado en el Senado") do |ws|
          ws.flag?(:caesar_eliminated)
        end
        scene_modern.add_precondition("La carta de Amunet debe haber sido enviada a Bayek") do |ws|
          ws.flag?(:amunet_letter_sent)
        end

        emit("story.senate_infiltration", actor: :aya, data: { date: "15 de marzo del 44 a.C.", allies: ["Marco Junio Bruto", "Cayo Casio Longino"] })

        # Asesinato de Julio César
        caes = @state.character(:caesar)
        caes.kill!
        @state.eliminate_target(:the_father_of_understanding)
        @state.set_flag(:caesar_eliminated, true)

        emit("combat.assassination_executed", actor: :aya, target: :caesar, data: {
          blow: "Primera puñalada asestada en la espalda antes del ataque de los senadores",
          last_words: "Et tu, Brute?",
          legacy: "Caída del Padre de la Comprensión de la Orden de los Antiguos"
        })

        # Carta final a Bayek y adopción del nombre AMUNET
        transition_to(scene_letter)
        @state.set_flag(:amunet_letter_sent, true)
        @state.set_flag(:amunet_identity_assumed, true)

        emit("story.amunet_letter", actor: :aya, data: {
          new_name: "Amunet (La Oculta)",
          message: "Aya ha muerto. Mi tumba será cavada aquí en Roma. Larga vida a los Ocultos."
        })

        # Presente: Layla Hassan y William Miles
        transition_to(scene_modern, new_location: "Depresión de Qattara (Egipto)", new_time: "Octubre de 2017")
        @state.set_flag(:layla_recruited_by_assassins, true)

        emit("story.modern_day_alliance", actor: :layla, data: {
          ally: "William Miles (Mentor de los Asesinos modernos)",
          future: "Layla acepta colaborar con la Hermandad manteniendo su independencia científica"
        })

        @state.level_up(2)
        @state.unlock_trophy(:earn_them_all)
      end

      def generate_summary
        "Episodio 21 completado: Idus de Marzo (44 a.C.). Amunet (Aya) asesta la primera puñalada a Julio César en el Senado Romano. En el presente, Layla Hassan es rescatada y reclutada por William Miles. ¡Platino alcanzado!"
      end

      def spoilers
        [
          "Aya es Amunet, la legendaria Asesina cuya estatua reposa en la Villa Auditore de Assassin's Creed II.",
          "Cleopatra sobrevive al Idus de Marzo pero será envenenada por Amunet en el 30 a.C. con un áspid.",
          "En el presente, la colega de Layla, Deanna Geary, es asesinada por el equipo Sigma de Abstergo.",
          "William Miles recluta formalmente a Layla Hassan para la causa de los Asesinos modernos."
        ]
      end

      def easter_eggs
        [
          "Conexión canónica directa con Assassin's Creed II: se revela el rostro y la historia de Amunet.",
          "La laptop de Layla con la autopsia de Desmond Miles y los correos con Sophia Rikkin de la película de Assassin's Creed."
        ]
      end

      def mitigations
        [
          "Tras completar este episodio final, el mundo queda abierto libremente para Bayek para completar el trofeo 'Old Habits'.",
          "Revisar la cueva de Qattara en el presente antes de sincronizar para no perder notas del Animus."
        ]
      end

      def side_quests
        ["A Gift from the Gods (Final Fantasy XV)", "Bayek's Promise (Stone Circles 12/12)"]
      end

      def trophies
        ["trophy_plat", "old_habits", "done_learning"]
      end
    end
  end
end
