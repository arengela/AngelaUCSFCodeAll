function ecog=applyLineNoiseNotch_60HzHarmonics(ecog,sampFreq)

notchFreq=60;
while notchFreq<sampFreq/2
    fprintf(['Notch Filters: ' int2str(notchFreq) 'Hz.. \n'])
    [b,a]=fir2(1000,[0 notchFreq-1 notchFreq-.5 notchFreq+.5 notchFreq+1 sampFreq/2]/(sampFreq/2),[1 1 0 0 1 1 ]);
	ecog.data=filtfilt(b,a,ecog.data')';
    notchFreq=notchFreq+60;
end
fprintf('\nNotch Filters Applied\n')
