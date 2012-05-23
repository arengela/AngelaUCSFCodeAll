%GP31 CRM
filesall{1}=[path '/GP31_B3']
filesall{2}=[path '/GP31_B15']
filesall{3}=[path '/GP31_B16']
filesall{4}=[path '/GP31_B17']
filesall{5}=[path '/GP31_B18']
filesall{6}=[path '/GP31_B19']
filesall{7}=[path '/GP31_B20']
filesall{8}=[path '/GP31_B23']
filesall{9}=[path '/GP31_B24']
filesall{10}=[path '/GP31_B57']
filesall{11}=[path '/GP31_B58']
filesall{12}=[path '/GP31_B59']
filesall{13}=[path '/GP31_B74']
filesall{14}=[path '/GP31_B77']
dest='L:\PreprocessedFilesCRMGP31'


%EC2 Articulation
path='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC2'
filesall{1}=[path '/EC2_B1']
filesall{2}=[path '/EC2_B8']
filesall{3}=[path '/EC2_B9']
filesall{4}=[path '/EC2_B15']
filesall{5}=[path '/EC2_B76']
filesall{6}=[path '/EC2_B89']
filesall{7}=[path '/EC2_B105']
dest='M:\EC2Articulation';

%GP33 Articulation\
filesall{1}='C:\Users\Angela\Documents\Data_preprocess_temp\GP33_B1'
filesall{2}='C:\Users\Angela\Documents\Data_preprocess_temp\GP33_B5'
filesall{3}='C:\Users\Angela\Documents\Data_preprocess_temp\GP33_B30'

dest='L:\GP33_Articulation_Preprocessed'




%%

filesall{1}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC5\EC5_B28'
filesall{2}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC5\EC5_B27'
filesall{3}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC5\EC5_B25'
filesall{4}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC5\EC5_B22'
filesall{5}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC5\EC5_B20'
filesall{6}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC5\EC5_B19'
filesall{7}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC5\EC5_B18'
filesall{8}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC5\EC5_B28'
filesall{9}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC5\EC5_B7'
filesall{10}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC5\EC5_B6'
filesall{11}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC6\EC6_B10'
filesall{12}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC6\EC6_B11'
filesall{13}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC6\EC6_B26'
filesall{14}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC6\EC6_B28'
filesall{15}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC6\EC6_B40'
dest='K:\Tests'

%%
%GP31 Articulation
filesall{1}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B1'
filesall{2}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B2'
filesall{3}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B4'
filesall{4}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B6'
filesall{5}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B9'
filesall{6}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B21'
filesall{7}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B30'
filesall{8}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B32'
filesall{9}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B63'
filesall{10}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B65'
filesall{11}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B67'
filesall{12}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B71'
filesall{13}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B78'
filesall{14}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B82'
filesall{15}='C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\GP31\GP31_B83'

dest='M:\GP31Articulation'

%%
for i=14:15
    [a,b]=fileparts(filesall{i})
    cd(filesall{i})
    newpathname=sprintf('%s/%s',dest,b)
    mkdir(newpathname)
    mkdir([newpathname '/RawHTK'])
    %mkdir([newpathname '/HilbAA_70to150_8band'])
    %mkdir([newpathname '/HilbReal_4to200_40band'])
    %mkdir([newpathname '/HilbImag_4to200_40band'])
    mkdir([newpathname '/Artifacts'])
    mkdir([newpathname '/Analog'])
    
    copyfile('Analog',sprintf('%s/Analog',newpathname))
    copyfile('Artifacts',sprintf('%s/Artifacts',newpathname))    
    copyfile('RawHTK',sprintf('%s/RawHTK',newpathname))
    
    if strmatch('HilbAA_70to150_8band',ls)
        copyfile('HilbAA_70to150_8band',sprintf('%s/HilbAA_70to150_8band',newpathname))
        k{i}=1
    end
    
    copyfile('HilbReal_4to200_40band',sprintf('%s/HilbReal_4to200_40band',newpathname))
    copyfile('HilbImag_4to200_40band',sprintf('%s/HilbImag_4to200_40band',newpathname))
       
end

%%
for i=1:15
    cd(filesall{i})

    