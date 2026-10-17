# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep04AyaInAlexandria < OriginsLab::BaseScenario
      def episode_id
        "04_aya_en_alejandria"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 9, role: :medjay, status: :alive },
          relationships: { aya: :beloved_wife },
          belongings: [:medjay_badge]
        )
        aya = Character.new(
          id: :aya,
          name: "Aya de Alejandría",
          attributes: { hp: 100, level: 10, role: :agent_of_cleopatra, status: :alive },
          relationships: { bayek: :beloved_husband, cleopatra: :patron },
          belongings: [:hidden_blade]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "alexandria_serapis_monument",
          location: "Monumento de Serapis en Alejandría",
          time_period: "48 a.C.",
          drachmas: 1200,
          level: 9,
          hidden_blade_level: 0,
          trinkets_count: 22,
          characters: { bayek: bayek, aya: aya },
          inventory: [:medjay_badge],
          flags: {}
        )
      end

      def execute_scenario
        _scene_reunion = Scene.new(id: :alexandria_serapis_monument, title: "Monumento de Serapis", location: "Alejandría")
        scene_blade = Scene.new(id: :underground_hideout_blade, title: "Cámara Secreta de Aya", location: "Alejandría")
        scene_blade.add_precondition("Bayek y Aya deben haberse reencontrado") do |ws|
          ws.flag?(:aya_reunited)
        end

        emit("story.reunion_recorded", actor: :bayek, target: :aya, data: { dialogue: "Mi corazón late de nuevo en Alejandría." })
        @state.set_flag(:aya_reunited, true)

        # Entrega de la legendaria Hoja Oculta
        transition_to(scene_blade)
        aya = @state.character(:aya)
        aya.remove_belonging(:hidden_blade)
        @state.character(:bayek).add_belonging(:hidden_blade)
        @state.upgrade_hidden_blade!
        @state.add_item(:hidden_blade)

        # Aya confirma la eliminación de Actaeon y Ktesos
        @state.eliminate_target(:the_vulture)
        @state.eliminate_target(:the_ram)

        emit("story.item_acquired", actor: :bayek, target: :aya, data: { item: "Hoja Oculta", origin: "Arma utilizada por Darío en el siglo V a.C." })
        emit("story.targets_reported", actor: :aya, data: { eliminated: ["Actaeon (El Buitre)", "Ktesos (El Carnero)"] })

        @state.set_flag(:hidden_blade_acquired, true)
        @state.level_up(1)
        @state.add_trinket(5)
      end

      def generate_summary
        "Alejandr\u00EDa, 48 a.C. La capital de los Ptolomeos deslumbra con sus avenidas de m\u00E1rmol blanco, estatuas doradas y su colosal biblioteca. Siguiendo las marcas secretas dejadas en el monumento de Serapis, Bayek desciende a una cripta subterr\u00E1nea oculta bajo un aljibe. All\u00ED se funde en un apasionado y desgarrador abrazo con Aya. En la penumbra de la cripta, Aya entrega a Bayek una reliquia milenaria: la Hoja Oculta que perteneci\u00F3 a Dar\u00EDo, el persa que ejecut\u00F3 a Jerjes I en el 465 a.C. Aya revela con frialdad implacable que ella ya ha ajusticiado en Alejandr\u00EDa a dos miembros de la Orden: Actaeon ('El Buitre') y Ktesos ('El Carnero')."
      end

      def spoilers
        [
          "La g\u00E9nesis de la Hoja Oculta en Egipto: Cleopatra entreg\u00F3 la hoja de Dar\u00EDo a Aya tras reclutarla como agente secreta. Este brazalete mec\u00E1nico representa el primer puente directo entre el linaje persa de asesinos y la futura Hermandad egipcia.",
          "Los asesinatos ya consumados por Aya: A diferencia de Bayek, que busca venganza puramente visceral por Khemu, Aya ya ha comprendido que la Orden de los Antiguos es una hidra pol\u00EDtica que busca moldear el destino del mundo conocido.",
          "La conspiraci\u00F3n palaciega en Alejandr\u00EDa: Aya informa a Bayek que los miembros restantes de la Orden en la metr\u00F3polis son Gennadios, prefecto de la guardia ptolemaica, y un misterioso manipulador conocido solo como 'La Serpiente', que opera dentro de los c\u00EDrculos m\u00E1s \u00EDntimos de la corte real."
        ]
      end

      def easter_eggs
        [
          "La conexi\u00F3n con 'Legacy of the First Blade': La hoja entregada a Bayek es exactamente la misma arma empu\u00F1ada por Dar\u00EDo en el DLC de Assassin's Creed Odyssey, forjada en bronce y hierro persa.",
          "El busto de Alejandro Magno en la biblioteca: En el distrito real, cerca de la Biblioteca de Alejandr\u00EDa, se halla una estatua con la inscripci\u00F3n original griega de Alejandro proclam\u00E1ndose hijo leg\u00EDtimo del dios Am\u00F3n-Ra tras su visita a Siwa en el 331 a.C."
        ]
      end

      def mitigations
        [
          "Gesti\u00F3n de la Hoja Oculta en nivel 1: Al recibir la Hoja Oculta, su da\u00F1o de asesinato base es insuficiente para eliminar enemigos capitanes o comandantes de un solo golpe si superan el nivel de Bayek. Es prioritario subir la Hoja al menos a Nivel 3 recolectando hierro y bronce en convoyes de carros militares en el Delta."
        ]
      end

      def side_quests
        ["The Odyssey", "Serapis Unites", "A Tithe By Any Other Name", "The Accidental Philosopher"]
      end

      def trophies
        ["reduce_reuse_recycle", "handy_man"]
      end
    end
  end
end
