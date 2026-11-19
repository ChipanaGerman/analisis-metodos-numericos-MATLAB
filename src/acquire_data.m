function raw = acquire_data(root,refresh)
%ACQUIRE_DATA Descargar originales sin reemplazar silenciosamente la edición.
slug = 'average-exposure-pm25-pollution';
folder = fullfile(root,'data');
if ~isfolder(folder), mkdir(folder); end
raw.csv = fullfile(folder,[slug '.csv']);
raw.metadata = fullfile(folder,[slug '.metadata.json']);
raw.url = ['https://ourworldindata.org/grapher/' slug];
paths = {raw.csv,raw.metadata};
urls = {[raw.url '.csv'],[raw.url '.metadata.json']};
need = refresh || ~isfile(paths{1}) || ~isfile(paths{2});
if need
    % Descargar ambos a temporales; conservar la edición anterior si falla.
    temporary = {tempname(folder),tempname(folder)};
    cleanup = onCleanup(@() remove_temporary(temporary));
    try
        opts = weboptions('Timeout',90);
        for k = 1:2, websave(temporary{k},urls{k},opts); end
        jsondecode(fileread(temporary{2}));
        load_series(temporary{1}); % validar antes de reemplazar originales
        for k = 1:2
            if isfile(paths{k})
                tag = char(datetime('now','Format','yyyyMMdd_HHmmss_SSS'));
                copyfile(paths{k},[paths{k} '.' tag '.bak']);
            end
            movefile(temporary{k},paths{k},'f');
        end
        obtainedAt = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss'Z'"));
        fid = fopen(fullfile(folder,'acquired_at.txt'),'w');
        assert(fid>=0,'No se pudo guardar fecha de descarga.');
        fprintf(fid,'%s',obtainedAt); fclose(fid);
    catch ME
        error('mn:Download', ['No se pudieron adquirir y validar los originales. ' ...
            'No se ejecutará con datos simulados. Descargue CSV y metadatos ' ...
            'como indica README.md. Causa: %s'],ME.message);
    end
end
raw.csvSHA256 = sha256_file(raw.csv);
raw.metadataSHA256 = sha256_file(raw.metadata);
raw.analyzedAtUTC = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss'Z'"));
datefile = fullfile(folder,'acquired_at.txt');
if isfile(datefile)
    raw.acquiredAtUTC = strtrim(fileread(datefile));
else
    raw.acquiredAtUTC = 'Descarga manual; fecha no registrada';
end
raw.metadataContents = jsondecode(fileread(raw.metadata));
cols = fieldnames(raw.metadataContents.columns);
assert(numel(cols)==1,'mn:Metadata','Se esperaba un indicador en los metadatos.');
unit = raw.metadataContents.columns.(cols{1}).unit;
assert(contains(lower(unit),'micrograms per cubic meter'), ...
    'mn:Unit','La unidad no coincide con exposición a PM2.5 en microgramos por metro cúbico.');
raw.unit = unit;
snapshotPath = fullfile(folder,'snapshot.json');
if isfile(snapshotPath), raw.snapshot=jsondecode(fileread(snapshotPath)); end
end

function remove_temporary(paths)
for k = 1:numel(paths)
    if isfile(paths{k}), delete(paths{k}); end
end
end

