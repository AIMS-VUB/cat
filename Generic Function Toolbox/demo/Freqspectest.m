%% Simpele sinus met sympathieke samplingfrequentie
Fs = 1024;
sinusfreq = 10;
amp = 2;

t = 0.001:(1/Fs):1.000;
x = amp*sin(2*pi*sinusfreq*t);
figure, plot(t, x);

[X, f] = freqspec(x, Fs);

figure, plot(f, X);

%% Specifiek voorbeeld
Fs = 1/3;
sinusfreq = 1/30;
amp = 2;

N = 150;
t = (1:N)/Fs;
x = amp*sin(2*pi*sinusfreq*t);

l = N/2;
f = Fs/N*(0:l);
Y = fft(x)/l;
Y = Y.*conj(Y);
figure, plot(f, Y(1:l+1));

[Z, fz] = freqspec(x, Fs);
figure, plot(fz, Z);

%Haha