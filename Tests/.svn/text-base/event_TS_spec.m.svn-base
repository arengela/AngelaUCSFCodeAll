%get analog events

cd(Analog)
label_file='transcript_AN4.lab'; 
[ev1 ev2 s] = textread(label_file,'%f%f%s');

%stopIdx=strmatch('stop',s);
ev1=ev1(2:end);
ev2=ev2(2:end);
s=s(1:end-1);

%s=s(tmpi);

%FIX THIS!
%condition_labels=setdiff(s,{'baseline','stop'});% unique stim labels in alphabetical order


ev1=ev1(2:end);
    ev1(end+1)=ev2(end);
    E_times=ev1/(1000*10000);

event=E_times*400

%%
data=handles.ecogDS.data;
c=161;

figure
subplot(2,1,1)
specgram(data(c,:),[],400,50);
hold on
plot(E_times,100,'r*')
subplot(2,1,2)
plot(data(c,:))
hold on
plot(event,1,'r*')
