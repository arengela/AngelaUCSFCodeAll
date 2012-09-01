function [p, sp] = pitman_mc(data,testmedian,n)
% Pitman_MC finds Monte Carlo test for right-tail Pitman test
% p = Pitman_MC(data,med,n)
%
% inputs
%   data    vector of data
%   median  median value of null hypothesis
%   n       number of simulations
%
% outputs
%   p       MC p-value
%   Sp      montecarlo simulated S_pluses

% npar_pitman called by npar_main performs nonparametric pitman test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Nonparametric Statistical Tests in Matlab
%
% Author:
%   Erik B. Erhardt                                             erike@wpi.edu
%   Statistics Graduate Student and Teaching Assistant
%   Dept. of Mathematical Sciences                             (508) 831-5546
%   Worcester Polytechnic Institute                                    SH 204
%   100 Institute Rd.
%   Worcester, MA  01609-2280
%
% Date: 2/6/2003 1:30PM
%
% Program: npar_pitman.m
% Includes:
%   Pitman
% Called by:
%   npar_main.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%defaults
n = 10000;
data = data-med;
ld = length(data);
plus = find(data>0);
S_plus = sum(data(plus));

% For exact value we need to compute all possible combinations of plus and
% minuses, and add all the probabilities of values for S_plus that fall in
% the rejection region.

% Monte Carlo:  we generate n vectors of 0-1 rv's and asign signs to items
% in the vector data, compute S_plus for each, and compute the (1-alpha)% percentile of this distribution.

for i=1:n
    rand = binornd(1,0.5,1,ld);
    Sp(i) = sum(abs(data.*rand));
end

tail = find(or(Sp>S_plus,Sp==S_plus));

p = length(tail)/n;

