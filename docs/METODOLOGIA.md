# Metodología del trabajo

## Problema y objetivo

Describir la evolución temporal de la tasa de mortalidad atribuida a contaminación del aire exterior en Perú y evaluar qué aportan cinco temas de métodos numéricos al análisis de una serie real. La comparación con Chile y Bolivia es descriptiva y debe respetar los años disponibles y una definición común del indicador.

No se pretende estimar efectos causales, ofrecer recomendaciones médicas ni producir un pronóstico epidemiológico. La tasa de mortalidad no es una concentración de partículas ni una medida directa de exposición individual.

## Datos y trazabilidad

La fuente de acceso es el indicador de Our World in Data `outdoor-pollution-death-rate`. El programa conserva el CSV, su JSON de metadatos y sus hashes SHA-256. En el informe definitivo se citará tanto a OWID como al proveedor primario y la edición que efectivamente identifiquen esos metadatos. No se atribuye por adelantado una edición del estudio de carga de enfermedad.

Se filtra por códigos ISO PER, CHL y BOL. El esquema esperado incluye Entity, Code, Year y un solo indicador numérico. Un cambio de esquema exige revisión y produce un error explícito. Para Perú se exigen al menos doce observaciones consecutivas anuales, sin duplicados ni tasas negativas o ausentes. No se rellenan huecos silenciosamente.

Antes de interpretar el gráfico debe verificarse si la tasa es cruda o estandarizada por edad, las unidades, el alcance de contaminación exterior y los límites de incertidumbre disponibles. El programa conserva esta información pero no puede sustituir su revisión conceptual.

## Ajuste y sistemas algebraicos

Se comparan polinomios de grados 1 y 2, con variable temporal escalada z = (t − centro) / escala. Esto evita potencias grandes de años como 2000 y reduce problemas de condicionamiento. Los coeficientes se almacenan en orden ascendente.

La matriz de diseño tiene columnas 1, z y, para grado dos, z². Se forma el sistema de ecuaciones normales (VᵀV)c = Vᵀy. Se resuelve mediante eliminación gaussiana con pivoteo parcial y sustitución hacia atrás. Se calcula el residuo infinito del sistema y se comparan los coeficientes con la solución rectangular `V\y` de MATLAB.

Las ecuaciones normales pueden elevar al cuadrado el número de condición de V; se usan aquí como aplicación explícita de sistemas del curso, con grados pequeños, escalado temporal y contraste independiente. El número de condición se informa: un residuo pequeño por sí solo no garantiza coeficientes exactos en un sistema mal condicionado.

## Validación temporal y teoría de errores

Se reserva el último 20 % de años, con al menos tres observaciones, para comparar modelos entrenados únicamente con los años anteriores. Se elige el grado de menor RMSE; un empate exacto favorece el grado uno. Luego se reajusta el grado elegido sobre toda la serie para describir el período histórico.

RMSE = raíz de la media de los errores cuadrados. MAE = media de sus valores absolutos. Se informa R² cuando hay variabilidad en los datos; para una serie constante se declara indefinido. MAPE omite denominadores cero y registra cuántos se excluyeron.

El conjunto reservado sirve para selección; no es una evaluación independiente posterior a esa selección. El error del ajuste final es descriptivo y normalmente optimista respecto a años futuros. Tampoco es la incertidumbre epidemiológica de los datos originales.

## Interpolación

Se usa interpolación lineal por tramos: entre dos nodos consecutivos se ponderan sus valores según la distancia temporal. Conserva los extremos y evita la oscilación de polinomios globales de grado alto.

Para verificarla se retiran algunos años interiores y se comparan sus observaciones con los valores reconstruidos exclusivamente desde los nodos retenidos. No se evalúa una interpolación en los mismos nodos que se usaron para construirla. Se prohíbe extrapolar.

## Ecuaciones no lineales

El escenario académico es localizar un cruce con el 80 % de la tasa del primer año observado. No es una meta oficial ni un umbral médico. Se define f(t) = ajuste(t) − 0.8 × tasa inicial.

Se busca el primer intervalo con cambio de signo dentro de los años observados. Bisección divide el intervalo y conserva la parte que contiene un cruce. Newton usa la derivada analítica del polinomio; si su paso sale del intervalo o la derivada no es utilizable, recurre al punto medio. Por ello se denomina Newton salvaguardado.

Se guardan año estimado, residuo y límites en cada iteración. El límite es de 200 iteraciones y la tolerancia de 10⁻⁸ en residuo o ancho del intervalo. Si no se encuentra un cruce aplicable, se informa sin extrapolar. Un contacto tangencial sin cambio de signo podría no detectarse: el análisis se limita expresamente a cruces con cambio de signo o ceros exactos de la malla.

El año del cruce de una curva suave puede ser fraccionario y no debe confundirse con un año observado. No se informa como fecha de una intervención o de un cambio causal.

## Derivación e integración

Con paso anual h, la derivada interior se aproxima por [y(i+1) − y(i−1)] / (2h). Los extremos usan fórmulas unilaterales de orden dos. La unidad es cambio de la tasa por año. Las diferencias pueden amplificar ruido y deben interpretarse junto con la serie.

Se aplican trapecios compuestos y Simpson 1/3. Simpson requiere una cantidad par de intervalos; cuando el total es impar se aplica Simpson al bloque inicial par y un trapecio al último intervalo. Se registra cuál regla se usó.

La diferencia entre las dos reglas es una medida de discrepancia numérica, no un error verdadero conocido. El área bajo una tasa tiene unidades de tasa multiplicada por años; no equivale al total de muertes. No se convierten tasas en conteos sin conocer población, estandarización y definición del indicador.

## Criterio para cerrar el análisis

Se aceptará la entrega cuando las pruebas MATLAB pasen, los datos originales estén identificados y revisados, cada cifra del informe provenga de una tabla generada, los gráficos sean legibles y la exposición explique tanto las aplicaciones como sus límites.

