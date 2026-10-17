# DRON SENTINELA mm — Matriz Táctica MITRE ATT&CK para Renoise (Tool `.xrnx`)

Herramienta oficial de Renoise para modelado, control estocástico y combate bio-acústico basada en la investigación:
> **"Estocástica Biomecánica y Fusión de Sensores: Análisis Predictivo del Dron Centinela"**  
> *Cátedra de Cibernética Teórica y Síntesis Estocástica*

---

## 🎯 Arquitectura General

Esta herramienta traduce los 5 capítulos de la tesis en un sistema ejecutable de **48 parámetros tácticos** organizados bajo el estándar matricial de **MITRE ATT&CK**. Permite:
1. **Configuración Integral**: 8 tácticas operacionales con 6 parámetros/técnicas cada una (48 parámetros en total).
2. **Ejecución desde el Menú**: Acceso directo desde `Tools -> Dron Sentinela - Matriz Táctica MITRE ATT&CK...` o clic derecho en el `Pattern Editor`.
3. **Inyección de Patrones Canónicos**: Generación de patrones de **96 líneas** a **72 BPM y 12 LPB** (ventana de Markov de 6.66 segundos a 14.4 Hz).
4. **Ejecución Dinámica en Movimiento (Live Tracker Engine)**: Cuando el tracker de Renoise está en reproducción (`transport.playing == true`), la herramienta calcula en tiempo real el Filtro de Kalman Extendido (EKF 12D), modula la alternancia binaural IACC a 14.4 Hz (colapso del efecto Haas), ajusta potencia BLDC y evalúa la dispersión balística (saltos de Lévy y divergencia de CEP enemigo).

---

## 📊 Matriz MITRE ATT&CK (8 Tácticas × 6 Técnicas = 48 Parámetros)

