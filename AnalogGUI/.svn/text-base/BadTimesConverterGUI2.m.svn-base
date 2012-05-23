function BadTimesConverterGUI (badtimes,filename)


if ~isempty(badtimes)
    [m,ind] = sort(badtimes(:,1));
    badtimes = badtimes(ind,:);
    fid = fopen(filename,'w');
    first = 0;
    for cnt1 = 1:size(badtimes,1)
        fprintf(fid,'%s \n',[num2str(floor(first*1E7)) ' ' num2str(floor(badtimes(cnt1,1)*1E7)) ' b ']); 
        %fprintf(fid,'%s \n',[num2str(floor(badtimes(cnt1,1)*1E7)) ...
            %' ' num2str(floor(badtimes(cnt1,2)*1E7)) ' e ' num2str(badtimes(cnt1,3))]);
        first = badtimes(cnt1,1);
    end
    fclose(fid);
else 
    fid = fopen(filename,'w');
    fprintf(fid,' ');
    fclose(fid);
end