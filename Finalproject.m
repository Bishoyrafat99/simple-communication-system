[y,Fs]=audioread('strings4.wav');
y=y(1:8*Fs);
t=0:8*Fs-1;
figure;
subplot(221);plot(t,y);grid on;title('time domain');
Y=fft(y);
Y=fftshift(Y);
Fvec=-8*Fs/2:8*Fs/2-1;
Ymag=abs(Y);
subplot(222);plot(Fvec,Ymag);grid on;title('signal magnitude');
Yphase=angle(Y);
subplot(223);plot(Fvec,Yphase);grid on;title('signal phase');
sound(y,Fs);
channel=[];
channel= [channel menu('choose your signal','delta','ExpOne','ExpTwo','chimpresp')];
switch channel
    case 1
        delta=[ones(1,1),zeros(1,8*Fs-1)];
        w=conv(y,delta);
        t1=0:16*Fs-2;figure;plot(t1,w);title('convolution 1');
        sound(w,Fs);
    case 2
        ExpOne=exp(-2*pi*5000*t);
        w=conv(y,ExpOne);
        t1=0:16*Fs-2;figure;plot(t1,w);title('convolution 2');
        sound(w,Fs);
    case 3
        ExpTwo=exp(-2*pi*1000*t);
        w=conv(y,ExpTwo);
        t1=0:16*Fs-2;figure;plot(t1,w);title('convolution 3');
        sound(w,Fs);
    case 4
        n=0:0.01:1;
        chimpresp=[2*ones(1,1),zeros(1,99),0.5*ones(1,1)];
        w=conv(chimpresp,y);
        t1=0:8*Fs/(8*Fs+99):8*Fs;figure;plot(t1,w);title('convolution 4');
        sound(w,Fs);
end
sigma=input('enter the value of sigma : ');
z=sigma*randn(1,length(w));
s=w+z;figure;plot(t1,s);title('noise time domain');
sound(s,Fs);
S=fft(s);
S=fftshift(S);
Svec=-length(w)/2:(length(w)/2)-1;
Smag=abs(S);
figure;
subplot(321);plot(Svec,Smag);grid on;title('noise freq domain magnitude');
Sphase=angle(S);
subplot(322);plot(Svec,Sphase);grid on;title('noise freq domain angle');
         % Design LPF %
f=linspace(-Fs/2,Fs/2,length(S));         
filter = input('do you want to filter the signal? [y/n] : ','s');
if isequal(filter,'y')           
       Ns = length(S)./Fs;           
       cut_off_F = Ns.*(Fs/2-3400);           
       q3=length(S)-cut_off_F +1;            
       zz=round( q3 );           
       S([1:cut_off_F zz:length(S)])=0;
       figure; subplot(2,2,[1 2])
       plot(f,abs(S));                 
       title('filtered signal,freq domain')        
       inverse=real(ifft(ifftshift(S))); 
       subplot(2,2,[3 4]); plot(t1,inverse)          
       title('filtered signal,time domain')          
       sound(inverse,Fs);
end       

