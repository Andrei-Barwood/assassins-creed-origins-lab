# Laboratorio Narrativo & Mitigación Táctica: *Assassin's Creed Origins* (Episodios 01 al 21)

Simulador narrativo, motor de continuidad y matriz táctica de prevención y mitigación para la campaña principal completa (21 episodios canónicos divididos en 5 Actos) de **Assassin's Creed Origins**, modelado en **Ruby** con verificación determinista de estados, eventos estructurados, hoja de ruta de trofeos de platino, catálogo integral de misiones secundarias, secretos y easter eggs.

---

## Índice

1. [Propósito y Arquitectura](#propósito-y-arquitectura)
2. [Estructura de la Campaña: Los 5 Actos y 21 Episodios](#estructura-de-la-campaña-los-5-actos-y-21-episodios)
3. [Spoilers Completos de Historia y Lore](#spoilers-completos-de-historia-y-lore)
4. [Catálogo de Easter Eggs y Secretos](#catálogo-de-easter-eggs-y-secretos)
5. [Hoja de Ruta de Trofeos & Mitigación de Glitches](#hoja-de-ruta-de-trofeos--mitigación-de-glitches)
6. [Catálogo de Misiones Secundarias por Región](#catálogo-de-misiones-secundarias-por-región)
7. [Estrategias Tácticas de Mitigación y Prevención](#estrategias-tácticas-de-mitigación-y-prevención)
8. [Uso del CLI (`bin/episodio`)](#uso-del-cli-binepisodio)
9. [Servidor Web Interactivo (`bin/servidor`)](#servidor-web-interactivo-binservidor)
10. [Ejecución de Pruebas Automatizadas (`rake test`)](#ejecución-de-pruebas-automatizadas-rake-test)
11. [Artefactos Preservados de Renoise (Dron Centinela)](#artefactos-preservados-de-renoise-dron-centinela)

---

## Propósito y Arquitectura

Este repositorio convierte el entorno de desarrollo en un **laboratorio de software verificable** diseñado bajo los patrones de Clean Code, Programación Orientada a Objetos y Arquitectura Limpia en Ruby, siguiendo la pauta de [`07 - like a dragon`](file:///Users/andreibarwood/Documents/snocomm/07%20-%20like%20a%20dragon):

```text
.
├── AGENTS.md                  # Reglas maestras y directrices para agentes
├── BITACORA.md                # Registro cronológico detallado de ingeniería
├── Gemfile / Gemfile.lock     # Dependencias de Ruby (Sinatra, WEBrick, Minitest, Rake)
├── Procfile                   # Definición de proceso web
├── Rakefile                   # Automatización de tareas y suite de tests
├── README.md                  # Este documento integral
├── bin/
│   ├── episodio               # CLI ejecutable con filtros analíticos y subcomandos
│   └── servidor               # Servidor web Sinatra en puerto 4567
├── config.ru                  # Punto de entrada para servidores Rack
├── lib/
│   └── origins_lab/
│       ├── base_scenario.rb   # Plantilla base abstracta de episodios
│       ├── character.rb       # Modelo de personajes, vida, facciones y relaciones
│       ├── event_log.rb       # Registro estructurado e inmutable de eventos
│       ├── manifest.rb        # Catálogo maestro (episodios, trofeos, secundarias, etc.)
│       ├── scene.rb           # Escenas con validación estricta de precondiciones
│       ├── world_state.rb     # Estado global inmutable por clonación profunda
│       ├── web_app.rb         # Aplicación web interactiva Sinatra
│       ├── scenarios/         # Implementación de los 21 episodios canónicos
│       │   ├── ep01.rb ... ep21.rb
│       └── views/             # Vistas ERB responsivas (Bootstrap 5 estilizado)
└── test/                      # Suite de tests Minitest (20 suites, 274 aserciones)
```

---

## Estructura de la Campaña: Los 5 Actos y 21 Episodios

### Acto 1: El Medjay de Siwa y el Destierro (49 a.C.)
- **`01_el_oasis` (El Oasis - Nivel 1 en Siwa):** Ajusticiamiento de **Rudjek ("La Garza")** en el templo subterráneo. Retorno al Oasis de Siwa y reunión con Hepzefa.
- **`02_el_falso_siwan` (El Falso Siwan - Nivel 5 en Siwa):** Infiltración al Templo de Amón y ejecución de **Medunamun ("El Ibis")** con el Orbe de Edén. Liberación de Siwa.
- **`03_que_amon_vaya_contigo` (Que Amón Vaya Contigo - Nivel 8 en Siwa / Lago Mareotis):** Despedida de Siwa; viaje por el Desierto de Mareotis hacia la capital ptolemaica.

### Acto 2: La Metrópolis de Alejandría y la Primera Hoja Oculta (48 a.C.)
- **`04_aya_en_alejandria` (Aya en Alejandría - Nivel 10 en Alejandría):** Reencuentro con Aya en la cripta secreta; entrega de la primera **Hoja Oculta** (utilizada por Darío contra Jerjes I). Se revela que Aya ya abatió a **Actaeon ("El Buitre")** y **Ktesos ("El Carnero")**.
- **`05_gennadios_el_filakita` (Gennadios el Filakita - Nivel 11 en Alejandría):** Asalto a la Guarnición de Akra y muerte de Gennadios. Desencadena la persecución activa de los 10 Phylakes.
- **`06_el_fin_de_la_serpiente` (El Fin de la Serpiente - Nivel 12 en Alejandría):** Asesinato de **Eudoros ("La Serpiente")** en las termas de vapor. El mecanismo de la hoja se dispara y **cercena el dedo anular de Bayek**, fundando el sacrificio iniciático de la Hermandad.
- **`07_el_encuentro_con_cleopatra` (El Encuentro con Cleopatra - Nivel 13 en Nomos de Canopo):** Audiencia en la villa de Apolodoro; Cleopatra nombra formalmente a Bayek y Aya como los **Medjay de Egipto**.

### Acto 3: La Cacería de las Cuatro Bestias (48 - 47 a.C.)
- **`08_la_picadura_del_escarabajo` (La Picadura del Escarabajo - Nivel 15 en Sais / Delta):** Rescate del suegro de Taharqa mutilado; Taharqa ofrece una copa de vino adulterada y captura a Bayek.
- **`09_las_mentiras_del_escarabajo` (Las Mentiras del Escarabajo - Nivel 16 en Letópolis / Desierto):** Bayek despierta enterrado en la arena; alucinación de lluvia de escarabajos (*Overheating*); ajusticiamiento de **Taharqa ("El Escarabajo")** en el templo de Letópolis ante su hijo Kawab.
- **`10_la_madriguera_de_la_hiena` (La Madriguera de la Hiena - Nivel 19 en Guiza):** Incursión a la Gran Pirámide de Keops; descubrimiento de los rituales Isu con Sílice de **Khaliset ("La Hiena")** intentando revivir a su hija fallecida; combate en la tormenta de arena.
- **`11_el_rostro_del_lagarto` (El Rostro del Lagarto - Nivel 21 en Menfis):** Pestilencia en Menfis; viaje alucinatorio del Duat y batalla mística contra la serpiente Apep; ejecución de **Hetepi ("El Lagarto")** identificado por su bufanda azul y tos en el Templo de Ptah.
- **`12_las_escamas_del_cocodrilo` (Las Escamas del Cocodrilo - Nivel 25 en Faiyum):** Búsqueda de la libreta de cuentas de "El Cocodrilo"; rescate de Shadya; tragedia: Shadya es ejecutada ahogada en el fondo del lago con una piedra de molino por orden de Berenike.
- **`13_las_fauces_del_cocodrilo` (Las Fauces del Cocodrilo - Nivel 28 en Krokodilopolis):** Infiltración en la arena de gladiadores junto a Kensa; asalto nocturno a la villa de Faiyum y ejecución de **Berenike ("El Cocodrilo")**.

### Acto 4: La Traición de Cleopatra y el Sitio de Alejandría (47 a.C.)
- **`14_el_camino_de_los_gabiniani` (El Camino de los Gabiniani - Nivel 31 en Alejandría):** Eliminación de los desertores romanos comandados por Venator; consejo de guerra preparatorio.
- **`15_la_hoja_de_la_diosa` (La Hoja de la Diosa - Nivel 32 en Alejandría / Mediterráneo):** Aya infiltra a Cleopatra en una alfombra persa ante Julio César; combate naval; Aya escala y enciende el legendario **Faro de Alejandría**.
- **`16_la_batalla_del_nilo` (La Batalla del Nilo - Nivel 33 en Delta del Nilo):** Persecución en carruaje con César; muerte de **Pothinus ("El Escorpión")** sobre su elefante de guerra; derrota de Septimius, a quien César concede amnistía traicionando a Bayek y Aya.

### Acto 5: El Origen de la Hermandad y el Idus de Marzo (47 - 44 a.C.)
- **`17_las_secuelas` (Las Secuelas - Nivel 34 en Alejandría / Siwa):** Muerte de Apolodoro en la tumba de Alejandro Magno; revelación de que **Flavius Metellus ("El León")** y **Septimius ("El Chacal")** robaron los artefactos Isu; Flavius tortura y asesina a Hepzefa en Siwa.
- **`18_el_pesaje_final` (El Pesaje Final - Nivel 35 en Kyrenaika / Cirene):** Caza implacable de Flavius en la Acrópolis de Cirene; Flavius distorsiona la realidad con la Manzana de Edén; Bayek lo ejecuta y consigue la **paz eterna para Khemu**.
- **`19_el_ultimo_medjay` (El Último Medjay - Nivel 36 en Playas de Alejandría):** Despedida matrimonial entre Bayek y Aya; fundación de **Los Ocultos (The Hidden Ones)**; la marca dejada por el cráneo de águila de Khemu en la arena da origen al **emblema de los Asesinos**.
- **`20_la_caida_de_un_imperio` (La Caída de un Imperio - Nivel 36 en Roma / Foro Romano):** Aya viaja a Roma en el 44 a.C.; infiltración al Foro Romano; duelo final y asesinato de **Lucius Septimius** empuñando el Cetro de Edén.
- **`21_nacimiento_del_credo_roma` (Nacimiento del Credo & Roma - Nivel 36 en Senado de Roma / Cueva de Egipto):** 15 de marzo del 44 a.C. (Idus de Marzo); Aya asesta la primera puñalada a **Julio César** ("Padre de la Comprensión"); Aya adopta la identidad de **Amunet** (cerrando la conexión con la estatua de *Assassin's Creed II*); en el presente, Layla Hassan es rescatada en la cueva de Qattara por William Miles. ¡Platino alcanzado!

---

## Spoilers Completos de Historia y Lore

1. **La Verdadera Muerte de Khemu (Siwa, 49 a.C.):** Khemu no murió a manos directas de un guardia; durante el secuestro en la cripta subterránea, los enmascarados de la Orden intentaban obligar a Bayek a activar el Orbe Isu. Al resistirse Bayek, un miembro de la Orden sujetó la mano de Bayek armada con una daga y la desvió hacia el pecho de su hijo, clavándose directamente en el corazón de Khemu.
2. **Identidad de los Enmascarados de la Orden:**
   - *La Garza*: Rudjek (noble local de Siwa).
   - *El Ibis*: Medunamun (sacerdote corrupto del templo de Amón).
   - *El Buitre*: Actaeon & *El Carnero*: Ktesos (ambos asesinados por Aya en Alejandría antes de la llegada de Bayek).
   - *La Serpiente*: Eudoros (escriba real de las termas de Alejandría).
   - *El Escarabajo*: Taharqa (constructor benefactor que enterró a sus opositores en la arena de Letópolis).
   - *La Hiena*: Khaliset (nigromante que usaba artefactos de la Primera Civilización para resucitar a su hija Esris).
   - *El Lagarto*: Hetepi (sacerdote de Ptah que envenenó la comida y aire de Menfis).
   - *El Cocodrilo*: Berenike (terrateniente de Faiyum responsable del ahogamiento de la niña Shadya).
   - *El Escorpión*: Pothinus (tutor eunuco del joven rey Ptolomeo XIII).
   - *El Chacal*: Lucius Septimius (comandante de los Gabiniani y brazo armado de César).
   - *El León*: Flavius Metellus (general supremo romano y asesino de Hepzefa).
   - *El Padre de la Comprensión*: Cayo Julio César.
3. **El Dedo Anular Cercenado:** En las termas de Alejandría, Bayek forcejea bajo el agua con Eudoros. La hoja oculta de Darío no disponía de mecanismo de separación; al accionarse con el puño cerrado, corta limpiamente el dedo anular de Bayek. A partir de entonces, todos los iniciados en Los Ocultos amputan su dedo anular como símbolo de devoción.
4. **La Traición de Cleopatra y César:** Tras utilizar a Bayek y Aya para tomar el poder y asegurar Alejandría, Cleopatra y César perdonan a Septimius y Flavius a cambio de control político sobre Egipto, marginando a los Medjay.
5. **Aya es Amunet:** Al renunciar a su identidad civil tras matar a César, Aya escribe una carta final a Bayek firmando como **Amunet** ("La Oculta"). Esta revelación empalma directamente con *Assassin's Creed II* (2009), donde en la cripta bajo la Villa Auditore de Monteriggioni se halla la estatua conmemorativa de Amunet como la heroína que eliminó a Cleopatra en el 30 a.C. mediante el veneno de un áspid.
6. **Línea Temporal del Presente (Layla Hassan):** Layla Hassan, empleada de Abstergo Communications, modifica su propio Animus para leer ADN ancestral de momias sin importar el linaje consanguíneo. Abstergo envía al equipo táctico Sigma para ejecutarla y matan a su amiga Deanna Geary. William Miles (padre de Desmond Miles) la rescata en la Cueva de Qattara y la recluta para la Hermandad de Asesinos contemporánea.

---

## Catálogo de Easter Eggs y Secretos

1. **Crossover Oficial con Final Fantasy XV (*A Gift from the Gods*):**
   - *Ubicación:* Pirámide escalonada del Nomos de Saqqara (Nivel 23).
   - *Mecánica:* Un meteorito choca contra el desierto. Bayek resuelve un puzle numérico solar y abre un portal místico del que emergen Bahamut y el villano Ardyn Izunia.
   - *Recompensa:* Espada legendaria *Ultima Blade*, escudo *Ziedrich* y montura de camello disfrazado de Chocobo (*Kweh*).
2. **La Cripta Isu bajo la Gran Esfinge de Guiza (*Armadura Isu*):**
   - *Ubicación:* Grieta secreta en la parte trasera de la Esfinge de Guiza.
   - *Requisitos:* Completar los 12 Círculos de Piedra de la misión *La Promesa de Bayek* y recolectar 50 unidades de Sílice en las tumbas.
   - *Recompensa:* Atuendo cibernético Isu con voz metálica modulada y protección holográfica.
3. **Los Seis Mecanismos Antiguos y Transmisiones del Futuro:**
   - *Ubicación:* Tumbas de Oun-mAa Niyeptess, Seshem.eff, Eeyoo Sekedoo, Khufu, Smenkhkare y Qeneb too Kah'Aiye.
   - *Lore:* Monolitos de la Primera Civilización que se activan con Sílice y reproducen audios precursores dirigiéndose directamente a Layla Hassan y Desmond Miles sobre la no-linealidad temporal.
4. **Los Nueve Espejismos del Gran Mar de Arena:**
   - *Ubicación:* Gran Mar de Arena / Desierto Blanco a mediodía.
   - *Eventos:* Lluvia de insectos (trofeo *Overheating*), arbusto ardiente, estrella fugaz, espejismo de Khemu señalando un oasis, jinete fantasma y árbol que se desvanece al acercarse.
5. **La Estatua de Amunet en Assassin's Creed II:**
   - Cierra una brecha de continuidad histórica planeada por Ubisoft durante más de 8 años, revelando el origen de la Asesina egipcia reverenciada por Ezio Auditore.
6. **Archivos Confidenciales en la Laptop de Layla Hassan:**
   - Salir del Animus en la Cueva de Qattara permite examinar correos con Sophia Rikkin (personaje de la película oficial de *Assassin's Creed* de 2016 con Michael Fassbender) y los informes de la autopsia médica de Desmond Miles tras los eventos de *Assassin's Creed III*.

---

## Hoja de Ruta de Trofeos & Mitigación de Glitches

El juego base contiene **51 trofeos** con un Platino prestigioso (`Earn Them All!`).

| Trofeo | Tipo | Grado | Riesgo | Protocolo de Mitigación / Prevención Inquebrantable |
| :--- | :--- | :--- | :--- | :--- |
| **Earn Them All!** | Platino | Platino | ALTO | Obtener los 50 trofeos restantes siguiendo la hoja de ruta sin saltear pasos. |
| **Old Habits** | Exploración | Oro | **CRÍTICO** | Completar las 291 ubicaciones (**?**) del mapa. **PREVENCIÓN:** Jamás explorar ubicaciones secundarias controlando a Aya (su progreso no se transfiere a Bayek). Usar a Senu al 100% para revelar cofres sumergidos invisibles en Herakleion y la guarida eremita en el Desierto Blanco. |
| **Reduce, Reuse, Recycle** | Economía | Bronce | **MÁXIMO (Perdible)** | Vender 100 baratijas a la vez. **PREVENCIÓN:** Jamás presionar el botón "Vender todas las baratijas" en tiendas hasta tener 100 unidades acumuladas en el inventario. |
| **Overheating** | Alucinación | Bronce | MEDIO | Cabalgar al Gran Mar de Arena a mediodía (11:00-14:00), desmontar y caminar a pie hasta detonar el espejismo de la lluvia de escarabajos. |
| **I Can See My House...** | Exploración | Bronce | BAJO | Escalar el pico de Ra-Horakhty en el Desierto Negro (la montaña más alta de Egipto). |
| **Defying Authority** | Combate | Bronce | MEDIO | Vencer a un Phylakes. Atraerlo a azoteas con flechas incendiarias y bombas de humo; evitar combate a campo abierto contra su caballo. |
| **Seven Farmers** | Misión | Bronce | BAJO | Completar la misión secundaria *Siete Granjeros* en el Nomos de Uab (Nivel 30+ recomendado). |
| **Are You Not Entertained?** | Arena | Bronce | MEDIO | Superar todos los torneos de la Arena de Gladiadores de Krokodilopolis. |
| **Ben-Hur** | Carreras | Bronce | MEDIO | Ganar el primer torneo del Hipódromo de Canopo usando rebufo y embestidas laterales. |
| **Archer of the Month** | Habilidad | Bronce | MEDIO | Tiro a la cabeza en el aire con arco tras desbloquear la habilidad correspondiente de Cazador. |

---

## Catálogo de Misiones Secundarias por Región

El repositorio modela y cataloga **más de 35 misiones secundarias clave** con otorgante, nivel, recompensas y notas narrativas:
- **Siwa (Niveles 2–5):** *Gear Up*, *Striking the Anvil*, *Hideaway*, *Water Rats*, *Family Reunion*, *The Healer*, *Prisoners in the Temple*.
- **Lago Mareotis (Niveles 7–10):** *Ambush in the Temple*, *Taste of Her Sting*, *Book of the Dead*, *Birthright*, *Lady of Slaughter*.
- **Alejandría (Niveles 10–13):** *The Accidental Philosopher*, *Higher Education*, *Phylakitai in the Eye*, *The Odyssey*, *Symposiasts*.
- **Nomos de Canopo (Niveles 12–14):** *The Weasel*, *The Hungry River*, *Wild Ride*, *Old Times*.
- **Menfis (Niveles 20–22):** *Blood in the Water*, *Ozymandias*, *Mortuary Practice*, *Children of Taran*.
- **Faiyum & Krokodilopolis (Niveles 24–30):** *The Bride*, *Sobek's Tears*, *The Jaws of Sobek*, *Bad Faith*, *Fires of Dionysias*.
- **Kyrenaika / Cirene (Niveles 34–38):** *My Brother for a Horse*, *Founding Father*, *The Cat and the Mouse*, *Pax Romana*.
- **Especiales / Crossover:** *A Gift from the Gods* (FFXV), *Bayek's Promise* (12 Círculos de Piedra).

---

## Estrategias Tácticas de Mitigación y Prevención

1. **Protocolo Anti-Glitch de Baratijas (*Reduce, Reuse, Recycle*):**
   - El modelo `WorldState#sell_trinkets_all!` prohíbe transacciones que no alcancen las 100 unidades.
   - Plan de contingencia si se vendieron por error: cazar hienas en las dunas de Guiza o asaltar campamentos militares con cofres de suministros triples.
2. **Protocolo de Ubicaciones Seguras (*Old Habits*):**
   - No limpiar zonas mientras se jueguen episodios de Aya (`ep15`, `ep20`, `ep21`).
   - Si tras terminar el juego falta una ubicación, verificar:
     - 1. Guarida de Eremitas oculta en el cañón del Desierto Blanco.
     - 2. Cofre sumergido al sur de la isla de Herakleion.
     - 3. Campamento desierto en la Depresión de Qattara.
3. **Protocolo contra Phylakes:**
   - Rango de niveles: 20 a 40.
   - Estrategia: vigilar el cuerno rojo en la brújula; tender emboscadas desde riscos rocosos con *Arco Depredador* y flechas incendiarias.
4. **Protocolo contra Elefantes de Guerra (Jumbe, Surus, Herwennefer, Qetesh & Resheph):**
   - Requisito: Nivel 38 mínimo.
   - Armamento: Arco Ligero con atributo *Salud al acertar* (*Health on Hit*) y espadas duales con adrenalina instantánea.
   - Maniobra: rodar hacia las patas traseras en sentido opuesto a su giro y castigar el vientre cuando el paquidermo se alza.
5. **Mitigación de Brecha de Nivel (*Level Gating*):**
   - Enemigos con 4 niveles por encima muestran calavera roja e inmunidad al asesinato sigiloso.
   - Mitigación: sincronizar atalayas regionales (+100 XP), completar misiones secundarias antes del arco principal y resolver acertijos de papiros.

---

## Uso del CLI (`bin/episodio`)

El CLI permite ejecutar simulaciones episódicas con granularidad analítica:

```bash
# Mostrar ayuda y catálogo de episodios
./bin/episodio --help
./bin/episodio list

# Ejecutar el Episodio 01 con informe analítico completo
./bin/episodio 01 --all

# Ejecutar con filtros específicos
./bin/episodio 06 --spoilers
./bin/episodio 09 --mitigations
./bin/episodio 21 --spoilers --trophies

# Consultar catálogo de misiones secundarias por región
./bin/episodio side-quests Siwa
./bin/episodio side-quests Faiyum

# Consultar hoja de ruta de trofeos filtrada por nivel de riesgo
./bin/episodio trophies critico
./bin/episodio trophies maximo
./bin/episodio trophies

# Consultar secretos y easter eggs
./bin/episodio easter-eggs

# Consultar matriz de mitigaciones tácticas
./bin/episodio mitigations
```

---

## Servidor Web Interactivo (`bin/servidor`)

El laboratorio cuenta con una interfaz web desarrollada en **Sinatra**:

```bash
# Iniciar servidor web en el puerto 4567
./bin/servidor

# O mediante Rack:
bundle exec rackup config.ru -p 4567
```

Abre tu navegador en `http://localhost:4567` para explorar:
- Dashboard de los 5 Actos y 21 Episodios.
- Vista de simulación episódica con eventos paso a paso, spoilers, secretos y secundarias.
- Catálogo de secundarias con filtros por región.
- Hoja de ruta interactiva de trofeos con código de colores por nivel de riesgo.
- Galería de easter eggs y conexiones con el lore de la franquicia.
- Matriz táctica de mitigación y prevención.

---

## Ejecución de Pruebas Automatizadas (`rake test`)

La suite de pruebas en `test/` verifica la integridad del dominio, precondiciones de escenas y ejecución secuencial:

```bash
rake test
```

Salida esperada:
```text
20 runs, 274 assertions, 0 failures, 0 errors, 0 skips
Finished in ~0.009s (28,000+ assertions/s) — 0 warnings (-w clean).
```

---

## Artefactos Preservados de Renoise (Dron Centinela)

Como parte de la coexistencia de proyectos en este mismo directorio, los archivos originales de la herramienta de Renoise se mantienen intactos:
- [`com.snocomm.dron_centinela.xrnx`](file:///Users/andreibarwood/Documents/snocomm/Dron%20Sentinela%20mm/com.snocomm.dron_centinela.xrnx): Paquete empaquetado y listo para arrastrar a Renoise V3.5.3+.
- [`tesis_dron_centinela.pdf`](file:///Users/andreibarwood/Documents/snocomm/Dron%20Sentinela%20mm/tesis_dron_centinela.pdf): Documento académico de la Cátedra de Cibernética Teórica.
- [`dron_centinela_src/`](file:///Users/andreibarwood/Documents/snocomm/Dron%20Sentinela%20mm/dron_centinela_src/): Código fuente en Lua con la corrección de compatibilidad en `main.lua`.
