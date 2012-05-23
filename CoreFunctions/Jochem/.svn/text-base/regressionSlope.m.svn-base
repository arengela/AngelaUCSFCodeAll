function s=regressionSlope(x,y)
% s=regressionSlope(x,y) returns the slope of a linear regression between x and y

n=length(x);
sumX=sum(x);
s=(n*sum(x.*y)-sumX*sum(y))/(n*sum(x.^2)-sumX.^2);
