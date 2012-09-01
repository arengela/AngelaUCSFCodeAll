function npar_main(method,data,data2,testmedian)
% npar_main is the main program for Erik's Matlab nonparametric statistical toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Nonparametric Statistical Tests in Matlab
%
% Author:
%   Erik B. Erhardt                                             erike@wpi.edu
%   Statistics Graduate Student and Teaching Assistant
%   Dept. of Mathematical Sciences                             (508) 831-5546
%   Worcester Polytechnic Institute                                    SH 204
%   100 Institute Rd.
%   Worcester, MA  01609-2280
%
% Date: 2/6/2003 1:30PM
%
% Program: npar_main.m
% Includes:
%   Main
% Calls:
%   npar_pitman.m       Pitman
%   npar_pitmanmc.m     Pitman Monte Carlo
%   npar_vdwaerden.m    Van Der Waerden normal scores test
%   npar_wilcoxsr.m     Wilcoxon signed-rank (convert to ranks only)
%   npar_wilcoxsr_ci.m  Wilcoxon signed-rank Confidence Intervals
%   npar_sign.m         Sign and Sign Confidence Intervals
%   npar_runsrandom.m   Runs test for randomness
%
%
% Called by:
%   command line
%
% Use:
%     npar_main(method,data,testmedian)
%        method =
%           pitman       Pitman test
%           pitmanmc     Pitman Monte Carlo test (using Pitman_MC Matlab function)
%           vdwaerden    Van Der Waerden normal scores test
%           wilcoxsr     Wilcoxon signed-rank test
%           sign         Sign test
%           runsrandom   Runs test for randomness
%
%        data =
%           vector of data
%        data2 =
%           second vector of data for two-sample tests
%           if not being used, assign data2=0
%        testmedian =
%           median you want to test
%
%  Enjoy the EXACT results.
%
% Note: A convienient way to run this is to create a file
%               npar_data.m
%       to define your data, testmedian and method and run that file.
%
%
% Maintenance:
%
% npar_wilcoxsr_ci.m:
%   this statement corrects the subscripts, but the CIs are not exact when ties occur.
%   walshind=fix(walshind);   % in case of tie this will not be integer
%
% npar_pitmanind.m:
%   not sure if cont correction is appropriate in using normal approximation
%
% npar_wmwrsum.m:
%   no normal approximation yet.
%   Un stat seems to match StatXact value in S&S book, Um does not.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Known limitations of Matlab:
%  There is a memory limit of k=21 when we store all the S+ values (2^k).
[comptype,nmax] = computer; %nmax is the maximum number of elements allowed in an array

%%% Output file (appended to)
diary('npar_out.txt');
currenttime=clock;
fprintf('Time Started:  %i-%i-%i %i:%i:%3.1f\n',currenttime(1),currenttime(2),currenttime(3),currenttime(4),currenttime(5),currenttime(6));

format compact;

% begin timer
tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Switch section BEGIN
% NOTE: If wilcoxsrtest=1, the pitman test will NOT be performed on the original data

% Switch Initialization BEGIN
   pitmantest=0;
   pitmantestprint=0;

   pitmanmctest=0;
   pitmanmctestprint=0;

   wilcoxsrtest=0;
   wilcoxsrtestprint=0;

   vdwaerdentest=0;
   vdwaerdentestprint=0;

   signtest=0;
   signtestprint=0;

   runsrandomtest=0;
   runsrandomtestprint=0;

% two-sample
   pitmanindtest=0;
   pitmanindtestprint=0;

   wilcoxrsumtest=0;
   wilcoxrsumtestprint=0;

   wmwrsumtest=0;
   wmwrsumtestprint=0;

   kendallranktest=0;
   kendallranktestprint=0;

   normalciprint=0;
   histogramsw=0;
   pairedsamplesw=0;
   independentsw=0;
% Switch Initialization END

if strcmp('pitman',method)==1;      % Pitman test switch (1=on)
   pitmantest=1;
   pitmantestprint=1;
end;

if strcmp('pitmanmc',method)==1;    % Pitman Monte Carlo test switch (1=on)
   pitmanmctest=1;
   pitmanmctestprint=1;
end;

if strcmp('wilcoxsr',method)==1;    % Wilcoxon signed-rank test switch (1=on)
   wilcoxsrtest=1;
   wilcoxsrtestprint=1;
end;

if strcmp('vdwaerden',method)==1;   % Van Der Waerden normal scores test switch (1=on)
   vdwaerdentest=1;
   wilcoxsrtest=1;
   vdwaerdentestprint=1;
end;

