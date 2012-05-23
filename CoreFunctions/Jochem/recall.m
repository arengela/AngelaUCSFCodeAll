function [recPos recNeg]=recall(actLabel,predictedLabel)
% [recPos recNeg]=recall(actLabel,predictedLabel) calculate the recall
% PURPOSE:          Calculate the two class recall (the proportion of
%                   examples that belong to a class and were predicted to 
%                   belong to that class. 
%                   The average of recPos and recNeg is 0.5 if the class
%                   labels were predicted at random and >0.5 otherwise
%                   See Rieger etal. 2008 Neuroimage 42, pp. 1056ff
% INPUT:
% actLabel:         The actual class labels (positive or negative)
% predictedLabel:   Class labels assigned e.g. by a classifier
%
% OUTPUT:
% recPos:           Recalled proportion in the positive class
% recNeg:           Recalled proportion in the negative class
% 

%090108 JR wrote it

idxActPos=find(actLabel>0);
idxPredPos=find(predictedLabel>0);
idxActNeg=find(actLabel<0);
idxPredNeg=find(predictedLabel<0);

tmp=length(intersect(idxActPos,idxPredPos))/length(idxActPos);
recPos=tmp/(tmp+length(intersect(idxActPos,idxPredNeg))/length(idxActPos));

tmp=length(intersect(idxActNeg,idxPredNeg))/length(idxActNeg);
recNeg=tmp/(tmp+length(intersect(idxActNeg,idxPredPos))/length(idxActNeg));
