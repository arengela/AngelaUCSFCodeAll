function [syncedEdfData,normalizedHtkData,R,pval,maxlag]=syncEDFtoTDT(htkData,edfData)
   htkData=detrend(htkData','constant')';
   edfData=detrend(edfData','constant')';
   for i=1:size(htkData,1)
       [r,lag]=xcorr(edfData(i,:)',htkData(i,:)');
       [R(i),idx]=max(r);
       maxlag(i)=lag(idx);
   end
   
   
   syncedEdfData=edfData(:,mode(maxlag):size(htkData,2)+mode(maxlag)-1);    
   normalizedHtkData=htkData;
   
   for i=1:size(htkData,1)
     [tmp,p]=corrcoef(syncedEdfData(i,:),normalizedHtkData(i,:));
     R(i)=tmp(1,2);
     pval(i)=p(1,2);
   end
   
   
end


