# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep11TheLizardsFace < OriginsLab::BaseScenario
      def episode_id
        "11_el_rostro_del_lagarto"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 20, role: :medjay, status: :alive },
          relationships: { hetepi: :target_lizard },
          belongings: [:hidden_blade]
        )
        hetepi = Character.new(
          id: :hetepi,
          name: "Sumo Sacerdote Hetepi (El Lagarto)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: {},
          belongings: [:lizard_mask, :blue_scarf, :poison_vial]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "memphis_temple_of_ptah",
          location: "Templo de Ptah en Menfis",
          time_period: "48 a.C.",
          drachmas: 4500,
          level: 20,
          hidden_blade_level: 5,
          trinkets_count: 68,
          characters: { bayek: bayek, hetepi: hetepi },
          inventory: [:hidden_blade],
          flags: {}
        )
      end

      def execute_scenario
        _scene_temple = Scene.new(id: :memphis_temple_of_ptah, title: "Templo de Ptah", location: "Menfis")
        scene_duat = Scene.new(id: :duat_apep_hallucination, title: "El Sueño del Duat", location: "El Más Allá")
        scene_duat.add_precondition("Hetepi debe haber sido desenmascarado y ejecutado") do |ws|
          ws.flag?(:hetepi_eliminated)
        end

        emit("story.investigate_plague", actor: :bayek, data: { clue: "Toro Apis envenenado con arsénico" })

        # Identificación correcta del sacerdote enmascarado
        het = @state.character(:hetepi)
        het.kill!
        @state.eliminate_target(:the_lizard)
        @state.set_flag(:hetepi_eliminated, true)
        @state.add_item(:lizard_mask)

        emit("combat.assassination_executed", actor: :bayek, target: :hetepi, data: {
          identification: "Sacerdote del pañuelo azul que tose por el humo venenoso",
          location: "Atrio sagrado del Templo de Ptah"
        })

        # Visión en el Duat combatiendo contra Apep
        transition_to(scene_duat)
        emit("story.vision_duat", actor: :bayek, data: { vision: "Batalla mística contra la serpiente gigante Apep en la barca solar" })

        @state.level_up(1)
        @state.add_trinket(6)
        @state.unlock_trophy(:raging_bulls)
      end

      def generate_summary
        "Episodio 11 completado: Hetepi 'El Lagarto' es identificado por su tos y su pañuelo azul y ejecutado en el templo de Menfis, liberando la ciudad de la peste simulada."
      end

      def spoilers
        [
          "Hetepi envenenaba al Toro Sagrado Apis con arsénico para hacer creer al pueblo que los dioses habían maldecido Egipto.",
          "La muerte de Hetepi detona la visión de la barca solar de Ra enfrentando a la serpiente Apep."
        ]
      end

      def easter_eggs
        [
          "El sueño psicodélico de Apep anticipa las dimensiones mitológicas del Más Allá de los faraones (Aaru, Heb Sed, Duat)."
        ]
      end

      def mitigations
        [
          "PREVENCIÓN DE DESINCRONIZACIÓN: Identificar al sacerdote exacto observando quién tose y viste el talismán azul.",
          "Desbloquear el trofeo 'Raging Bulls' en Menfis usando un dardo de furia en un buey cautivo."
        ]
      end

      def side_quests
        ["Odor Most Foul", "Blood in the Water", "The Baker's Dilemma", "Children of Anubis"]
      end

      def trophies
        ["raging_bulls", "reduce_reuse_recycle"]
      end
    end
  end
end
