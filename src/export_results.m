function export_results(R,T,outdir)
%EXPORT_RESULTS Exportar evidencia y un resumen legible sin toolboxes.
writetable(R.modelComparison,fullfile(outdir,'comparacion_modelos.csv'));
writetable(R.interpolation,fullfile(outdir,'validacion_interpolacion.csv'));
writetable(R.derivatives,fullfile(outdir,'derivadas.csv'));
writetable(R.countryCoverage,fullfile(outdir,'cobertura_paises.csv'));
fid=fopen(fullfile(outdir,'resultados.json'),'w','n','UTF-8');
assert(fid>=0,'No se pudo escribir resultados.json.');
fprintf(fid,'%s',jsonencode(R,'PrettyPrint',true)); fclose(fid);
names={'Iteration','Year','Residual','Lower','Upper'};
writetable(array2table(R.bisectionHistory,'VariableNames',names), ...
    fullfile(outdir,'iteraciones_biseccion.csv'));
writetable(array2table(R.newtonHistory,'VariableNames',names), ...
    fullfile(outdir,'iteraciones_newton.csv'));
fid=fopen(fullfile(outdir,'fuente_y_metadatos.json'),'w');
assert(fid>=0,'No se pudo escribir el manifiesto.');
fprintf(fid,'%s',jsonencode(R.source,'PrettyPrint',true)); fclose(fid);
% Gráficos reproducibles y sin ventanas emergentes.
fig=figure('Visible','off','Color','w'); cleanup=onCleanup(@() close(fig));
plot(R.year,R.exposure,'o-','DisplayName','Dato OWID'); hold on;
fine=linspace(R.year(1),R.year(end),500);
plot(fine,mn_predict(R.model,fine),'-','LineWidth',1.6,'DisplayName','Ajuste seleccionado');
yline(R.threshold,'--','Umbral académico del 80 %','DisplayName','Umbral');
xlabel('Año'); ylabel('PM2.5 (µg/m³)'); grid on; legend('Location','best');
title('Perú: datos y ajuste de la exposición a PM2.5');
exportgraphics(fig,fullfile(outdir,'01_ajuste.png'),'Resolution',180);
clf(fig); plot(R.year,R.fit-R.exposure,'o-'); yline(0,'--'); grid on;
xlabel('Año'); ylabel('Ajuste menos observación'); title('Residuos del ajuste final');
exportgraphics(fig,fullfile(outdir,'02_residuos.png'),'Resolution',180);
clf(fig); plot(R.year,R.calculus.derivative,'o-'); yline(0,'--'); grid on;
xlabel('Año'); ylabel('Cambio de PM2.5 (µg/m³ por año)'); title('Derivación numérica de la serie');
exportgraphics(fig,fullfile(outdir,'03_derivadas.png'),'Resolution',180);
clf(fig); hold on; codes=unique(T.Code);
for k=1:numel(codes)
    Q=T(T.Code==codes(k) & T.Year>=R.year(1) & T.Year<=R.year(end),:);
    plot(Q.Year,Q.Exposure,'DisplayName',char(codes(k)));
end
xlabel('Año'); ylabel('PM2.5 (µg/m³)'); legend('Location','best'); grid on;
title('Comparación descriptiva; consultar cobertura por país');
exportgraphics(fig,fullfile(outdir,'04_paises.png'),'Resolution',180);
fid=fopen(fullfile(outdir,'resumen.html'),'w','n','UTF-8');
assert(fid>=0,'No se pudo escribir el resumen.'); htmlCleanup=onCleanup(@() fclose(fid));
fprintf(fid,['<!doctype html><html lang="es"><meta charset="utf-8">' ...
    '<title>Análisis numérico de contaminación exterior en Perú</title>' ...
    '<style>body{font:17px/1.55 system-ui;max-width:960px;margin:40px auto;padding:20px}' ...
    'img{max-width:100%%}table{border-collapse:collapse}td,th{border:1px solid #ccc;padding:8px}' ...
    '@media print{body{margin:0}img{max-height:380px}}</style>' ...
    '<h1>Análisis numérico de la exposición media anual a PM2.5 en Perú</h1>']);
fprintf(fid,'<p>Serie: %s. Período: %d–%d; %d observaciones.</p>', ...
    escape(R.dataInfo.indicator),R.year(1),R.year(end),numel(R.year));
fprintf(fid,'<p>Fuente: <a href="%s">Our World in Data</a>. Analizado en UTC: %s.</p>', ...
    R.source.url,R.source.analyzedAtUTC);
