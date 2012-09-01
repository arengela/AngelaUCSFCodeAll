function Tau = KendallTau(x,y)
%
%   Tau = KendallTau(x,y)
%
%   Carlos J. Morales
%   March 2003

n = length(x);
xrank = tiedrank(x);
yrank = tiedrank(y);
xsort = sort(x);
Con = zeros(1,n);
Dis = zeros(1,n);

for i = 1:n-1
        Con(i) = sum(yrank(i)<yrank(i:end));
        Dis(i) = sum(yrank(i)>yrank(i:end));
end

concordant = sum(Con);
discordant = sum(Dis);

Tau = (concordant-discordant)/((1/2)*(n*(n-1)));



        