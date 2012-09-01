function C = MakeCorr(V)
%
%   MakeCorr(V)         Make Correlation.  Makes a correlation matrix out
%                       of a covariance matrix.
%
%  Created by Carlos J. Morales
%  June 2002

DV = sqrt(diag(V));

R = DV*DV';

C = V./R;

