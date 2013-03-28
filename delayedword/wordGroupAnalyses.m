%% GET WORD GROUPS and PLOT GRAND MEAN AVE WAVEFORM
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup\brocawords')
wordGroups={'sef','sei','lef','lei','lhf','lhi'};
timeIdx=0;
for p=1:8
    for eidx=[2 4 5]
        clear LabelsGroups
        %usech=unique([reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]) reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[])]);
        usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
        usesamps=1:400
        Labels=AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetr,8);
        %[Data,midx]=max(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr),[],2);
        %Data=squeeze(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr),2));
        Data=AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr);

        if timeIdx==1
            Data=midx;
        end
        %Data=squeeze(prctile(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr),99,2));

        for i=1:length(Labels)
            idx=find(strcmp(Labels{i},{brocawords.names}))
            if isempty(idx)
                continue;
            else
                if brocawords(idx).logfreq_HAL>8.75
                    f='f';
                else
                    f='i'
                end
                LabelsGroups{i}=strcat(brocawords(idx).lengthtype(1),brocawords(idx).difficulty(1),f);
            end
        end
            
        for g=1:length(wordGroups)
            trNum=find(strcmp(wordGroups{g},LabelsGroups))
            wordTypeResponse(p,eidx).group(g).data=Data(:,:,1,trNum);
        end       
    end
end
%% GROUP WORD GROUPS AND FIND CORRELATION
opengl software
colormat=jet%load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\haxby.m')
clear dHold

calcType=1;
groupType=1

switch groupType
    case 1
        gGrouped={[1:4],[5 6]};%Easy vs diff Long words
    case 2
        gGrouped={[3 5],[4 6]}
    case 3
        gGrouped={[1 2],[3:6]}%short vs long
