function [x,residual] = mn_gauss(A,b)
%MN_GAUSS Eliminación gaussiana con pivoteo parcial y sustitución hacia atrás.
[n,m] = size(A); b = b(:);
assert(n==m && numel(b)==n && n>0,'mn:Shape','Dimensiones incompatibles.');
assert(all(isfinite(A(:))) && all(isfinite(b)),'mn:Finite','Valores no finitos.');
originalA = A; originalB = b;
tol = eps*max(1,norm(A,inf))*n;
for k = 1:n
    [pivot,j] = max(abs(A(k:n,k))); j = j+k-1;
    assert(pivot>tol,'mn:Singular','Sistema singular o numéricamente singular.');
    if j~=k, A([k j],:) = A([j k],:); b([k j]) = b([j k]); end
    for i = k+1:n
        factor = A(i,k)/A(k,k);
        A(i,k:n) = A(i,k:n)-factor*A(k,k:n);
        b(i) = b(i)-factor*b(k);
    end
end
x = zeros(n,1);
for i = n:-1:1
    x(i) = (b(i)-A(i,i+1:n)*x(i+1:n))/A(i,i);
end
residual = norm(originalA*x-originalB,inf);
end

