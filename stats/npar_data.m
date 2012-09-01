% npar_data is the data file calling npar_main for Erik's nonparametric statistical toolbox
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
% Program: npar_data.m
% Includes:
%   Data and results
% Called by:
%   command line: npar_data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data section BEGIN
%  (include data (and data2 if two-sample) and testmedian to test)

%%% first clear any old data
clear method data data2 testmedian

% EXAMPLES S&S %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example 2.1 in S&S pitman
%data=[73, 82, 87, 68, 106, 60, 97]';
%testmedian=70;
%     Order stat: 7 ,  S-: 12 ,  p-value: 0.054687500
%     Order stat: 123 ,  S+: 95 ,  p-value: 0.960937500
%     Normal approximation with continuity correction  p-value: 0.052917927
% Example 2.2 in S&S pitman
%data=[12,18,24,26,37,40,42,47,49,49,78,108]';
%testmedian=30;
%     Order stat: 166 ,  S-: 40 ,  p-value: 0.040527344
%     Order stat: 3942 ,  S+: 210 ,  p-value: 0.962402344
%     Normal approximation with continuity correction  p-value: 0.047226097
% Example 2.4 in S&S wilcoxsr
%data=[-2,4,8,25,-5,16,3,1,12,17,20,9]';
%testmedian=15;
%     Order stat: 4009 ,  S-: 64 ,  p-value: 0.978759766
%     Order stat: 107 ,  S+: 14 ,  p-value: 0.026123047
%     Normal approximation with continuity correction  p-value: 0.027306772
%     0.95703 Confidence Limit on the Median 9.00000 (index  14): (2.50000,16.00000)
%     0.94727 Confidence Limit on the Median 9.00000 (index  15): (3.00000,14.50000)
% Example 2.5 in S&S
%data=[1,1,5,5,8,8,8]';
%testmedian=3;
% Example 2.6 in S&S wilcoxsr
%data=[12,18,24,26,37,40,42,47,49,49,78,108]';
%testmedian=30;
%     Order stat: 166 ,  S-: 1.650000e+001 ,  p-value: 0.040527344
%     Order stat: 3946 ,  S+: 6.150000e+001 ,  p-value: 0.963378906
%     Normal approximation with continuity correction  p-value: 0.042070267
%     0.95459 Confidence Limit on the Median 41.50000 (index  14): (27.50000,63.00000)
%     0.94531 Confidence Limit on the Median 41.50000 (index  15): (29.00000,62.50000)
% Example 2.7 in S&S wilcoxsr
%data=[-5,-2,1,3,4,8,9,12,16,17,20,25]';
%testmedian=0;
%     Order stat: 19 ,  S-: 7 ,  p-value: 0.004638672
%     Order stat: 4082 ,  S+: 71 ,  p-value: 0.996582031
%     Normal approximation with continuity correction  p-value: 0.006735599
%     0.95703 Confidence Limit on the Median 9.00000 (index  14): (2.50000,16.00000)
%     0.94727 Confidence Limit on the Median 9.00000 (index  15): (3.00000,14.50000)
% Example 2.8 in S&S wilcoxsr
%data=[12,18,24,26,37,40,42,47,49,49,78,108]';
%testmedian=0;
%     Order stat: 1 ,  S-: 0 ,  p-value: 0.000244141
%     Order stat: 4096 ,  S+: 78 ,  p-value: 1.000000000
%     Normal approximation with continuity correction  p-value: 0.001258248
%     0.95605 Confidence Limit on the Median 41.50000 (index  14): (27.50000,63.00000)
%     0.94580 Confidence Limit on the Median 41.50000 (index  15): (29.00000,62.50000)
% Example 2.9a in S&S sign
%data=[5.5,6,6.5,7.6,7.6,7.7,8,8.2,9.1,15.1]';
%testmedian=9;
%     Number of signs: 2 ,  p-value: 0.054687500
%     Normal approximation with continuity correction  p-value: 0.056923149
%     0.97852 Confidence Limit on the Median 7.65000 (index   2): (6.00000,9.10000)
%     0.89062 Confidence Limit on the Median 7.65000 (index   3): (6.50000,8.20000)
% Example 2.9b in S&S sign
%data=[5.6,6.1,6.3,6.3,6.5,6.6,7,7.5,7.9,8,8,8.1,8.1,8.2,8.4,8.5,8.7,9.4,14.3,26]';
%testmedian=9;
%     Number of signs: 3 ,  p-value: 0.001288414
%     Normal approximation with continuity correction  p-value: 0.001825217
%     0.95861 Confidence Limit on the Median 8.00000 (index   6): (6.60000,8.40000)
%     0.88468 Confidence Limit on the Median 8.00000 (index   7): (7.00000,8.20000)
% Example 2.10 in S&S sign
%data=[5.5,6,6.5,7.6,7.6,7.7,8,8.2,9.1,15.1]';
%testmedian=9;
%     Number of signs: 2 ,  p-value: 0.054687500
%     Normal approximation with continuity correction  p-value: 0.056923149
%     0.97852 Confidence Limit on the Median 7.65000 (index   2): (6.00000,9.10000)
%     0.89062 Confidence Limit on the Median 7.65000 (index   3): (6.50000,8.20000)
% Example 2.11 in S&S sign
%data=[12,18,24,26,37,40,42,47,49,49,78,108]';
%testmedian=30;
%     Number of signs: 4 ,  p-value: 0.193847656
%     Normal approximation with continuity correction  p-value: 0.193238115
%     0.96143 Confidence Limit on the Median 41.00000 (index   3): (24.00000,49.00000)
%     0.85400 Confidence Limit on the Median 41.00000 (index   4): (26.00000,49.00000)
% Example 2.12 in S&S vdwaerden
%data=[12,18,24,26,37,40,42,47,49,49,78,108]';
%testmedian=30;
%     Order stat: 254 ,  S-: 9.653200e+000 ,  p-value: 0.062011719
%     Order stat: 3844 ,  S+: 2.634025e+001 ,  p-value: 0.938476563
% Example 2.13a in S&S pitman, wilcoxsr and sign
%data=[5.5,6,6.5,7.6,7.6,7.7,8,8.2,9.1,15.1]';
%testmedian=9;
%    Pitman Test Results:
%     Order stat: 853 ,  S-: 1.490000e+001 ,  p-value: 0.833007813
%     Order stat: 172 ,  S+: 6.200000e+000 ,  p-value: 0.167968750
%     Normal approximation with continuity correction  p-value: 0.182033483
%    Wilcoxon signed-rank Test Results:
%     Order stat: 979 ,  S-: 44 ,  p-value: 0.956054688
%     Order stat: 52 ,  S+: 11 ,  p-value: 0.050781250
%     Normal approximation with continuity correction  p-value: 0.051347006
%     0.95898 Confidence Limit on the Median 7.65000 (index   8): (6.55000,10.80000)
%     0.94531 Confidence Limit on the Median 7.65000 (index   9): (6.60000,10.55000)
%    Sign Test Results:
%     Number of signs: 2 ,  p-value: 0.054687500
%     Normal approximation with continuity correction  p-value: 0.056923149
%     0.95861 Confidence Limit on the Median 8.00000 (index   6): (6.60000,8.40000)
%     0.88468 Confidence Limit on the Median 8.00000 (index   7): (7.00000,8.20000)
% Example 2.13b (and 2.14 for CIs) in S&S pitman, wilcoxsr and sign
%data=[5.6,6.1,6.3,6.3,6.5,6.6,7,7.5,7.9,8,8,8.1,8.1,8.2,8.4,8.5,8.7,9.4,14.3,26]';
%testmedian=9;
%    Pitman Test Results:
%     Order stat: 568694 ,  S-: 2.720000e+001 ,  p-value: 0.542348862
%     Order stat: 479679 ,  S+: 2.270000e+001 ,  p-value: 0.457457542
%     Normal approximation with continuity correction  p-value: 0.428402189
%    Wilcoxon signed-rank Test Results:
%     Order stat: 1041230 ,  S-: 169 ,  p-value: 0.992994308
%     Order stat: 7784 ,  S+: 41 ,  p-value: 0.007423401
%     Normal approximation with continuity correction  p-value: 0.008864155
%     0.95046 Confidence Limit on the Median 7.82500 (index  53): (7.15000,8.50000)
%     0.94565 Confidence Limit on the Median 7.82500 (index  54): (7.15000,8.45000)
%    Sign Test Results:
%     Number of signs: 3 ,  p-value: 0.001288414
%     Normal approximation with continuity correction  p-value: 0.001825217
%     0.95861 Confidence Limit on the Median 8.00000 (index   6): (6.60000,8.40000)
%     0.88468 Confidence Limit on the Median 8.00000 (index   7): (7.00000,8.20000)