fprintf(fid,'<h2>Resultados observados</h2><p>Exposición inicial %.6g; final %.6g. Variación relativa %.4g %%.</p>', ...
    R.exposure(1),R.exposure(end),R.observedPercentChange);
fprintf(fid,'<h2>Ajuste y errores</h2><p>Grado seleccionado: %d. Validación temporal: %d–%d.</p>', ...
    R.model.degree,R.validationYears(1),R.validationYears(2));
write_table(fid,R.modelComparison);
fprintf(fid,['<p>La validación elige el grado; sus errores no son una evaluación final independiente. ' ...
    'Tras elegir, el modelo se reajusta con todos los años.</p>' ...
    '<p>RMSE del ajuste final %.6g; MAE %.6g; R² %.6g. ' ...
    'Condición de las ecuaciones normales %.6g; residuo del sistema %.6g; ' ...
    'diferencia de coeficientes respecto a MATLAB %.6g.</p>'], ...
    R.fitMetrics.rmse,R.fitMetrics.mae,R.fitMetrics.r2,R.model.conditionNormal, ...
    R.model.systemResidual,R.model.coefficientDifference);
fprintf(fid,'<img src="01_ajuste.png" alt="Datos y ajuste"><img src="02_residuos.png" alt="Residuos">');
fprintf(fid,'<h2>Interpolación</h2><p>RMSE en %d nodos interiores omitidos: %.6g. No se extrapola.</p>', ...
    height(R.interpolation),R.interpolationMetrics.rmse);
fprintf(fid,'<h2>Ecuaciones no lineales</h2><p>Umbral académico: %.6g. %s</p>',R.threshold,escape(R.rootStatus));
fprintf(fid,['<p>Año por bisección: %.10g; Newton salvaguardado: %.10g. ' ...
    'Residuos: %.6g y %.6g. NaN indica que no se obtuvo una raíz aplicable.</p>'], ...
    R.rootBisection,R.rootNewton,R.rootResidualBisection,R.rootResidualNewton);
fprintf(fid,['<h2>Integración y derivación</h2><p>Trapecios: %.8g. %s: %.8g. ' ...
    'Diferencia entre reglas: %.6g.</p><p>Unidad del área: exposición integrada en el tiempo ' ...
    '(µg/m³ multiplicados por años). No es una dosis individual ni un conteo de muertes. ' ...
    'La diferencia entre reglas no es un error verdadero conocido.</p>'], ...
    R.calculus.trapezoid,escape(R.calculus.simpsonRule),R.calculus.simpson,R.calculus.quadratureDifference);
fprintf(fid,'<img src="03_derivadas.png" alt="Cambios anuales"><h2>Comparaciones</h2>');
write_table(fid,R.countryCoverage);
fprintf(fid,'<img src="04_paises.png" alt="Series de países">');
fprintf(fid,['<h2>Interpretación y límites</h2><p>Los cambios describen esta serie de estimaciones. ' ...
    'No demuestran efectos causales ni permiten inferir variación local en Arequipa. ' ...
    'El cruce de una curva suavizada no equivale necesariamente al primer año observado bajo el umbral. ' ...
    'Los errores numéricos y de ajuste no sustituyen la incertidumbre epidemiológica del proveedor. ' ...
    'Las conclusiones académicas finales deben contrastarse con los metadatos originales.</p>' ...
    '<h2>Reproducibilidad</h2><p>SHA-256 del CSV: <code>%s</code>. ' ...
    'Metadatos y proveedor primario en fuente_y_metadatos.json.</p></html>'],R.source.csvSHA256);
end

function write_table(fid,T)
fprintf(fid,'<table><thead><tr>');
for k=1:width(T), fprintf(fid,'<th>%s</th>',escape(T.Properties.VariableNames{k})); end
fprintf(fid,'</tr></thead><tbody>');
for i=1:height(T)
    fprintf(fid,'<tr>');
    for k=1:width(T)
        v=T{i,k};
        if isnumeric(v), text=sprintf('%.8g',v); else, text=char(string(v)); end
        fprintf(fid,'<td>%s</td>',escape(text));
    end
    fprintf(fid,'</tr>');
end
fprintf(fid,'</tbody></table>');
end

function text = escape(text)
text=strrep(char(text),'&','&amp;'); text=strrep(text,'<','&lt;');
text=strrep(text,'>','&gt;'); text=strrep(text,'"','&quot;');
end

