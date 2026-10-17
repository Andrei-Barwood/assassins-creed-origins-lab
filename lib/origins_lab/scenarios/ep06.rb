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
        "Alejandr\u00EDa, 48 a.C. Guiado por la informaci\u00F3n de Aya, Bayek se introduce clandestinamente en las lujosas y vaporosas Termas P\u00FAblicas de Alejandr\u00EDa. Tras deslizarse por los conductos de ventilaci\u00F3n y eliminar a los guardias en togas, Bayek sorprende a Eudoros ('La Serpiente') a solas en el ba\u00F1o termal privado. Se desata un combate feroz cuerpo a cuerpo en el agua. Eudoros intenta ahogar al Medjay, pero Bayek activa la Hoja Oculta con el pu\u00F1o cerrado: la cuchilla brota hacia adelante y cercena limpiamente el dedo anular de Bayek antes de hundirse profundamente en la yugular de Eudoros. Con este sacrificio involuntario de sangre, nace el rito inici\u00E1tico que marcar\u00E1 a los Asesinos por los siguientes dos mil a\u00F1os."
      end

      def spoilers
        [
          "El origen del dedo cercenado: En entregas cl\u00E1sicas de la franquicia (como Assassin's Creed I con Alta\u00EFr Ibn-La'Ahad), los Asesinos se amputaban ceremonialmente el dedo anular. Origins revela la verdad hist\u00F3rica: no fue un dogma m\u00EDstico premeditado, sino un defecto de dise\u00F1o ergon\u00F3mico de la hoja de Dar\u00EDo al ser disparada con el pu\u00F1o cerrado en combate cerrado bajo el agua.",
          "La falacia de 'La Serpiente': Antes de morir en el Duat, Eudoros se r\u00EDe de Bayek y le revela que \u00E9l no era la cabeza de la conspiraci\u00F3n, sino un simple pe\u00F3n administrativo. La verdadera Serpiente no es un hombre, sino la propia Orden de los Antiguos enquistada en el poder imperial.",
          "El ritual de la pluma de garza: En esta escena se consagra el ritual funerario de los Asesinos: Bayek empapa una pluma de ave en la sangre de la v\u00EDctima para sellar su paso ante el tribunal de Osiris."
        ]
      end

      def easter_eggs
        [
          "Conexi\u00F3n con Leonardo da Vinci en Assassin's Creed II: En AC2, Leonardo modifica la hoja oculta de Ezio Auditore eliminando la necesidad de amputar el dedo anular, comentando con una sonrisa que 'hace siglos un antepasado tuyo sufri\u00F3 una desagradable mutilaci\u00F3n'. La escena de Eudoros es exactamente ese momento hist\u00F3rico.",
          "La arquitectura de las termas helen\u00EDsticas: Las termas est\u00E1n modeladas seg\u00FAn los hallazgos arqueol\u00F3gicos de los gimnasios ptolemaicos de Tebas y Alejandr\u00EDa, con mosaicos geom\u00E9tricos y sistemas de calderas hipocausto bajo el suelo."
        ]
      end

      def mitigations
        [
          "Infiltraci\u00F3n sin armas en las termas: En esta misi\u00F3n Bayek debe despojarse de su equipo pesado y vestir una toalla ceremonial. Solo dispone de la Hoja Oculta. Es vital silenciar a los 3 guardias de los vestuarios atray\u00E9ndolos con silbidos hacia las cortinas de vapor para no activar la alarma general del complejo."
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
