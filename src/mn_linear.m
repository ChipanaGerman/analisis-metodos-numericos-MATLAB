function qy = mn_linear(x,y,q)
%MN_LINEAR Interpolación lineal; prohíbe extrapolación.
x = x(:); y = y(:);
assert(numel(x)==numel(y) && numel(x)>=2 && all(diff(x)>0) && ...
    all(isfinite(x)) && all(isfinite(y)), 'mn:Interpolation','Nodos inválidos.');
assert(all(isfinite(q(:))) && all(q(:)>=x(1) & q(:)<=x(end)), ...
    'mn:Extrapolation','Consultas fuera del intervalo o no finitas.');
qy = zeros(size(q));
for k = 1:numel(q)
    i = find(x<=q(k),1,'last'); i = min(i,numel(x)-1);
    weight = (q(k)-x(i))/(x(i+1)-x(i));
    qy(k) = (1-weight)*y(i)+weight*y(i+1);
end
end

