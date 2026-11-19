# Análisis de métodos numéricos en MATLAB

Trabajo final de Métodos Numéricos — Ingeniería de Sistemas, UNSA, 2026B.

**Tema:** evolución de la tasa de mortalidad atribuida a la contaminación del aire exterior en Perú. Chile y Bolivia se incluyen como referencias descriptivas, cuando hay datos comparables.

## Equipo

| Integrante | Correo |
| --- | --- |
| Chipana Jeronimo German Arturo | gchipanaj@unsa.edu.pe |
| Palma Apaza Santiago Enrique | spalmaa@unsa.edu.pe |
| Mejia Rondan Giovanni Patrick | gmejiar@unsa.edu.pe |
| Baca Calsin Leonardo Juan Jose | lbacac@unsa.edu.pe |

El docente autorizó el equipo de cuatro integrantes. Códigos universitarios y nombre del docente pendientes de proporcionar.

## Ejecutar

Requiere MATLAB R2021a o posterior y MATLAB base, sin toolboxes adicionales. Desde esta carpeta:

```matlab
addpath('src');
addpath('tests');
run_tests;                      % pruebas independientes de Internet
main;                           % descarga inicial y análisis
```

La primera ejecución necesita Internet. Guarda el CSV y los metadatos originales en `data/`. Las siguientes ejecuciones reutilizan esos archivos. No se sustituyen datos reales por datos simulados cuando falla la descarga.

Si la descarga automática falla, visita https://ourworldindata.org/grapher/outdoor-pollution-death-rate y descarga el CSV completo como `data/outdoor-pollution-death-rate.csv`. También guarda https://ourworldindata.org/grapher/outdoor-pollution-death-rate.metadata.json con ese nombre en `data/`.

```matlab
main(false);                    % reutilizar los archivos conservados
main(true);                     % solicitar una actualización del origen
```

Cada ejecución crea una carpeta con fecha y hora en `results/`: datos utilizados, métricas, iteraciones, gráficos PNG, resumen HTML y archivo MAT. `results/latest.txt` indica su ubicación. Los resultados dependen de la edición descargada de OWID; conservar los archivos originales es necesario para reproducirlos.

## Métodos

1. **Teoría de errores:** MAE, RMSE, error relativo donde está definido, error residual del sistema y comparación entre aproximaciones.
2. **Ecuaciones no lineales:** bisección y Newton para localizar un cruce histórico de la curva ajustada con un umbral del 80 % del primer valor observado. Si no existe un intervalo con cambio de signo, el programa lo informa.
3. **Sistemas de ecuaciones algebraicas:** eliminación gaussiana con pivoteo parcial en las ecuaciones normales del ajuste. Contraste independiente con `A\b`.
4. **Ajuste e interpolación:** mínimos cuadrados de grados 1 y 2 con tiempo escalado; elección por validación temporal; interpolación lineal por tramos validada con años interiores omitidos.
5. **Derivación e integración:** diferencias finitas de orden dos en malla anual; trapecios y Simpson 1/3. Para una cantidad impar de intervalos, Simpson se combina con un último trapecio y se declara la combinación.

No se interpreta el área bajo una tasa como número de muertes. No se suman riesgos sanitarios ni se atribuyen causas a simples tendencias temporales. No se hacen pronósticos fuera del período observado.

## Estructura

- `main.m`: entrada y coordinación.
- `src/`: descarga, validación, métodos, análisis y exportación.
- `tests/run_tests.m`: pruebas con soluciones conocidas y casos de error.
- `docs/`: metodología, estructura del informe, exposición y requisitos.
- `scripts/`: preparación del historial Git y comprobaciones disponibles fuera de MATLAB.
- `.github/workflows/matlab.yml`: ejecución prevista de pruebas y análisis en GitHub Actions, con artefactos descargables.

## Estado de verificación

Consultar `docs/ESTADO.md`. Una configuración de GitHub Actions no equivale a una ejecución aprobada. Los resultados y las conclusiones finales deben generarse y revisarse después de ejecutar MATLAB sobre el archivo real.

