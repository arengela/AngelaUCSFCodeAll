function makeCombinedEventFiles(files,newLabels)
%{
Combine stimulus HTK log files from different channels to one HTK file.

Input: files=cell array of HTK stimulus file names
       newLabels=input [] to keep old labels, or input string to convert all labels
Example:
    files={'stimlus_log2_AN2.lab','stimlus_log_AN3.lab','stimlus_log_AN4.lab'}
    newLabels={[],'babutton','dabutton'}
    makeCombinedEventFiles(files,newLabels)
Output: Saves HTK file and matlab variable with all unique stimuli
%}


E_times=[];
str=[]
allConditions=[];

if nargin==1
    newLabels=cell(1,length(files));
end
    
for i=1:length(files)
    
    label_file=files{i}; 
    [ev1 ev2 s] = textread(label_file,'%f%f%s');
    
    if ~isempty(newLabels{i})
        s=repmat({newLabels{i}},size(s));
    end
    str=vertcat(str,s);
    ev1=ev1(2:end);
    ev1(end+1)=ev2(end);
    E_times=vertcat(E_times, ev1/(1000*10000));
    allConditions=vertcat(allConditions,unique(s));
end
        
[E_times_sorted,idx]=sort(E_times);
str_sorted=str(idx);    
 
BadTimesConverterGUI3(E_times_sorted,str_sorted,'transcript_all.lab')
allEventTimes=[num2cell(E_times_sorted) str_sorted];
save('allEventTimes','allEventTimes');
save('allConditions','allConditions');


