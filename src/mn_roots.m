function [root,history,converged] = mn_roots(method,f,df,a,b,tol,maxiter)
%MN_ROOTS Bisección o Newton salvaguardado por intervalo con cambio de signo.
assert(isfinite(a) && isfinite(b) && a<b && tol>0 && isfinite(tol) && ...
    maxiter>=1 && maxiter==fix(maxiter),'mn:RootInput','Parámetros inválidos.');
fa = f(a); fb = f(b);
assert(isfinite(fa) && isfinite(fb),'mn:RootFinite','Función no finita.');
assert(fa==0 || fb==0 || sign(fa)~=sign(fb),'mn:Bracket','No hay cambio de signo.');
assert(ismember(string(method),["bisection","newton"]),'mn:Method','Método desconocido.');
history = zeros(maxiter,5); converged = false;
if fa==0, root=a; history=[0 a 0 a b]; converged=true; return; end
if fb==0, root=b; history=[0 b 0 a b]; converged=true; return; end
root = (a+b)/2;
for k = 1:maxiter
    candidate = (a+b)/2;
    if strcmp(method,'newton')
        slope = df(root);
        if isfinite(slope) && abs(slope)>eps
            trial = root-f(root)/slope;
            if isfinite(trial) && trial>a && trial<b, candidate=trial; end
        end
    end
    root = candidate; value = f(root);
    assert(isfinite(value),'mn:RootFinite','Función no finita durante iteración.');
    history(k,:) = [k root value a b];
    if abs(value)<=tol || (b-a)<=tol
        converged=true; history=history(1:k,:); return;
    end
    if sign(fa)~=sign(value), b=root; else, a=root; fa=value; end
end
history = history(1:maxiter,:);
end

