# Guion de exposición

La duración propuesta es de doce a quince minutos, ajustable a la indicación del docente. El reparto siguiente es una propuesta para preparar la defensa, no un registro de contribuciones efectivamente realizadas.

| Integrante | Bloque propuesto | Evidencia que debe explicar |
| --- | --- | --- |
| Germán Chipana | Problema, fuente, calidad y errores | Datos, metadatos, RMSE y validación temporal |
| Santiago Palma | Sistemas algebraicos y ajuste | Escalado, pivoteo, condicionamiento y coeficientes |
| Giovanni Mejia | Interpolación y raíces | Años retirados, bisección y Newton salvaguardado |
| Leonardo Baca | Derivación, integración y cierre | Unidades, diferencias finitas, cuadraturas y límites |

## Secuencia de diapositivas

1. Título y equipo.
2. Problema, objetivo y pregunta del análisis.
3. Fuente, definición exacta, cobertura y edición de los datos.
4. Flujo del programa y cinco temas del curso.
5. Sistema de mínimos cuadrados y pivoteo parcial.
6. Comparación de modelos, validación y residuos.
7. Interpolación validada con años retirados.
8. Raíces: umbral académico, iteraciones y resultado o ausencia de cruce.
9. Derivación e integración con sus unidades.
10. Demostración de ejecución y archivos generados.
11. Conclusiones respaldadas por resultados reales.
12. Limitaciones, fuentes y preguntas.

## Demostración

Abrir MATLAB en la raíz. Ejecutar `addpath('tests'); run_tests` y mostrar que finaliza sin errores. Ejecutar `main(false)` con los originales conservados. Abrir `resumen.html`, explicar una tabla y contrastarla con su CSV. Conservar una ejecución previa completa por si la red falla; no presentar una ejecución grabada como si fuera en directo.

## Preguntas que debemos poder responder

- ¿Qué significa esta tasa y está estandarizada por edad?
- ¿Por qué comparar países usando tasas y no conteos?
- ¿Por qué escalar los años antes de ajustar?
- ¿Qué ventaja aporta el pivoteo y qué informa el número de condición?
- ¿Por qué un polinomio de grado alto puede ser una mala elección?
- ¿En qué se diferencian interpolación y ajuste?
- ¿Por qué los años de validación son posteriores a los de entrenamiento?
- ¿Qué ocurre si no hay cambio de signo o Newton intenta salir del intervalo?
- ¿Por qué el área bajo la tasa no es un número de muertes?
- ¿Qué diferencia hay entre error numérico e incertidumbre de los datos?

