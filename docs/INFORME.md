# Análisis de la mortalidad atribuida a contaminación del aire exterior en Perú mediante métodos numéricos

## Carátula

Universidad Nacional de San Agustín de Arequipa

Escuela Profesional de Ingeniería de Sistemas

Curso: Métodos Numéricos — 2026B

Docente: pendiente de proporcionar

Entrega del trabajo escrito: 4 de diciembre de 2026

| Integrante | Código universitario |
| --- | --- |
| Chipana Jeronimo German Arturo | Pendiente |
| Palma Apaza Santiago Enrique | Pendiente |
| Mejia Rondan Giovanni Patrick | Pendiente |
| Baca Calsin Leonardo Juan Jose | Pendiente |

## Introducción

Las series temporales de indicadores sanitarios permiten describir cambios históricos y comparar representaciones matemáticas de los datos. Sin embargo, observar una gráfica no basta para determinar qué ajustes son adecuados, cómo se comportan los errores ni qué significan operaciones como derivar o integrar una tasa.

Este trabajo propone analizar en MATLAB la tasa de mortalidad atribuida a contaminación del aire exterior en Perú, obtenida de Our World in Data. Se aplican teoría de errores, solución de sistemas algebraicos, ajuste e interpolación, ecuaciones no lineales e integración y derivación numéricas. Chile y Bolivia se consideran como referencias descriptivas cuando existe información comparable.

## Objetivos

El objetivo general es implementar y evaluar procedimientos numéricos que permitan describir una serie sanitaria real y explicar el significado de sus resultados.

Los objetivos específicos son verificar la calidad y trazabilidad de los datos; comparar ajustes de bajo grado con validación temporal; resolver y comprobar el sistema de coeficientes; validar una interpolación en nodos retirados; localizar cruces históricos cuando existan; y calcular cambios y áreas con una interpretación correcta de sus unidades.

## Datos y métodos

La metodología completa, las fórmulas y los criterios de aceptación se desarrollan en `METODOLOGIA.md`. El período, el número de observaciones, la definición exacta del indicador y la edición del proveedor se incorporarán después de ejecutar y revisar el análisis real.

## Explicación del código

| Archivo | Responsabilidad |
| --- | --- |
| main.m | Coordinar adquisición, análisis y exportación |
| acquire_data.m | Descargar y conservar originales y metadatos |
| load_series.m | Validar esquema, países, años y valores |
| mn_gauss.m | Resolver sistemas por eliminación con pivoteo |
| mn_fit.m y mn_predict.m | Ajustar, evaluar y derivar polinomios |
| mn_metrics.m | Calcular errores con casos indefinidos explícitos |
| mn_linear.m | Interpolar sin extrapolar |
| mn_roots.m | Bisección y Newton salvaguardado |
| mn_calculus.m | Diferencias finitas y cuadraturas |
| analyze_series.m | Aplicar los métodos al problema |
| export_results.m | Producir tablas, gráficos y resumen HTML |
| run_tests.m | Comprobar soluciones conocidas y errores esperados |

## Resultados que deben incorporarse

Esta sección todavía no contiene resultados experimentales. Se completará con la ejecución real, sin usar valores de los casos sintéticos de prueba.

| Evidencia de ejecución | Uso en el informe |
| --- | --- |
| datos_utilizados.csv y fuente_y_metadatos.json | Cobertura, definición, fuente y edición |
| comparacion_modelos.csv | Comparación temporal y grado elegido |
| 01_ajuste.png y 02_residuos.png | Tendencia y evaluación visual del ajuste |
| validacion_interpolacion.csv | Precisión en años interiores retirados |
| iteraciones_biseccion.csv e iteraciones_newton.csv | Convergencia o ausencia de cruce |
| derivadas.csv y 03_derivadas.png | Cambios de la tasa |
| resumen.html | Cuadraturas, métricas e interpretación |
| cobertura_paises.csv y 04_paises.png | Comparación con cobertura explícita |

## Importancia de los métodos aplicados

La teoría de errores permite evaluar aproximaciones y distinguir precisión numérica de incertidumbre del origen. Los sistemas algebraicos conectan los datos con los coeficientes de un modelo y muestran la importancia del pivoteo y el condicionamiento. El ajuste resume una tendencia; la interpolación reconstruye valores interiores bajo supuestos distintos. La búsqueda de raíces permite localizar cruces de un nivel en una representación continua. La derivación expresa la velocidad del cambio y la integración resume un área cuya unidad debe conservarse.

## Conclusiones

Las conclusiones empíricas quedan pendientes de ejecutar MATLAB con datos reales y revisar los resultados. Deberán responder, con cifras verificadas, qué modelo tuvo menor error de validación, qué precisión alcanzó la interpolación, si existió un cruce histórico del umbral y qué patrones mostraron las diferencias finitas. Si los métodos no proporcionan evidencia suficiente para una afirmación, se declarará esa limitación.

## Referencias que deben completarse

- Our World in Data. Outdoor air pollution death rate. https://ourworldindata.org/grapher/outdoor-pollution-death-rate
- Proveedor primario, edición y licencia: completar con los metadatos efectivamente descargados.
- Guía del trabajo final del curso de Métodos Numéricos, UNSA, 2026B.

