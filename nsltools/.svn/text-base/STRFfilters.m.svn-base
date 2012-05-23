function strfs = STRFfilters(wt,wf,Nt,Nf,fst,fsf)

HR = gen_cort(wt, Nt,fst*2);% if BP, all BPF
HS = gen_corf(wf, Nf,fsf*2);% if BP, all BPF
strfs(:,:,1) = fftshift(real(ifft2(HS*HR')));
strfs(:,:,2) = fftshift(imag(ifft2(HS*HR')));
strfs(:,:,3) = fftshift(real(ifft2([HS(1);flipud(HS(2:end))]*HR')));
strfs(:,:,4) = fftshift(imag(ifft2([HS(1);flipud(HS(2:end))]*HR')));

