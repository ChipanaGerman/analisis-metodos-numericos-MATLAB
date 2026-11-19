# Estado verificable del proyecto

## Preparado

Código MATLAB que cubre cinco bloques del curso; pruebas con soluciones conocidas y entradas inválidas; descarga y conservación de originales; exportación de tablas, figuras y resumen HTML; documentación metodológica y guion de exposición; configuración de GitHub Actions para MATLAB.

Se generó y verificó un bundle Git con cuatro commits iniciales, atribuidos a los cuatro nombres y correos autorizados. El bundle contiene el proyecto y permite importar ese historial. El repositorio remoto sigue sin recibirlo. La revisión de integridad comprobó los catorce archivos MATLAB, sus nombres de función, referencias de pruebas y presencia de la configuración de ejecución; no equivale a ejecutar MATLAB.

## Bloqueos observados

- El repositorio público existe y es consultable, pero la integración respondió HTTP 403, Resource not accessible by integration, al intentar crear README.md. No se publicó ese archivo.
- Git por terminal no pudo conectar con github.com debido a una restricción de resolución de red.
- Se pudo inicializar .git, pero los permisos de esta sesión impidieron escribir su configuración. No debe interpretarse esa carpeta vacía como un historial ya publicado.
- La descarga de los archivos de OWID no fue posible desde esta terminal. No hay datos reales descargados ni resultados empíricos producidos.
- No se encontró MATLAB ni Octave en PATH ni en las carpetas habituales de Program Files. Las pruebas MATLAB todavía no se ejecutaron.
- La carga del entorno de dependencias para documentos devolvió un error. El informe y la exposición se conservan como texto editable; no se han generado Word, PDF o PowerPoint finales.

## Cierre pendiente

Habilitar escritura de la integración sobre el repositorio o publicar el historial preparado desde una terminal con acceso; ejecutar las pruebas y el análisis en MATLAB o GitHub Actions; revisar metadatos y resultados; incorporar cifras reales al informe y a las diapositivas; completar códigos y docente; generar y revisar los documentos finales.

Las comprobaciones de archivos disponibles fuera de MATLAB no validan sintaxis ni ejecución de MATLAB. Una configuración de automatización no demuestra que las pruebas hayan pasado.

