# frozen_string_literal: true

module OriginsLab
  class Manifest
    EpisodeInfo = Struct.new(
      :id,
      :slug,
      :title,
      :act,
      :act_name,
      :class_name,
      :level_recommended,
      :region,
      :target,
      :description,
      keyword_init: true
    )

    SideQuestInfo = Struct.new(
      :id,
      :title,
      :region,
      :level,
      :giver,
      :description,
      :rewards,
      :narrative_notes,
      keyword_init: true
    )

    TrophyInfo = Struct.new(
      :id,
      :title,
      :grade,
      :description,
      :missable,
      :risk_level,
      :mitigation_strategy,
      keyword_init: true
    )

    EasterEggInfo = Struct.new(
      :id,
      :title,
      :category,
      :location,
      :description,
      :how_to_find,
      :lore_significance,
      keyword_init: true
    )

    MitigationStrategyInfo = Struct.new(
      :id,
      :domain,
      :title,
      :threat_description,
      :prevention_protocol,
      :recovery_protocol,
      keyword_init: true
    )

    EPISODES = [
      # ACTO 1: EL MEDJAY DE SIWA Y EL DESTIERRO (49 a.C.)
      EpisodeInfo.new(
        id: "01",
        slug: "01_el_oasis",
        title: "El Oasis (The Oasis)",
        act: 1,
        act_name: "Acto 1: El Medjay de Siwa y el Destierro (49 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep01TheOasis",
        level_recommended: 1,
        region: "Siwa",
        target: "Rudjek (La Garza)",
        description: "Invierno del 49 a.C. Bayek de Siwa regresa a su oasis natal tras un a\u00F1o de cacer\u00EDa implacable por el desierto l\u00EDbico. En las catacumbas de la Pir\u00E1mide Doblada, acorrala y ejecuta a Rudjek 'La Garza' incrust\u00E1ndole su propia m\u00E1scara de bronce en el cr\u00E1neo, reencontr\u00E1ndose despu\u00E9s con su hermano de armas Hepzefa para liberar la aldea."
      ),
      EpisodeInfo.new(
        id: "02",
        slug: "02_el_falso_siwan",
        title: "El Falso Siwan (The False Siwan)",
        act: 1,
        act_name: "Acto 1: El Medjay de Siwa y el Destierro (49 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep02TheFalseSiwan",
        level_recommended: 5,
        region: "Siwa",
        target: "Medunamun (El Ibis)",
        description: "Bajo el sol de Siwa, el monumental Templo de Am\u00F3n sufre las torturas y la extorsi\u00F3n de Medunamun 'El Ibis', quien intenta despertar el Orbe de Ed\u00E9n Isu. Bayek se infiltra por los andamios del santuario y machaca el cr\u00E1neo del sacerdote contra las losas del altar con la propia reliquia dorada, liberando a Siwa de la tiran\u00EDa."
      ),
      EpisodeInfo.new(
        id: "03",
        slug: "03_que_amon_vaya_contigo",
        title: "Que Amón Vaya Contigo (May Amun Walk Beside You)",
        act: 1,
        act_name: "Acto 1: El Medjay de Siwa y el Destierro (49 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep03MayAmunWalkBesideYou",
        level_recommended: 8,
        region: "Siwa / Lago Mareotis",
        target: nil,
        description: "Con el oasis natal a salvo de sus opresores inmediatos, Bayek pronuncia un juramento sobre el recuerdo de Khemu y se despide de Hepzefa en las puertas fortificadas. Con arco en ristre y provisiones m\u00EDnimas, cruza la inmensidad del Desierto de Mareotis hacia la cosmopolita y traicionera metr\u00F3polis de Alejandr\u00EDa."
      ),

      # ACTO 2: LA METRÓPOLIS DE ALEJANDRÍA Y LA PRIMERA HOJA OCULTA (48 a.C.)
      EpisodeInfo.new(
        id: "04",
        slug: "04_aya_en_alejandria",
        title: "Aya en Alejandría (Aya)",
        act: 2,
        act_name: "Acto 2: La Metrópolis de Alejandría y la Primera Hoja Oculta (48 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep04AyaInAlexandria",
        level_recommended: 10,
        region: "Alejandría",
        target: "Actaeon (El Buitre) & Ktesos (El Carnero) [por Aya]",
        description: "Alejandr\u00EDa deslumbra con sus avenidas de m\u00E1rmol y su gran biblioteca. En una cripta secreta bajo el monumento de Serapis, Bayek se re\u00FAne apasionadamente con su esposa Aya, quien le entrega la legendaria Hoja Oculta persa de Dar\u00EDo y revela haber ejecutado ya a dos conspiradores de la Orden: Actaeon y Ktesos."
      ),
      EpisodeInfo.new(
        id: "05",
        slug: "05_gennadios_el_filakita",
        title: "Gennadios el Filakita (Gennadios the Phylakitai)",
        act: 2,
        act_name: "Acto 2: La Metrópolis de Alejandría y la Primera Hoja Oculta (48 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep05GennadiosThePhylakitai",
        level_recommended: 11,
        region: "Alejandría",
        target: "Gennadios",
        description: "El prefecto militar Gennadios intensifica la cacer\u00EDa de rebeldes leales a Cleopatra en la capital. Bayek asalta la Guarnici\u00F3n de Akra, burla las patrullas de las almenas y atraviesa el cuello del comandante corrupto, desatando como represalia la cacer\u00EDa de los temibles diez Phylakes por todo el territorio egipcio."
      ),
      EpisodeInfo.new(
        id: "06",
        slug: "06_el_fin_de_la_serpiente",
        title: "El Fin de la Serpiente (End of the Snake)",
        act: 2,
        act_name: "Acto 2: La Metrópolis de Alejandría y la Primera Hoja Oculta (48 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep06EndOfTheSnake",
        level_recommended: 12,
        region: "Alejandría",
        target: "Eudoros (La Serpiente)",
        description: "Infiltr\u00E1ndose en las vaporosas Termas P\u00FAblicas de Alejandr\u00EDa en pa\u00F1os menores, Bayek embosca a Eudoros 'La Serpiente' en el agua caliente. En el violento forcejeo que sigue, la Hoja Oculta se dispara con el pu\u00F1o cerrado y amputa el dedo anular de Bayek antes de degollar al escriba real, consagrando el rito de iniciaci\u00F3n de los Ocultos."
      ),
      EpisodeInfo.new(
        id: "07",
        slug: "07_el_encuentro_con_cleopatra",
        title: "El Encuentro con Cleopatra (Egypt's Medjay)",
        act: 2,
        act_name: "Acto 2: La Metrópolis de Alejandría y la Primera Hoja Oculta (48 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep07MeetingCleopatra",
        level_recommended: 13,
        region: "Nomos de Canopo",
        target: nil,
        description: "En la suntuosa villa de Apolodoro en el Nomos de Canopo, Bayek y Aya obtienen audiencia secreta con la reina depuesta Cleopatra VII. Deslumbrada por la valent\u00EDa de los esposos, Cleopatra los inviste como los Medjay protectores de todo Egipto y les encomienda la purga de las cuatro bestias de la Orden en las provincias."
      ),

      # ACTO 3: LA CACERÍA DE LAS CUATRO BESTIAS (48 - 47 a.C.)
      EpisodeInfo.new(
        id: "08",
        slug: "08_la_picadura_del_escarabajo",
        title: "La Picadura del Escarabajo (The Scarab's Sting)",
        act: 3,
        act_name: "Acto 3: La Cacería de las Cuatro Bestias (48 - 47 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep08TheScarabsSting",
        level_recommended: 15,
        region: "Sais / Delta del Nilo",
        target: nil,
        description: "El f\u00E9rtil y traicionero Delta del Nilo esconde el terror de 'El Escarabajo'. En Sais, Bayek rescata al noble Ghupa con la lengua extirpada y es acogido por su yerno, el fil\u00E1ntropo constructor Taharqa. Sin embargo, durante un brindis de aparente hospitalidad, Taharqa ofrece una copa envenenada con estramonio y captura al Medjay."
      ),
      EpisodeInfo.new(
        id: "09",
        slug: "09_las_mentiras_del_escarabajo",
        title: "Las Mentiras del Escarabajo (The Scarab's Lies)",
        act: 3,
        act_name: "Acto 3: La Cacería de las Cuatro Bestias (48 - 47 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep09TheScarabsLies",
        level_recommended: 16,
        region: "Letópolis / Desierto",
        target: "Taharqa (El Escarabajo)",
        description: "Bayek despierta enterrado vivo en la arena de Let\u00F3polis bajo un sol inclemente. Tras silbar a su montura y escapar de los carro\u00F1eros en medio de alucinaciones donde el cielo llueve escarabajos dorados, Bayek recupera su arsenal y clava su Hoja Oculta en el pecho de Taharqa frente a la mirada at\u00F3nita de su peque\u00F1o hijo Kawab."
      ),
      EpisodeInfo.new(
        id: "10",
        slug: "10_la_madriguera_de_la_hiena",
        title: "La Madriguera de la Hiena (The Hyena's Den)",
        act: 3,
        act_name: "Acto 3: La Cacería de las Cuatro Bestias (48 - 47 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep10TheHyenasDen",
        level_recommended: 19,
        region: "Guiza",
        target: "Khaliset (La Hiena)",
        description: "En las entra\u00F1as de la Gran Pir\u00E1mide de Keops en Guiza, Bayek descubre el dolor enloquecido de Khaliset 'La Hiena', quien realiza sacrificios de prisioneros usando S\u00EDlice de la Primera Civilizaci\u00F3n intentando revivir a su hija difunta Esris. Bayek la persigue hasta la superficie y la abate en una feroz tormenta de arena."
      ),
      EpisodeInfo.new(
        id: "11",
        slug: "11_el_rostro_del_lagarto",
        title: "El Rostro del Lagarto (The Lizard's Face)",
        act: 3,
        act_name: "Acto 3: La Cacería de las Cuatro Bestias (48 - 47 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep11TheLizardsFace",
        level_recommended: 21,
        region: "Menfis",
        target: "Hetepi (El Lagarto)",
        description: "La antigua capital sagrada de Menfis se desmorona por una extra\u00F1a pestilencia que envenena el aire y los templos. Guiado por los sacerdotes de Ptah, Bayek viaja en trance m\u00EDstico al Duat para derrotar a la serpiente Apep, desenmascarando y ejecutando al conspirador Hetepi ('El Lagarto'), identificado por su bufanda azul y tos seca."
      ),
      EpisodeInfo.new(
        id: "12",
        slug: "12_las_escamas_del_cocodrilo",
        title: "Las Escamas del Cocodrilo (The Crocodile's Scales)",
        act: 3,
        act_name: "Acto 3: La Cacería de las Cuatro Bestias (48 - 47 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep12TheCrocodilesScales",
        level_recommended: 25,
        region: "Faiyum",
        target: nil,
        description: "El pr\u00F3spero oasis de Faiyum padece las confiscaciones de 'El Cocodrilo'. Bayek se al\u00EDa con la resistencia local para recuperar la libreta de cuentas custodiada por la peque\u00F1a Shadya. Sin embargo, los soldados interceptan a la ni\u00F1a y Bayek vive su mayor tragedia al hallarla ahogada en el fondo del lago atada a una piedra de molino."
      ),
      EpisodeInfo.new(
        id: "13",
        slug: "13_las_fauces_del_cocodrilo",
        title: "Las Fauces del Cocodrilo (The Crocodile's Jaws)",
        act: 3,
        act_name: "Acto 3: La Cacería de las Cuatro Bestias (48 - 47 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep13TheCrocodilesJaws",
        level_recommended: 28,
        region: "Krokodilopolis",
        target: "Berenike (El Cocodrilo)",
        description: "Para vengar la muerte de Shadya, Bayek se inscribe como gladiador en la Arena de Krokodilopolis junto a su vieja amiga de Siwa, la feroz cazadora Kensa. Tras vencer a los Hermanos Galos, Bayek asalta la villa de la terrateniente Berenike ('El Cocodrilo'), vence a Kensa y ejecuta a la usurpadora en su propio lecho."
      ),

      # ACTO 4: LA TRAICIÓN DE CLEOPATRA Y EL SITIO DE ALEJANDRÍA (47 a.C.)
      EpisodeInfo.new(
        id: "14",
        slug: "14_el_camino_de_los_gabiniani",
        title: "El Camino de los Gabiniani (The Way of the Gabiniani)",
        act: 4,
        act_name: "Acto 4: La Traición de Cleopatra y el Sitio de Alejandría (47 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep14WayOfTheGabiniani",
        level_recommended: 31,
        region: "Alejandría",
        target: nil,
        description: "Los Gabiniani, regimientos de legionarios romanos desertores instalados en Alejandr\u00EDa, conspiran para tomar el control de la capital e impedir la llegada de Roma. Bayek sabotea sus arsenales y ejecuta en duelo al comandante Venator, mientras Cleopatra convoca un consejo de guerra ante la inminente llegada de Julio C\u00E9sar."
      ),
      EpisodeInfo.new(
        id: "15",
        slug: "15_la_hoja_de_la_diosa",
        title: "La Hoja de la Diosa (Aya: Blade of the Goddess)",
        act: 4,
        act_name: "Acto 4: La Traición de Cleopatra y el Sitio de Alejandría (47 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep15BladeOfTheGoddess",
        level_recommended: 32,
        region: "Alejandría / Mar Mediterráneo",
        target: nil,
        description: "Aya comanda una de las mayores haza\u00F1as navales del Mediterr\u00E1neo: introduce clandestinamente a Cleopatra enrollada dentro de una alfombra persa en los aposentos imperiales de Julio C\u00E9sar en el palacio real, zarpando despu\u00E9s para romper el bloqueo naval ptolemaico y encender la pira de gu\u00EDa en la c\u00FAspide del Faro de Alejandr\u00EDa."
      ),
      EpisodeInfo.new(
        id: "16",
        slug: "16_la_batalla_del_nilo",
        title: "La Batalla del Nilo (The Battle of the Nile)",
        act: 4,
        act_name: "Acto 4: La Traición de Cleopatra y el Sitio de Alejandría (47 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep16TheBattleOfTheNile",
        level_recommended: 33,
        region: "Delta del Nilo",
        target: "Pothinus (El Escorpión)",
        description: "La Batalla del Nilo desata el choque total entre las legiones romanas y el ej\u00E9rcito de Ptolomeo XIII. Bayek y C\u00E9sar huyen en cuadriga bajo fuego de jabalinas, abatiendo al elefante de Pothinus ('El Escorpi\u00F3n') y derrotando a Septimius ('El Chacal'). Sin embargo, C\u00E9sar y Cleopatra amnist\u00EDan al verdugo, consumando la gran traici\u00F3n pol\u00EDtica a los Medjay."
      ),

      # ACTO 5: EL ORIGEN DE LA HERMANDAD Y EL IDUS DE MARZO (47 - 44 a.C.)
      EpisodeInfo.new(
        id: "17",
        slug: "17_las_secuelas",
        title: "Las Secuelas (The Aftermath)",
        act: 5,
        act_name: "Acto 5: El Origen de la Hermandad y el Idus de Marzo (47 - 44 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep17TheAftermath",
        level_recommended: 34,
        region: "Alejandría / Siwa",
        target: nil,
        description: "En el mausoleo subterr\u00E1neo de Alejandro Magno, Bayek y Aya encuentran a Apolodoro agonizante: el general romano Flavius Metellus es 'El Le\u00F3n' y ha robado el Cetro y la Manzana del Ed\u00E9n para marchar sobre Siwa. Al llegar al oasis, Bayek encuentra el templo arrasado y sostiene en llanto el cuerpo martirizado de su hermano Hepzefa."
      ),
      EpisodeInfo.new(
        id: "18",
        slug: "18_el_pesaje_final",
        title: "El Pesaje Final (The Final Weighing)",
        act: 5,
        act_name: "Acto 5: El Origen de la Hermandad y el Idus de Marzo (47 - 44 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep18TheFinalWeighing",
        level_recommended: 35,
        region: "Kyrenaika / Cirene",
        target: "Flavius Metellus (El León)",
        description: "Bayek persigue a Flavius Metellus hasta la Acr\u00F3polis de Cirene en Kyrenaika. Flavius distorsiona el tejido de la realidad manipulando el Fruto del Ed\u00E9n con ilusiones fantasmales. Bayek resiste los embates gravitatorios, ejecuta al Gran Maestre y contempla en el Duat el alma de Khemu ascendiendo en paz a los campos de ca\u00F1as de Aaru."
      ),
      EpisodeInfo.new(
        id: "19",
        slug: "19_el_ultimo_medjay",
        title: "El Último Medjay (Last of the Medjay)",
        act: 5,
        act_name: "Acto 5: El Origen de la Hermandad y el Idus de Marzo (47 - 44 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep19LastOfTheMedjay",
        level_recommended: 36,
        region: "Playas de Alejandría",
        target: nil,
        description: "En el crep\u00FAsculo de una playa solitaria de Alejandr\u00EDa, Bayek y Aya sellan su divorcio y su despedida definitiva en el plano terrenal. Reconociendo que su dolor ha trascendido, fundan 'Los Ocultos' (The Hidden Ones) con el voto inmortal de servir a la luz desde la oscuridad, arrojando a la arena el cr\u00E1neo de \u00E1guila que da origen al blas\u00F3n de los Asesinos."
      ),
      EpisodeInfo.new(
        id: "20",
        slug: "20_la_caida_de_un_imperio",
        title: "La Caída de un Imperio (Fall of an Empire, Rise of Another)",
        act: 5,
        act_name: "Acto 5: El Origen de la Hermandad y el Idus de Marzo (47 - 44 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep20FallOfAnEmpire",
        level_recommended: 36,
        region: "Roma / Foro Romano",
        target: "Lucius Septimius (El Chacal)",
        description: "Aya viaja a las costas de Italia en el 44 a.C. y penetra en las defensas del Foro Romano. En un combate tit\u00E1nico entre las estatuas republicanas, Aya confronta a Lucius Septimius ('El Chacal') empu\u00F1ando el Cetro de Ed\u00E9n electrificado, esquivando sus ondas de choque y clavando sus hojas en su yugular para vengar la sangre de Siwa."
      ),
      EpisodeInfo.new(
        id: "21",
        slug: "21_nacimiento_del_credo_roma",
        title: "Nacimiento del Credo & Roma (Birth of the Creed & Rome)",
        act: 5,
        act_name: "Acto 5: El Origen de la Hermandad y el Idus de Marzo (47 - 44 a.C.)",
        class_name: "OriginsLab::Scenarios::Ep21BirthOfTheCreedRome",
        level_recommended: 36,
        region: "Curia del Senado de Roma / Cueva de Egipto (Presente)",
        target: "Julio César (Padre de la Comprensión)",
        description: "Idus de Marzo (15 de marzo del 44 a.C.). Aya se infiltra en la Curia del Senado Romano junto a Bruto y Casio, asestando la primera pu\u00F1alada a Julio C\u00E9sar ('El Padre de la Comprensi\u00F3n'). Aya adopta el nombre sagrado de AMUNET, mientras en el presente, Layla Hassan es rescatada en la cueva de Qattara por William Miles para liderar a los Asesinos modernos."
      )
    ].freeze

    # Catálogo Completo de Misiones Secundarias (Todas las Regiones)
    SIDE_QUESTS = [
      SideQuestInfo.new(id: "sq_siwa_01", title: "Gear Up", region: "Siwa", level: 2, giver: "Herrero de Siwa", description: "Recolección de pieles de animales salvajes para forjar la primera mejora de la coraza de Bayek.", rewards: "500 XP, Peto Nivel 2", narrative_notes: "Tutorial de cacería y crafting."),
      SideQuestInfo.new(id: "sq_siwa_02", title: "Striking the Anvil", region: "Siwa", level: 3, giver: "Benipe", description: "Recuperar las herramientas robadas del herrero retenidas por los soldados ptolemaicos en el campamento.", rewards: "600 XP, Maza de bronce", narrative_notes: "Resistencia local en Siwa."),
      SideQuestInfo.new(id: "sq_siwa_03", title: "Hideaway", region: "Siwa", level: 3, giver: "Fenuku", description: "Rescatar al pequeño Chenzira atrapado en una cueva de hienas tras explorar ruinas antiguas.", rewards: "500 XP", narrative_notes: "Muestra la compasión paternal de Bayek tras perder a Khemu."),
      SideQuestInfo.new(id: "sq_siwa_04", title: "Water Rats", region: "Siwa", level: 3, giver: "Aldeano local", description: "Limpiar los manantiales de agua dulce de bandidos que cobran peaje por beber.", rewards: "600 XP", narrative_notes: "Régimen del Medjay protegiendo a los indefensos."),
      SideQuestInfo.new(id: "sq_siwa_05", title: "Family Reunion", region: "Siwa", level: 2, giver: "Teremun", description: "Liberar a los granjeros cautivos en la granja fortificada; hallazgo trágico de los cuerpos ejecutados.", rewards: "600 XP", narrative_notes: "Demuestra la brutalidad de Medunamun."),
      SideQuestInfo.new(id: "sq_siwa_06", title: "The Healer", region: "Siwa", level: 3, giver: "Rabiah", description: "Recuperar suministros médicos sumergidos en el lago para atender a los heridos en la Casa de la Vida.", rewards: "600 XP", narrative_notes: "Vínculo emocional con Rabiah."),
      SideQuestInfo.new(id: "sq_siwa_07", title: "Prisoners in the Temple", region: "Siwa", level: 4, giver: "Sacerdote rebelde", description: "Liberar a los tres sacerdotes cautivos en el Templo de Amón antes del ritual de Medunamun.", rewards: "500 XP", narrative_notes: "Preparación del asalto principal."),
      SideQuestInfo.new(id: "sq_siwa_08", title: "Bayek's Promise", region: "Egipto (Global)", level: 5, giver: "Recuerdos de Khemu", description: "Localizar e interactuar con los 12 Círculos de Piedra repartidos por todo Egipto para alinear las constelaciones.", rewards: "3000 XP, Acceso a la Cripta Isu bajo la Esfinge", narrative_notes: "El viaje espiritual y de luto más íntimo de Bayek."),

      SideQuestInfo.new(id: "sq_mareotis_01", title: "Hidden Tax", region: "Lago Mareotis", level: 6, giver: "Granjero local", description: "Rescatar al hermano del granjero secuestrado por cobradores de impuestos corruptos en las ruinas.", rewards: "600 XP", narrative_notes: "Extorsión fiscal ptolemaica."),
      SideQuestInfo.new(id: "sq_mareotis_02", title: "Ambush in the Temple", region: "Lago Mareotis", level: 6, giver: "Menehet", description: "Investigar la corrupción en el Templo de Sejmet y desmantelar una red de ladrones sacrílegos.", rewards: "900 XP", narrative_notes: "Reencuentro con su viejo amigo sacerdote Menehet."),
      SideQuestInfo.new(id: "sq_mareotis_03", title: "Ulterior Votive", region: "Lago Mareotis", level: 7, giver: "Menehet", description: "Rastrear al comerciante que vende estatuas votivas falsificadas que ofenden a los dioses.", rewards: "800 XP", narrative_notes: "Cultura y religiosidad popular."),
      SideQuestInfo.new(id: "sq_mareotis_04", title: "Lady of Slaughter", region: "Lago Mareotis", level: 8, giver: "Sumo Sacerdote", description: "Bayek viste la piel de león de Sejmet y combate en el festival sagrado en Yamu para restaurar el honor cívico.", rewards: "1250 XP, Atuendo de Sejmet", narrative_notes: "Una de las misiones festivas más memorables."),
      SideQuestInfo.new(id: "sq_mareotis_05", title: "Taste of Her Sting", region: "Lago Mareotis", level: 17, giver: "Altar ritual", description: "Investigar una serie de brutales asesinatos rituales dedicados a la diosa Serket en 4 regiones.", rewards: "3750 XP, Daga Legendaria", narrative_notes: "Trama de detectives y fanáticos religiosos."),
      SideQuestInfo.new(id: "sq_mareotis_06", title: "Book of the Dead", region: "Lago Mareotis", level: 8, giver: "Anciano moribundo", description: "Recuperar el papiro del Libro de los Muertos robado para que el anciano pueda entrar al Aaru.", rewards: "600 XP", narrative_notes: "Reflexión profunda sobre el más allá."),
      SideQuestInfo.new(id: "sq_mareotis_07", title: "Birthright", region: "Lago Mareotis", level: 9, giver: "Doncellas de la villa", description: "Vengar a los sirvientes asesinados en la villa noble confiscada ilegalmente.", rewards: "800 XP", narrative_notes: "Crueldad de los terratenientes griegos."),

      SideQuestInfo.new(id: "sq_alex_01", title: "The Odyssey", region: "Alejandría", level: 10, giver: "Karst", description: "Escoltar al filósofo griego Karst para escapar de los matones de Gennadios.", rewards: "800 XP", narrative_notes: "Filosofía y persecución política."),
      SideQuestInfo.new(id: "sq_alex_02", title: "Serapis Unites", region: "Alejandría", level: 10, giver: "Sacerdote de Serapis", description: "Rescatar a los esclavos falsamente acusados de robo en el ágora de Alejandría.", rewards: "800 XP", narrative_notes: "Culto sincrético ptolemaico."),
      SideQuestInfo.new(id: "sq_alex_03", title: "A Tithe By Any Other Name", region: "Alejandría", level: 10, giver: "Sacerdote", description: "Interceptar el carro de diezmos confiscado por los guardias del puerto.", rewards: "800 XP", narrative_notes: "Conflicto religioso en la metrópolis."),
      SideQuestInfo.new(id: "sq_alex_04", title: "The Accidental Philosopher", region: "Alejandría", level: 20, giver: "Madre desesperada", description: "Buscar al joven Tifón que huyó para convertirse en pensador cínico en los muelles.", rewards: "1500 XP", narrative_notes: "Toque cómico filosófico."),
      SideQuestInfo.new(id: "sq_alex_05", title: "Higher Education", region: "Alejandría", level: 21, giver: "Sabio de la Biblioteca", description: "Recuperar los rollos robados de geometría euclidiana en el puerto.", rewards: "1500 XP", narrative_notes: "La Gran Biblioteca de Alejandría."),
      SideQuestInfo.new(id: "sq_alex_06", title: "Phylakitai in the Eye", region: "Alejandría", level: 22, giver: "Rebelde local", description: "Emboscada coordinada contra los últimos oficiales leales a Gennadios.", rewards: "1500 XP", narrative_notes: "Limpieza final de opresores."),

      SideQuestInfo.new(id: "sq_delta_01", title: "Conflicts of Interest", region: "Sais", level: 15, giver: "Harkhuf", description: "Investigar al comerciante local que delata a los rebeldes ante 'El Escarabajo'.", rewards: "1250 XP", narrative_notes: "Tensión en el Delta."),
      SideQuestInfo.new(id: "sq_delta_02", title: "Smoke Over Water", region: "Sais", level: 16, giver: "Amosis", description: "Rescatar a los aldeanos atrapados en los arrozales incendiados por los bandidos del Escarabajo.", rewards: "1500 XP", narrative_notes: "Guerra asimétrica rural."),
      SideQuestInfo.new(id: "sq_delta_03", title: "All Eyes on Us", region: "Sais", level: 16, giver: "Rebeldes del loto", description: "Eliminar a los arqueros vigías apostados en las torres de Sais.", rewards: "1250 XP", narrative_notes: "Operación de contrainteligencia."),

      SideQuestInfo.new(id: "sq_giza_01", title: "Precious Bonds", region: "Guiza", level: 18, giver: "Oba", description: "Liberar a los hermanos canteros esclavizados dentro de las galerías de la pirámide.", rewards: "1500 XP", narrative_notes: "Saqueo de tumbas y esclavitud."),
      SideQuestInfo.new(id: "sq_giza_02", title: "Thick Skin", region: "Guiza", level: 18, giver: "Artesano", description: "Cazar cocodrilos e hipopótamos gigantes para obtener cuero blindado.", rewards: "1500 XP", narrative_notes: "Crafting avanzado."),
      SideQuestInfo.new(id: "sq_giza_03", title: "What's Yours Is Mine", region: "Guiza", level: 19, giver: "Cortesano herido", description: "Rastrear a los saqueadores que robaron la llave de la tumba de Micerinos.", rewards: "3500 XP", narrative_notes: "Exploración de la pirámide menor."),

      SideQuestInfo.new(id: "sq_memphis_01", title: "Odor Most Foul", region: "Menfis", level: 20, giver: "Sacerdote embalsamador", description: "Investigar el hedor nauseabundo en las catacumbas: profanación sistemática de momias.", rewards: "1500 XP", narrative_notes: "Ritos funerarios y corrupción."),
      SideQuestInfo.new(id: "sq_memphis_02", title: "Blood in the Water", region: "Menfis", level: 20, giver: "Pescador", description: "Eliminar a los cocodrilos cebados con carne de prisioneros ejecutados por 'El Lagarto'.", rewards: "1500 XP", narrative_notes: "Terrorismo de Estado."),
      SideQuestInfo.new(id: "sq_memphis_03", title: "The Baker's Dilemma", region: "Menfis", level: 20, giver: "Panadera real", description: "Rescatar a la pastelera real secuestrada por negarse a cocinar comida envenenada.", rewards: "1500 XP", narrative_notes: "Vínculo con el veneno de Hetepi."),
      SideQuestInfo.new(id: "sq_memphis_04", title: "Children of Anubis", region: "Menfis", level: 23, giver: "Sacerdotisa", description: "Desmantelar la secta fanática que secuestra huérfanos para ofrendas al inframundo.", rewards: "2000 XP", narrative_notes: "Justicia del Medjay."),

      SideQuestInfo.new(id: "sq_faiyum_01", title: "Murder in the Temple", region: "Faiyum", level: 24, giver: "Sacerdote de Sobek", description: "Resolver el asesinato de un sacerdote apuñalado a traición frente al estanque sagrado.", rewards: "2250 XP", narrative_notes: "Intriga sacerdotal."),
      SideQuestInfo.new(id: "sq_faiyum_02", title: "The Bride", region: "Faiyum", level: 25, giver: "Doncella en el acantilado", description: "Evitar el suicidio de una joven cuyo amante fue ahogado por los esbirros de 'El Cocodrilo'.", rewards: "2250 XP", narrative_notes: "Refleja la crueldad de Berenike."),
      SideQuestInfo.new(id: "sq_faiyum_03", title: "The Sickness", region: "Faiyum", level: 26, giver: "Médico de Karanis", description: "Destruir los almacenes de grano contaminado con estiércol para detener una epidemia.", rewards: "2500 XP", narrative_notes: "Guerra biológica arcaica."),
      SideQuestInfo.new(id: "sq_faiyum_04", title: "Sobek's Gold", region: "Faiyum", level: 27, giver: "Capitán del puerto", description: "Recuperar el cargamento de oro del templo hundido en el fondo del lago de Faiyum.", rewards: "3000 XP", narrative_notes: "Buceo y combate acuático."),

      SideQuestInfo.new(id: "sq_uab_01", title: "Seven Farmers", region: "Nomos de Uab", level: 30, giver: "Rai", description: "Defender una granja asediada por bandidos liderados por 'El Comandante'.", rewards: "7000 XP, Trofeo 'Seven Farmers'", narrative_notes: "Homenaje magistral a 'Los Siete Samuráis'."),

      SideQuestInfo.new(id: "sq_cyrene_01", title: "Absolute Power", region: "Cirene", level: 34, giver: "Dionisios", description: "Desmantelar la red de extorsión del magistrado romano corrupto en la Acrópolis.", rewards: "4000 XP", narrative_notes: "Ocupación romana de Cirenaica."),
      SideQuestInfo.new(id: "sq_cyrene_02", title: "The Flea of Cyrene", region: "Cirene", level: 34, giver: "Esopo (El Niño Pulga)", description: "Salto de fe sincronizado desde los monumentos más altos de Cirene junto a un niño acróbata.", rewards: "3000 XP", narrative_notes: "Legado del Parkour y saltos de fe."),
      SideQuestInfo.new(id: "sq_cyrene_03", title: "Found Honor", region: "Montañas Verdes", level: 35, giver: "Legionario desertor", description: "Recuperar el águila estandarte de la legión romana de manos de bandidos bárbaros.", rewards: "3000 XP", narrative_notes: "Honor militar romano."),

      SideQuestInfo.new(id: "sq_crossover_01", title: "A Gift from the Gods", region: "Nomos de Saqqara", level: 23, giver: "Meteorito caído", description: "Investigar el impacto de un meteorito celestial y resolver el acertijo solar en la tumba Isu.", rewards: "Arma 'Ultima Blade', Escudo 'Ziedrich', Montura Chocobo ('Kweh')", narrative_notes: "Crossover oficial canónico con Final Fantasy XV (Noctis y Ardyn).")
    ].freeze

    # Catálogo de Trofeos de Platino y Estrategias de Prevención
    TROPHIES = [
      TrophyInfo.new(
        id: "trophy_plat",
        title: "Earn Them All!",
        grade: "Platino",
        description: "Obtén todos los 50 trofeos restantes del juego base.",
        missable: false,
        risk_level: "Alto",
        mitigation_strategy: "Seguir el protocolo de prevención de baratijas y completar ubicaciones exclusivamente con Bayek."
      ),
      TrophyInfo.new(
        id: "trophy_old_habits",
        title: "Old Habits",
        grade: "Oro",
        description: "Completa todas las 291 ubicaciones (? en el mapa) en las 35 regiones de Egipto.",
        missable: false,
        risk_level: "Crítico",
        mitigation_strategy: "NUNCA explorar ubicaciones clave durante las misiones donde controlas a Aya (no cuentan para el registro de Bayek). Usar a Senu al 100% de sincronización para revelar cofres sumergidos y guaridas ermitañas invisibles como la cueva en el Desierto Blanco."
      ),
      TrophyInfo.new(
        id: "trophy_reduce_reuse_recycle",
        title: "Reduce, Reuse, Recycle",
        grade: "Bronce",
        description: "Vende 100 baratijas (trinkets) a la vez en una sola transacción.",
        missable: true,
        risk_level: "Máximo",
        mitigation_strategy: "PREVENCIÓN RADICAL: Jamás presionar el botón de venta masiva de baratijas al comerciante hasta verificar en la pestaña de inventario que posees 100 o más unidades. Si vendes de una en una, el farmeo post-juego tomará de 10 a 15 horas innecesarias."
      ),
      TrophyInfo.new(
        id: "trophy_overheating",
        title: "Overheating",
        grade: "Bronce",
        description: "Presencia una lluvia de escarabajos alucinado en el desierto por insolación.",
        missable: false,
        risk_level: "Medio",
        mitigation_strategy: "Cabalgar hacia el Gran Mar de Arena o el Desierto Blanco entre las 11:00 y las 14:00 horas in-game. Desmontar del camello y caminar a pie. Esperar a que los espejismos de calor generen el evento aleatorio de enjambre de escarabajos cayendo del cielo."
      ),
      TrophyInfo.new(
        id: "trophy_house_from_here",
        title: "I Can See My House From Here!",
        grade: "Bronce",
        description: "Alcanza la cima de la montaña más alta de Egipto en el Desierto Negro.",
        missable: false,
        risk_level: "Bajo",
        mitigation_strategy: "Escalar la cumbre de Ra-Horakhty en el Desierto Negro. Al llegar al pico exacto con el mojón de piedras, el trofeo saltará automáticamente."
      ),
      TrophyInfo.new(
        id: "trophy_archer_of_the_month",
        title: "Archer of the Month",
        grade: "Bronce",
        description: "Mata a un enemigo con un tiro a la cabeza con arco mientras estás en el aire.",
        missable: false,
        risk_level: "Medio",
        mitigation_strategy: "Adquirir la habilidad 'Arquero en el aire' en la rama de Cazador. Saltar desde una cornisa o roca hacia un guardia desprevenido, apuntar con arco de cazador (ralentiza el tiempo) y clavar una flecha en el cráneo."
      ),
      TrophyInfo.new(
        id: "trophy_seven_farmers",
        title: "Seven Farmers",
        grade: "Bronce",
        description: "Completa la misión secundaria 'Siete Granjeros' en el Nomos de Uab.",
        missable: false,
        risk_level: "Bajo",
        mitigation_strategy: "Tener nivel 30 mínimo antes de iniciar la misión. Defender la granja con trampas de fuego y flechas de sobrecarga."
      ),
      TrophyInfo.new(
        id: "trophy_ben_hur",
        title: "Ben-Hur",
        grade: "Bronce",
        description: "Gana tu primer torneo de carreras en el Hipódromo de Canopo.",
        missable: false,
        risk_level: "Medio",
        mitigation_strategy: "Mantener el rebufo en las curvas cerradas y usar la embestida lateral con la cuadriga contra los rivales que intentan adelantar por la cuerda interior."
      ),
      TrophyInfo.new(
        id: "trophy_are_you_not_entertained",
        title: "Are You Not Entertained?",
        grade: "Bronce",
        description: "Completa todos los eventos de la Arena de Gladiadores de Krokodilopolis.",
        missable: false,
        risk_level: "Medio",
        mitigation_strategy: "Utilizar hachas pesadas contra gladiadores con escudo y dagas duales de veneno contra los hermanos galos."
      ),
      TrophyInfo.new(
        id: "trophy_defying_authority",
        title: "Defying Authority",
        grade: "Bronce",
        description: "Derrota a uno de los Phylakes cazarrecompensas que patrullan Egipto.",
        missable: false,
        risk_level: "Medio",
        mitigation_strategy: "No enfrentarlos a campo abierto. Atraerlos a una zona con tejados, dispararles flechas incendiarias a la montura y usar bombas de humo al descender."
      ),
      TrophyInfo.new(
        id: "trophy_circle_of_life",
        title: "The Circle of Life",
        grade: "Bronce",
        description: "Alimenta a un depredador salvaje con un cadáver humano.",
        missable: false,
        risk_level: "Bajo",
        mitigation_strategy: "Matar a un bandido, cargar el cuerpo en hombros y arrojarlo al agua cerca de un nido de cocodrilos en Faiyum."
      ),
      TrophyInfo.new(
        id: "trophy_raging_bulls",
        title: "Raging Bulls",
        grade: "Bronce",
        description: "Haz que un toro salvaje mate a 3 enemigos.",
        missable: false,
        risk_level: "Medio",
        mitigation_strategy: "Disparar una flecha somnífera o dardo de furia a un toro dentro de un corral de campamento militar para que embista a los legionarios en pánico."
      ),
      TrophyInfo.new(
        id: "trophy_black_flag",
        title: "Where's My Black Flag?",
        grade: "Bronce",
        description: "Destruye 8 barcos de bandidos y rebeldes en las vías fluviales de Egipto.",
        missable: false,
        risk_level: "Bajo",
        mitigation_strategy: "Abordar una trireme con espolón en el Lago Mareotis y embestir falúas menores hasta partirlas en dos."
      ),
      TrophyInfo.new(
        id: "trophy_done_learning",
        title: "I'm Done Learning",
        grade: "Plata",
        description: "Activa una habilidad de nivel Maestro en cualquiera de las tres ramas.",
        missable: false,
        risk_level: "Bajo",
        mitigation_strategy: "Llegar al final de la rama de Cazador, Guerrero o Vidente e invertir el primer punto en el nodo maestro infinito."
      )
    ].freeze

    # Catálogo de Easter Eggs y Secretos
    EASTER_EGGS = [
      EasterEggInfo.new(
        id: "ee_ffxv",
        title: "A Gift from the Gods (Final Fantasy XV Crossover)",
        category: "Crossover Oficial",
        location: "Nomos de Saqqara (Pirámide Escalonada)",
        description: "Misión canónica donde un meteorito estelar abre un portal del que emerge Bahamut y el villano Ardyn Izunia de FFXV.",
        how_to_find: "Seguir la marca verde de misión de nivel 23 en Saqqara. Resolver el puzle de sombras en los pilares solares.",
        lore_significance: "Premia la espada legendaria Ultima Blade, el escudo Ziedrich y la montura de camello disfrazado de Chocobo ('Kweh')."
      ),
      EasterEggInfo.new(
        id: "ee_sphinx_crypt",
        title: "La Cripta Isu y la Armadura Secreta de la Gran Esfinge",
        category: "Primera Civilización (Isu)",
        location: "Guiza (Bajo las patas traseras de la Esfinge)",
        description: "Cámara subterránea colosal que proyecta un mapa holográfico de las 12 constelaciones celestes conectadas a los templos precursores.",
        how_to_find: "Completar los 12 Círculos de Piedra de la misión 'La Promesa de Bayek', recolectar 50 unidades de Sílice en las tumbas e introducirse por la grieta secreta de la Esfinge.",
        lore_significance: "Desbloquea el atuendo Isu con casco cibernético y voz metálica modulada, confirmando la herencia de los precursores."
      ),
      EasterEggInfo.new(
        id: "ee_ancient_mechanisms",
        title: "Los Seis Mecanismos Antiguos y las Transmisiones del Futuro",
        category: "Lore / Desmond Miles",
        location: "Tumbas de Oun-mAa Niyeptess, Seshem.eff, Eeyoo Sekedoo, Khufu, Smenkhkare, Qeneb too Kah'Aiye",
        description: "Monolitos Isu que se activan con Sílice y emiten monólogos de la Primera Civilización dirigidos explícitamente a Layla Hassan y Desmond Miles.",
        how_to_find: "Explorar el fondo de las 6 pirámides y tumbas mayores e interactuar con el pedestal pre-catástrofe.",
        lore_significance: "Explica la naturaleza no lineal del tiempo, la ilusión del libre albedrío y advierte sobre el colapso del campo magnético terrestre."
      ),
      EasterEggInfo.new(
        id: "ee_desert_hallucinations",
        title: "Los Nueve Espejismos del Gran Mar de Arena",
        category: "Psicoacústica y Folclore",
        location: "Gran Mar de Arena / Desierto Blanco / Desierto Negro",
        description: "Al caminar bajo el sol abrasador, Bayek sufre alucinaciones: lluvia de insectos, arbusto ardiente, estrella fugaz, espejismo de Khemu señalando un oasis, un árbol que desaparece y un jinete fantasma.",
        how_to_find: "Caminar a pie durante el mediodía sin montar a caballo en zonas de desierto profundo durante 3 minutos continuos.",
        lore_significance: "Conexión espiritual y trauma post-traumático de Bayek por la pérdida de su familia."
      ),
      EasterEggInfo.new(
        id: "ee_amunet_statue",
        title: "La Estatua de Amunet en Assassin's Creed II",
        category: "Conexión Canónica de la Saga",
        location: "Monteriggioni (Villa Auditore, AC2) vs Roma (Final de ACO)",
        description: "En Assassin's Creed II (2009), la cripta de los Asesinos Legendarios bajo la Villa Auditore incluye la estatua de Amunet, la asesina de Cleopatra. ACO revela que Amunet era Aya.",
        how_to_find: "Completar la misión 21 en Roma donde Aya escribe la carta final firmando como Amunet.",
        lore_significance: "Cierra una brecha de continuidad histórica planeada por Ubisoft durante más de 8 años."
      ),
      EasterEggInfo.new(
        id: "ee_layla_laptop",
        title: "Archivos Ocultos en la Laptop de Layla Hassan",
        category: "Línea Temporal del Presente",
        location: "Cueva de Qattara (Mundo Real)",
        description: "La computadora de Layla contiene correos electrónicos con Sophia Rikkin (de la película de Assassin's Creed), autopsia médica de Desmond Miles y audios sobre el Animus portátil.",
        how_to_find: "Salir del Animus manualmente en cualquier momento del juego y examinar el ordenador portátil sobre la mesa de campaña.",
        lore_significance: "Unifica el universo cinematográfico de Fox (Callum Lynch) con los videojuegos principales."
      )
    ].freeze

    # Matriz de Mitigación y Prevención de Riesgos
    MITIGATIONS = [
      MitigationStrategyInfo.new(
        id: "mit_trinkets",
        domain: "Trofeos / Economía",
        title: "Mitigación de Venta Accidental de Baratijas ('Reduce, Reuse, Recycle')",
        threat_description: "Vender baratijas individualmente o presionar 'Vender todas' antes de acumular 100 unidades obliga a un grindeo de 12 horas en el post-juego.",
        prevention_protocol: "Prohibición total de venta de baratijas desde el inicio del juego. Revisar el contador en inventario periódicamente.",
        recovery_protocol: "Si se vendieron por error, equipar arco ligero y cazar hienas en las dunas de Guiza o asaltar campamentos con cofre de suministros triples."
      ),
      MitigationStrategyInfo.new(
        id: "mit_old_habits",
        domain: "Trofeos / Exploración",
        title: "Prevención de Bloqueo del Trofeo de Platino 'Old Habits'",
        threat_description: "Dejar una ubicación secundaria incompleta (un tesoro sin abrir o capitán sin matar) o explorar con Aya durante misiones restringidas.",
        prevention_protocol: "Completar el 100% de ubicaciones ÚNICAMENTE en el post-juego controlando a Bayek. Ajustar el brillo de la pantalla en el mapa para distinguir ? blancos de ? dorados.",
        recovery_protocol: "Revisar meticulosamente las siguientes 3 ubicaciones ocultas propensas a extravío: Cueva de Eremitas en Desierto Blanco, Isla sumergida en Herakleion y Campamento abandonado en Qattara."
      ),
      MitigationStrategyInfo.new(
        id: "mit_phylakes",
        domain: "Combate / Supervivencia",
        title: "Mitigación de Muerte por Emboscada de Phylakes",
        threat_description: "Los 10 Phylakes tienen cuernos de alarma y daño masivo cuerpo a cuerpo. Su nivel oscila entre 20 y 40.",
        prevention_protocol: "Monitorear el icono de cuerno rojo en la brújula. Si el Phylakes tiene más de 2 niveles por encima de Bayek, evitar la confrontación a caballo.",
        recovery_protocol: "Usar Arco Depredador con flechas de fuego a la cabeza desde riscos inalcanzables para su IA ecuestre. Arrojar bombas de humo si acorta distancia."
      ),
      MitigationStrategyInfo.new(
        id: "mit_war_elephants",
        domain: "Combate de Élite",
        title: "Protocolo contra Elefantes de Guerra (Jumbe, Surus, Herwennefer, Qetesh & Resheph)",
        threat_description: "Los 4 campamentos de elefantes tienen jefes nivel 40 con pisotones de área, embestidas imparables y arqueros en la torreta.",
        prevention_protocol: "No intentar antes del nivel 38. Equipar arco ligero con atributo 'Salud al acertar' y espada dual con adrenalina instantánea.",
        recovery_protocol: "Mantenerse siempre pegado a las patas traseras del paquidermo rodando en sentido contrario a su giro. Disparar al vientre descubierto cuando se encabrite."
      ),
      MitigationStrategyInfo.new(
        id: "mit_level_gating",
        domain: "Progresión / RPG",
        title: "Mitigación de Penalización por Brecha de Nivel (Level Gating)",
        threat_description: "Enemigos con calavera roja (4+ niveles por encima) no reciben daño de asesinato de la hoja oculta y matan de un solo impacto.",
        prevention_protocol: "Completar todas las misiones secundarias de cada región antes de avanzar el capítulo principal correspondiente.",
        recovery_protocol: "Sincronizar atalayas regionales (+100 XP c/u), resolver acertijos de papiros y rescatar rebeldes cautivos en caminos secundarios."
      )
    ].freeze

    def self.all_episodes
      EPISODES
    end

    def self.by_act(act_num)
      EPISODES.select { |ep| ep.act == act_num.to_i }
    end

    def self.find(id_or_slug)
      str = id_or_slug.to_s.downcase.strip
      EPISODES.find { |ep| ep.id == str || ep.slug == str || ep.id == format("%02d", str.to_i) }
    end

    def self.normalize_id(id)
      str = id.to_s.strip
      if str =~ /^\d+$/
        format("%02d", str.to_i)
      else
        str
      end
    end

    def self.all_side_quests
      SIDE_QUESTS
    end

    def self.side_quests_by_region(region_name)
      SIDE_QUESTS.select { |sq| sq.region.downcase.include?(region_name.to_s.downcase) }
    end

    def self.all_trophies
      TROPHIES
    end

    def self.trophies_by_risk(risk_str)
      norm = ->(s) { s.to_s.downcase.tr("áéíóú", "aeiou") }
      target = norm.call(risk_str)
      TROPHIES.select { |tr| norm.call(tr.risk_level) == target || norm.call(tr.risk_level).include?(target) }
    end

    def self.all_easter_eggs
      EASTER_EGGS
    end

    def self.all_mitigations
      MITIGATIONS
    end
  end
end