| Táctica | Código | Nombre Táctico | Descripción Operacional | Mapeo Tracker |
|---|---|---|---|---|
| **TA0001** | `T1011` | Portadora FMCW mmWave | 77.0 - 81.0 GHz (Inmunidad a grafeno) | Transposición base radar |
| | `T1012` | Ancho de Barrido FMCW | 1.0 - 4.0 GHz (Resolución de rango) | Pitch Slide 01xx / 02xx |
| | `T1013` | Penetración Dieléctrica | 0.1 - 5.0 dB/km (Fósforo blanco) | Filtro paso bajo / Resonancia |
| | `T1014` | Duración Chirp Tc | 10 - 100 μs | Delay sub-tick (00-FF) |
| | `T1015` | Bins FFT Range-Doppler | 64 - 512 bins espectrales | Búfer 09xx / 0Sxx (256 sectores) |
| | `T1016` | Canales MIMO AoA (MUSIC) | 2 - 16 canales virtuales | Polifonía y apertura estéreo |
| **TA0002** | `T1021` | Constante Tau Gauss-Markov | 0.5 - 10.0 s (Memoria inercial) | Decaimiento envolvente Jerk |
| | `T1022` | Varianza Ruido Proceso Q | 0.01 - 1.00 m²/s⁵ (Sobre-aceleración) | Desviación estocástica de offsets |
| | `T1023` | Varianza Ruido Medición R | 0.01 - 0.50 (Incertidumbre de fase) | Micro-jitter e interpolación |
| | `T1024` | Ganancia de Kalman Kk | 0.00 - 1.00 (Inercia vs Observación) | Peso de modulación en vivo |
| | `T1025` | Forma Simétrica de Joseph | 0 (Off) / 1 (On, Estabilidad P) | Definición positiva numérica |
| | `T1026` | Gating Innovación Nu | 1.0 - 10.0 σ (Filtro Chi-Square) | Rechazo de contramedidas |
| **TA0003** | `T1031` | Tempo Canónico Maestro | 32 - 180 BPM (Default: 72 BPM) | `transport.bpm` |
| | `T1032` | Líneas por Pulso (LPB) | 4 - 32 LPB (Default: 12 LPB) | `transport.lpb` |
| | `T1033` | Ticks por Línea (TPL) | 1 - 16 TPL (Default: 16 TPL) | `transport.tpl` (4.34 ms/tick) |
| | `T1034` | Paso de Línea Delta t | 10 - 200 ms (Calculado: 69.44 ms) | Base temporal inercial |
| | `T1035` | Micro-retardo Sub-tick | 0x00 - 0xFF (0 a 69.17 ms) | Columna Delay |
| | `T1036` | Frecuencia Servosistemas | 5 - 50 Hz (Calculado: 14.4 Hz) | Reloj de toberas y gimbales |
| **TA0004** | `T1041` | Vector B0xx: Interrupción | 0x00 - 0x10 | Salto de patrón de emergencia |
| | `T1042` | Vector 01xx/02xx: Chirp Jam | 0x01 - 0x40 | Rampa RF continua |
| | `T1043` | Vector 03xx/05xx: Gimbal Glide | 0x01 - 0x7F | Portamento angular sin fatiga |
| | `T1044` | Vector 09xx: Apertura Ecos | 0x00 - 0xFF | Correlador temporal FMCW |
| | `T1045` | Vector 0Lxx: Acople EKF-BLDC | 0x00 - 0xFF | RMSE a potencia de toberas |
| | `T1046` | Vector 0Rxy: Fricción Abrasiva | 0x01 - 0x7F (Default: 0x32) | Retrigger anti-deslizamiento |
| **TA0005** | `T1051` | Exponente de Hertz (p) | 1.0 - 2.5 (Default: 1.5 ley canónica) | Curva de impacto dinámico |
| | `T1052` | Rigidez Elástica k | 1 - 100 kN/m^p | Corte de brillo modal |
| | `T1053` | Amortiguamiento Viscoelástico | 0.01 - 1.00 | Tasa de decaimiento del mazo |
| | `T1054` | Inarmonicidad Modal | 1.0 - 8.0 (Ratios 2.75x / 5.48x) | Afinación de parciales de barra |
| | `T1055` | Material Resonador | 1: Palisandro, 2: Duraluminio, 3: Latón | Timbre orgánico vs metálico |
| | `T1056` | Dispersión Impact Chomp | 0.0 - 1.0 (Fricción de fieltro) | Ruido en transiente (< 4 ms) |
| **TA0006** | `T1061` | Cadencia Seisillo Biomecánico | 3.6 - 14.4 Hz (Default: 7.2 Hz) | Notas en líneas pares (cada 2L) |
| | `T1062` | Jitter Determinista | 0.000 ms estricto (Valle Inquietante) | Cuantización cristalina |
| | `T1063` | Rise Time del Transiente | 1 - 20 ms (Default: 3 ms, < 12 ms) | Acoustic Startle Reflex |
| | `T1064` | Conmutación Espacial IACC | 0 (Off) / 1 (On, Alternancia 14.4Hz) | Paneo 0x10 / 0x70 / 0x40 |
| | `T1065` | Colapso Efecto Haas | 0 - 100% (Desorientación olivar) | Profundidad de inversión de fase |
| | `T1066` | Disonancia Neuro-Acústica | 0 - 127 | Nivel de contramedida acústica |
| **TA0007** | `T1071` | Ventana de Markov MPC | 16 - 256 líneas (Default: 96 líneas) | Longitud de patrón inmutable |
| | `T1072` | Sector 0S00: Bombo / GRF | 0x00 - 0x1F | Fuerza de contacto con el suelo |
| | `T1073` | Sector 0S40: Caja / Choque | 0x20 - 0x5F | Amortiguación viscoelástica |
| | `T1074` | Sector 0S80: Contratiempo | 0x60 - 0x9F | Tracción asimétrica de chasis |
| | `T1075` | Sector 0Sc0: Redoble / Swing | 0xA0 - 0xDF | Micro-oscilación pata oscilante |
| | `T1076` | Ghost Notes / Encoders | 0x01 - 0x30 | Palpación en fase aérea |
| **TA0008** | `T1081` | Supresión de Autocorrelación | 0 - 100% (Ruptura de 2Hz/4Hz) | Evasión de periodicidad |
| | `T1082` | Saltos de Lévy (Alfa) | 1.0 - 2.0 (Default: 1.45) | Difusión anómala no lineal |
| | `T1083` | Divergencia CEP Enemigo | 1.0 - 50.0 m (Degradación balística) | Dispersión de tiro hostil |
| | `T1084` | Antirresonancia Chasis | 0 (Off) / 1 (On, Desintonización) | Protección de fuselaje titanio |
| | `T1085` | Micro-par Cizallante | 0x01 - 0x7F (Comando 0Rxy) | Tren de micro-pulsos abrasivos |
| | `T1086` | Modo Autónomo de Combate | 1: Patrol, 2: Intercept, 3: Psyop, 4: Evasion | Orquestador cinemático |

