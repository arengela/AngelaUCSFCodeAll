function [allEventTimes,allConditions]=readLabFile(label_file)

E_times=[];
[ev1 ev2 s] = textread(label_file,'%f%f%s');
ev1=ev1(2:end);
ev1(end+1)=ev2(end);
E_times=vertcat(E_times, ev1/(1000*10000));
allEventTimes=horzcat(num2cell(E_times),s);
allConditions=unique(s);


