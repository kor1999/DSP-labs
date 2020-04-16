chdir('C:\Users\kor19\Desktop')
load("signal_with_noise_and_filtered.sod")
// Take the first channel
s = signal_with_noise
s = s(1, :)
// Plot
subplot(231)
plot(s)
xlabel("Time, n", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("Signal with noise in time domain", 'fontsize', 3)
xs2png(0, "signal_with_noise_time.png")
// close() // close immediately after saving


// Plot spectrum
// calculate frequencies
s_len = length(s)
frequencies = (0:s_len-1)/s_len * Fs;
// plot
subplot(232)
plot2d("nl", frequencies, abs(fft(s)), color("blue"))
xlabel("Frequency component, n", 'fontsize', 2)
ylabel("Freq Amplitude", 'fontsize', 2)
title("Signal with noise in frequency domain", 'fontsize', 3)
xs2png(0, "signal_with_noise_freq.png")
// close() // close immediately after saving


// N: integer length of FIR filter
// cutoff: fraction of Fs, at which frequencies are stopped
// stop_value: the value for frequencies in the stop band
// (after cutoff frequency)
// return: frequency representation of an ideal
// low pass FIR filter of length N+1 if N is even
// or N if N is odd

function H = iideal_lowpass()
    H = ones(1, 44100) * 0
    for i=1 : 44100
        if i > 3 & i < 30 | i > 44070 then
        //if i == 9 | i == 10 | i == 11 | i == 19 | i == 20 | i == 21 | i == 44089 | i == 44090 | i == 44091 | i == 44079 | i == 44080 | i == 44091 then
            arr(i) = 0;
        elseif i > 8000 & i < 36100 then
            arr(i) = 0;
        else 
            arr(i) = 1;
        end
    end
    H = arr'
    //H =  [1. arr flipdim(arr, 2)] 
endfunction     


// Plot ideal lowpass freq response
// calculate lowpass
// Filter will have length 257
//H_l = ideal_lowpass(256, 0.15, 0.);
H_l = iideal_lowpass();

// calculate frequencies
h_len = length(H_l)

// plot
subplot(233)
plot(H_l)
//plot2d("nn", frequencies, H_l, color("blue"))
xlabel("Frequency, Hz", 'fontsize', 2)
ylabel("Freq amplitude", 'fontsize', 2)
title("Frequency response of ideal low-pass filter", 'fontsize', 3)
xs2png(0, "ideal_lowpass_freq.png")
// close() // close immediately after saving



// Compute impulse response
// project into temporal domain
// imaginary part should be close to 0
h_l = real(ifft(H_l))

test1 = ones(1, 5) * 0
test1(1) = 1
test1(2) = 2
test1(3) = 3

h_l = [h_l(ceil(length(h_l)/2):length(h_l)), h_l(1:floor(length(h_l)/2))]
h_l = h_l .* window('hn', length(h_l), 8)

subplot(234)
plot2d('nn', 0:length(h_l)-1, h_l, color("blue"))
xlabel("Time, n", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("Impulse response of ideal low-pass filter", 'fontsize', 3)
xs2png(gcf(), "ideal_lowpass_time.png")

h_len = length(h_l)
frequencies = (0:h_len-1)/h_len * Fs;

subplot(235)
plot2d("nl", frequencies, abs(fft(h_l)), color("blue"))

s_len = length(s)
frequencies = (0:s_len-1)/s_len * Fs;
subplot(236)
plot2d("nl", frequencies, abs(fft(s)), color("red"))


final = convol(s, h_l)
s_len = length(final)
frequencies = (0:s_len-1)/s_len * Fs;
subplot(236)
plot2d("nl", frequencies, abs(fft(final)), color("blue"))

playsnd(final,44100)
savewave('final.wav ',final,44100)
