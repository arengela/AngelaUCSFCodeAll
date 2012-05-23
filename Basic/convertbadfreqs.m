oldVar=badFreqs82;

newVar=[];
for i=1:size(oldVar,1)
    if oldVar(i,1)==1
        rows=find(oldVar(:,3)==oldVar(lastgood,3));
        newVar=[newVar; oldVar(rows,1:2) repmat(oldVar(i,3),length(rows),1)];
    else
        a=oldVar(i,3);
        newVar=[newVar; oldVar(i,1:2) a];
        lastgood=i;
    end
end



figure
newVar=badFreqs;
for i=1:size(newVar,1)
    plot([newVar(i,1) newVar(i,2)],[newVar(i,3) newVar(i,3)])
    hold on
end
badFreqs82=newVar;


A=sortrows(badFreqs,1);
ch=A(1:7,3)';
ecog=ecogFilterTemporal_GUI(handles.ecogNormalized,[118 114],3,ch);
handles.ecogTmps=ecog;
handles.ecogTmps=ecogFilterTemporal_GUI(handles.ecogTmps,[142 138],3,ch);
badFreqs=A;

handles.ecogTmps=handles.ecogNormalized;
for i=1:size(A,1)
    ch=A(i,3);
    freq=[A(i,2) A(i,1)];
    handles.ecogTmps=ecogFilterTemporal_GUI(handles.ecogTmps,freq,3,ch);
end
handles.ecogNormalized=handles.ecogTmps;