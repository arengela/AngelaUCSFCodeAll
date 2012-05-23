function ecog=ecogRemoveCommonAverageReference(ecog)
% ecog=ecogRemoveCommonAverageReference(ecog) Removes the common average reference
% 
% PURPOSE:  Subtracts from all channels in data the common average reference 
%           (timepoint by timepoint average) calculated from the selected good
%           channels and stores it in refChanTS. Calculations are done
%           seperately for each trial.
%
% INPUT:    
% ecog:     An ecog structure (maybe baseline corrected data?)
% 
% OUTPUT:
% ecog:     An ecog structure with 'refChanTS holding the common average
%           refernce
%

% 090131 JR wrote it


for k=1:size(ecog.data,3)
    ecog.refChanTS(1,:,k)=mean(ecog.data(ecog.selectedChannels,:,k),1);
    ecog.data(:,:,k)=ecog.data(:,:,k)-repmat(ecog.refChanTS(1,:,k),size(ecog.data,1),1);
end