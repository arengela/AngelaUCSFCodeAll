%% initialize
cond={'slide','w','we','beep','r'};
timeseg=[-4:.5:10]*1000;
subj='EC18'
blocks={'EC18_B1','EC18_B2','EC18_rest'}

%% load PAC values for active and passive
%% pac is structure of matrix, chanxtimextrial
%% phaseamp is structure of matrix, chanx timex trialx phase
%% cidx: condition 
%% t: trial
%% tidx: timeseg
%% lf: lowfreq
%% hf: highfreq
%% ch=channel num

for cidx=1    
    for t=1:28
        for tidx=1:25
            for lf=8
                for hf=31
                    for ch=1:256
                        %load pac
                        filename=sprintf('%s\%s\%s\%s\%s\pac%i_t%i_lf%i_hf%i',pathname,subj{1},block,cidx,tidx,t,lf,hf);
                        pac.B1(ch,tidx,t)=readhtk(filename);
                        filename=sprintf('%s\%s\%s\%s\%s\pac%i_t%i_lf%i_hf%i',pathname,subj{2},block,cidx,tidx,t,lf,hf);
                        pac.B2(ch,tidx,t)=readhtk(filename);

                        %load Phase Amp                    
                        filename=sprintf('%s\%s\%s\%s\%s\phaseamp%i_t%i_lf%i_hf%i',pathname,subj{1},block,cidx,tidx,t,lf,hf);
                        phamp.B1(ch,tidx,t,:)=readhtk(filename);
                        filename=sprintf('%s\%s\%s\%s\%s\phaseamp%i_t%i_lf%i_hf%i',pathname,subj{2},block,cidx,tidx,t,lf,hf);
                        phamp.B2(ch,tidx,t,:)=readhtk(filename);

                    end
                end
            end
        end
    end
end



%% load baseline PAC
timeseg=[-4:.5:20]*1000;

for tidx=1:length(timeseg)
    for hf=31
        for lf=8
            for ch=1:256
                filename=sprintf('%s\%s\%s\%s\%s\pac%i_t%i_lf%i_hf%i',pathname,subj{3},block,cidx,tidx,t,lf,hf);                                
                pac.baseline(ch,tidx)=readhtk(filename);
                
                filename=sprintf('%s\%s\%s\%s\%s\phaseamp%i_t%i_lf%i_hf%i',pathname,subj{3},block,cidx,tidx,t,lf,hf);
                phamp.baseline(ch,tidx)=readhtk(filename);
            end
        end
    end
end


%% statistics
%significance from baseline
%significance from eachother
%standard error


%% plot pac values, compare active and passive vs baseline PAC


%%
