# Bitácora de Ingeniería: Laboratorio Narrativo & Mitigación Assassin's Creed Origins

**Proyecto:** Laboratorio de Continuidad Narrativa, Mitigación de Trofeos y Simulación Táctica de *Assassin's Creed Origins* (Actos 1 al 5, Episodios 01 al 21).  
**Tecnología:** Ruby 3.2+, Sinatra, WEBrick, Minitest, CLI Runner.  
**Ubicación del Repositorio:** `/Users/andreibarwood/Documents/snocomm/Dron Sentinela mm`  
**Estado:** Integración completa al 100% (20 test suites, 274 aserciones, 0 fallos, 0 errores, 0 warnings).

---

## 1. Contexto y Origen de la Transformación

El proyecto se originó en el espacio de trabajo que albergaba la herramienta estocástica de Renoise (*Dron Centinela* / Matriz Táctica MITRE ATT&CK). A petición del usuario, dicho entorno fue reconvertido en un repositorio de Ruby con la arquitectura exacta y el nivel de profundidad de `/Users/andreibarwood/Documents/snocomm/07 - like a dragon`, preservando los artefactos binarios previos del dron (`com.snocomm.dron_centinela.xrnx`, `tesis_dron_centinela.pdf`, `dron_centinela_src/`) pero articulando una infraestructura completa de software para el análisis riguroso de *Assassin's Creed Origins* (ACO).

---

## 2. Decisiones de Arquitectura de Dominio

Siguiendo el patrón arquitectónico demostrado en el laboratorio de *Yakuza: Like a Dragon*, se implementó un sistema basado en:
1. **Modelos de Dominio Puros (`lib/origins_lab/`):**
   - **`Character`:** Modela entidades (Bayek, Aya/Amunet, Khemu, Hepzefa, Cleopatra, César, Flavius, Septimius, Layla Hassan, etc.) con puntos de vida (HP), estado de vida/muerte, afiliaciones faccionales, mapas de relaciones interpersonales y lista de pertenencias o equipo clave.
   - **`WorldState`:** Estado inmutable por clonación profunda (`deep_clone`). Gestiona nivel de experiencia, dracmas, acumulador de baratijas (`trinkets_count`), nivel de la Hoja Oculta (0 a 10), armaduras crafteadas (peto, brazal, carcaj, estabilizador, bolsa de herramientas), inventario, banderas narrativas booleanas, objetivos eliminados de la Orden de los Antiguos y trofeos ganados. Incluye la transacción protegida `sell_trinkets_all!` que previene el fallo del trofeo *Reduce, Reuse, Recycle*.
   - **`EventLog` y `Event`:** Registro cronológico de eventos inmutables que encapsulan identificador del evento, actor, objetivo, escena y metadatos complementarios (método de asesinato, diálogos clave, recompensas).
   - **`Scene`:** Nodos espaciotemporales provistos de un motor de precondiciones ejecutables (`add_precondition`, `check_preconditions!`). Si una condición de continuidad no se satisface, el sistema lanza `OriginsLab::PreconditionError`.
   - **`BaseScenario`:** Clase abstracta que estandariza el flujo del ciclo de vida (`run`, `execute_scenario`, `transition_to`, `outcome`, `spoilers`, `easter_eggs`, `mitigations`, `side_quests`, `trophies`).
   - **`Manifest`:** Catálogo estático inmutable con la metadata canónica de los 21 episodios, más de 35 misiones secundarias estructuradas por región, 14 perfiles de trofeos con estrategias de mitigación, 6 easter eggs mayores del juego y 5 protocolos tácticos contra bugs y dificultades de combate.

---

## 3. Implementación Episodio por Episodio (21 Capítulos)

### Acto 1: El Medjay de Siwa y el Destierro (49 a.C.)
- **Episodio 01 (`01_el_oasis` - El Oasis):** Ajusticiamiento de Rudjek "La Garza" incrustando su máscara con una daga en el templo subterráneo. Regreso al Oasis de Siwa y reunión con Hepzefa. Se revela el asesinato de Khemu por desvío forzado de la daga de Bayek.
- **Episodio 02 (`02_el_falso_siwan` - El Falso Siwan):** Infiltración al Templo de Amón y ejecución de Medunamun "El Ibis" usando el Orbe de Edén como instrumento de golpe contundente. Liberación de Siwa.
- **Episodio 03 (`03_que_amon_vaya_contigo` - Que Amón Vaya Contigo):** Despedida de Siwa en las puertas de la ciudad; entrega del arco por Hepzefa; cruce del Desierto de Mareotis hacia Alejandría.