end
clf
set(gcf,'Color','w')
for p=1:8
    for eidx=[2 5]
        pos=subplotMinGray(2,8,find([2 5]==eidx),p-1);
        subplot('Position',pos)
        clear dHold wordType
        
        
        for gidx=1:length(gGrouped)
            g=gGrouped{gidx};
            dHold{gidx}=cat(4,wordTypeResponse(p,eidx).group(g).data);
            wordType{gidx}=repmat(gidx,size(dHold{gidx},4),1);
        end
        
        switch calcType
            case 1            
                yvar=squeeze(max(cat(4,dHold{:}),[],2));%max zscore
            case 2
                [~,midx]=max(cat(4,dHold{:}),[],2); yvar=squeeze(midx);%Max time
            case 3        
                d=squeeze(cat(4,dHold{:}));%Max latency
                clear yvar
                for c=1:size(d,1)
                    for t=1:size(d,3)
                        yvar(c,t)=length(find(d(c,:,t)>1));
                    end
                end
            case 4
                yvar=squeeze(mean(cat(4,dHold{:}),2));%max zscore

        end
        
        xvar=cat(1,wordType{:});
        [R,pval]=corr(yvar',xvar,'Type','Spearman');
        visualizeGrid(2,['E:\General Patient Info\' patients{p} '\brain5.jpg'],[]);
        hold on
        [pval,tmp]=MT_FDR_PRDS(pval',0.05);
        ch=find(pval<0.5);
        ch=1:length(pval);
        R=(R+1);
        
         a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain5.jpg']);
            
            if 1%renderImage==1
                limx=size(a,2);
                limy=size(a,1);        
                grain=30;
                gx=1:grain:limx;
                gy=1:grain:limy;
                [X,Y] = MESHGRID(gx,gy);                            
                

                [Xq,Yq,Vq]=griddata(BrainCoord(p).xy(1,ch),BrainCoord(p).xy(2,ch),R(ch),X,Y); 
                R(find(pval>=.1))=0;
                [Xq2,Yq2,Vq2]=griddata(BrainCoord(p).xy(1,ch),BrainCoord(p).xy(2,ch),R(ch),X,Y); 

                
                Vq(find(isnan(Vq)))=0; 
                tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
                tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
                
                Vq2(find(isnan(Vq2)))=0; 
                tmp2=imresize(Vq2,[size(a,1)*10 size(a,2)*10]);
                tmp23=imresize(tmp2,[size(a,1) size(a,2)]);
                tmp23(find(tmp23<0))=0;
                
                tmp3(find(tmp3<0))=0;
                tmp4=tmp3./max(max(tmp3));
                tmp4=smooth2(tmp4,10);  
            
            
                ha=axes('position',pos);
                %imagesc(repmat(a,[1 1 3]))
                imshow(repmat(a,[1 1 3]))   
                hold on
                set(ha,'handlevisibility','off', ...
                'visible','off')
                ha=axes('position',pos);
                imshow(tmp3,[0 2])    
                tmp4=tmp4./max(max(tmp4));
                tmp4=tmp4*2;
                tmp4(find(tmp4>.8))=.8;
                %alpha(smooth2(tmp5,1));
                %imshow(tmp23./max(max(tmp23)))
                alpha(tmp23./max(max(tmp23)))
                colormap(jet)
                freezeColors
            end
        
%         plotManyPolygons([BrainCoord(p).xy(1,ch);BrainCoord(p).xy(2,ch)]',100,...
%             colormat(ceil(R(ch)*length(colormat)),:,:),1,20);
        %input('n')
        %clf
    end
end
%% WORD GROUP TTEST- ONE VALUE
        
opengl software
colormat=jet%load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\haxby.m')
clear dHold

calcType=5;
groupType=1

switch groupType
    case 1
        gGrouped={[3:4],[5 6]};%Easy vs diff Long words
    case 2
        gGrouped={[3 5],[4 6]}%Freq
    case 3
        gGrouped={[1 2],[3:6]}%short vs long
end
clf
samps=[200:400];
set(gcf,'Color','w')
for p=1:8
    for eidx=[2 5]
        pos=subplotMinGray(2,8,find([2 5]==eidx),p-1);
        subplot('Position',pos)
        clear dHold wordType
        
        
        for gidx=1:length(gGrouped)
            g=gGrouped{gidx};
            dHold{gidx}=cat(4,wordTypeResponse(p,eidx).group(g).data);
            wordType{gidx}=repmat(gidx,size(dHold{gidx},4),1);
            dHold{gidx}=dHold{gidx}(:,samps,:,:);
        end
        xvar=cat(1,wordType{:});
        switch calcType
            case 1            
                yvar=squeeze(max(cat(4,dHold{:}),[],2));%max zscore
            case 2
                [~,midx]=max(cat(4,dHold{:}),[],2); yvar=squeeze(midx);%Max time
            case 3        
                d=squeeze(cat(4,dHold{:}));%Max latency
                clear yvar
                for c=1:size(d,1)
                    for t=1:size(d,3)
                        yvar(c,t)=length(find(d(c,:,t)>1));
                    end
                end
            case 4
                yvar=squeeze(mean(cat(4,dHold{:}),2));%max zscore
            case 5
                yvar=permute(squeeze(cat(4,dHold{:})),[1 3 2]);
        end
        
        activeCh=unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh']) ;      
        ch=activeCh;       
        clear R;
        for c=activeCh
            [R(c),pval(c),ci]=ttest2(reshape(squeeze(yvar(c,xvar==1,:)),[],1),reshape(squeeze(yvar(c,xvar==2,:)),[],1),...
                0.01,[],'unequal');
        end
        
         a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain5.jpg']);
         imagesc(repmat(a,[1,1,3])); hold on; 
         ch=find(R==1);
         plotManyPolygons([BrainCoord(p).xy(1,ch);BrainCoord(p).xy(2,ch)]',100,...
             rgb('red'),1,20);
        %input('n')
        %clf
    end
end
%%
%% WORD GROUP TTEST- ACROSS TIME
        
        opengl software
colormat=jet%load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\haxby.m')
clear dHold

calcType=5;
groupType=2

switch groupType
    case 1
        gGrouped={[1:4],[5 6]};%Easy vs diff Long words
    case 2
        gGrouped={[3 5],[4 6]}
    case 3
        gGrouped={[1 2],[3:6]}%short vs long
end
clf
samps=[200:400];
set(gcf,'Color','w')
for i=1:length(samps)/25

for p=1:8
    for eidx=[2 5]
        pos=subplotMinGray(2,8,find([2 5]==eidx),p-1);
        subplot('Position',pos)
        clear dHold wordType
        
        
        for gidx=1:length(gGrouped)
            g=gGrouped{gidx};
            dHold{gidx}=cat(4,wordTypeResponse(p,eidx).group(g).data);
            wordType{gidx}=repmat(gidx,size(dHold{gidx},4),1);
            dHold{gidx}=dHold{gidx}(:,samps,:,:);
        end
        xvar=cat(1,wordType{:});
        switch calcType
            case 1            
                yvar=squeeze(max(cat(4,dHold{:}),[],2));%max zscore
            case 2
                [~,midx]=max(cat(4,dHold{:}),[],2); yvar=squeeze(midx);%Max time
            case 3        
                d=squeeze(cat(4,dHold{:}));%Max latency
                clear yvar
                for c=1:size(d,1)
                    for t=1:size(d,3)
                        yvar(c,t)=length(find(d(c,:,t)>1));
                    end
                end
            case 4
                yvar=squeeze(mean(cat(4,dHold{:}),2));%max zscore
            case 5
                yvar=permute(squeeze(cat(4,dHold{:})),[1 3 2]);
        end
        
        activeCh=unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh']) ;      
        ch=activeCh;       
        clear R pval;
        for c=activeCh
             [R(c,:),pval(c,:),ci]=ttest2(squeeze(yvar(c,xvar==1,:)),squeeze(yvar(c,xvar==2,:)),...
                 0.01,[],'unequal');            
        end
        
         a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain5.jpg']);
         imagesc(repmat(a,[1,1,3])); hold on; 
             s=(i-1)*25+1:i*25;
             ch=find(sum(R(:,s),2)>=20);
             plotManyPolygons([BrainCoord(p).xy(1,ch);BrainCoord(p).xy(2,ch)]',100,...
                 rgb('red'),1,20);
          Rhold{p,eidx}=R;

    end
    end
    input('n')
    clf
end
%%
for p=1:8
    for eidx=[2 5]
        imagesc(Rhold{p,eidx})
        input('b')
    end
end
