# Reglas y Guía para Agentes — Laboratorio Narrativo & Mitigación Assassin's Creed Origins

Este documento establece los principios de arquitectura, modelado de dominio y diseño de simulación para cualquier intervención en este repositorio.

---

## 1. Misión y Alcance

- Mantener un **laboratorio narrativo y de mitigación táctica en Ruby** que simula, valida y analiza los **21 episodios principales** (distribuidos en 5 Actos canónicos) de *Assassin's Creed Origins*.
- El sistema actúa como un **gemelo digital del flujo de juego**, permitiendo reproducir la continuidad narrativa, calcular estados de inventario/nivel/trofeos, verificar precondiciones cronológicas y consultar matrices tácticas de mitigación contra bugs, pérdidas de trofeos y cuellos de botella de combate.
- **Rango cerrado de episodios:** `01` a `21` (desde el despertar de Bayek en Siwa y el ajuste de cuentas con Rudjek hasta el Idus de Marzo en Roma, la muerte de César y el presente con Layla Hassan y William Miles).

---

## 2. Idioma y Nomenclatura

- **Documentación, comentarios narrativos, spoilers, easter eggs y salida CLI/Web:** Español.
- **Código Ruby, clases, métodos, variables, atributos y tests:** Inglés idiomático Ruby (Clean Code, OOP, SOLID).
- **Taxonomía de eventos estable (`EventLog`):**
  - `story.scenario_started`
  - `story.objective_started`
  - `story.scene_transition`
  - `story.reunion_recorded`
  - `story.bathhouse_infiltration`
  - `story.senate_infiltration`
  - `story.modern_day_alliance`
  - `story.amunet_letter`
  - `combat.assassination_executed`
  - `combat.naval_skirmish`
  - `combat.chariot_clash`
  - `combat.boss_battle`
  - `story.scenario_completed`

---

## 3. Modelo de Dominio y Calidad

- **Separación de responsabilidades:**
  - `lib/origins_lab/character.rb`: Entidades con vida, estatus, afiliaciones, relaciones y pertenencias.
  - `lib/origins_lab/world_state.rb`: Contenedor inmutable por clonación profunda del estado del mundo (nivel de Bayek, dracmas, baratijas, nivel de la hoja oculta, equipo, banderas narrativas y trofeos desbloqueados).
  - `lib/origins_lab/event_log.rb`: Registro estructurado e inmutable de eventos con actor, objetivo, escena y datos adicionales.
  - `lib/origins_lab/scene.rb`: Entorno escénico con verificación estricta de precondiciones (`add_precondition` y `check_preconditions!`).
  - `lib/origins_lab/base_scenario.rb`: Plantilla abstracta que orquesta el ciclo de vida del episodio (`run`, `transition_to`, `spoilers`, `easter_eggs`, `mitigations`, `side_quests`, `trophies`).
  - `lib/origins_lab/manifest.rb`: Catálogo canónico centralizado de episodios, misiones secundarias por región, trofeos por nivel de riesgo, secretos y protocolos de mitigación.
  - `lib/origins_lab/scenarios/ep01.rb` .. `ep21.rb`: Las 21 implementaciones episódicas específicas.
  - `lib/origins_lab/web_app.rb`: Servidor Sinatra interactivo para visualización web.
  - `bin/episodio`: CLI con soporte para inspección analítica granular y subcomandos.
- **Determinismo estricto:** La simulación utiliza un generador pseudoaleatorio (`Random.new(seed)`) con semilla por defecto `42`, permitiendo suites de pruebas 100% reproducibles y libres de flakiness.
- **Manejo de errores:** Las fallas de precondición levantan excepciones explícitas `OriginsLab::PreconditionError` para evitar inconsistencias de continuidad.

---

## 4. Códigos de Salida CLI (`bin/episodio`)

- **`0`**: Ejecución exitosa (todos los pasos cronológicos se cumplieron y las aserciones de estado son válidas).
- **`2`**: Error de ejecución en tiempo de simulación (precondición rota, estado corrompido o excepción de dominio).
- **`3`**: Identificador inválido o comando no reconocido (fuera del catálogo `01`..`21` o subcomando ausente).

---

## 5. Protocolo de Prevención y Mitigación de Trofeos

Cualquier expansión de escenarios o estados debe cumplir con las siguientes reglas inviolables de *Assassin's Creed Origins*:
1. **Regla de Oro de Baratijas (*Reduce, Reuse, Recycle*):**
   - Nunca reducir el contador `trinkets_count` individualmente en los escenarios.
   - Solo se debe alterar a través del método seguro `WorldState#sell_trinkets_all!`, el cual desbloquea el trofeo exclusivamente si el volumen acumulado es `>= 100`.
2. **Regla de Integridad de Ubicaciones (*Old Habits*):**
   - Las ubicaciones (? en el mapa) y cofres jamás deben ser completadas bajo el control de Aya, ya que el motor original de Ubisoft no transfiere el progreso del mapa al perfil principal de Bayek.
3. **Regla de Insolación (*Overheating*):**
   - La alucinación de lluvia de escarabajos requiere modelar la estancia continua en zonas de desierto profundo (Gran Mar de Arena / Desierto Blanco) a mediodía.
