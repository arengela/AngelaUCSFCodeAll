function xysites=plotPointsBrainNormalized3(AP,Z,SF,CS,a)

hold on
scatter(SF(:,1),SF(:,2),'fill')
scatter(CS(:,1),CS(:,2),'fill')
%idx=find([stimPoints{:,14}]<0 & [stimPoints{:,15}]<0)
idx=1:length(AP)
for i=idx    
    %% GET SF LINE
    c=polyfit(SF(:,1),SF(:,2),1);
    plot(polyval(c,1:size(a,2)))

    % GET parallel line z away
    SFline(1,:)=1:size(a,2);
    SFline(2,:)=polyval(c,1:size(a,2));

    h=SFline(2,end)-SFline(2,1);
    alpha=atan(h/size(a,2))
    y=Z(i)/cos(alpha);
    c(2)=c(2)+y;
    %% GET INTERSECTION WITH CS
    SFline2(1,:)=1:size(a,2);
    SFline2(2,:)=polyval(c,1:size(a,2));
    plot(SFline2(1,:),SFline2(2,:))
    dist=squareform(pdist([SFline2 CS']'));
    dist=dist(length(SFline2)+1:end,1:length(SFline2));
    [dist2,idx1]=min(dist)
    [dist2,idx2]=min(dist2)
    idx1=idx1(idx2)
    scatter(CS(idx1,1),CS(idx1,2))
    scatter(SFline2(1,idx2),SFline2(2,idx2))
    if CS(idx1,2)> SFline2(2,idx2)
        idx3=idx1-1;
    else
        idx3=idx1+1;
    end
    scatter(CS(idx3,1),CS(idx3,2),'fill')

    c2=polyfit(CS([idx1 idx3],1),CS([idx1 idx3],2),1);
    plot(polyval(c2,1:size(a,2)))
    [x,y]=lineintersect([1 polyval(c,1) size(a,2) polyval(c,size(a,2))],...
        [1 polyval(c2,1) size(a,2) polyval(c2,size(a,2))])
    plot(x,y,'m.')
    %%
    X=x+AP(i)*cos(alpha);
    Y=y+(AP(i)*sin(alpha));
    plot(X,Y,'y.')
    xysites(i,1)=X;
    xysites(i,2)=Y;
end
