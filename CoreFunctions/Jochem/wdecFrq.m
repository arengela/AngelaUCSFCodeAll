function [pF, Ind] = wdecFrq(N,L,DELTA,wname)
%wdecFrq get pseudo frequencies for wavelet decomposition.
%   [pf, Ind] = wdecFrq(N,L,DELTA,'wname') returns the
%   pseudo-frequencies corresponding to the intervals
%   resulting from level N, according to the sampling
%   period DELTA for a given wavelet wname.
%   Returns the pseudofrequencies pf and the Indices of
%   the corresponding intervals calculated from the bookkeeping 
%   vektor L.

pF = zeros(1,N);
Ind = zeros(1,N);
if (length(L)-2~=N),
    disp('error: level N does not correspond to length of L');
    return;
end
if ~(DELTA>0),
    disp('error: delta must be greater than zero.');
    return;
end
cf = centfrq(wname);

% Calculate indices of corresponding intervals
% where the index assigns the beginning of a freqency interval
Ind(1)=L(1)+1;
if(N>1)
    for k=2:N,
        Ind(k)=Ind(k-1)+L(k);
    end
end

% Calculate pseudo frequencies
a = 2^(N-1);
j = 1;
while a>=1,
    pF(j)=cf/(a*DELTA);
    a=a./2;
    j=j+1;
end