### Acto 2: La Metrópolis de Alejandría y la Primera Hoja Oculta (48 a.C.)
- **Episodio 04 (`04_aya_en_alejandria` - Aya en Alejandría):** Encuentro con Aya en el monumento de Serapis; descenso a la cámara subterránea donde Aya entrega a Bayek la legendaria Hoja Oculta de Darío; revelación de que Aya ya eliminó a Actaeon (El Buitre) y Ktesos (El Carnero).
- **Episodio 05 (`05_gennadios_el_filakita` - Gennadios el Filakita):** Infiltración a la Guarnición de Akra; asesinato del prefecto corrupto Gennadios; activación de la cacería de los 10 Phylakes en todo Egipto.
- **Episodio 06 (`06_el_fin_de_la_serpiente` - El Fin de la Serpiente):** Infiltración a las Termas Públicas de Alejandría; asesinato de Eudoros (La Serpiente) en el vapor; la hoja se dispara accidentalmente al forcejear y cercena el dedo anular de Bayek, instituyendo la tradición ritual del Credo.
- **Episodio 07 (`07_el_encuentro_con_cleopatra` - El Encuentro con Cleopatra):** Audiencia secreta en la Villa de Apolodoro en Canopo; Cleopatra se presenta como aliada legítima y nombra a Bayek y Aya como "Los Medjay de Egipto".

### Acto 3: La Cacería de las Cuatro Bestias (48 - 47 a.C.)
- **Episodio 08 (`08_la_picadura_del_escarabajo` - La Picadura del Escarabajo):** Llegada al Delta del Nilo; rescate del suegro de Taharqa (Ghupa) con la lengua arrancada; Taharqa ofrece una copa de vino envenenada y noquea a Bayek.
- **Episodio 09 (`09_las_mentiras_del_escarabajo` - Las Mentiras del Escarabajo):** Bayek despierta enterrado en la arena del desierto de Letópolis; escape de los carroñeros; alucinación de insolación y lluvia de escarabajos (*Overheating*); infiltración al templo de Letópolis y ejecución de Taharqa frente a su hijo Kawab.
- **Episodio 10 (`10_la_madriguera_de_la_hiena` - La Madriguera de la Hiena):** Incursión en la Gran Pirámide de Keops en Guiza; descubrimiento de los rituales nigrománticos de Khaliset intentando revivir a su hija fallecida Esris con Sílice y artefactos Isu; duelo durante la tormenta de arena.
- **Episodio 11 (`11_el_rostro_del_lagarto` - El Rostro del Lagarto):** Llegada a Menfis envenenada por pestilencia; intervención del Sumo Sacerdote Pasherenptah; alucinación del Duat y batalla contra la serpiente gigante Apep con el Arco de Luz; desenmascaramiento de Hetepi ("El Lagarto", distinguido por su bufanda azul y tos seca) y ejecución en el templo de Ptah.
- **Episodio 12 (`12_las_escamas_del_cocodrilo` - Las Escamas del Cocodrilo):** Llegada al oasis de Faiyum; investigación de la libreta de cuentas de "El Cocodrilo"; rescate de la niña Shadya; tragedia: Shadya es arrojada al fondo del lago atada a una piedra de molino por orden de Berenike.
- **Episodio 13 (`13_las_fauces_del_cocodrilo` - Las Fauces del Cocodrilo):** Bayek y Kensa se infiltran en la Arena de Gladiadores de Krokodilopolis; combate contra los Hermanos Galos; asalto nocturno a la villa de Berenike; duelo contra su guardaespaldas Kensa y ejecución despiadada de Berenike para vengar a Shadya.

### Acto 4: La Traición de Cleopatra y el Sitio de Alejandría (47 a.C.)
- **Episodio 14 (`14_el_camino_de_los_gabiniani` - El Camino de los Gabiniani):** Infiltración en los cuarteles de los legionarios amotinados (Gabiniani) en Alejandría; asesinato de Venator que conspiraba contra Cleopatra; consejo de guerra de Cleopatra preparándose para la llegada de Julio César.
- **Episodio 15 (`15_la_hoja_de_la_diosa` - La Hoja de la Diosa):** Aya enrolla a Cleopatra dentro de una alfombra persa y la introduce clandestinamente en los aposentos de César en el Palacio Real; asalto naval en el Mediterráneo; Aya escala y enciende el gran Faro de Alejandría para guiar la flota romana.
- **Episodio 16 (`16_la_batalla_del_nilo` - La Batalla del Nilo):** Persecución frenética en carruaje con César disparando lanzas incendiarias; Bayek abate al elefante de guerra de Pothinus ("El Escorpión"); Septimius interviene y es vencido en duelo por Bayek, pero César lo detiene y le otorga amnistía; Cleopatra corona su alianza con Roma, traicionando a Bayek y Aya.

