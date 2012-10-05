function [bestc, bestg, bestcv, model, predicted_label,accuracy, decision_values] = svm(instanceMatrix, labelVector,testinstanceMatrix, testlabelVector)
% instanceMatrix  An m by n matrix of m training instances with n features
% labelVector   An m by 1 vector of classes

% subtract minimum across instances for each feature 
% normalize by maximum
% (data - repmat(min(data,[],1),size(data,1),1))*spdiags(1./(max(data,[],1)-min(data,[],1))',0,size(data,2),size(data,2))
scale = spdiags(1./max(instanceMatrix,[],1)',...
    0,size(instanceMatrix,2),size(instanceMatrix,2));

instanceMatrixNorm = instanceMatrix*scale;
%% find best parameters
bestcv = 0;
for log2c = 1000
  for log2g =  5000
    cmd = ['-t 2 -q -b 1 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = svmtrain(labelVector, instanceMatrixNorm, cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
    end
    fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
  end
end
%% train
cmd = ['-t 2 -q -b 1 -c ', num2str(bestc), ' -g ', num2str(bestg)];
model = svmtrain(labelVector, instanceMatrixNorm, cmd);

%% test
testinstanceMatrixNorm = testinstanceMatrix*scale;

cmd = [' -b 1'];
[predicted_label, accuracy, decision_values] = svmpredict(testlabelVector, testinstanceMatrixNorm, model, cmd);

