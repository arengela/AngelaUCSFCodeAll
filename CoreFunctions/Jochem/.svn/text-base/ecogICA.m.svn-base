function ecog=ecogICA(ecog)
%ecog=ecogICA(ecog) EXPERIMENTAL !!! compute an ICA on the active channels

%http://www.cis.hut.fi/projects/ica/fastica/
%note that W*A=I where A is mixing the independet signals (icas) so the
%x=AS so that figure; tmp=A*ica; plot(tmp') shows the original data
[ica,A,W]=fastica(ecog.data(ecog.selectedChannels,:,1)*1000);
warning('Only the first trial was processed')