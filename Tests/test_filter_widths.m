for f=1:npbs
                H{f} = zeros(1,T); 
                k = freqs-cfs(f);
                H{f}(1:nfreqs) = exp((-0.5).*((k./sds(f)).^2));
                H{f}(nfreqs+1:end)=fliplr(H{f}(2:ceil(T/2))); 
                H{f}(1)=0;
                %filteredData.data(c,:,f)=abs(ifft(adat(c,:).*(H.*h),T));
                %hilbdata=ifft(adat(end,:).*(H{f}.*h),T);
                %filteredData.data(c,:,f)=abs(hilbdata);
                %phaseInfo.data(c,:,f)=angle(hilbdata);                
end  
            
figure
for f=1:npbs
    %filter{f}=H{f}.*h;
    plot((H{f}.*h))
    hold on
end

for f=1:npbs
    filter_array(f,:)=H{f}.*h;
end

figure
plot(sum(filter_array,1))