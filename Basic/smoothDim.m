function dSm=smoothDim(data,dim,span);
if nargin<3
    span=5;
end
n=ndims(data);
o=setdiff(1:n,dim);
d=permute(data,[o dim]);
for i=1:size(data,o)
    dSm(i,:)=smooth(d(i,:),span);
end