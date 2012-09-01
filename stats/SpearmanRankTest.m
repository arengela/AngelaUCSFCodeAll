function [p, r, t, R, T ] =SpearmanRankTest(x,y,alter,MC,n)
%
% [p, r, t, R ] =SpearmanRankTest(x,y,alter,MC,n)
%
% input
% x,y       vestor data
% alter     0 for two-sided, 1 for right-tail, -1 for left-tail
% MC        1 if Monte Carlo is to be used, 0 if asymptotic

% ouput
% p         p-value
% r         Spearman Correleation
% t         test stats value
% R         Distribution of R (exact or Monte Carlo)
%
% Carlos J. Morales
% March, 2003

m = max(size(x));
x = reshape(x,1,m);
y = reshape(y,1,m);
xrank = tiedrank(x);
yrank = tiedrank(y);
t = sum((xrank-yrank).^2);
r = 1 -(6*t)/(m*(m^2-1));
if MC==1   %If sample size too large, use Monte Carlo    
    for i=1:n
        permutation = randperm(m);
        d(i,:) = xrank-permutation;
        T(i) = sum(d(i,:).^2);
        R(i) = 1 -(6*T(i))/(m*(m^2-1));
    end
    if alter > 0
        p = sum(R>r)/n;
    elseif alter < 0
        p = sum(R<r)/n;
    else
        sprintf('Not implemented yet')
    end
    
elseif MC==0  % asymptotic
    
    tn = r*(sqrt((m-2)/(1-r^2)));
    p = 1- tcdf(tn,m-2);
    
else    % eaxct
    Perms = perms(1:m);
    N = factorial(m);
     for i=1:N
        d(i,:) = xrank-Perms(i,:);
        T(i) = sum(d(i,:).^2);
        R(i) = 1 -(6*T(i))/(m*(m^2-1));
    end
    if alter > 0
        p = sum(R>r)/N;
    elseif alter < 0
        p = sum(R<r)/N;
    else
        sprintf('Not implemented yet')
    end
end

    
    