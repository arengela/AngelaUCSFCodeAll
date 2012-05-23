function H = gen_cort(fc, L, STF, PASS)
% THIS VERSION IS USED FOR IEEE TRANS PAPER ON SPEECH DETECTION

if nargin < 4, PASS = [2 3]; end;


% tonotopic axis
%R1	= (0:L)'/L*STF/2;	% length = L + 1 for now
%R2	= 15; 
% Gamma distribution function 
% H(f) = f^alpha exp(-beta f)
%H = (R1/fc).^(R2) .* exp(-R2*(R1/fc));
t = (0:L-1)'/STF * fc;

                                                                    %h = cos(2*pi*t) .* sqrt(t) .* exp(-2*t) * fc;
% h = sin(2*pi*t) .*t.^2.* exp(-3.5*t) * fc;
%h = sin(2*pi*t) .*t.^2.* exp(-14*t) * fc; %% (** == b1)
h = sin(2*pi*t) .*t.^2.* exp(-5*t) * fc; %% (** b2 )

%h = diff(h); h = [h(1)/2; h];
h = h-mean(h);
H0 = fft(h, 2*L);
A = angle(H0(1:L));
H = abs(H0(1:L));
[maxH, maxi] = max(H);
H = H / max(H);

% passband
if PASS(1) == 1,		%lowpass
	sumH = sum(H);
	H(1:maxi-1) = ones(maxi-1, 1);
	H = H / max(H);%sum(H) * sumH; % h real-> abs(H) even
    % Make it a min-phase filter (Oppenheim-Shafer 1989 p.784)
    Re_H_hat= log(H); % even
    c= real(ifft([Re_H_hat; Re_H_hat(end:-1:1)])); % real cepstrum. take real to remove numerical error
    l_min= zeros(2*L,1); l_min(0+1)= 1; l_min(L+1)=1; l_min(2:L)= 2; % 2*u[n]-del[n]: see (12.101) p. 794: values for n<0 appear in N/2<n<=N-1(or end); 2*u[n]-del[n]= [l[0]=1, 2, ...,l[L-1]=2, 0,...,0]
    h_hat_min= c.*l_min; % complex cepstrum
    H_hat_min= fft(h_hat_min);
    H= H.*exp(sqrt(-1)*imag(H_hat_min(1:L)));    % H_min phase
elseif PASS(1) == PASS(2),	% highpass
	sumH = sum(H);
	H(maxi+1:L) = ones(L-maxi, 1);
	H = H / max(H);%sum(H) * sumH;
    % Make it a min-phase filter (Oppenheim-Shafer 1989 p.784)
    Re_H_hat= log(H); % even
    c= real(ifft([Re_H_hat; Re_H_hat(end:-1:1)])); % real cepstrum
    l_min= zeros(2*L,1); l_min(0+1)= 1; l_min(L+1)=1; l_min(2:L)= 2; % 2*u[n]-del[n]: see (12.101) p. 794: values for n<0 appear in N/2<n<=N-1(or end); 2*u[n]-del[n]= [l[0]=1, 2, ...,l[L-1]=2, 0,...,0]
    h_hat_min= c.*l_min; % complex cepstrum
    H_hat_min= fft(h_hat_min);
    H= H.*exp(sqrt(-1)*imag(H_hat_min(1:L)));   % H_min phase
else
%     H = H .* exp(i*A);
    %return a non-causal result!
    H = H+i*0.00000000001;
end;


