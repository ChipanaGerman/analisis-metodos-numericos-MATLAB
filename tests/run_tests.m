function run_tests
%RUN_TESTS Pruebas deterministas; los datos sintéticos sólo se usan aquí.
root=fileparts(fileparts(mfilename('fullpath'))); addpath(fullfile(root,'src'));
% Pivoteo obligatorio: primera diagonal cero pero sistema no singular.
A=[0 2;1 3]; b=[4;7]; [x,r]=mn_gauss(A,b);
assert(norm(x-[1;2],inf)<1e-12 && r<1e-12);
must_fail(@() mn_gauss([1 2;2 4],[1;2]),'mn:Singular');
must_fail(@() mn_gauss(ones(2,3),[1;2]),'mn:Shape');
% Ajuste exacto de polinomio cuadrático en años grandes.
t=(1990:2010)'; y=4+0.2*(t-2000)+0.03*(t-2000).^2;
m=mn_fit(t,y,2); assert(max(abs(mn_predict(m,t)-y))<1e-10);
assert(max(abs(mn_predict(m,t,true)-(0.2+0.06*(t-2000))))<1e-10);
% MAPE excluye ceros; R² de una serie constante no está definido.
M=mn_metrics([0;2],[1;3]); assert(M.excludedFromMAPE==1 && abs(M.mape-50)<1e-12);
M=mn_metrics([2;2],[2;2]); assert(isnan(M.r2));
% Interpolación conserva extremos y es exacta para una recta.
q=[0 .5 1 1.5 2]; v=mn_linear([0 1 2],[1 3 5],q);
assert(max(abs(v-(1+2*q)))<1e-12);
must_fail(@() mn_linear([0 1],[0 1],2),'mn:Extrapolation');
must_fail(@() mn_linear([0 0],[1 2],0),'mn:Interpolation');
% Raíz conocida, raíz en extremo, falta de cruce y no convergencia.
f=@(x) x.^2-2; df=@(x) 2*x;
for method={'bisection','newton'}
    [v,h,ok]=mn_roots(method{1},f,df,0,2,1e-12,200);
    assert(ok && abs(v-sqrt(2))<1e-10 && ~isempty(h));
end
[v,~,ok]=mn_roots('bisection',@(x) x,@(x) 1,0,1,1e-10,10);
assert(ok && v==0);
must_fail(@() mn_roots('bisection',f,df,2,3,1e-8,10),'mn:Bracket');
[~,~,ok]=mn_roots('bisection',f,df,0,2,1e-14,1); assert(~ok);
% Newton con derivada nula debe recurrir a bisección.
[v,~,ok]=mn_roots('newton',f,@(x) 0,0,2,1e-12,200);
assert(ok && abs(v-sqrt(2))<1e-10);
% Derivación exacta de cuadrática; Simpson exacto para cúbica.
t=(0:0.25:2)'; C=mn_calculus(t,t.^2);
assert(max(abs(C.derivative-2*t))<1e-12);
C=mn_calculus(t,t.^3); assert(abs(C.simpson-4)<1e-12);
assert(abs(C.trapezoid-trapz(t,t.^3))<1e-12);
C=mn_calculus((0:3)',(0:3)');
assert(abs(C.simpson-4.5)<1e-12 && contains(C.simpsonRule,'trapecio'));
must_fail(@() mn_calculus([0 1 3],[0 1 9]),'mn:Grid');
% Comprobación integral sintética sin descarga, con todos los módulos.
T=table(repmat("Peru",21,1),repmat("PER",21,1),(2000:2020)', ...
    100-2*(0:20)','VariableNames',{'Country','Code','Year','Rate'});
R=analyze_series(T);
assert(R.model.degree==1 || R.modelComparison.ValidationRMSE(2)<1e-10);
assert(abs(R.rootBisection-2010)<1e-6 && abs(R.rootNewton-2010)<1e-6);
assert(R.interpolationMetrics.rmse<1e-10);
% La ausencia de cruce debe producir un estado explícito, no extrapolación.
T.Rate=100+2*(0:20)'; R=analyze_series(T); assert(isnan(R.rootBisection));
test_loader;
fprintf('Todas las pruebas MATLAB finalizaron correctamente.\n');
end

function must_fail(f,id)
try
    f();
catch ME
    assert(strcmp(ME.identifier,id),'Error inesperado: %s (%s)',ME.message,ME.identifier);
    return;
end
error('mn:Test','Se esperaba el error %s.',id);
end

function test_loader
p=[tempname '.csv']; cleanup=onCleanup(@() remove_file(p));
raw=table(repmat("Peru",12,1),repmat("PER",12,1),(2000:2011)',ones(12,1), ...
    'VariableNames',{'Entity','Code','Year','Metric'});
writetable(raw,p); [T,info]=load_series(p);
assert(height(T)==12 && info.peruFirstYear==2000);
raw=[raw;raw(1,:)]; writetable(raw,p);
must_fail(@() load_series(p),'mn:Duplicates');
raw=raw(1:12,:); raw.Metric(3)=NaN; writetable(raw,p);
must_fail(@() load_series(p),'mn:Values');
end

function remove_file(p)
if isfile(p), delete(p); end
end

