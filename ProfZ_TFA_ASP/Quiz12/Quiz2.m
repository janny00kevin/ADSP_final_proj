%% Quiz 2: Time-Frequency Analysis of Music. One is the original music and the other one is the sound recorded by parametric speaker (Google it!)
clear all 

%%% Read out two music (fs is the sampling frequency)
[org_music fs] = audioread('org.mp4'); %original music
[par_music fs] = audioread('par.mp4'); % parametric sound

N1 = length(org_music);  % length of the data
N2 = length(par_music);  %  N1 is the same as N2
t_indx = [0:1:N1-1]*1/fs;  % time index in second
%%
%%% Question 2.1: Display waveform and spectrum
figure
plot(t_indx, org_music)
hold on
plot(t_indx, par_music)
xlabel('Time (s)')
ylabel('Magnitude')
title('Time-domain waveform comparison')
legend('Original music','Parametric sound')

%%% FFT of both music 
f_org = fft(org_music);
f_par = fft(par_music);

figure
plot(([0:1:N1-1]/N1-0.5)*fs,20*log10(abs(fftshift(f_org))))
hold on
plot(([0:1:N1-1]/N1-0.5)*fs,20*log10(abs(fftshift(f_par))))
xlim([0 2000])  % confine the display frequency range
ylim([-20 80])  % confine the display magnitude
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Spectrum comparision')
legend('Original music','Parametric sound')

%%
%%% Question 2.2
%%% Time-frequency analysis (Complete all codes and display the STFT results)  
%%% Note1: You can use MATLAB "stft" function or write
%%% STFT by yourself, but you need to specific the following four
%%% parameters: Window size, Windowing function, FFT length, Overlapping
%%% length.
       
%%% Note2: Because the analysis is time comsuming, you can crop your data
%%% to be a length of 220000 (roughly 5 seconds).

%%% Note3: Display your STFT result in dB within the frequency range of 0-4000 Hz. 

w_len = 1024;  % window size for STFT
win = hann(w_len) ;  % Windowing function  
fft_len = 2048;  % FFT length for STFT (can be different from the window size).
OverlapLength = w_len/2;  % Overlapping window length between two STFT analses. 

crop_length = 220000; % roughly 5 seconds
org_music_crop = org_music(1:crop_length);
par_music_crop = par_music(1:crop_length);
t_indx_crop = t_indx(1:crop_length);

%%% STFT of original music
[s_org, f_org, t_org] = stft(org_music_crop, fs, 'Window', win, 'OverlapLength', OverlapLength, 'FFTLength', fft_len);
%%% STFT of parametric sound
[s_par, f_par, t_par] = stft(par_music_crop, fs, 'Window', win, 'OverlapLength', OverlapLength, 'FFTLength', fft_len);

%%% Convert the STFT result to dB
s_org_dB = 20*log10(abs(s_org));
s_par_dB = 20*log10(abs(s_par));

%%% Display STFT results within the frequency range of 0-4000 Hz
figure
subplot(2,1,1)
surf(t_org, f_org, s_org_dB, 'EdgeColor', 'none');
axis tight
view(0, 90)
xlim([0 max(t_org)])
ylim([0 4000])
colorbar
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('STFT of Original Music (dB)')

subplot(2,1,2)
surf(t_par, f_par, s_par_dB, 'EdgeColor', 'none');
axis tight
view(0, 90)
xlim([0 max(t_par)])
ylim([0 4000])
colorbar
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('STFT of Parametric Sound (dB)')

%%
%%% Question 2.3.  Improve the parametric sound by filtering. Complete your
%%% design below, and output the sound as a mp4 file using the following
%%% function.

% Designing a Butterworth low-pass filter
lowFreq = 200;
highFreq = 600; % Cutoff frequency in Hz
filterOrder = 4; % Filter order (adjustable parameter)

% Design the filter
[b, a] = butter(filterOrder, [lowFreq/(fs/2), highFreq/(fs/2)], 'bandpass');

% Apply the filter to the parametric music
par_music_imp =8*filter(b, a, par_music) + par_music;

audiowrite('par_improvement.mp4',par_music_imp,fs);



par_music_imp_crop = par_music_imp(1:crop_length);
%%% STFT of parametric sound
[s_imp, f_imp, t_imp] = stft(par_music_imp_crop, fs, 'Window', win, 'OverlapLength', OverlapLength, 'FFTLength', fft_len);
s_imp_dB = 20*log10(abs(s_imp));

figure
subplot(2,1,1)
surf(t_org, f_org, s_org_dB, 'EdgeColor', 'none');
axis tight
view(0, 90)
xlim([0 max(t_org)])
ylim([0 4000])
colorbar
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('STFT of Original Music (dB)')

subplot(2,1,2)
surf(t_imp, f_imp, s_imp_dB, 'EdgeColor', 'none');
axis tight
view(0, 90)
xlim([0 max(t_imp)])
ylim([0 4000])
colorbar
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('STFT of Improved Parametric Sound (dB)')
