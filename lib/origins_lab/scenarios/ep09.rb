# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep09TheScarabsLies < OriginsLab::BaseScenario
      def episode_id
        "09_las_mentiras_del_escarabajo"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 40, level: 15, role: :medjay, status: :buried_alive },
          relationships: { taharqa: :mortal_enemy },
          belongings: []
        )
        taharqa = Character.new(
          id: :taharqa,
          name: "Taharqa (El Escarabajo)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: { kawab: :son },
          belongings: [:scarab_mask, :heavy_axe]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "letopolis_desert_burial",
          location: "Dunas del Desierto de Letópolis",
          time_period: "48 a.C.",
          drachmas: 3200,
          level: 15,
          hidden_blade_level: 3,
          trinkets_count: 53,
          characters: { bayek: bayek, taharqa: taharqa },
          inventory: [],
          flags: { bayek_drugged: true, taharqa_is_scarab: true }
        )
      end

      def execute_scenario
        _scene_burial = Scene.new(id: :letopolis_desert_burial, title: "Enterrado en la Arena", location: "Desierto de Letópolis")
        scene_temple = Scene.new(id: :letopolis_temple_execution, title: "Templo de Letópolis", location: "Letópolis")
        scene_temple.add_precondition("Bayek debe haberse liberado de la arena") do |ws|
          ws.flag?(:desert_escape_achieved)
        end

        emit("story.survival_challenge", actor: :bayek, data: { condition: "Enterrado hasta el cuello bajo el sol abrasador" })

        # Rescate por Senu y su caballo
        @state.character(:bayek).set_attribute(:status, :alive)
        @state.character(:bayek).set_attribute(:hp, 100)
        @state.set_flag(:desert_escape_achieved, true)
        @state.add_item(:hidden_blade)
        emit("story.loyal_beast_rescue", actor: :bayek, data: { rescuers: ["Senu (Halcón)", "Montura fiel"] })

        # Asalto y ejecución de Taharqa
        transition_to(scene_temple)
        tah = @state.character(:taharqa)
        tah.kill!
        @state.eliminate_target(:the_scarab)
        @state.set_flag(:scarab_eliminated, true)
        @state.add_item(:scarab_mask)

        emit("combat.assassination_executed", actor: :bayek, target: :taharqa, data: {
          witness: "Kawab (hijo de Taharqa)",
          moral_choice: "Bayek perdona la vida a Kawab y oculta la maldad de su padre"
        })

        @state.level_up(1)
        @state.add_trinket(7)
        @state.unlock_trophy(:overheating)
      end

      def generate_summary
        "Let\u00F3polis / Desierto del Delta, 48 a.C. Bayek despierta bajo un sol abrasador, enterrado en la arena hasta el cuello, con la carne ardiendo y buitres revoloteando sobre su cabeza. Desesperado, emite un silbido agudo que llama a su fiel caballo; el corcel galopa por las dunas, muerde los nudos de las ataduras y desentierra al Medjay. A pie, deshidratado y sufriendo delirios de insolaci\u00F3n en los que el cielo llueve escarabajos dorados, Bayek recupera su equipo en un campamento cercano. Con una sed insaciable de justicia, asalta las obras del colosal templo en construcci\u00F3n de Let\u00F3polis y atraviesa la garganta de Taharqa con su Hoja Oculta justo en el instante en que el peque\u00F1o hijo de Taharqa, Kawab, entra en la c\u00E1mara para abrazar a su padre."
      end

      def spoilers
        [
          "El dilema moral frente al hijo inocente: El asesinato de Taharqa frente a los ojos de Kawab refleja tr\u00E1gicamente la propia experiencia de Bayek con Khemu. Bayek contempla el horror en la mirada del ni\u00F1o y comprende que su sed de venganza est\u00E1 perpetuando una cadena infinita de hu\u00E9rfanos y dolor.",
          "El espejismo can\u00F3nico de los escarabajos: Las alucinaciones que sufre Bayek en las arenas de Let\u00F3polis son producto de la deshidrataci\u00F3n severa y el veneno residual, detonando el evento en el que insectos sagrados caen del cielo como lluvia negra y dorada.",
          "La redenci\u00F3n p\u00F3stuma en los DLC: A\u00F1os m\u00E1s tarde, en el DLC 'Los Ocultos' (Sina\u00ED), Kawab reaparece como un l\u00EDder rebelde que busca venganza contra Bayek, cerrando un arco argumental formidable sobre el perd\u00F3n y la ruptura del ciclo de violencia."
        ]
      end

      def easter_eggs
        [
          "Desbloqueo org\u00E1nico del trofeo 'Overheating': Este episodio es el momento narrativo ideal donde el juego expone al jugador a las condiciones exactas de insolaci\u00F3n para activar la lluvia de insectos necesaria para el trofeo de bronce 'Overheating'.",
          "Let\u00F3polis y la ciudad sepultada: La Let\u00F3polis hist\u00F3rica fue redescubierta bajo metros de sedimentos del Nilo. En el juego, gran parte de las viviendas cl\u00E1sicas est\u00E1n semienterradas en dunas, reflejando el abandono progresivo de la ciudad durante el periodo helen\u00EDstico."
        ]
      end

      def mitigations
        [
          "Recuperaci\u00F3n inmediata del equipamiento: Al escapar de la arena, Bayek no tiene armas ni escudo. No intentar atacar a los guardias de Let\u00F3polis con los pu\u00F1os desnudos. Utilizar el sigilo entre la hierba alta para infiltrarse en la tienda del comandante donde reposa el cofre con todas las armas confiscadas."
        ]
      end

      def side_quests
        ["The Tax Master", "Precious Bonds"]
      end

      def trophies
        ["overheating", "reduce_reuse_recycle"]
      end
    end
  end
end
