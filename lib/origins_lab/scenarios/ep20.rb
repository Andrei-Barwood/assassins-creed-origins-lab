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
        "Roma / Foro Romano, 44 a.C. Tres a\u00F1os despu\u00E9s de la separaci\u00F3n en Alejandr\u00EDa, Aya desembarca en las costas del mar Tirreno y se infiltra en el coraz\u00F3n del Imperio Romano. En el 44 a.C., la ciudad bulle con los preparativos para la proclamaci\u00F3n de Julio C\u00E9sar como dictador perpetuo. En el majestuoso Foro Romano, fuertemente custodiado por cohortes pretorianas, Aya localiza a Lucius Septimius ('El Chacal'). Septimius ha sido recompensado por C\u00E9sar y empu\u00F1a el legendario Cetro de Ed\u00E9n de la tumba de Alejandro, utiliz\u00E1ndolo como una lanza electrificada que emite descargas de energ\u00EDa Isu. En un duelo acrob\u00E1tico de una violencia colosal entre las estatuas imperiales, Aya evade los rayos del cetro, desarma al general romano y clava sus dagas duales en su cuello, vengando la masacre de Siwa y cobrando la sangre del chacal."
      end

      def spoilers
        [
          "El poder destructivo del Cetro de Ed\u00E9n: Septimius demuestra por primera vez en la franquicia las capacidades ofensivas directas del Cetro de la Primera Civilizaci\u00F3n, proyectando ondas de choque que desestabilizan a los soldados circundantes.",
          "La protecci\u00F3n de C\u00E9sar a los tiranos: La presencia de Septimius como mano derecha de C\u00E9sar en Roma confirma que C\u00E9sar no era un simple aliado circunstancial de la Orden, sino el protector pol\u00EDtico absoluto del r\u00E9gimen tir\u00E1nico de los Antiguos.",
          "La preparaci\u00F3n del magnicidio: Tras abatir a Septimius, Aya es contactada en los p\u00F3rticos del Teatro de Pompeyo por los senadores republicanos Marco Junio Bruto y Cayo Casio Longino, quienes le entregan la toga senatorial y planifican el ataque para la sesi\u00F3n del Senado del d\u00EDa siguiente: el Idus de Marzo."
        ]
      end

      def easter_eggs
        [
          "La arquitectura republicana de Roma: Roma en el 44 a.C. a\u00FAn no pose\u00EDa el m\u00E1rmol del emperador Augusto ni el Coliseo; est\u00E1 construida en ladrillo rojo y toba volc\u00E1nica, reflejando fielmente la Roma tardorrepublicana previa al gran incendio.",
          "Marco Junio Bruto y la armadura de Assassin's Creed: Brotherhood: El senador Bruto que saluda a Aya es el mismo personaje hist\u00F3rico cuya armadura legendaria y pergaminos secretos son recolectados por Ezio Auditore en las catacumbas de Roma en Assassin's Creed: Brotherhood (2010)."
        ]
      end

      def mitigations
        [
          "Combate como Aya contra Septimius con el Cetro: Aya no dispone del arco ni de las armas de Bayek; combate exclusivamente con dagas dobles y espada de pretoriano. Septimius utiliza un ataque giratorio imparable con el cetro dorado. La t\u00E1ctica es rodar en c\u00EDrculo alrededor de su pierna izquierda y asestar combos r\u00E1pidos de 3 golpes tras cada golpe fallido de su arma pesada."
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
