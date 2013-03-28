blocks=9:20;
rootpath='/data_store/human/prcsd_data/EC33'
for b=blocks
    try
        filename=[rootpath '/EC33_B' int2str(b) '/HilbAA_70to150_8band'];
        data=loadHTKtoEcog_CT(filename,256,[]);
        holdch=data.data(193:256,:,:);
        data.data(193:256,:,:)=data.data(129:192,:,:);
        data.data(129:192,:,:)=holdch;
        saveEcogToHTK(filename,data)
    end
end