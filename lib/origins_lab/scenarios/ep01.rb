# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep01TheOasis < OriginsLab::BaseScenario
      def episode_id
        "01_el_oasis"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 1, role: :medjay, status: :alive },
          relationships: { hepzefa: :best_friend, khemu: :son, aya: :beloved_wife },
          belongings: [:medjay_badge, :bronze_sword, :hunter_bow]
        )
        rudjek = Character.new(
          id: :rudjek,
          name: "Rudjek (La Garza)",
          attributes: { hp: 100, role: :order_target, status: :alive },
          relationships: {},
          belongings: [:order_mask]
        )
        hepzefa = Character.new(
          id: :hepzefa,
          name: "Hepzefa",
          attributes: { hp: 100, role: :rebel_friend, status: :alive },
          relationships: { bayek: :brother_in_arms },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "siwa_underground_temple",
          location: "Templo Subterráneo de Siwa",
          time_period: "49 a.C. - Invierno",
          drachmas: 250,
          level: 1,
          trinkets_count: 5,
          characters: { bayek: bayek, rudjek: rudjek, hepzefa: hepzefa },
          inventory: [:medjay_badge, :bronze_sword, :hunter_bow],
          flags: {}
        )
      end

      def execute_scenario
        _scene_temple = Scene.new(id: :siwa_underground_temple, title: "Templo Subterráneo", location: "Templo Subterráneo de Siwa")
        scene_oasis = Scene.new(id: :siwa_village_reunion, title: "Oasis de Siwa", location: "Siwa")
        scene_oasis.add_precondition("Rudjek debe haber sido eliminado") do |ws|
          ws.flag?(:rudjek_eliminated)
        end

        emit("story.objective_started", actor: :bayek, data: { objective: "Ajusticiar a Rudjek 'La Garza'" })

        # Combate y ejecución de Rudjek
        rudjek = @state.character(:rudjek)
        rudjek.kill!
        @state.eliminate_target(:the_heron)
        @state.set_flag(:rudjek_eliminated, true)
        @state.add_item(:heron_mask)
        emit("combat.assassination_executed", actor: :bayek, target: :rudjek, data: { method: "Máscara incrustada con daga", target_alias: "La Garza" })

        # Transición al Oasis
        transition_to(scene_oasis, new_location: "Oasis de Siwa")
        emit("story.reunion_recorded", actor: :bayek, target: :hepzefa, data: { dialogue: "Siwa duerme, pero el Medjay vigila." })

        @state.set_flag(:siwa_base_unlocked, true)
        @state.level_up(1)
        @state.add_trinket(3)
        @state.unlock_trophy(:first_steps)
      end

      def generate_summary
        "Episodio 01 completado: Rudjek 'La Garza' es ajusticiado en el templo subterráneo. Bayek regresa a Siwa y se reúne con Hepzefa."
      end

      def spoilers
        [
          "Khemu fue asesinado cuando la Orden forzó a Bayek a intentar abrir la cripta de Siwa usando el Fruto del Edén.",
          "La daga de Bayek fue desviada por un enmascarado y apuñaló el corazón de su propio hijo.",
          "Rudjek es solo el primer nombre en la lista de venganza de Bayek."
        ]
      end

      def easter_eggs
        [
          "El halcón Senu recibe su nombre del juego sagrado Senet y del concepto del alma en el misticismo egipcio.",
          "En el templo subterráneo hay jeroglíficos que profetizan el despertar de la Primera Civilización."
        ]
      end

      def mitigations
        [
          "NUNCA vender baratijas (trinkets) individuales desde este episodio; acumular 100 para 'Reduce, Reuse, Recycle'.",
          "Cazar gacelas e íbices en Siwa para subir el peto a nivel 2 antes de salir del oasis.",
          "Sincronizar las 3 atalayas de Siwa para potenciar la visión de Senu."
        ]
      end

      def side_quests
        ["Gear Up", "Striking the Anvil", "Hideaway", "Water Rats", "Family Reunion"]
      end

      def trophies
        ["first_steps", "reduce_reuse_recycle", "defying_authority"]
      end
    end
  end
end
