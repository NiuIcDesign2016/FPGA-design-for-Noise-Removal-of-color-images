
clear all

img1=imread('fig/Lena512.jpg');

y=imread('fig/R1_fixed_2.bmp');
img2=y;

isAll=1;
mSize=1;

[N,M] = size(y);

if isAll==1
    y=wextend('2D', 'symw', y, mSize);
    sN=1+mSize; eN=N+mSize;
    sM=1+mSize; eM=M+mSize;
else
    sN=2; eN=N-1;
    sM=2; eM=M-1;
end

THa=20;
THb=25;

for n=sN:eN
    for m=sM:eM                   
            a=double(y(n-1,m-1));
            b=double(y(n-1,m));
            c=double(y(n-1,m+1));
            d=double(y(n,m-1));
            p=double(y(n,m));
            e=double(y(n,m+1));
            f=double(y(n+1,m-1));
            g=double(y(n+1,m));
            h=double(y(n+1,m+1));
            
            window = [a b c d p e f g h ];
            [Dm,Id] = sort(window);    
            Xm = window(Id);
            
            Max = Xm(6)+THa; Min = Xm(4)-THa;
            if Max <= Xm(5)+THb
                Nmax = Max;
            else
                Nmax = Xm(5)+THb;
            end
            
            if Min >= Xm(5)-THb
                Nmin = Min;
            else
                Nmin = Xm(5)-THb;
            end
            
          if p <= Nmin || p >= Nmax
              
              D1 = abs(d-h)+abs(a-e);
              D2 = abs(a-g)+abs(b-h);
              D3 = abs(b-g)*2;
              D4 = abs(b-f)+abs(c-g);
              D5 = abs(c-d)+abs(e-f);
              D6 = abs(d-e)*2;
              D7 = abs(a-h)*2;
              D8 = abs(c-f)*2;
              
              if e <= Nmin || e >= Nmax 
                  D1 = 512; D5 = 512; D6 = 512;
              end
              if f <= Nmin || f >= Nmax
                  D4 = 512; D5 = 512; D8 = 512;
              end
              if g <= Nmin || g >= Nmax
                  D2 = 512; D3 = 512; D4 = 512;
              end
              if h <= Nmin || h >= Nmax
                  D1 = 512; D2 = 512; D7 = 512;
              end
              
              Dmin = min([D1 D2 D3 D4 D5 D6 D7 D8]);
              
              if Dmin == 512
                  p = mean([a b c d]);
              elseif Dmin==D1 p = mean([a d e h]);
              elseif Dmin==D2 p = mean([a b g h]);
              elseif Dmin==D3 p = mean([b g]);
              elseif Dmin==D4 p = mean([b c f g]);
              elseif Dmin==D5 p = mean([c d e f]);
              elseif Dmin==D6 p = mean([d e]);
              elseif Dmin==D7 p = mean([a h]);
              elseif Dmin==D8 p = mean([c f]);
              end
              
              y(n,m) = median([p b d e g]);
          end
    end
end

if isAll==1
    y=y(mSize+1:N+mSize,mSize+1:M+mSize);
else
    y(1,:) = y(2,:);
    y(N,:) = y(N-1,:);
    y(:,1) = y(:,2);
    y(:,M) = y(:,M-1);
end   

%figure(2);
%imshow(y);
imwrite(y,'fig/R1_fixed_3.bmp');

PSNR(img1, y) 

PSNR(img1,img1)

