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
        "Episodio 09 completado: Bayek escapa de las dunas con ayuda de Senu, recupera su equipo y ejecuta a Taharqa en el templo, perdonando a su hijo Kawab."
      end

      def spoilers
        [
          "Bayek decide perdonar al joven Kawab, quien reaparecerá años después como aliado en el DLC The Hidden Ones.",
          "La muerte de Taharqa desmantela la red de torturas en el Delta del Nilo."
        ]
      end

      def easter_eggs
        [
          "Tras escapar del desierto, el calor extremo desencadena la lluvia de escarabajos alucinada (Trofeo 'Overheating')."
        ]
      end

      def mitigations
        [
          "PREVENCIÓN TROFEO 'Overheating': Aprovechar la salida al desierto de Letópolis para caminar a pie hacia el Gran Mar de Arena hasta que lluevan escarabajos.",
          "Recuperar el equipo del campamento militar de Pyknodas antes de atacar a Taharqa."
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