if strcmp('sign',method)==1;        % Sign test switch (1=on)
   signtest=1;
   signtestprint=1;
end;

if strcmp('runsrandom',method)==1;  % Runs test for randomness switch (1=on)
   runsrandomtest=1;
   runsrandomtestprint=1;
end;

if strcmp('pitmanind',method)==1;    % Wilcoxon rank-sum test switch (1=on)
   pitmanindtest=1;
   pitmanindtestprint=1;
   independentsw=1;
end;

if strcmp('wilcoxrsum',method)==1;    % Wilcoxon rank-sum test switch (1=on)
   wilcoxrsumtest=1;
   wilcoxrsumtestprint=1;
   independentsw=1;
end;

if strcmp('wmwrsum',method)==1;    %  rank-sum test switch (1=on)
   wmwrsumtest=1;
   wmwrsumtestprint=1;
   independentsw=1;
end;

if strcmp('kendallrank',method)==1;  % Kendall Rank Correlation Coefficient (1=on)
   kendallranktest=1;
   kendallranktestprint=1;
   independentsw=1;
end;

%%% Switch section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data section BEGIN

%%% vector data
[numrowdata,numcoldata]=size(data);  % make column vectors
if numcoldata>numrowdata;
 data=data';
 [numrowdata,numcoldata]=size(data);
end;

%%% vector data2
[numrowdata2,numcoldata2]=size(data2);  % make column vectors
if numcoldata2>numrowdata2;
 data2=data2';
 [numrowdata2,numcoldata2]=size(data2);
end;

if min(numrowdata,numcoldata) > 1 | min(numrowdata2,numcoldata2) > 1;
 data
 error('Data must be vector data (not matrix data).');
end;
if max(numrowdata,numcoldata) == 1;
 data
 error('Data must be vector data (one value is meaningless).');
end;

if numrowdata2 == 1;
 singlesamplesw=1;            % single sample statistics only
else;
 singlesamplesw=0;
end;

if independentsw == 0;
 if numrowdata2 == numrowdata;
  pairedsamplesw=1;           % paired sample statistics available
 else;
  pairedsamplesw=0;
  if numrowdata2 ~= 1;
   error('Paired tests require the data vectors to have the same number of elements.');
  end;
 end;
end;

dataorg=data;                       % Retain original values of data
data2org=data2;                     % Retain original values of data
runsrandomdataorg=data;             % Retain original values of data

if independentsw==0;
 if pairedsamplesw==1;               % two sample case
  data=data2-data;                   % Compute difference
  datadiff=data-testmedian;
 end;
 data=data-testmedian;               % Compute difference
end;

k=length(data);                     % k = number of var
k2=length(data2);                   % k2 = number of var

%%% Runs Random BEGIN
if runsrandomtest==1;               %%% this must be done before sorting occurs
 [runsrandompval,runsrandompval1,runsrandompval2,runsrandomnormalpval,numruns]=npar_runsrandom(data,k);
end;
%%% Runs Random END

data=sort(data);                     % Sort data
data2=sort(data2);                   % Sort data

%%% Data section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Histogram section BEGIN
if histogramsw==1;
 figure;
 hist(dataorg);
 title('Histogram of vector dataorg');
 %print fig1
 %print -depsc fig1
 if pairedsamplesw==1;
  figure;
  hist(data2org);
  title('Histogram of vector data2org');
  figure;
  hist(data);
  title('Histogram of vector data');
 end;
