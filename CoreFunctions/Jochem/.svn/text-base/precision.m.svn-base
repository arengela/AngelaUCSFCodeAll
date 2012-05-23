function [precPos precNeg]=precision(actLabel,predictedLabel)
% [precPos precNeg]=precision(actLabel,predictedLabel) calculate the recall
% PURPOSE:          Calculate the two class precision (the proportion of
%                   examples that were predited to belong to a class and
%                   actually belong to that class).
%                   The average of precPos and precNeg is 0.5 if the class
%                   labels were predicted at random and >0.5 otherwise
%                   See Rieger etal. 2008 Neuroimage 42, pp. 1056ff
% INPUT:
% actLabel:         The actual class labels (positive or negative)
% predictedLabel:   Class labels assigned e.g. by a classifier
%
% OUTPUT:
% precPos:           Precision (proportion) in the positive class
% precNeg:           Precision (proportion) in the negative class

%090108 JR wrote it


idxActPos=find(actLabel>0);
idxPredPos=find(predictedLabel>0);
idxActNeg=find(actLabel<0);
idxPredNeg=find(predictedLabel<0);

tmp=length(intersect(idxActPos,idxPredPos))/length(idxActPos);
precPos=tmp/length((tmp+intersect(idxActNeg,idxPredPos))/length(idxActPos));

tmp=length(intersect(idxActNeg,idxPredNeg))/length(idxActNeg);
precNeg=tmp/(tmp+length(intersect(idxActPos,idxPredNeg))/length(idxActNeg));
