function [f] = gammax(z)
             % GAMMA  Gamma function valid in the entire complex plane.
             %        Gives exact results for integer arguments.
             %        Relative accuracy is better than 10^-13.
             %        This routine uses an excellent Lanczos series
             %        approximation for the complex Gamma function.
             %
             %usage: [f] = gamma(z)
             %        z may be complex and of any size.
             %        Also  n! = prod(1:n) = gamma(n+1)
             %        
             %tested under version 5.3.1
             %
             %References: C. Lanczos, SIAM JNA  1, 1964. pp. 86-96
             %            Y. Luke, "The Special ... approximations", 1969 pp. 29-31
             %            Y. Luke, "Algorithms ... functions", 1977
             %            J. Spouge,  SIAM JNA 31, 1994. pp. 931
             %            W. Press,  "Numerical Recipes"
             %            S. Chang, "Computation of special functions", 1996
             %
             %see also:   GAMMA GAMMALN GAMMAINC PSI
             %see also:   mhelp GAMMA

             %Paul Godfrey
             %pgodfrey@intersil.com
             %11-15-00

             twopi=pi+pi;
             [row, col] = size(z);
             z=z(:);
             zz=z;

             f = 0.*z; % reserve space in advance

             p=find(real(z)<0);
             if ~isempty(p)
                z(p)=-z(p);
             end

             %Lanczos approximation for the complex plane
             %calculated with vpa digits(128)
             c = [   1.000000000000000174663;
                  5716.400188274341379136;
                -14815.30426768413909044;
                 14291.49277657478554025;
                 -6348.160217641458813289;
                  1301.608286058321874105;
                  -108.1767053514369634679;
                     2.605696505611755827729;
                    -0.7423452510201416151527e-2;
                     0.5384136432509564062961e-7;
                    -0.4023533141268236372067e-8];

             %Matlab's own Gamma is based upon one by W.J. Cody from Oct. 12, 1989

             % c is calculated from c=D*B*C*F
             % where D is [1  -Sloane's sequence A002457],
             % fact(2n+2)/(2fact(n)fact(n+1)), diagonal
             % and B is rows from the odd  cols of A & Stegun table 24.1 (Binomial),
             % unit Upper triangular
             % and C is cols from the even cols of A & Stegun table 22.3 (Cheby),
             % C(1)=1/2, Lower triangular
             % and F is sqrt(2)/pi*gamma(z+0.5).*exp(z+g+0.5).*(z+g+0.5).^-(z+0.5)
             % gamma(z+0.5) can be computed using factorials,2^z, and sqrt(pi).
             % A & Stegun formulas 6.1.8 and 6.1.12)
             %
             % for z=0:(g+1) where g=9 for this example. Num. Recipes used g=5
             % gamma functions were made for g=5 to g=13.
             % g=9 gave the best error performance
             % for n=1:171. This accuracy is comparable to Matlab's
             % real only Gamma function.

             %for example, for g=5 we have dimension (g+2) as
             %
             %D=diag([1 -1 -6 -30 -140 -630 -2772])
             %
             %B=[1  1  1  1  1   1   1;
             %   0  1 -2  3 -4   5  -6;
             %   0  0  1 -4 10 -20  35;
             %   0  0  0  1 -6  21 -56;
             %   0  0  0  0  1  -8  36;
             %   0  0  0  0  0   1 -10;
             %   0  0  0  0  0   0   1]
             %
             %C=[0.5  0    0     0     0     0    0;
             %   -1   2    0     0     0     0    0;
             %    1  -8    8     0     0     0    0;
             %   -1  18  -48    32     0     0    0;
             %    1 -32  160  -256   128     0    0;
             %   -1  50 -400  1120 -1280   512    0;
             %    1 -72  840 -3584  6912 -6144 2048]
             %
             %
             %F=[ 83.2488738328781364;
             %    16.0123164052516814;
             %     7.0235516528280364;
             %     4.1065601620725384;
             %     2.7864466488340058;
             %     2.0690586753686773;
             %     1.6309293967598249]
             %
             %so  c = (D*(B*C))*F
             %
             %this will generate the Num. Recp. values
             %(if you used vpa for calculating F)
             %notice that (D*B*C) always contains only integers
             %(except for the 1/2 value)

             %Note: 24*sum(c) ~= Integer = 12*g*g+23 if you calculated c correctly
             %for this example g=5 so 24*sum(c) = 322.99... ~= 12*5*5+23 = 323

             %Spouge's approximate formula for the c's can be calculated from applying
             %L'Hopitals rule to the partial fraction expansion of the sum portion of
             %Lanczos's formula. These values are easyer to calculate than D*B*C*F
             %but are not as accurate. (An approx. of an approx.)


             g=9;
             %Num Recipes used g=9
             %for a lower order approximation
             t=z+g;
             s=0;
             for k=g+2:-1:2
                 s=s+c(k)./t;
                 t=t-1;
             end
             s=s+c(1);
             ss=(z+g-0.5);
             s=log(s.*sqrt(twopi)) + (z-0.5).*log(ss)-ss;

             LogofGamma = s;
             f = exp(LogofGamma);

             if ~isempty(p)
                f(p)=-pi./(zz(p).*f(p).*sin(pi*zz(p)));
             end

             p=find(round(zz)==zz & imag(zz)==0 & real(zz)<=0);
             if ~isempty(p)
                f(p)=Inf;
             end

             %make results exact for integer arguments
             p=find(round(zz)==zz & imag(zz)==0 & real(zz)>0 );
             if ~isempty(p)
                zmax=max(zz(p));
                pp=1;
                for zint=1:zmax
                    p=find(zz==zint);
                    if ~isempty(p)
                       f(p)=pp;
                    end
                    pp=pp*zint;
                end
             end

             f=reshape(f,row,col);

             return

             %A demo of this routine is:
             clc
             clear all
             close all
             x=-4:1/16:4.5;
             y=-4:1/16:4;
             [X,Y]=meshgrid(x,y);
             z=X+i*Y;
             f=gamma(z);
             p=find(abs(f)>10);
             f(p)=10;

             mesh(x,y,abs(f),phase(f));
             view([-40 30]);
             rotate3d;
             return

             %to see the relative accuracy for real n
             clc
             clear all
             close all
             warning off
             format long g

             n=[0.5:0.5:171.5];
             n=n(:);

             which gamma
             lg=gamma(n);%Lanczos complex gamma
             wd=pwd;
             %get ready to use the other Gamma function
             cd ../
             which gamma
             mg=gamma(n);%Matlab's gamma
             cd(wd)

             %let's consider Maple's Gamma to be the true and accurate standard
             G=mfun('gamma',n);

             elg=abs((G-lg)./G);
             meanelg=mean(elg);
             stdelg =svd( elg);
             eelg=log10(elg);

             emg=abs((G-mg)./G);
             meanemg=mean(emg);
             stdemg =svd( emg);
             eemg=log10(emg);

             figure(1)
             plot(n,eelg,'bh')
             hold on;
             plot(n,eemg,'r*')
             grid on

             xlabel('n')
             ylabel('Relative accuracy compared to Maple Gamma')
             title('Matlab real Gamma in red, Lanczos complex Gamma in blue')

             MeanErrorAndStd=[meanemg stdemg;
                              meanelg stdelg]

             return
             