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
        "Curia del Senado de Pompeyo (Roma, 15 de marzo del 44 a.C.) / Cueva de Qattara (Presente, octubre de 2017). En el hist\u00F3rico Idus de Marzo, Aya se infiltra en la Curia del Senado Romano vestida con la toga republicana. Cuando Julio C\u00E9sar avanza hacia la tribuna para proclamarse dictador perpetuo, los senadores rebeldes lo rodean. Aya se desliza velozmente a su espalda y asesta la primera y fat\u00EDdica pu\u00F1alada en los om\u00F3platos de C\u00E9sar, pronunciando la condena de los Ocultos antes de que Bruto y los dem\u00E1s senadores descarguen sus 23 pu\u00F1aladas. Con la ca\u00EDda del 'Padre de la Comprensi\u00F3n', la Orden de los Antiguos sufre su golpe m\u00E1s demoledor. En la soledad de una cripta en Roma, Aya quema su antigua correspondencia y escribe una carta final a Bayek: anuncia que Aya ha muerto para siempre y que ha renacido bajo el nombre eterno de AMUNET ('La Oculta'). En el presente, en la remota cueva de la Depresi\u00F3n de Qattara, Layla Hassan despierta del Animus tras sobrevivir al escuadr\u00F3n de asalto Sigma de Abstergo; frente a ella se alza William Miles, Mentor de la Hermandad de Asesinos moderna, quien le ofrece una alianza formal para salvar el futuro de la humanidad. \u00A1Platino alcanzado!"
      end

      def spoilers
        [
          "Aya es AMUNET: Esta revelaci\u00F3n es una de las mayores sorpresas de la historia de la saga. En Assassin's Creed II (2009), la cripta secreta bajo la Villa Auditore de Monteriggioni albergaba seis estatuas de Asesinos Legendarios; una de ellas era Amunet, descrita en los textos como la Asesina egipcia que ejecut\u00F3 a Cleopatra con un \u00E1spid en el 30 a.C. Origins cierra una brecha de continuidad planeada durante m\u00E1s de 8 a\u00F1os, revelando que Aya era Amunet.",
          "Julio C\u00E9sar era el 'Padre de la Comprensi\u00F3n': La Orden de los Antiguos adoraba y buscaba entronizar al 'Padre de la Comprensi\u00F3n' (The Father of Understanding), una figura que m\u00E1s tarde se convertir\u00E1 en el lema de los Templarios ('Que el Padre de la Comprensi\u00F3n nos gu\u00EDe'). C\u00E9sar representaba la culminaci\u00F3n de ese ideal de orden totalitario impuesto a trav\u00E9s de la fuerza militar y el control de los artefactos Isu.",
          "El presente con Layla Hassan y William Miles: Abstergo asesin\u00F3 a Deanna Geary, la amiga \u00EDntima de Layla, demostrando la crueldad despiadada de la corporaci\u00F3n templaria moderna. William Miles (padre de Desmond Miles) rescata a Layla en Egipto y la recluta para la Hermandad contempor\u00E1nea, estableciendo las bases para las aventuras de Assassin's Creed Odyssey y Valhalla."
        ]
      end

      def easter_eggs
        [
          "La estatua de Amunet en Monteriggioni (AC2): Al contemplar la estatua de Amunet en Assassin's Creed II, la placa reza: 'Amunet, Asesina de Cleopatra'. Origins confirma que, tras el Idus de Marzo, Amunet continuar\u00E1 su cruzada en el Mediterr\u00E1neo hasta envenenar a Cleopatra catorce a\u00F1os despu\u00E9s, cuando la reina intente someter Egipto a Marco Antonio.",
          "La laptop de Layla y la autopsia de Desmond Miles: Salir del Animus en la cueva de Qattara permite explorar los archivos confidenciales del ordenador de Layla, incluyendo correos con Sophia Rikkin (directora ejecutiva de la Fundaci\u00F3n Abstergo en la pel\u00EDcula de Assassin's Creed de 2016), fotos del Animus 4.35 y el informe forense del cuerpo de Desmond Miles recuperado en el Gran Templo de Nueva York tras los sucesos de Assassin's Creed III."
        ]
      end

      def mitigations
        [
          "Transici\u00F3n al post-juego y limpieza de trofeos: Tras los cr\u00E9ditos finales, el juego devuelve el control a Bayek en Egipto en un estado de mundo abierto permanente. Todas las regiones, campamentos y misiones secundarias permanecen accesibles para completar el trofeo de Platino 'Earn Them All!' y el trofeo de oro 'Old Habits'.",
          "Verificaci\u00F3n final del trofeo 'Old Habits': Asegurarse de haber sincronizado las 58 atalayas de Egipto y haber completado los 291 signos de interrogaci\u00F3n (?) exclusivamente bajo el control de Bayek."
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
