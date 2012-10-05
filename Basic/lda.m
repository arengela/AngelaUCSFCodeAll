function [ldcoeff, ldvec] = lda(dat)
% function [ldcoeff, ldvec] = lda(dat)
%
% dat = 1xK cell matrix where K = number of classes
%       In each cell = Nk x Feature matrix
%       ex: dat{1} = rand(5,3); dat{2} = rand(6,3); dat{3} = rand(4,3);
%
% NOTE: Since Sb is at most rank K-1,  there will be only at most K-1 non-zero
% eigenvectors. These identify a subspace containing the variability
% between features
%
% Code by Connie Cheung

% computation
k = size(dat,2);
Sw = zeros(size(dat{1},2));
for iClass = 1:k
    n(iClass) = size(dat{iClass},1);
    groupMean(iClass,:) = mean(dat{iClass});
    Sw = Sw + (n(iClass)-1)*cov(dat{iClass});
end
totalN = sum(n);
Sw = Sw/(totalN - k); % within class variance

if k~=2
    Sb = cov(groupMean); % between class variance
else
    tmp = groupMean(1,:)-groupMean(2,:);
    Sb = tmp'*tmp;
end


% lda
% maximize between-class variance, minimize within-class variance
[temp_evec d] = eig(Sw\Sb);
temp_evals = abs(diag(d));

% Eigenvalues nearly always returned in descending order, but just
% to make sure.....
[ldcoeff perm] = sort(temp_evals, 1, 'descend');
N = length(perm);
if ldcoeff == temp_evals(1:N)
    % Originals were in order
    ldvec = temp_evec(:, 1:N);
    return
else
    % Need to reorder the eigenvectors
    for i=1:N
        ldvec(:,i) = temp_evec(:,perm(i));
    end
end
