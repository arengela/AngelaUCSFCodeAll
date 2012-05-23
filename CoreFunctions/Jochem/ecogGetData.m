% Codes have a 4 times higher sampling rate
% 1:6 movement direction
% 7 run start
% 9 arrived at target location 
main_path = '/data1/rieger/DATA/Berkeley/Ecog/Lavi/BMI'; % 'D:\Data\Berkeley\Ecog\Lavi\BMI\';

%movements initiations
theDirs={'B1'};%,'B2','B33','B34'};
eventsResampled = [];
srate = [];
Dec_CAReeg = [];
bad_chan = [];
x=[];
y=[];
for k=1:length(theDirs)
    tmp = load([main_path filesep theDirs{k} filesep 'analyzed data' filesep 'events.mat']);
    %resample the event vector
    eventCodes=unique(tmp.ANevent);
    eventCodes(eventCodes==0)=[]; % delete event Code 0 which is not informative
    eventsResampled_tmp=zeros(length(tmp.ANevent)/4,1);
    for eC=eventCodes
        idx=find(tmp.ANevent==eC);
        idx=ceil(idx/4); % That's the resampled indices
        eventsResampled_tmp(idx)=eC;
    end
    eventsResampled = [ eventsResampled ; eventsResampled_tmp];
    
    tmp = load([main_path filesep theDirs{k} filesep 'analyzed data' filesep 'Dgdat_afterCAR.mat']);
    Dec_CAReeg = [Dec_CAReeg, tmp.Dec_CAReeg];
    bad_chan = unique([bad_chan tmp.bad_chan]);
    srate = tmp.srate;
    
    %load([main_path filesep theDirs{k} filesep 'analyzed data' filesep 'ERSPmat_obtained.mat']);
    %load([main_path filesep theDirs{k} filesep 'analyzed data' filesep 'movement.mat']);
    
    tmp = load([main_path filesep theDirs{k} filesep 'analyzed data' filesep 'movementXY.mat']);
    x = [x, tmp.x];
    y = [y, tmp.y];
end
sampDurMs=1000/srate;
% clear tmp eC eventCodes eventsResampled_tmp idx k main_path theDirs 

% events
%   ANevent       1x2127076             8508304  single array
%   srate         1x1                         8  double array
%   
% Dgdat_afterCAR
%   DCAR             1x531769              2127076  single array
%   Dec_CAReeg      64x531769            272265728  double array
%   bad_chan         1x1                         8  double array
%   log              1x191                     382  char array
%   ref_elec         1x1                         8  double array
%   srate            1x1                         8  double array
%   
% ERSPmat_obtained
%   ERSPmat         64x42x1680                   36126720  double array
%   after            1x1                                8  double array
%   before           1x1                                8  double array
%   dec_factor       1x1                                8  double array
%   freqs_high       1x42                             336  double array
%   freqs_low        1x42                             336  double array
%   newsrate         1x1                                8  double array
%   prc_rej          1x1                                8  double array
% 
% movement
%   dec_factor       1x1                         8  double array
%   theta_e     531769x1                   2127076  single array
%   theta_s     531769x1                   2127076  single array
%   
% movementXY  
%   x         1x531769              4254152  double array
%   y         1x531769              4254152  double array