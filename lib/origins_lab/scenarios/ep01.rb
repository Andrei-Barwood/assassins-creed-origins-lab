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
        "Invierno del 49 a.C. En las catacumbas claustrof\u00F3bicas del templo subterr\u00E1neo de la Pir\u00E1mide Doblada de Siwa, Bayek confronta a Rudjek 'La Garza'. La m\u00E1scara con pico her\u00E1ldico es destrozada con la propia daga de bronce que Rudjek pretend\u00EDa empu\u00F1ar, incrust\u00E1ndola en su cr\u00E1neo a trav\u00E9s del antifaz ceremonial. Con el primer nombre de su juramento de sangre tachado, Bayek emerge malherido a las dunas de Siwa para reunirse con su hermano de armas, Hepzefa. El oasis natal que una vez jur\u00F3 proteger como Medjay yace ahora bajo el yugo de los soldados ptolemaicos y sacerdotes her\u00E9ticos de Medunamun."
      end

      def spoilers
        [
          "La tragedia de Khemu (Siwa, 49 a.C.): La memoria de la muerte de Khemu se reconstruye mediante flashbacks fragmentados. Durante una incursi\u00F3n de la Orden de los Antiguos en el Templo de Am\u00F3n, Bayek y su hijo fueron retenidos en una cripta precursora Isu. Los enmascarados exigieron que Bayek utilizara el Orbe dorado (Manzana del Ed\u00E9n) para abrir la c\u00E1mara secreta. Al negarse Bayek por desconocer los secretos del artefacto, los enmascarados pusieron un cuchillo en la garganta del peque\u00F1o Khemu. En el forcejeo que sigui\u00F3, un miembro de la Orden guio y desvi\u00F3 la mano armada de Bayek, haciendo que la propia daga de bronce del padre atravesara el pecho de su hijo.",
          "El significado de las m\u00E1scaras de la Orden: Rudjek porta la m\u00E1scara de 'La Garza', una alegor\u00EDa profanada de las deidades tot\u00E9micas del Nilo. La Orden de los Antiguos opera en las sombras utilizando el pante\u00F3n egipcio para infundir terror sagrado en la poblaci\u00F3n ignorante, present\u00E1ndose como emisarios de los dioses mientras buscan desentra\u00F1ar la tecnolog\u00EDa de los 'Precursores' o 'Los que vinieron antes' (Isu).",
          "La lista de condenados y la anatom\u00EDa de la venganza: Tras la muerte de Khemu, Bayek y su esposa Aya realizaron un pacto de sangre jurando exterminar a cada uno de los hombres presentes en la c\u00E1mara aquella noche fat\u00EDdica. Rudjek fue rastreado hasta su escondite en el templo subterr\u00E1neo, pero Bayek descubre que Medunamun ('El Ibis') ha tomado el control absoluto de Siwa, profanando el Templo de Am\u00F3n y torturando a los sacerdotes locales."
        ]
      end

      def easter_eggs
        [
          "Senu y la teolog\u00EDa del Ba egipcio: El halc\u00F3n real de Bayek, Senu (un \u00E1guila perdicera hembra), es una representaci\u00F3n directa del 'Ba' (el alma itinerante en la mitolog\u00EDa egipcia) que conecta espiritualmente con el Medjay. A diferencia de entregas posteriores o anteriores de Assassin's Creed donde la 'Vista de \u00C1guila' era una habilidad extrasensorial innata en el ADN, en Origins es una simbiosis real y f\u00EDsica entre Bayek y un ave rapaz adiestrada.",
          "Profec\u00EDas Isu en las paredes del templo: En los muros del templo subterr\u00E1neo de Siwa pueden apreciarse relieves jerogl\u00EDficos donde figuras antropomorfas con tecnolog\u00EDa avanzada proyectan orbes celestes. Estos grabados conectan directamente con los mensajes de la Primera Civilizaci\u00F3n descubiertos por Desmond Miles y anuncian la eventual convergencia de los Ocultos con la estirpe de los Asesinos.",
          "El juego sagrado del Senet: En la aldea de Siwa, junto a la choza de Hepzefa, se observa un tablero de Senet tallado en madera, un pasatiempo milenario jugado por los faraones que simbolizaba el tr\u00E1nsito del alma a trav\u00E9s del inframundo hacia los campos de ca\u00F1as de Aaru."
        ]
      end

      def mitigations
        [
          "Regla de Oro de Baratijas ('Reduce, Reuse, Recycle'): Prohibici\u00F3n absoluta de venta individual de baratijas. El trofeo exige vender 100 baratijas al comerciante en una \u00DANICA transacci\u00F3n presionando el comando de venta masiva. Las baratijas no otorgan ventajas de combate, por lo que retenerlas en el inventario no perjudica la progresi\u00F3n. Venderlas anticipadamente obligar\u00E1 en el post-juego a un farmeo tedioso de 10 a 15 horas cazando animales o saqueando campamentos en el Desierto Blanco.",
          "Ruta \u00F3ptima de cacer\u00EDa en el Oasis de Siwa: Antes de abandonar el valle, cazar gacelas y hienas en los riscos del sur para recolectar piel suave y dura. Esto permite subir el Peto de Bayek a Nivel 2 (+15% de armadura corporal) y el Carcaj a Nivel 2 (+30% de capacidad de flechas), reduciendo dr\u00E1sticamente la vulnerabilidad ante las patrullas ptolemaicas con arcos compuestos.",
          "Sincronizaci\u00F3n t\u00E1ctica de las 3 Atalayas de Siwa: Sincronizar de inmediato los 3 puntos de observaci\u00F3n en Siwa. Cada atalaya desbloqueada incrementa un 25% la percepci\u00F3n visual de Senu, permiti\u00E9ndole fijar objetivos a trav\u00E9s de muros de adobe y detectar cofres de suministro ocultos en las cuevas."
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
