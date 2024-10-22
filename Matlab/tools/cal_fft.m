function [f,P1] = cal_fft(X, Fs)
                 
    L = length(X);             % Length of signal
    Y = fft(X);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
end

