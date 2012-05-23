function glove=ecogGloveReadGloveLog(fName)
% glove=ecogGloveReadGloveLog(fName) read a glove ;

% PURPOSE:
%
% INPUT:
% fName:    A filename including the path
%
% OUTPUT:   
% glove:    A data structure with fields:
%           glove.timebase=zeros(count,1);
%           gesture (nx1)
%           fingers (nx5) thumb index ...
%           pitch   (nx1)
%           roll    (nx1)
%           acceleratorsXYZ (nx3)

% 090701 JR wrote it

if ~exist('fName','var') || isempty(fName)
    error('Provide a filename!')
end

fH=fopen(fName);
if fH==-1
    error('Could not open file!')
end
%read throuhj the whole file
l=fgetl(fH);
if ~ischar(l); 
    error('Could not read first line!')
end;
% determine the number of datapoints
count=0;
while 1
    l=fgetl(fH);
    if ~ischar(l); 
        break; 
    end;
    count=count+1;
end
frewind(fH);
l=fgetl(fH);
%allocate memory
glove.timebase=zeros(count,1);
glove.gesture=zeros(count,1);
glove.fingers=zeros(count,5);
glove.pitch=zeros(count,1);
glove.roll=zeros(count,1);
glove.acceleratorsXYZ=zeros(count,3);
count=1;
while 1
    l=fgetl(fH);
    if ~ischar(l); 
        break; 
    end;
    % data order should be
    % date	nanoseconds	gesture	f[0]	f[1]	f[2]	f[3]	f[4]
    % pitch	roll	ax	ay	az
    [d,lR]=strtok(l);    %date
    [d,lR]=strtok(lR);    %time string
    [d,lR]=strtok(lR);    %time nanoseconds
    glove.timebase(count)=str2num(d)/1000000;
    [d,lR]=strtok(lR);    %gesture
    glove.gesture(count)=str2num(d);
    [d,lR]=strtok(lR);    %fingers
    glove.fingers(count,1)=str2num(d);
    [d,lR]=strtok(lR);
    glove.fingers(count,2)=str2num(d);
    [d,lR]=strtok(lR);
    glove.fingers(count,3)=str2num(d);
    [d,lR]=strtok(lR);
    glove.fingers(count,4)=str2num(d);
    [d,lR]=strtok(lR);
    glove.fingers(count,5)=str2num(d);
    [d,lR]=strtok(lR);    %pitch
    glove.pitch(count)=str2num(d);
    [d,lR]=strtok(lR);    %roll
    glove.roll(count)=str2num(d);
    [d,lR]=strtok(lR);    %accelerators
    glove.acceleratorsXYZ(count,1)=str2num(d);
    [d,lR]=strtok(lR);    
    glove.acceleratorsXYZ(count,2)=str2num(d);
    [d,lR]=strtok(lR);    
    glove.acceleratorsXYZ(count,3)=str2num(d);
    count=count+1;
end
    
    
    
    
    
    
    