end;
%%% Histogram section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print the results section BEGIN
fprintf('================================================================================\n');
fprintf('Nonparametric Statistics Toolbox for Matlab by Erik Erhardt\n\n');
fprintf('Note:  All p-values are one-tailed (unless stated otherwise).\n')
fprintf('       Multiply by 2 for two-tailed test p-value.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Wilcox signed-rank
if wilcoxsrtest==1;
 [data,k]=npar_wilcoxsr(data,k);
 pitmantest=1;  % turn on pitman test switch now that the data have been converted to ranks
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Van Der Waerden normal scores
if vdwaerdentest==1;
 [data,k]=npar_vdwaerden(data,k);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Sign
if signtest==1;
 [datasign,signs,signpval,signnormalpval]=npar_sign(data,k,dataorg);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pitman
if pitmantest==1;
 printn=2^k;
 nmaxcompare=k*2^k;
 if nmaxcompare>nmax;                % if k too large for exact results, normal approximation only
  exact=0;
 else;
  exact=1;
  fprintf('\nNote:  2^%i=%i combinations will be performed, patience may be needed.',k,printn);
 end;
 [spit,statm,sminus,pval1,statp,splus,pval2,n,pitmannormalpval]=npar_pitman(data,k,exact);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pitman Monte Carlo
if pitmanmctest==1;
 [mcpval,mcsplus]=npar_pitmanmc(data,k);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Wilcox rank-sum (independent samples)
if wilcoxrsumtest==1;
 [data,data2,k,k2]=npar_wilcoxrsum(data,data2,k,k2);
 pitmanindtest=1;  % turn on pitmanind test switch now that the data have been converted to ranks
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pitman (independent samples)
if pitmanindtest==1;
 printn=nchoosek(k+k2,k);
 nmaxcompare=k*nchoosek(k+k2,k);
 if nmaxcompare>nmax;                % if k too large for exact results, normal approximation only
  exact=0;
 else;
  exact=1;
  fprintf('\nNote:  %i choose %i=%i combinations will be performed, patience may be needed.',k+k2,k,printn);
  [pitind,meansmall,datasmallsum,u1,pval1,datalargesum,u2,pval2,pitmanindnormalpval]=npar_pitmanind(data,data2,k,k2,exact);
 end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Wilcoxon-Mann-Whitney rank-sum (independent samples)
if wmwrsumtest==1;
 printn=nchoosek(k+k2,k);
 nmaxcompare=k*nchoosek(k+k2,k);
 if nmaxcompare>nmax;                % if k too large for exact results, normal approximation only
  exact=0;
  [unstat,umstat,u1,pval1,u2,pval2,wmwnormalpval]=npar_wmwrsum(data,data2,k,k2,exact);
 else;
  exact=1;
  fprintf('\nNote:  %i choose %i=%i combinations will be performed, patience may be needed.',k+k2,k,printn);
  [unstat,umstat,u1,pval1,u2,pval2,wmwnormalpval]=npar_wmwrsum(data,data2,k,k2,exact);
 end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Kendall Rank Correlation Coefficient (dependent samples)
if kendallranktest==1;
 data=dataorg;                       % Use unsorted original values of data
 data2=data2org;                     % Use unsorted original values of data
 printn=factorial(k);
 nmaxcompare=factorial(k);
 if nmaxcompare>nmax;                % if k too large for exact results, normal approximation only
  exact=0;
  [tkstat,pval2,pval1,tknormalpval]=npar_kendallrank(data,data2,k,k2,exact);
 else;
  exact=1;
  fprintf('\nNote:  %i!=%i permutations will be performed, patience may be needed.',k,printn);
  [tkstat,pval2,pval1,tknormalpval]=npar_kendallrank(data,data2,k,k2,exact);
 end;
end;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if pitmantestprint==1;
 fprintf('\n================================================================================\n');
 fprintf('Pitman Test Results: \n');
 if pairedsamplesw==1;
  printdatadiff=datadiff';
  printdatadiff
 else;
  printdataorg=dataorg';
  printdataorg
 end;
 printdata=data';
 printdata
 if exact==0;
  fprintf('n=%i gives %i comparisions with array size %i which is > %i is max elements in array. \n',k,printn,nmaxcompare,nmax);
  fprintf('Exact results not available, Normal approximation only. \n\n');
 else;
  fprintf('Median %5.2f \n\n',testmedian);
  fprintf('n=%i \n\n',k);
  fprintf('Order stat: %i ,  S-: %i ,  p-value: %10.9f \n',statm,sminus,pval1);
  fprintf('Order stat: %i ,  S+: %i ,  p-value: %10.9f \n',statp,splus ,pval2);
 end;
 fprintf('Normal approximation with continuity correction  p-value: %10.9f \n',pitmannormalpval);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if pitmanmctestprint==1;
 fprintf('\n================================================================================\n');
 fprintf('Pitman Monte Carlo Test Results: \n');
 if pairedsamplesw==1;
  printdatadiff=datadiff';
  printdatadiff
 else;
  printdataorg=dataorg';
  printdataorg
 end;
 %printdata=data';
 %printdata
 fprintf('Median %5.2f \n\n',testmedian);
 fprintf('n=%i \n\n',k);
 fprintf('Right-tail p-value: %10.9f \n',mcpval);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if wilcoxsrtestprint==1;
 fprintf('\n================================================================================\n');
 fprintf('Wilcoxon Signed-Rank Test Results: \n');
 if pairedsamplesw==1;
  printdatadiff=datadiff';
  printdatadiff
 else;
  printdataorg=dataorg';
  printdataorg
 end;
 printdata=data';
 printdata
 fprintf('Median %5.2f \n\n',testmedian);
 fprintf('n=%i \n\n',k);
 fprintf('Order stat: %i ,  S-: %i ,  p-value: %10.9f \n',statm,sminus,pval1);
 fprintf('Order stat: %i ,  S+: %i ,  p-value: %10.9f \n',statp,splus ,pval2);
 fprintf('Normal approximation with continuity correction  p-value: %10.9f \n',pitmannormalpval);

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%% Wilcoxon Confidence Intervals based on Walsh Averages
 fprintf('\n========================================\n');
 fprintf('Wilcoxon Signed-Rank Confidence Intervals using Walsh averages: \n');
 if pairedsamplesw==1;
  dataorg=datadiff;
 end;
 npar_wilcoxsr_ci(dataorg,k,n,spit)
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if vdwaerdentestprint==1;
 fprintf('\n================================================================================\n');
 fprintf('Van Der Waerden normal scores Test Results: \n');
 if pairedsamplesw==1;
  printdatadiff=datadiff';
  printdatadiff
 else;
  printdataorg=dataorg';
  printdataorg
 end;
 printdata=data';
 printdata
 fprintf('Median %5.2f \n\n',testmedian);
 fprintf('n=%i \n\n',k);
 fprintf('Order stat: %i ,  S-: %i ,  p-value: %10.9f \n',statm,sminus,pval1);
 fprintf('Order stat: %i ,  S+: %i ,  p-value: %10.9f \n',statp,splus ,pval2);
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if signtestprint==1;
 fprintf('\n================================================================================\n');
 fprintf('Sign Test Results: \n');
 if pairedsamplesw==1;
  printdatadiff=datadiff';
  printdatadiff
 else;
  printdataorg=dataorg';
  printdataorg
 end;
 printsign=datasign(:,2)';
 printsign
 fprintf('Median %5.2f \n\n',testmedian);
 fprintf('n=%i \n\n',k);
 fprintf('Number of signs: %i ,  p-value: %10.9f \n',signs,signpval);
 fprintf('Normal approximation with continuity correction  p-value: %10.9f \n',signnormalpval);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%% Sign Confidence Intervals
 fprintf('\n========================================\n');
 fprintf('Sign Confidence Intervals: \n');
 if pairedsamplesw==1;               % two sample case
  dataorg=datadiff;
 end;
 npar_sign_ci(data,k,dataorg);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if runsrandomtestprint==1;
 fprintf('\n================================================================================\n');
 fprintf('Runs Test for Randomness Results: \n');
 printdataorg=runsrandomdataorg';
 printnumruns=numruns;
 printdataorg
 printnumruns
 fprintf('%i runs in %i dichotomous data p-value: %10.9f \n',numruns,k,runsrandompval);
 fprintf('Left-tail  p-value: %10.9f \n',runsrandompval1);
 fprintf('Right-tail p-value: %10.9f \n',runsrandompval2);
 fprintf('Using Normal approximation with continuity correction.\n');
 fprintf('n=%i ,  runs=%i ,  p-value: %10.9f \n',k,numruns,runsrandomnormalpval);
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if pitmanindtestprint==1;
 fprintf('\n================================================================================\n');
 fprintf('Pitman Test (Independent Samples) Results: \n');
 printdataorg=dataorg';
 printdata2org=data2org';
 printdataorg
 printdata2org
 if exact==0;
  fprintf('n=%i gives %i comparisions with array size %i which is > %i is max elements in array. \n',k,printn,nmaxcompare,nmax);
  fprintf('No results are available. \n\n');
 else;
  fprintf('Mean of %i values chosen %i at a time: %5.2f \n\n',k+k2,k,meansmall);
  fprintf('Sum of smaller data set: %5.2f , larger data set: %5.2f \n\n',datasmallsum,datalargesum);
  fprintf(' Left tail has %i at least as extreme, p-value: %10.9f \n',u1,pval1);
  fprintf('Right tail has %i at least as extreme, p-value: %10.9f \n',u2,pval2);
  fprintf('Norm cont corr may not be appropriate -- need to check\n');
  fprintf('Normal approximation with continuity correction  p-value: %10.9f \n',pitmanindnormalpval);
 end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if wilcoxrsumtestprint==1;
 fprintf('\n================================================================================\n');
 fprintf('Wilcoxon Rank-Sum Test (Independent Samples) Results: \n');
 printdataorg=dataorg';
 printdata2org=data2org';
 printdataorg
 printdata2org
 fprintf('Mean of %i values chosen %i at a time: %5.2f \n\n',k+k2,k,meansmall);
 fprintf('Sum of smaller data set: %5.2f , larger data set: %5.2f \n\n',datasmallsum,datalargesum);
 fprintf(' Left tail has %i at least as extreme, p-value: %10.9f \n',u1,pval1);
 fprintf('Right tail has %i at least as extreme, p-value: %10.9f \n',u2,pval2);
 fprintf('Norm cont corr may not be appropriate -- need to check\n');
 fprintf('Normal approximation with continuity correction  p-value: %10.9f \n',pitmanindnormalpval);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Wilcoxon Confidence Intervals based on Walsh Averages
% fprintf('\n========================================\n');
% fprintf('Wilcoxon Signed-Rank Confidence Intervals using Walsh averages: \n');
% if pairedsamplesw==1;
%  dataorg=datadiff;
% end;
% npar_wilcoxsr_ci(dataorg,k,n,pitind);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if wmwrsumtestprint==1;
 fprintf('\n================================================================================\n');
 fprintf('Wilcoxon-Mann-Whitney Rank-Sum Test (Independent Samples) Results: \n');
 printdataorg=dataorg';
 printdata2org=data2org';
 printdataorg
 printdata2org
 if exact==0;
  fprintf('n=%i gives %i comparisions with array size %i which is > %i is max elements in array. \n',k+k2,printn,nmaxcompare,nmax);
  fprintf('Normal approximation available. \n\n');
  fprintf('Normal approximation with continuity correction  p-value: %10.9f \n',wmwnormalpval);
 else;
  fprintf('Um stat: %5.2f , has %i at least as extreme, p-value: %10.9f \n',umstat,u1,pval1);
  fprintf('Un stat: %5.2f , has %i at least as extreme, p-value: %10.9f \n',unstat,u2,pval2);
  fprintf('Un stat seems to match StatXact value in S&S book, Um does not.\n');
  %fprintf('Un stat: %5.2f , Um stat: %5.2f \n\n',unstat,umstat);
  %fprintf(' Left tail has %i at least as extreme, p-value: %10.9f \n',u1,pval1);
  %fprintf('Right tail has %i at least as extreme, p-value: %10.9f \n',u2,pval2);
  %fprintf('Norm cont corr may not be appropriate -- need to check\n');
  fprintf('Normal approximation with continuity correction  p-value: %10.9f \n',wmwnormalpval);
 end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if kendallranktest==1;
 fprintf('\n================================================================================\n');
 fprintf('Kendall Rank Correlation Coefficient Test Results: \n');
 printdataorg=dataorg';
 printdata2org=data2org';
 printdataorg
 printdata2org
 if exact==0;
  fprintf('n=%i gives %i comparisions with array size %i which is > %i is max elements in array. \n',k,printn,nmaxcompare,nmax);
  fprintf('Exact results not available, Normal approximation only. \n\n');
 else;
  fprintf('t_k: %10.9f  \n',tkstat);
  fprintf(' Left tail (positive correlation) p-value: %10.9f \n',pval1);
  fprintf('Right tail (negative correlation) p-value: %10.9f \n',pval2);
 end;
 %fprintf('Normal approximation with continuity correction  p-value: %10.9f \n',pitmannormalpval);
end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if normalciprint==1;
 %%% Normal Confidence Intervals
 fprintf('\n========================================\n');
 fprintf('Normal Confidence Intervals (inappropriate for nonnormal data): \n');
 normalmean=mean(dataorg);
 normalstd=std(dataorg)/sqrt(k);
 for i=1:10;
   siglevel=(i/100);
   normerror=norminv(1-siglevel/2,0,1);
   normalcil = normalmean-normalstd*normerror;
   normalciu = normalmean+normalstd*normerror;
   fprintf('%6.5f Confidence Limit on the Mean %6.5f: (%6.5f,%6.5f) \n',1-siglevel,normalmean,normalcil,normalciu);
 end;
 %%% Normal Confidence Intervals (t-distribution)
 fprintf('\n========================================\n');
 fprintf('t-distribution Confidence Intervals (inappropriate for nonnormal data): \n');
 for i=1:10;
   siglevel=(i/100);
   normerror=tinv(1-siglevel/2,k-1);
   normalcil = normalmean-normalstd*normerror;
   normalciu = normalmean+normalstd*normerror;
   fprintf('%6.5f Confidence Limit on the Mean %6.5f: (%6.5f,%6.5f) \n',1-siglevel,normalmean,normalcil,normalciu);
 end;
end;

fprintf('================================================================================\n');


% Print the results section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% end timer
timeelapsed=toc;
fprintf('Time elapsed:  %8.2f seconds.\n',timeelapsed);
diary('off');
fprintf('Results appended to file:  npar_out.txt\n');

% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%