% PROBLEMS S&S %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 2.9 in S&S
%data=[126,142,156,228,245,246,370,419,433,454,478,503]';
%testmedian=400;
% Problem 2.10 in S&S
%data=[-2,4,8,25,-5,16,3,1,12,17,20,9]';
%testmedian=15;
% Problem 2.12 in S&S
%data=[3.1,1.8,2.7,2.4,2.9,0.2,3.7,5.1,8.3,2.1,2.4]';
%testmedian=2;
% Problem 2.18 in S&S
%data=[475,483,627,881,892,924,1077,1224,1783,1942,2013,2719,4650,6915]';
%testmedian=870;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example 3.16 in S&S (eq 3.8, 3.9 & 3.10)  (runs test for randomness)
%data=[0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0]';
%testmedian=.5;
%    Runs Test for Randomness Results:
%     3 runs in 20 dichotomous data p-value: 0.000097426
%     Left-tail  p-value: 0.000108251
%     Right-tail p-value: 0.999978350
%     Using Normal approximation with continuity correction.
%     n=20 ,  runs=3 ,  p-value: 0.000284462
%data=[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1]';
%testmedian=.5;
%    Runs Test for Randomness Results:
%     20 runs in 20 dichotomous data p-value: 0.000010825
%     Left-tail  p-value: 0.999989175
%     Right-tail p-value: 0.000000000
%     Using Normal approximation with continuity correction.
%     n=20 ,  runs=20 ,  p-value: 0.000047019
%data=[0,0,1,0,1,1,1,0,1,0,0,1,0,1,0,0,0,1,1,0]';
%testmedian=.5;
%    Runs Test for Randomness Results:
%     13 runs in 20 dichotomous data p-value: 0.112026673
%     Left-tail  p-value: 0.885091688
%     Right-tail p-value: 0.226339605
%     Using Normal approximation with continuity correction.
%     n=20 ,  runs=13 ,  p-value: 0.228743239


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example 4.1 in S&S wilcoxsr and sign
%data=[557,505,465,562,544,448,531,458,560,485,520,445]';
%data2=[564,521,495,564,560,481,545,478,580,484,539,467]';
%testmedian=0;
%    Wilcoxon signed-rank Test Results:
%     Order stat: 4095 ,  S-: 77 ,  p-value: 0.999755859
%     Order stat: 2 ,  S+: 1 ,  p-value: 0.000488281
%     Normal approximation with continuity correction  p-value: 0.001619961
%     0.95557 Confidence Limit on the Median 17.25000 (index  14): (9.50000,23.50000)
%     0.94531 Confidence Limit on the Median 17.25000 (index  15): (9.50000,23.00000)
%    Sign Test Results:
%     Number of signs: 1 ,  p-value: 0.003173828
%     Normal approximation with continuity correction  p-value: 0.004687384
%     0.96143 Confidence Limit on the Median 17.50000 (index   3): (7.00000,22.00000)
%     0.85400 Confidence Limit on the Median 17.50000 (index   4): (14.00000,20.00000)
% Example 4.2 in S&S wilcoxsr and sign
%data=[45,61,33,29,21,47,53,32,37,25,81]';
%data2=[53,67,47,34,31,49,62,51,48,29,86]';
%testmedian=10;
%    Wilcoxon signed-rank Test Results:
%     Order stat: 908 ,  S-: 46 ,  p-value: 0.886718750
%     Order stat: 127 ,  S+: 19 ,  p-value: 0.124023438
%     Normal approximation with continuity correction  p-value: 0.123287829
%     0.96094 Confidence Limit on the Median 7.50000 (index  10): (5.00000,10.00000)
%     0.94727 Confidence Limit on the Median 7.50000 (index  11): (5.00000,9.50000)
%    Sign Test Results:
%     Number of signs: 3 ,  p-value: 0.113281250
%     Normal approximation with continuity correction  p-value: 0.171390856
%     0.98828 Confidence Limit on the Median 8.00000 (index   2): (4.00000,14.00000)
%     0.93457 Confidence Limit on the Median 8.00000 (index   3): (5.00000,11.00000)
% Example 4.4 in S&S sign
%data=[0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1]';
%testmedian=0.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 4.2 in S&S
%data=[7,5,12,-3,-5,2,14,18,19,21,-1]';
%testmedian=0;
% Problem 4.3 in S&S wilcoxsr
%data=[11.7,12.1,13.3,15.1,15.9,15.3,11.9,16.2,15.1,13.6]';
%data2=[10.9,11.9,13.4,15.4,14.8,14.8,12.3,15.0,14.2,13.1]';
%testmedian=0;
% Problem 4.7 in S&S sign
%data=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]';
%testmedian=0.5;
% Problem 4.12 in S&S wilcoxsr
%data=[73,73,74,66,71,73,68,72,73,72]';
%data2=[72,79,79,77,83,78,70,78,78,77]';
%testmedian=3;
% Problem 4.15 in S&S wilcoxsr
%data=[43.5,51.2,46.8,55.5,45.5,42.0,36.0,49.8,42.5,50.8,36.6,47.6,41.9,48.4,53.5]';
%data2=[45.5,44.5,45.0,54.5,49.5,43.5,41.0,53.0,48.0,52.5,41.0,47.5,42.5,45.0,52.5]';
%testmedian=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example 5.1 in S&S wilcoxrsum
%data=[23,18,17,25,22,19,31,26,29,33]';
%data2=[21,28,32,30,41,24,35,34,27,39,36]';
%testmedian=0;
% Example 5.2 in S&S wmwrsum
%data=[23,18,17,25,22,19,31,26,29,33]';
%data2=[21,28,32,30,41,24,35,34,27,39,36]';
%testmedian=0;
% Example 5.3 in S&S wmwrsum
%data=[16,18,19,22,22,25,28,28,28,31,33]';
%data2=[22,23,25,27,27,28,30,32,33,35,36,38,38]';
%testmedian=0;
% Example 5.3a in S&S wmwrsum
%data=[1,2,2,3,3,4]';
%data2=[1,1,4,5,5,5,7,8,9,9,9,9,10]';
%testmedian=0;
% Example 5.4 in S&S
%data=[10,10,10,20,20,20,20,20,20,30,30]';
%data2=[20,20,20,20,20,20,30,30,30,30,30,30,30]';
%testmedian=0;
% Example 5.10 in S&S wmwrsum
%data=[13,13,22,26,33,33,59,72,72,72,77,78,78,80,81,82,85,85,85,86,88]';
%data2=[0,19,22,30,31,37,55,56,66,66,67,67,68,71,73,75,75,78,79,82,83,83,88,96]';
%testmedian=0;

