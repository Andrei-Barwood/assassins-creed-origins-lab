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
        "Alejandr\u00EDa, 48 a.C. Gennadios, el implacable prefecto de la polic\u00EDa militar de Alejandr\u00EDa, ha intensificado la persecuci\u00F3n contra los rebeldes que apoyan a Cleopatra y ha puesto precio a la cabeza de Aya. Infiltr\u00E1ndose en la imponente Guarnici\u00F3n de Akra, Bayek burla las patrullas de arqueros en las almenas y asesta una estocada letal a Gennadios en el patio de armas. Con su \u00FAltimo aliento, el prefecto se burla de Bayek y le advierte: su muerte no traer\u00E1 la paz, sino que desatar\u00E1 la furia de los Phylakes, los diez cazarrecompensas de \u00E9lite que jurar\u00E1n cazar al Medjay por cada rinc\u00F3n de Egipto."
      end

      def spoilers
        [
          "El origen del sistema de Phylakes: La muerte de Gennadios activa mec\u00E1nicamente el despliegue de los diez cazadores de \u00E9lite. Estos guerreros representan la guardia pretoriana ptolemaica corrompida por el dinero de la Orden.",
          "La red de espionaje de Gennadios: En el escritorio del prefecto se descubren cartas que demuestran que Gennadios recib\u00EDa \u00F3rdenes directas de Eudoros ('La Serpiente') para limpiar la ciudad de mendigos, hu\u00E9rfanos y sacerdotes que cuestionaran las finanzas reales."
        ]
      end

      def easter_eggs
        [
          "El himno de los Phylakes: Cuando un Phylakes entra a menos de 100 metros de Bayek, una banda sonora disonante de trompetas de bronce y cuernos de guerra de la antig\u00FCedad resuena en el juego, creando una atm\u00F3sfera de terror y persecuci\u00F3n implacable.",
          "La carta 'La presa de Siwa': Tras matar al primer Phylakes, se desbloquea la misi\u00F3n de cacer\u00EDa 'Filakitas en el Ojo' que conduce al tesoro secreto de la armadura del Mar Negro."
        ]
      end

      def mitigations
        [
          "Estrategia de evasi\u00F3n contra Phylakes tempranos: El primer Phylakes en aparecer en Alejandr\u00EDa es 'El Forastero' (Nivel 20). Si Bayek est\u00E1 en nivel 11 o 12, un solo golpe de su maza pesada provocar\u00E1 muerte instant\u00E1nea. NUNCA enfrentarlo a campo abierto. Si el icono del cuerno rojo parpadea en la br\u00FAjula, huir a caballo hacia las azoteas o sumergirse en los canales mar\u00EDtimos donde la IA enemiga no puede rastrear."
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
