function C = mn_calculus(x,y)
%MN_CALCULUS Derivación de orden dos e integración de una malla uniforme.
x = x(:); y = y(:); n = numel(x);
assert(n>=3 && n==numel(y) && all(isfinite(x)) && all(isfinite(y)), ...
    'mn:Calculus','Se requieren al menos tres pares finitos.');
h = x(2)-x(1);
assert(h>0 && all(abs(diff(x)-h)<=1e-10*max(1,abs(h))), ...
    'mn:Grid','Se requiere malla uniforme creciente.');
d = zeros(n,1);
d(1) = (-3*y(1)+4*y(2)-y(3))/(2*h);
d(end) = (3*y(end)-4*y(end-1)+y(end-2))/(2*h);
d(2:end-1) = (y(3:end)-y(1:end-2))/(2*h);
trap = h*(sum(y)-0.5*(y(1)+y(end)));
intervals = n-1;
evenIntervals = intervals-mod(intervals,2);
ys = y(1:evenIntervals+1);
simpson = h/3*(ys(1)+ys(end)+4*sum(ys(2:2:end-1))+2*sum(ys(3:2:end-2)));
rule = 'Simpson 1/3 compuesto';
if mod(intervals,2)==1
    simpson = simpson+h*(y(end-1)+y(end))/2;
    rule = 'Simpson 1/3 y trapecio en el último intervalo';
end
C = struct('derivative',d,'trapezoid',trap,'simpson',simpson,'simpsonRule',rule, ...
    'quadratureDifference',abs(trap-simpson));
end
