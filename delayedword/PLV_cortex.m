% Choose Pairs of electrodes
C2=nchoosek(test.usechans,2)
C2(:,3)=C2(:,2)-C2(:,1);
idx=find(C2(:,3)>10)
sigch=C2(idx,1:2);
%%
buffer=[2500 2500]
segsize=(sum(buffer)/1000)*400
midline=(buffer(1)/1000)*400
set(gcf,'Color','w')
f=9;
for ch=1:10%size(sigch,1)
    %usechan=[ find(test.usechans==sigch(ch,1)) find(test.usechans==sigch(ch,2))];
    usechan=1:2;
    chanNum=sigch(ch,:);
    
    T=PLVtests(12,2,chanNum)
    test=T.Data
%     test3=segmentedData('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band',0)
%     test3.usechans=chanNum;
%     test3.channelsTot=length(test3.usechans);
%     test3.loadBaselineFolder('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','phase');    
      baseline=test.ecogBaseline.phase(usechan,:,f);
%     
%     for e=[1:3]
        sigdata=zeros(40,1000);
        plvdata=zeros(40,1000); 

        e=1
        if 1%length(find(holdRatio(ch,:)>2))>=3
            for f=1:40
                 stack1=squeeze(test.segmentedEcog(e).phase(usechan(1),:,:,:));
                 stack2=squeeze(test.segmentedEcog(e).phase(usechan(2),:,:,:));
                 
                 for t=1:51
                     [lag,XR_base(t,:)]=cxcorr(stack1(400:800,f,t)',stack2(400:800,f,t)');
                     [lag,XR(t,:)]=cxcorr(stack1(800:1200,f,t)',stack2(800:1200,f,t)');
                 end
                 subplot(1,4,1)
                             plot(mean(XR_base,1),'r')
                             hold on
                             plot(mean(XR,1))
                             hold off
                            [a_base,b]=max(mean(XR_base,1));
                 
                             [a,b]=max(mean(XR,1));
                             title(['f' int2str(f) ' lag' num2str(lag(b)) ' ratio ' num2str(a/a_base)])
                 holdRatio(ch,f)=a/a_base;
                 
%                  %shift=lag(b);
%                  try
%                      lagidx=1
%                      for shift=0:10:200
%                          shiftStack1=squeeze(stack1(401:1400,:,f))';
%                          shiftStack2=squeeze(stack2(401+shift:1400+shift,:,f))';
% 
%                          [ps,realPLV,bse]=PLVstats(shiftStack1,shiftStack2,baseline,[],chanNum);
%                          %idx=find(ps<=.001 & abs(realPLV)>=bse);
%                          %PLV(ch).sigdata(f,idx)=realPLV(idx);
%                          %PLV(ch).plvdata(f,:)=realPLV;
%                          PLV(ch).plv_shift(lagidx,f,:)=realPLV;
%                          
%                       
%                          
%                          
%                          
%                          
%                          lagidx=lagidx+1;
%                      end
%                  end
            end
            %r=input('next','s');
        end
        
        PLV(ch).XR=XR;
        PLV(ch).XR_base=XR_base;
        %PLV(ch).difference=mean(PLV(ch).plv_shift(:,:,1:400),3)-mean(PLV(ch).plv_shift(:,:,400:1000),3);
end
%%
mkdir('/home/angela/Documents/PLV')
cd('/home/angela/Documents/PLV')
save('PLV','PLV')

%%
for l=1:200
    imagesc(squeeze(PLV(ch).plv_shift(l,:,:)))
    input('n')
en
d