---

## 🚀 Instalación y Uso Inmediato

### Método A: Instalación Automática (Arrastrar y Soltar)
1. Toma el archivo empaquetado:
   `com.snocomm.dron_centinela.xrnx`
2. Arrástralo y suéltalo directamente sobre la ventana de **Renoise**.
3. Renoise mostrará el diálogo: *"Do you want to install the tool 'Dron Sentinela - Matriz Táctica MITRE ATT&CK'?"* -> Haz clic en **Yes**.

### Método B: Acceso en Renoise
- Ve al menú superior:  
  `Tools -> Dron Sentinela - Matriz Táctica MITRE ATT&CK...`
- O haz clic derecho en el **Pattern Editor**:  
  `Dron Sentinela -> Abrir Matriz Táctica...`
- Atajo de teclado global:  
  Configurable desde `Preferences -> Keys -> Global -> Tools -> Dron Sentinela Tactical Matrix`.

---

## ⚡ Flujo Táctico Recomendado

1. **Paso 1: Inicializar Entorno Canónico**  
   Presiona el botón `INICIALIZAR ENTORNO CANÓNICO`.  
   Esto configura el proyecto a **72 BPM**, **12 LPB** (Delta t = 69.44 ms) y crea las 4 pistas dedicadas:
   - `TAC_AMEN_MPC`: Canal de locomoción cuadrúpeda con transientes de bombo, caja, ghost notes y retriggers.
   - `TAC_SEISILLO_MALLET`: Canal modal Euler-Bernoulli con seisillos a 7.2 Hz, paneo alternante IACC y jitter 0.000 ms.
   - `TAC_FMCW_RADAR`: Canal de barrido continuo de radiofrecuencia (77-81 GHz) y acoplamiento BLDC.
   - `TAC_EKF_TELEMETRY`: Canal de impulsos GRF, portamentos de toberas y vectores cinemáticos.

2. **Paso 2: Inyectar Patrón de 96 Líneas**  
   Presiona `INYECTAR PATRÓN 96 LÍNEAS`.  
   El patrón actual se dimensiona a 96 líneas y se rellena con la álgebra hexadecimal canónica descrita en la tesis.

3. **Paso 3: Activar Motor Táctico en Vivo**  
   Presiona `MOTOR EN VIVO (TOGGLE)`.  
   Presiona la barra espaciadora en Renoise para poner el tracker en reproducción.  
   Mientras el tracker se mueve:
   - Cada línea de 69.44 ms avanza el estado cinemático 12D del Dron Centinela.
   - La alternancia binaural IACC se modula en tiempo real en la pista `TAC_SEISILLO_MALLET`.
   - La telemetría EKF muestra en vivo el rango radial $r$, ángulo de acimut $\theta$, elevación $\phi$, velocidad Doppler $d$, magnitud de Jerk (sobre-aceleración), residuo de innovación $\nu_k$ y divergencia del CEP adversario ante saltos de Lévy.
