function m=vec2mat(vec,c,vecb)  
    l=length(vec(:));
    r=ceil(l/c);
    d=c*r-l;
    m=reshape([vec vecb(1:d)],c,r)';
end