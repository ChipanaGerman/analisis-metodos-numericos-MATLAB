function model = mn_fit(t,y,degree)
%MN_FIT Ajuste de bajo grado con tiempo escalado y sistema explícito.
t = t(:); y = y(:);
assert(numel(t)==numel(y) && all(isfinite(t)) && all(isfinite(y)), ...
    'mn:FitInput','Datos de ajuste incompatibles.');
assert(ismember(degree,[1 2]) && numel(t)>degree+1, ...
    'mn:Degree','Grado permitido: 1 o 2; se requieren observaciones suficientes.');
center = mean(t); scale = max(abs(t-center));
assert(scale>0,'mn:Time','El tiempo no puede ser constante.');
z = (t-center)/scale;
V = ones(numel(t),degree+1);
for j = 1:degree, V(:,j+1) = z.^j; end
A = V.'*V; b = V.'*y;
[c,residual] = mn_gauss(A,b);
reference = V\y; % QR en MATLAB para sistema rectangular de rango completo
model = struct('degree',degree,'center',center,'scale',scale, ...
    'coefficients',c,'conditionNormal',cond(A),'systemResidual',residual, ...
    'coefficientDifference',norm(c-reference,inf));
end

