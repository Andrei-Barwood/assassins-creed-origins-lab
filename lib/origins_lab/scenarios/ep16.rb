# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep16TheBattleOfTheNile < OriginsLab::BaseScenario
      def episode_id
        "16_la_batalla_del_nilo"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 32, role: :medjay, status: :alive },
          relationships: { caesar: :fragile_ally },
          belongings: [:hidden_blade, :javelins]
        )
        pothinus = Character.new(
          id: :pothinus,
          name: "Eunuco Pothinus (El Escorpión)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: {},
          belongings: [:war_elephant, :scorpion_mask]
        )
        septimius = Character.new(
          id: :septimius,
          name: "Lucius Septimius (El Chacal)",
          attributes: { hp: 100, role: :order_general, status: :alive },
          relationships: { caesar: :future_advisor },
          belongings: [:mace_and_chain]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "nile_chariot_chase",
          location: "Delta del Nilo",
          time_period: "47 a.C.",
          drachmas: 9000,
          level: 32,
          hidden_blade_level: 9,
          trinkets_count: 96,
          characters: { bayek: bayek, pothinus: pothinus, septimius: septimius },
          inventory: [:hidden_blade],
          flags: {}
        )
      end

      def execute_scenario
        _scene_chariot = Scene.new(id: :nile_chariot_chase, title: "Persecución en Carruaje", location: "Delta del Nilo")
        scene_palace_betrayal = Scene.new(id: :cleopatra_caesar_betrayal, title: "La Gran Traición", location: "Palacio de Alejandría")
        scene_palace_betrayal.add_precondition("Pothinus debe haber sido eliminado en la batalla") do |ws|
          ws.flag?(:pothinus_eliminated)
        end

        emit("combat.chariot_battle", actor: :bayek, data: { vehicle: "Carruaje de César", weapon: "Jabalinas explosivas contra elefantes de guerra" })

        # Ejecución de Pothinus
        pot = @state.character(:pothinus)
        pot.kill!
        @state.eliminate_target(:the_scorpion)
        @state.set_flag(:pothinus_eliminated, true)
        @state.add_item(:scorpion_mask)
        emit("combat.assassination_executed", actor: :bayek, target: :pothinus, data: { weapon: "Hoja Oculta", target: "El Escorpión montado en elefante" })

        # Combate contra Septimius e intervención de César
        transition_to(scene_palace_betrayal)
        @state.set_flag(:septimius_spared_by_caesar, true)
        @state.set_flag(:cleopatra_betrayal_confirmed, true)

        emit("story.political_betrayal", actor: :bayek, data: {
          opponents: ["Julio César", "Cleopatra VII"],
          injustice: "César detiene la ejecución de Septimius y lo nombra consejero romano",
          consequence: "Bayek y Aya son expulsados del palacio y repudiados"
        })

        @state.level_up(1)
        @state.add_trinket(4)

        # Si se superan 100 baratijas, ejecutar la venta de mitigación
        if @state.trinkets_count >= 100
          @state.sell_trinkets_all!
        end
      end

      def generate_summary
        "Episodio 16 completado: Guerra civil en el Nilo. Pothinus 'El Escorpión' es asesinado sobre su elefante de guerra. César perdona a Septimius y Cleopatra traiciona a los Medjay."
      end

      def spoilers
        [
          "Ptolomeo XIII se ahoga en el Nilo perseguido por soldados romanos y devorado por cocodrilos.",
          "César no busca liberar a Egipto, sino apoderarse de los artefactos de la Primera Civilización con la ayuda de Septimius."
        ]
      end

      def easter_eggs
        [
          "El ahogamiento del joven rey Ptolomeo XIII en el Nilo sigue con exactitud las crónicas de la Guerra Alejandrina de César."
        ]
      end

      def mitigations
        [
          "En el carruaje, mantener las jabalinas cargadas para impactar a los ojos del elefante en cuanto se alza sobre sus patas.",
          "Alcanzar las 100 baratijas en este punto para desbloquear con seguridad 'Reduce, Reuse, Recycle'."
        ]
      end

      def side_quests
        ["Rebel Strike"]
      end

      def trophies
        ["reduce_reuse_recycle"]
      end
    end
  end
end
