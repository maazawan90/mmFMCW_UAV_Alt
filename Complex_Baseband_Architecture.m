% BSD 3 Clause
% 
% Copyright (C) 2023 MAAZ ALI AWAN, maazawan90@hotmail.com
% 
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% 
% 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

close all
clear all
clc
% Define the frequency and sampling parameters
fc = 77e9;           % Carrier frequency, transmit signal (Hz)
fr = 76.99e9;        % Carrier frequency, receive signal (Hz)
fs = 2*fc;           % Sampling frequency (Hz)
t = 0:1/fs:1e-6;     % Time vector (s)

% Generate the in-phase and quadrature signals
I = cos(2*pi*fc*t).*cos(2*pi*fr*t);
Q = sin(2*pi*fc*t).*cos(2*pi*fr*t);

% Construct the complex signal
x = I + 1j*Q;

% Compute the FFT of the complex signal
X = fft(x);

% Shift the FFT so that the zero-frequency component is in the center
X_shifted = fftshift(X);

% Compute the frequency axis
f = (-fs/2:fs/length(X_shifted):fs/2-1);

% Plot the magnitude of the frequency domain representation
plot(f, abs(X_shifted));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of I/Q signal');
xlim([-15e6 15e6]);