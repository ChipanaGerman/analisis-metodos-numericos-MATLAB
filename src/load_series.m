function [T,info] = load_series(path)
%LOAD_SERIES Lectura estricta de un único indicador y malla anual completa.
opts = detectImportOptions(path,'FileType','text','VariableNamingRule','preserve');
raw = readtable(path,opts);
names = string(raw.Properties.VariableNames);
required = ["Entity","Code","Year"];
assert(all(ismember(required,names)),'mn:Schema','Faltan Entity, Code o Year.');
metrics = names(~ismember(names,required));
assert(numel(metrics)==1,'mn:Schema', ...
    'Se esperaba un único indicador; se encontraron %d. Revisar la edición.',numel(metrics));
values = raw.(char(metrics(1)));
assert(isnumeric(values),'mn:Schema','El indicador debe ser numérico.');
year = raw.Year;
assert(isnumeric(year),'mn:Schema','Year debe ser numérico.');
codes = string(raw.Code);
keep = ismember(codes,["PER","CHL","BOL"]);
T = table(string(raw.Entity(keep)),codes(keep),year(keep),values(keep), ...
    'VariableNames',{'Country','Code','Year','Exposure'});
assert(~isempty(T),'mn:Coverage','No hay países seleccionados.');
assert(all(isfinite(T.Year) & T.Year==fix(T.Year)), ...
    'mn:Year','Hay años inválidos.');
assert(all(isfinite(T.Exposure) & T.Exposure>=0),'mn:Values', ...
    'Hay exposiciones negativas o ausentes. Revisar el origen; no se imputan automáticamente.');
keys = T.Code + "_" + string(T.Year);
assert(numel(unique(keys))==height(T),'mn:Duplicates','Hay pares país-año duplicados.');
T = sortrows(T,{'Code','Year'});
p = T(T.Code=="PER",:);
assert(height(p)>=12,'mn:Coverage','Se requieren al menos 12 años de Perú.');
assert(all(diff(p.Year)==1),'mn:Gap','La serie de Perú presenta huecos anuales.');
info.indicator = char(metrics(1));
info.peruFirstYear = p.Year(1);
info.peruLastYear = p.Year(end);
info.peruObservations = height(p);
info.missingPolicy = 'Rechazar huecos y valores faltantes en Perú; no imputar.';
end

