# frozen_string_literal: true

module OriginsLab
  module Scenarios
    class Ep05GennadiosThePhylakitai < OriginsLab::BaseScenario
      def episode_id
        "05_gennadios_el_filakita"
      end

      def main_actor
        :bayek
      end

      def default_initial_state
        bayek = Character.new(
          id: :bayek,
          name: "Bayek de Siwa",
          attributes: { hp: 100, level: 10, role: :medjay, status: :alive },
          relationships: { gennadios: :sworn_enemy },
          belongings: [:hidden_blade]
        )
        gennadios = Character.new(
          id: :gennadios,
          name: "Gennadios el Filakita",
          attributes: { hp: 100, role: :commander_of_guards, status: :alive },
          relationships: {},
          belongings: [:heavy_shield, :commander_spear]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "akra_garrison_alexandria",
          location: "Guarnición de Akra en Alejandría",
          time_period: "48 a.C.",
          drachmas: 1500,
          level: 10,
          hidden_blade_level: 1,
          trinkets_count: 28,
          characters: { bayek: bayek, gennadios: gennadios },
          inventory: [:hidden_blade],
          flags: {}
        )
      end

      def execute_scenario
        _scene_garrison = Scene.new(id: :akra_garrison_alexandria, title: "Guarnición de Akra", location: "Alejandría")
        scene_aftermath = Scene.new(id: :phylakes_warning, title: "Amenaza de los Filakitas", location: "Alejandría")
        scene_aftermath.add_precondition("Gennadios debe haber sido ejecutado") do |ws|
          ws.flag?(:gennadios_eliminated)
        end

        emit("story.infiltrate_garrison", actor: :bayek, data: { fortress: "Guarnición de Akra" })

        # Ejecución de Gennadios
        gen = @state.character(:gennadios)
        gen.kill!
        @state.set_flag(:gennadios_eliminated, true)

        emit("combat.assassination_executed", actor: :bayek, target: :gennadios, data: { weapon: "Hoja Oculta", alert: "Se desata la cacería de los 10 Phylakes" })

        transition_to(scene_aftermath)
        @state.set_flag(:phylakes_hunt_active, true)
        @state.unlock_trophy(:defying_authority)
        @state.level_up(1)
        @state.add_trinket(4)
      end

      def generate_summary
        "Episodio 05 completado: Gennadios es abatido en la Guarnición de Akra. Sus últimas palabras desatan la cacería de los 10 Phylakes por todo Egipto."
      end

      def spoilers
        [
          "La muerte de Gennadios alerta a los 10 Phylakes mercenarios errantes con cuernos de guerra.",
          "Derrotar a los 10 Phylakes recompensa el Atuendo Legendario 'Black Hood'."
        ]
      end

      def easter_eggs
        [
          "Dentro de la armería de Akra se halla un papiro que menciona a la guardia personal de Julio César en Roma."
        ]
      end

      def mitigations
        [
          "Estrategia contra Phylakes: No luchar a campo abierto contra la montura; emboscar con arco de depredador desde azoteas y usar bombas de humo.",
          "Sabotear el brasero de alarma de la guarnición de Akra antes de entablar combate para evitar refuerzos de nivel 12."
        ]
      end

      def side_quests
        ["Phylakitai in the Eye", "Higher Education"]
      end

      def trophies
        ["defying_authority", "reduce_reuse_recycle"]
      end
    end
  end
end