### Acto 5: El Origen de la Hermandad y el Idus de Marzo (47 - 44 a.C.)
- **Episodio 17 (`17_las_secuelas` - Las Secuelas):** Infiltración a la tumba subterránea de Alejandro Magno; hallazgo de Apolodoro herido de muerte; revelación: Flavius Metellus ("El León") y Lucius Septimius ("El Chacal") robaron el Cetro y la Manzana del Edén y marcharon a Siwa; Bayek regresa a Siwa y encuentra el cadáver de Hepzefa torturado y asesinado por Flavius.
- **Episodio 18 (`18_el_pesaje_final` - El Pesaje Final):** Caza implacable de Flavius en la Acrópolis de Cirene (Kyrenaika); Flavius manipula los poderes de la Manzana del Edén distorsionando el espacio; Bayek resiste las ilusiones, lo ejecuta y consuma la venganza definitiva por la muerte de Khemu, liberando su alma al Duat.
- **Episodio 19 (`19_el_ultimo_medjay` - El Último Medjay):** Encuentro final de despedida entre Bayek y Aya en la playa de Alejandría; renuncian a su matrimonio terrenal y fundan "Los Ocultos" (*The Hidden Ones*); Bayek arroja el cráneo de águila de Khemu a la arena, dejando impresa la silueta que se convierte en el emblema eterno de la Hermandad de Asesinos.
- **Episodio 20 (`20_la_caida_de_un_imperio` - La Caída de un Imperio):** Aya navega a Roma en el 44 a.C.; infiltración al Foro Romano; duelo final contra Lucius Septimius armado con el Cetro de Edén; asesinato definitivo de Septimius frente a las estatuas imperiales.
- **Episodio 21 (`21_nacimiento_del_credo_roma` - Nacimiento del Credo & Roma):** Idus de Marzo (15 de marzo del 44 a.C.); Aya se infiltra en la Curia del Senado Romano junto a Marco Junio Bruto y Casio; Aya asesta la primera puñalada en la espalda a Julio César (revelado como el "Padre de la Comprensión"); Aya adopta el nombre de **Amunet** (revelando la conexión con la estatua de *Assassin's Creed II*); en el presente, Layla Hassan es rescatada en la cueva de Qattara por William Miles y se une a la Hermandad de Asesinos contemporánea. ¡Platino alcanzado!

---

## 4. Hitos de Pruebas y Verificación

La suite de pruebas en `test/` fue diseñada con cobertura total de aserciones:
- `test_character.rb`: Comprueba ciclo de vida, HP, relaciones, clonación profunda y daño.
- `test_world_state.rb`: Comprueba inventario, objetivos, banderas, crafting y la regla de oro de baratijas (`sell_trinkets_all!`).
- `test_manifest.rb`: Comprueba la integridad de los 21 episodios, los 5 actos, el catálogo de secundarias, easter eggs y trofeos.
- `test_mitigations.rb`: Valida las matrices de prevención contra bugs, elefantes de guerra y Phylakes.
- `test_scenarios.rb`: Ejecuta de manera secuencial los 21 escenarios verificando que ninguno lance excepciones y comprobando puntos críticos de trama (dedo anular de Bayek en Ep06, escarabajos en Ep09, venganza de Khemu en Ep18 y Amunet/César en Ep21).

**Resultado de ejecución de `rake test`:**
```text
20 runs, 274 assertions, 0 failures, 0 errors, 0 skips
Finished in 0.0095s (28,688 assertions/s) — 0 warnings (-w clean).
```

---

## 5. Herramientas CLI y Servidor Web

- **`bin/episodio`:**
  - Ejecución de escenarios individuales con soporte para filtros de visualización (`--spoilers`, `--easter-eggs`, `--trophies`, `--side-quests`, `--mitigations`, `--all`).
  - Subcomandos de consulta rápida: `list`, `side-quests [region]`, `trophies [riesgo]`, `easter-eggs`, `mitigations`.
  - Códigos de salida conformes a la especificación estándar (0: Éxito, 2: Error de ejecución, 3: Argumento inválido).
- **`bin/servidor`:**
  - Servidor web interactivo Sinatra en el puerto 4567 con vistas ERB responsivas (`layout.erb`, `index.erb`, `episode.erb`, `side_quests.erb`, `trophies.erb`, `easter_eggs.erb`, `mitigations.erb`).
  - Soporte de arranque directo mediante Rack (`config.ru`) y `Procfile`.
