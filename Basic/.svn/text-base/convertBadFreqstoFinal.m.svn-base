load('badFreqs')
badFreqs=badFreqs82;

tmp=find(badFreqs(:,[1:2])>113 & badFreqs(:,[1:2])<116);
badFreqs(tmp)=114;


tmp=find(badFreqs(:,[1:2])>116.5 & badFreqs(:,[1:2])<119);
badFreqs(tmp)=118;

tmp=find(badFreqs(:,[1:2])>137 & badFreqs(:,[1:2])<140);
badFreqs(tmp)=138;

tmp=find(badFreqs(:,[1:2])>141 & badFreqs(:,[1:2])<143);
badFreqs(tmp)=142;

tmp=find(badFreqs(:,[1:2])>87 & badFreqs(:,[1:2])<90);
badFreqs(tmp)=88;


tmp=find(badFreqs(:,[1:2])>90 & badFreqs(:,[1:2])<92);
badFreqs(tmp)=91;

[i,j]=find(badFreqs(:,[1:2])<70 | badFreqs(:,[1:2])>150);
l=length(i)/2;
badFreqs(i(1:l),:)=[];


