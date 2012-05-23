function badTrials=checkEventSegmentationVisually(eventTS)
badTrials=cell(1,size(eventTS,2));
figure 
for k=1:size(eventTS,2)
    printf('Now Looking at subset %d',k)
    for m=1:size(eventTS{k},4)
        plot(squeeze(eventTS{k}(1,:,1,m)));
        title(['trial: ' num2str(m)])
        flag = 0;
        while flag==0
            r=input(['Good trial? [y]/n '],'s');
            if strcmpi('y',r)
                flag = 1;
                % Next trial
            elseif strcmpi('n',r)
                badTrials{k}=[badTrials{k} m];
                flag=1;
            else
                disp('Inavlid answer. Try again.')
                flag=0;
            end
        end
    end
end
