for nBlocks=1:4
    for k=1:64
       varName=sprintf('pWav%s%s.htk',num2str(nBlocks),num2str(k))
       chanNum=(nBlocks-1)*64+k
       [processed_ecog.data(chanNum,:),fs,dt,tc,t]=readhtk(varName);
     end
end