function M = mn_metrics(actual,estimated)
%MN_METRICS Errores respecto a observaciones, no a una verdad sin incertidumbre.
actual = actual(:); estimated = estimated(:);
assert(isequal(size(actual),size(estimated)) && ~isempty(actual) && ...
    all(isfinite(actual)) && all(isfinite(estimated)), ...
    'mn:Metrics','Vectores finitos del mismo tamaño requeridos.');
e = estimated-actual;
M.mae = mean(abs(e)); M.rmse = sqrt(mean(e.^2));
M.maxAbsolute = max(abs(e));
nonzero = actual~=0;
if any(nonzero), M.mape = 100*mean(abs(e(nonzero)./actual(nonzero))); else, M.mape = NaN; end
M.excludedFromMAPE = sum(~nonzero);
sst = sum((actual-mean(actual)).^2);
if sst>0, M.r2 = 1-sum(e.^2)/sst; else, M.r2 = NaN; end
end

