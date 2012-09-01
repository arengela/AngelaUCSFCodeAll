function [instanceMatrix, labelVector] = createSVMInstanceMatrix(allBlocks,...
    blockNames, names, classes, dataLength, elects)
% INPUTS
% allBlocks    structure with fields name,out
%                   ex: allBlocks.name = 'EC2_B1'
%                           .out = 1x288 struct array with fields:
% blockNames    cell array of blocks to include in instanceMatrix
%                   ex: {'EC2_B1', 'EC2_B3'}
% names         cell array of audio file names in the same order as found in
%               allBlocks.out
%                   ex: {'AC_ba'    'AC_bi'}
% classes        cell array of syllables to extract
%                   ex: { {'ba' 'bi'}, 'lu'}
% dataLength    amount of data in seconds to extract from onset of event
%                   ex: .3
% elects         electrodes of interest
%
% OUTPUTS
% instanceMatrix  An m by n matrix of m training instances with n features
% labelVector   An m by 1 vector of classes
%
% written by Connie


% finds which blocks are wanted in allBlocks
blockNums = [];
for iBlockName = 1:length(blockNames)
    for iBlock = 1:length(allBlocks)
        if ~isempty(strfind(allBlocks(iBlock).name, blockNames{iBlockName}))
            blockNums = [blockNums iBlock];
        end
    end
end

% finds syllable order in names array...MUST correspond to out structure
% order eg names(x) == out(x)
for i = 1:length(names)
    x= strfind(names{i},'_');
    n = names{i};
    syllable{i}=n(x+1:end);
end

% determine if classes are the same
if length(classes) ==2 && isequal(classes(1), classes(2))
    classEq = 1;
else
    classEq = 0;
end



% allocate memory
numInstances = 0;
dataf = allBlocks(1).out(1).dataf;
bef = allBlocks(1).out(1).befaft(1);
indices = ceil(dataf*bef): ceil(dataf*(dataLength+bef)); % indices = 150:300;
for iClass = 1:length(classes)
    ind = find(ismember(syllable,classes{iClass}));
    for iBlock = 1:length(blockNums)
        
        for iInd = 1:length(ind)
            % numInstances = numInstances + 1;
            numInstances = numInstances + size(allBlocks(blockNums(iBlock)).out(ind(iInd)).highgamma,3);
        end
        
    end
end
instanceMatrix = zeros(numInstances, length(indices)*length(elects));
labelVector = zeros(numInstances,1);

% retrieve instances
numInstant = 0;
for iClass = 1:length(classes) % for each class
    ind = find(ismember(syllable,classes{iClass})); % out(ind).name is a member of the class
    
    %     if classEq == 1 && iClass == 1
    %          p = randperm(length(ind));
    %         ind = ind(p(1:ceil(end/2)));
    %     elseif classEq == 1 && iClass == 2
    %         ind = ind(p(ceil(end/2)+1:end));
    %         TEST THIS
    %     end
    
    for iBlock = 1:length(blockNums) % for each block
         
        for iInd = 1:length(ind) % for each member of the class
             data = allBlocks(blockNums(iBlock)).out(ind(iInd)).highgamma;
            for iTrial = 1:size(data,3) % for each trial
                numInstant = numInstant + 1;
                trialdata = data(elects,indices,iTrial);
                trialdata = reshape(trialdata,1,[]);
                
                instanceMatrix(numInstant,:) = trialdata;
                labelVector(numInstant) = iClass;
            end
        end
        
    end
end


