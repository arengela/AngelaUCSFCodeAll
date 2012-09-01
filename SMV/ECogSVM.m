function svmOut = ECogSVM(allBlocks, classes, goodElects)
% function svmOut = ECogSVM(allBlocks, classes, goodElects)
% Runs createSVMInstanceMatrix, svmtrain, svmpredict
% 1) creates matrix from classes and blockNames, scales matrix
% 2) svmtrain, cross validation to find best parameters
% 3) svmtrain on entire training set to create model
% 4) svmpredict 
%
% output: svmOut
wpath = '/data_store/SyllablesListening/experiment_data';
if ~exist(wpath, 'dir')    
    wpath = '/Users/conniecheung/GradSchoolWork/EC_lab/Data/syllables_listening/syllables_6';
end

fnames = dir([wpath filesep '*.wav']);
for iAudio = 1:length(fnames)
    names{iAudio} = strrep(fnames(iAudio).name,'.wav','');
end

blockNames = {'EC2_B44', 'EC2_B46', 'EC2_B72', 'EC2_B83'};
dataLength = .35;
testblockNames = {'EC2_B88'; 'EC2_B106'};

 [instanceMatrix, labelVector] = createSVMInstanceMatrix(allBlocks,...
    blockNames, names, classes, dataLength, goodElects);

% scale = 1/10;

% subtract minimum across instances for each feature 
% normalize by maximum
% (data - repmat(min(data,[],1),size(data,1),1))*spdiags(1./(max(data,[],1)-min(data,[],1))',0,size(data,2),size(data,2))
scale = spdiags(1./max(instanceMatrix,[],1)',...
    0,size(instanceMatrix,2),size(instanceMatrix,2));

instanceMatrixNorm = instanceMatrix*scale;
%% find best parameters
bestcv = 0;
for log2c = -5:10
  for log2g = -10:10
    cmd = ['-b 1 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = svmtrain(labelVector, instanceMatrixNorm, cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
    end

    fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
  end
end
%% train
cmd = ['-b 1 -c ', num2str(bestc), ' -g ', num2str(bestg)];
model = svmtrain(labelVector, instanceMatrixNorm, cmd);

clear instanceMatrixNorm
clear instanceMatrix
%% test
[testinstanceMatrix, testlabelVector] = createSVMInstanceMatrix(allBlocks,...
    testblockNames, names, classes, dataLength, goodElects);

testinstanceMatrixNorm = testinstanceMatrix*scale;
clear testinstanceMatrix

cmd = ['-b 1'];
[predicted_label, accuracy, decision_values] = svmpredict(testlabelVector, testinstanceMatrixNorm, model, cmd);

svmOut.classes = classes;
svmOut.elects = goodElects;
svmOut.trainBlockNames = blockNames;
svmOut.testBlockNames = testblockNames;
svmOut.params = [bestc, bestg, bestcv];
svmOut.model = model;
svmOut.predictedLabel = predicted_label;
svmOut.accuracy = accuracy;
svmOut.decisionValues = decision_values;