function ecog=ecogDeselectBadChan(ecog)
% ecog=ecogDeselectBad(ecog) removes bad channels from the list of selected
% channels.  

%090106 JR wrote it

%chList=setdiff(ecog.selectedChannels,ecog.badChannels);
ecog.selectedChannels=setdiff(ecog.selectedChannels,ecog.badChannels);
