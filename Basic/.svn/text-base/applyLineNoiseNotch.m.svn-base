function ecog=applyLineNoiseNotch(ecog)

fprintf('Notch Filters: 60 Hz..')
[b,a]=fir2(1000,[0 59 59.5 60.5 61 200]/200,[1 1 0 0 1 1 ]);
%freqz(b,a,[],400)
ecog.data=filtfilt(b,a,ecog.data')';

fprintf('120 Hz..')
[b,a]=fir2(1000,[0 119 119.5 120.5 121 200]/200,[1 1 0 0 1 1 ]);
%freqz(b,a,[],400)
ecog.data=filtfilt(b,a,ecog.data')';

fprintf('180 Hz..')
[b,a]=fir2(1000,[0 179 179.5 180.5 181 200]/200,[1 1 0 0 1 1 ]);
%freqz(b,a,[],400)
ecog.data=filtfilt(b,a,ecog.data')';

ecog.sampFreq=ecog.sampFreq;

fprintf('\nNotch Filters Applied\n')
