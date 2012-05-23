p='/home/changlab/EcogData/Tests/'
cd(p)
files{1}='EC5_B18'
files{2}='EC5_B20'
files{3}='EC5_B25'
files{4}='EC5_B19'
files{5}='EC5_B22'
files{6}='EC5_B27'
files{7}='EC5_B28'
files{8}='EC5_B6'
files{9}='EC5_B7'
files{10}='EC6_B10'
files{11}='EC6_B11'
files{12}='EC6_B26'
files{13}='EC6_B28'
files{14}='EC6_B40'



for i=1:3
    tic
    quickpreprocessing_v3([p files{i}])
    t=toc
    save('t','t')
end

for i=4:9
    tic
    quickpreprocessing_v3([p files{i}])
    t=toc
    save('t','t')
end

for i=10:14
    tic
    quickpreprocessing_v3([p files{i}])
    t=toc
    save('t','t')
end