%data=[23,18,17]';
%data2=[21,28,32,30]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 5.10 in S&S wmwrsum
%data=[40,30,20,10,39,31,19,11,38,32,18,12,37,33,17,13,28]';%428 in 17 obs
%data2=[1,2,3,4,5,6,7,8,9,10,14,15,16,21,22,23,24,25,26,27,29,34,35,36]';
%testmedian=0;
% Problem 5.14 in S&S wmwrsum
%data=[204,218,197,183,227,233,191]';
%data2=[243,228,261,202,343,242,220,239]';
%testmedian=0;

%data=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24];
%data2=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24];
%testmedian=12;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% eg. http://www.oandp.org/jpo/library/1996_03_105.asp
%data=[1 2 3 4 5];    %(p-value) of 0.242 for a value of 0.400
%data2=[2 1 4 5 3];
%method='kendallrank';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 7.6 in S&S kendallrank
%data=[1,2,3,4,5,6,7];
%data2=[3,4,1,5,2,7,6];
%method='kendallrank';
%alter=-1;MC=1;n=10000;
%[p, r, t, R, T]=SpearmanRankTest(data,data2,alter,MC,n);
%p,r,t
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 7.7 in S&S kendallrank
%data=[5,3,2,4,1,6,7];
%data2=[3,1,4,2,7,6,5];
%method='kendallrank';
%alter=1;MC=1;n=10000;
%[p, r, t, R, T]=SpearmanRankTest(data,data2,alter,MC,n);
%p,r,t

