function ecogDS=downsampleEcog(ecog,newFreq,oldFreq)

fprintf('Downsampling Begin\n');

m=newFreq/400;
if exist('oldFreq')
    n=round(oldFreq/3.0518e+03);
else
    n=1;
end

    for i=1:size(ecog.data,1)
        ecogDS.data(i,:)=resample(ecog.data(i,:),m*2^11, n*5^6);
        fprintf('%i\n',i)
    end

fprintf('Downsampling Done\n');