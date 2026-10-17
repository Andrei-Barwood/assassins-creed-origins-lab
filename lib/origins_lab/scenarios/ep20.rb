# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep20FallOfAnEmpire < OriginsLab::BaseScenario
      def episode_id
        "20_la_caida_de_un_imperio"
      end

      def main_actor
        :aya
      end

      def default_initial_state
        aya = Character.new(
          id: :aya,
          name: "Aya de Alejandría (Amunet)",
          attributes: { hp: 100, level: 36, role: :hidden_one_infiltrator, status: :alive },
          relationships: { septimius: :jackal_target },
          belongings: [:dual_blades, :smoke_bombs]
        )
        septimius = Character.new(
          id: :septimius,
          name: "Lucius Septimius (El Chacal)",
          attributes: { hp: 100, role: :order_champion, status: :alive },
          relationships: { caesar: :military_protector },
          belongings: [:staff_of_eden, :jackal_mask]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "rome_roman_forum",
          location: "Foro Romano en Roma",
          time_period: "44 a.C.",
          drachmas: 18000,
          level: 36,
          trinkets_count: 18,
          characters: { aya: aya, septimius: septimius },
          inventory: [:dual_blades],
          flags: { hidden_ones_founded: true }
        )
      end

      def execute_scenario
        _scene_forum = Scene.new(id: :rome_roman_forum, title: "Foro Romano", location: "Roma")
        scene_victory = Scene.new(id: :septimius_fallen, title: "El Chacal Derrotado", location: "Roma")
        scene_victory.add_precondition("Septimius debe haber sido abatido") do |ws|
          ws.flag?(:septimius_eliminated)
        end

        emit("story.infiltrate_rome", actor: :aya, data: { city: "Roma", objective: "Cazar a Lucius Septimius antes de la sesión del Senado" })

        # Combate contra Septimius empuñando el Cetro de Edén
        sep = @state.character(:septimius)
        sep.kill!
        @state.eliminate_target(:the_jackal)
        @state.set_flag(:septimius_eliminated, true)

        emit("combat.assassination_executed", actor: :aya, target: :septimius, data: {
          weapon: "Dagas dobles de Asesino",
          enemy_weapon: "Cetro de Edén Isu con ondas de energía",
          consequence: "El camino hacia la Curia queda despejado"
        })

        transition_to(scene_victory)
        @state.level_up(1)
        @state.add_trinket(3)
      end

      def generate_summary
        "Episodio 20 completado: Jugando como Aya en Roma (44 a.C.). Duelo a muerte en el Foro Romano contra Lucius Septimius 'El Chacal' armado con el Cetro de Edén."
      end

      def spoilers
        [
          "Septimius confiaba en que el poder del Cetro de Edén lo hacía invencible contra armas mortales.",
          "César se prepara para ser proclamado dictador vitalicio en el Senado."
        ]
      end

      def easter_eggs
        [
          "El Foro Romano recrea fielmente los templos de Saturno, Cástor y Pólux y la Basílica Julia antes del incendio de Nerón."
        ]
      end

      def mitigations
        [
          "Estrategia contra Septimius: Rodear en sentido horario para esquivar su maza de energía cinética y contraatacar con esquiva lateral.",
          "Mantener la distancia cuando el Cetro brilla con pulsos dorados."
        ]
      end

      def side_quests
        ["Found Honor"]
      end

      def trophies
        ["reduce_reuse_recycle"]
      end
    end
  end
end