% PROBLEMS Triola %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example 12.5 in Triola
%data=[0,.5,1,1,2,3]';
%testmedian=0;

% My examples:
%data=[3,3,4,5,6,6,7,8];
%testmedian=3;


% EXAM 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 4.5 in S&S sign
%data=[1,0,0,1,1,1,1,1,1,1,0,1,1,1,0,1,1]'; %1-Father, 0-Mother
%testmedian=0.5;
%method='sign';
%%================================================================================
%%Nonparametric Statistics Toolbox for Matlab by Erik Erhardt
%%
%%Note:  All p-values are one-tailed (unless stated otherwise).
%%       Multiply by 2 for two-tailed test p-value.
%%
%%================================================================================
%%Sign Test Results:
%%
%%Number of signs: 4 ,  p-value: 0.024520874
%%Normal approximation with continuity correction  p-value: 0.026172532
%%
%%========================================
%%Sign Confidence Intervals:
%%0.99765 Confidence Limit on the Median 1.00000 (index   3): (0.00000,1.00000)
%%0.98727 Confidence Limit on the Median 1.00000 (index   4): (0.00000,1.00000)
%%0.95096 Confidence Limit on the Median 1.00000 (index   5): (1.00000,1.00000)

% Problem 4.6 in S&S wilcoxsr
%data=[50,56,51,46,88,79,81,95,73]';
%data2=[25,58,65,38,91,32,31,13,49]';
%testmedian=0;
%method='wilcoxsr';
%%================================================================================
%%Wilcoxon Signed-Rank Test Results:
%%
%%printdatadiff =
%%   -25     2    14    -8     3   -47   -50   -82   -24
%%
%%printdata =
%%     1     2    -3     4    -5    -6    -7    -8    -9
%%
%%Median  0.00
%%n=9
%%
%%Order stat: 19 ,  S+: 7 ,  p-value: 0.037109375
%%Normal approximation with continuity correction  p-value: 0.037780284
%%
%%========================================
%%Wilcoxon Signed-Rank Confidence Intervals using Walsh averages:
%%0.92188 Confidence Limit on the Median -23.50000 (index   8): (-47.00000,-2.50000)
%%0.89844 Confidence Limit on the Median -23.50000 (index   9): (-45.00000,-3.00000)
%%
%%========================================
%%t-distribution Confidence Intervals (inappropriate for nonnormal data):
%%0.95000 Confidence Limit on the Mean -24.11111: (-47.91949,-0.30273)
%%0.90000 Confidence Limit on the Mean -24.11111: (-43.31005,-4.91217)
%%================================================================================

