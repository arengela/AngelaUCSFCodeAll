%setup
% 
% 		Description: 
% 		Compiles the C routine (mex file) and tests the
% 		accuracy of the algorithm and the code implementation.
%
% Authors: Charles Cadieu <cadieu@berkeley.edu> and
%          Kilian Koepsell <kilian@berkeley.edu> 
%
% Reference: C. Cadieu and K. Koepsell, A Multivaraite Phase Distribution and its 
%            Estimation, NIPS, 2009 (in submission).

% Copyright (c) 2008 The Regents of the University of California
% All Rights Reserved.

mex -largeArrayDims fill_matrix.c

%%
%Angela's Scripts
cd /data_store/prcsd_data/CV_articulation/EC2/EC2_B1

ecogreal=loadHTKtoEcog([ pwd '\HilbReal_4to200_40band'],256)
ecogimag=loadHTKtoEcog([ pwd '\HilbImag_4to200_40band'],256)
ecogcomplex.data=complex(ecogreal.data,ecogimag.data);

%%
ecogreal=loadHTKtoEcog([ pwd '\HilbReal_4to200_40band'],256,[30000 60000])
ecogimag=loadHTKtoEcog([ pwd '\HilbImag_4to200_40band'],256,[30000 60000])
ecogcomplex.data=complex(ecogreal.data,ecogimag.data);

%%
tic;ecogreal=loadHTKtoEcog([ pwd '\HilbReal_4to200_40band'],256,[30000 60000]);t=toc


p='/data_store/prcsd_data/CV_articulatio/EC2/EC2_B9'
tic; ecogreal=loadHTKtoEcogParallel([ p filesep 'HilbReal_4to200_40band'],256,[30000 60000]); t=toc

ecogimag=loadHTKtoEcog([ pwd filesep 'HilbImag_4to200_40band'])
ecogcomplex.data=complex(ecogreal.data,ecogimag.data);


%%
%%
p='E:\PreprocessedFiles\EC2\EC2_B1'
tic;ecog=loadAmpPhase_saveMeM(p,256,2,[30000 60000]);t2=toc; tic; data_all=ecog.data(:,:,35); K_fit = fit_model(single(abs(data_all))); t3=toc; save(K_fit);


%%
clear ecogreal ecogimag
env.data=abs(ecogcomplex.data);
phase=angle(ecogcomplex.data);
clear ecogcomplex

%%

    a='data=data_all;'
    b='data=data_all(:,[1:(L/2)]);'
    c='data=data_all(:,[(L/2+1):L);'
    d='data=data_all(:,[1:(L/4)]);'
    e='data=data_all(:,[(L/4+1):(L/2)]);  ' 
    f='data=data_all(:,[(L/2+1):L/3]]);'
    g='data=data_all(:,[(L/3+1):L]);'



for f=1:40
    data_all=phase(:,:,i);
    L=size(data_all,2);
    eval(a);     
    tic
    K_fit = fit_model(single(abs(data)));
    t=toc
end




%% load data

load testdata/three_phases_v2 data K_true K_python







%% plot data

plot_phase_dist_nd(data)

%% fit data with single precision

K_fit = fit_model(single(data));

K_error_single = mean(abs(K_true(:)-K_fit(:)));
code_error_single = mean(abs(K_python(:)-K_fit(:)));

%% fit data with double precision

K_fit = fit_model(data);

hval = max(max(abs(K_fit(:))),max(abs(K_true(:))));

%% display results

figure(1)
subplot(131)
imagesc(abs(K_true),[-1 1]*hval)
title({'True coupling';'(K\_true)'})
axis square off
subplot(132)
imagesc(abs(K_fit),[-1 1]*hval)
title({'Estimated coupling';'matlab (K\_fit)'})
axis square off
subplot(133)
imagesc(abs(K_python),[-1 1]*hval)
title({'Estimated coupling';'python (K\_python)'})
axis square off

K_true
K_fit

K_error = mean(abs(K_true(:)-K_fit(:)));
code_error = mean(abs(K_python(:)-K_fit(:)));

fprintf('\n single precision');
fprintf('\n mean-absolute-difference = %6.8f',K_error_single);
fprintf('\n difference from python code = %6.8f\n',code_error_single);
fprintf('\n double precision');
fprintf('\n mean-absolute-difference = %6.8f; expect: 0.01730561',K_error);
fprintf('\n difference from python code = %6.8f; expect: 0.0\n',code_error);
