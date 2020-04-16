
[ss, Fss, _] = wavread("1a_marble_hall.wav")
ss = ss(1, 1:length(ss)/2)

ss_fft = fft(ss)
ss_inv = 1./ss_fft
h_l = ifft(ss_inv)

h_l = [h_l(ceil(length(h_l)/2):length(h_l)), h_l(1:floor(length(h_l)/2))]
h_l = h_l .* window('kr', length(h_l), 8)

[s, Fs, _] = wavread("7cef8230.wav")
s = s(1, :)

sss = convol(ss, s)//clear with irc
final = convol(sss, h_l) //echo with reversed echo


plot2d("nn", 1:length(sss), sss, color("green"))
plot2d("nn", 1:length(final), final, color("red"))
xlabel("Time, t", 'fontsize', 2)
ylabel("Freq Amplitude", 'fontsize', 2)

playsnd(final,44100)
savewave('finalTask2.wav ',final,44100)

