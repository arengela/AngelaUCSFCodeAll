ecogreal=loadHTKtoEcog_CT([ pwd '\HilbReal_4to200_40band'],256,[])
ecogimag=loadHTKtoEcog_CT([ pwd '\HilbImag_4to200_40band'],256,[])
ecogcomplex.data=complex(ecogreal.data,ecogimag.data);

%%
ecogreal=loadHTKtoEcog_CT([ pwd '\HilbReal_4to500_45band_1200Hz'],256,[])
ecogimag=loadHTKtoEcog_CT([ pwd '\HilbImag_4to500_45band_1200Hz'],256,[])
ecogcomplex.data=complex(ecogreal.data,ecogimag.data);
%%
filename='E:\PreprocessedFiles\EC8\EC8_B38'
for chanNum=1:256
    cd([ filename '\HilbReal_4to500_45band_1200Hz'])
    r=loadHTKtoEcog_onechan(chanNum,[1 30000])';
    
    cd([ filename '\HilbImag_4to500_45band_1200Hz'])
    i=loadHTKtoEcog_onechan(chanNum,[1 30000])';
    
    ecogcomplex.data(chanNum,:,:)=complex(r,i);  
    %env.data(chanNum,:,:)=abs(complex(r,i));
end

%%
env.data=abs(ecogcomplex.data);