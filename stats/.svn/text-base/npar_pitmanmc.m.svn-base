function [mcpval,mcsplus]=npar_pitmanmc(data,k)
% npar_pitmanmc called by npar_main performs nonparametric pitman Monte Carlo test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Nonparametric Statistical Tests in Matlab
%
% Author:
%   Carlos Morales         cmorales@wpi.edu
%   Statistics
%   Dept. of Mathematical Sciences
%   Worcester Polytechnic Institute
%   100 Institute Rd.
%   Worcester, MA  01609-2280
%
% Date: 2/6/2003 1:30PM
%
% Program: npar_pitmanmc.m
% Includes:
%   Pitman Monte Carlo
% Called by:
%   npar_main.m
%
% Pitman_MC finds Monte Carlo test for right-tail Pitman test
% [mcpval,mcsplus]=npar_pitmanmc(data,testmedian,n)
%
% inputs
%   data        vector of data
%   testmedian  median value of null hypothesis
%   n           number of simulations
%
% outputs
%   mcpval      MC p-value
%   mcsplus     montecarlo simulated S_pluses
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\nPitman MC using n=10000\n');
n = 10000;
plus = find(data>0);
S_plus = sum(data(plus));

% For exact value we need to compute all possible combinations of plus and
% minuses, and add all the probabilities of values for S_plus that fall in
% the rejection region.

% Monte Carlo:  we generate n vectors of 0-1 rv's and asign signs to items
% in the vector data, compute S_plus for each, and compute the
% (1-alpha)% percentile of this distribution.

datamc=data';
for i=1:n
    rand = binornd(1,0.5,1,k);
    mcsplus(i) = sum(abs(datamc.*rand));
end

tail = find(or(mcsplus>S_plus,mcsplus==S_plus));
mcpval = length(tail)/n;      % MC p-value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
