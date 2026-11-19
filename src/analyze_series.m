function R = analyze_series(T)
%ANALYZE_SERIES Análisis de Perú con validación temporal sin fuga de datos.
P = T(T.Code=="PER",:); t=P.Year; y=P.Exposure; n=numel(t);
holdout = max(3,ceil(0.2*n)); cut=n-holdout;
train = 1:cut; validation = cut+1:n;
models = cell(2,1); validationRMSE=zeros(2,1); trainingRMSE=zeros(2,1);
for degree=1:2
    models{degree}=mn_fit(t(train),y(train),degree);
    metrics=mn_metrics(y(validation),mn_predict(models{degree},t(validation)));
    validationRMSE(degree)=metrics.rmse;
    metrics=mn_metrics(y(train),mn_predict(models{degree},t(train)));
    trainingRMSE(degree)=metrics.rmse;
end
[~,bestDegree]=min(validationRMSE); % empate favorece el modelo más sencillo
R.modelComparison=table((1:2)',trainingRMSE,validationRMSE, ...
    'VariableNames',{'Degree','TrainingRMSE','ValidationRMSE'});
R.validationYears=[t(cut+1) t(end)];
R.validationNote='Validación para elegir grado; no constituye un conjunto de prueba independiente.';
R.model=mn_fit(t,y,bestDegree); % reajuste sobre todos los datos tras selección
R.fit=mn_predict(R.model,t); R.fitMetrics=mn_metrics(y,R.fit);
R.year=t; R.exposure=y;
% Interpolación validada únicamente en nodos interiores retirados.
omitted=3:3:n-1; retained=setdiff(1:n,omitted);
interpolated=mn_linear(t(retained),y(retained),t(omitted));
R.interpolation=table(t(omitted),y(omitted),interpolated,interpolated-y(omitted), ...
    'VariableNames',{'Year','Observed','Interpolated','Error'});
R.interpolationMetrics=mn_metrics(y(omitted),interpolated);
R.calculus=mn_calculus(t,y);
R.derivatives=table(t,y,R.calculus.derivative, ...
    'VariableNames',{'Year','Exposure','ExposureChangePerYear'});
R.threshold=0.8*y(1); % escenario académico, no umbral médico
R.rootStatus='No se encontró un cruce con cambio de signo en el período observado.';
R.rootBisection=NaN; R.rootNewton=NaN;
R.bisectionHistory=zeros(0,5); R.newtonHistory=zeros(0,5);
R.rootResidualBisection=NaN; R.rootResidualNewton=NaN;
f=@(year) mn_predict(R.model,year)-R.threshold;
df=@(year) mn_predict(R.model,year,true);
grid=linspace(t(1),t(end),1001); fg=f(grid);
% Detectar primero ceros exactos, después el primer intervalo de cruce.
exact=find(fg==0,1);
if ~isempty(exact)
    R.rootBisection=grid(exact); R.rootNewton=grid(exact);
    R.rootResidualBisection=0; R.rootResidualNewton=0;
    R.rootStatus='Se encontró un cero exacto en la malla de búsqueda.';
else
    j=find(sign(fg(1:end-1))~=sign(fg(2:end)),1);
    if ~isempty(j)
        [rb,hb,cb]=mn_roots('bisection',f,df,grid(j),grid(j+1),1e-8,200);
        [rn,hn,cn]=mn_roots('newton',f,df,grid(j),grid(j+1),1e-8,200);
        assert(cb && cn,'mn:Convergence','Un método de raíces no convergió.');
        R.rootBisection=rb; R.rootNewton=rn;
        R.bisectionHistory=hb; R.newtonHistory=hn;
        R.rootResidualBisection=abs(f(rb)); R.rootResidualNewton=abs(f(rn));
        R.rootStatus='Primer cruce detectado con cambio de signo dentro del período histórico.';
    end
end
R.observedPercentChange=100*(y(end)-y(1))/y(1);
if y(1)==0, R.observedPercentChange=NaN; end
% Comparaciones exclusivamente sobre la intersección de años disponibles.
codes=unique(T.Code); country=strings(0,1); first=[]; last=[]; initial=[]; final=[];
for k=1:numel(codes)
    Q=T(T.Code==codes(k) & T.Year>=t(1) & T.Year<=t(end),:);
    Q=Q(ismember(Q.Year,t),:);
    if isempty(Q), continue; end
    country(end+1,1)=codes(k); first(end+1,1)=Q.Year(1); last(end+1,1)=Q.Year(end);
    initial(end+1,1)=Q.Exposure(1); final(end+1,1)=Q.Exposure(end);
end
R.countryCoverage=table(country,first,last,initial,final, ...
    'VariableNames',{'Code','FirstYear','LastYear','InitialExposure','FinalExposure'});
end

