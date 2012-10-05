function epos=getGridPosition(p)
coltot=16;
n=(p(1)-0.03)*100/6+1;
m=-((p(2)-0.01)*100/6.2)+15;

epos=(m)*coltot+n;

