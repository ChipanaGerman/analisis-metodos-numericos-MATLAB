function outdir = main(refresh)
%MAIN Ejecutar el trabajo completo desde cualquier carpeta de MATLAB.
%   MAIN(false) reutiliza los originales; MAIN(true) solicita actualizarlos.
if nargin < 1, refresh = false; end
root = fileparts(mfilename('fullpath'));
addpath(fullfile(root,'src'));
raw = acquire_data(root,refresh);
[T,info] = load_series(raw.csv);
stamp = char(datetime('now','Format','yyyyMMdd_HHmmss_SSS'));
outdir = fullfile(root,'results',stamp);
mkdir(outdir);
writetable(T,fullfile(outdir,'datos_utilizados.csv'));
R = analyze_series(T);
R.source = raw;
R.dataInfo = info;
save(fullfile(outdir,'analisis.mat'),'R','T');
export_results(R,T,outdir);
fid = fopen(fullfile(root,'results','latest.txt'),'w');
assert(fid >= 0,'No se pudo escribir latest.txt.');
cleanup = onCleanup(@() fclose(fid));
fprintf(fid,'%s\n',outdir);
fprintf('\nAnálisis finalizado. Resultados: %s\n',outdir);
end

