%%% Write 2D filters to files

dir2write = '/export/grid/sivaram/2DFeats/filtFiles/';
filt_extn = 'strf';


filt_init_name = sprintf('%s%s', dir2write,filt_extn);




ft = 100; % sampling freq along time
ff = 3; % sampling freq along freq
nt =101; % num of samples along time
nf = 19; % num of samples along freq
%WT = [4 8 16    3 6 11]; % filt freq along time
%WF = [0.25 0.5 0.75 1  0.32 0.4 0.6 ];% filt freq along freq

WT = [4 ]; % filt freq along time
WF = [0.2];% filt freq along freq


for ii=1:size(WT,2)
    for jj=1:size(WF,2)

        wt = WT(ii);     
        wf = WF(jj);        disp([wt, wf]);

        strf = STRFfilters(wt, wf, nt, nf+nf-1, ft, ff);

        for shift_nf = nf : -1 : 1

            cent_nf = nf - shift_nf  + 1;

            filt_txt_name_init=filt_init_name;
            filt_txt_name_init = sprintf('%s_%d', filt_txt_name_init,cent_nf); %'_1_4_0.5_1.txt');
            filt_txt_name_init = sprintf('%s_%d_%0.3f', filt_txt_name_init, wt, wf);

            for direction = 1:4
                filt_txt_name = sprintf('%s_%d', filt_txt_name_init, direction);
                filt_name = sprintf('%s%s', filt_txt_name, '.filt');
                filt_txt_name = sprintf('%s%s', filt_txt_name, '.txt');


                fp_txt = fopen(filt_txt_name, 'w');
                fp_filt = fopen(filt_name, 'w');

                fprintf(fp_filt, '%s\n', filt_txt_name);
                for i=0:nf-1
                    for j=1:nt
                        fprintf(fp_txt, '%f ', strf(i+shift_nf, j, direction));
                    end
                    fprintf(fp_txt, '\n');
                end

                fclose(fp_filt);
                fclose(fp_txt);

            end
        end
    end
end