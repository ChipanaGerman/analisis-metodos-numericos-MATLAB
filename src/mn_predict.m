function y = mn_predict(model,t,derivative)
%MN_PREDICT Evaluar el polinomio o su derivada respecto al año.
if nargin<3, derivative = false; end
z = (t-model.center)/model.scale;
c = model.coefficients;
if derivative
    y = zeros(size(z));
    for j = 1:model.degree, y = y+j*c(j+1)*z.^(j-1)/model.scale; end
else
    y = zeros(size(z));
    for j = model.degree:-1:0, y = y.*z+c(j+1); end
end
end