% Problem 5.22 in S&S wmwrsum
%data=[8,6,4,2,10,5,6,6,19,4,10,4,10,12,7,2,5,1,8,2,0,7,6,4,4,11,2,16,8,7,8,4,0,2]';
%data2=[4,7,13,4,8,8,4,14,5,6,4,12,9,9,9,8,12,4,8,8,4,11,6,15,9,8,14,9,8,9,7,12,11,7,4,10,7,8,8,7,9,10,16,14,15,10,4,6,3,9,3,10,3,8]';
%testmedian=0;
%method='wmwrsum';
%%================================================================================
%%Wilcoxon-Mann-Whitney Rank-Sum Test (Independent Samples) Results:
%%
%%unstat = 1.2485e+003
%%umstat = 587.5000
%%
%%n=88 gives 2.721577e+024 comparisions with array size 9.253362e+025 which is > 2147483647 is max elements in array.
%%Normal approximation available.
%%
%%Normal approximation with continuity correction  p-value: 0.002230954
%%================================================================================


% Data section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if exist('testmedian') == 0  % if testmedian does not exist, then assume two sample test
 testmedian=0;
end;
if exist('data2') == 0  % if testmedian does not exist, then assume one sample test
 data2=0;
end;

%%% one-sample or paired routines
%method='pitman';
%method='pitmanmc';
%method='wilcoxsr';
%method='vdwaerden';
%method='sign';
%method='runsrandom';
%method='kendallrank';

%%% two-sample or independent routines
%method='pitmanind';
%method='wilcoxrsum';
%method='wmwrsum';

%%% profile tracks time per function
%profile on

npar_main(method,data,data2,testmedian)

%profile off
%profile viewer

% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%