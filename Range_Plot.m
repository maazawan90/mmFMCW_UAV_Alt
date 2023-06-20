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

clc
clear all
close all

ADC_file = fopen('ADC_matrix.dat'); % Open ADC data file
ADC_temp = fscanf(ADC_file, '%d'); % Read ADC data
ADC_single = ADC_temp(7:end); % Extract relevant ADC data
Q = ADC_single(1:2:end); % Extract Q values
I = ADC_single(2:2:end); % Extract I values
fclose(ADC_file); % Close ADC data file

% Cube formation
for c = 0:1:15
    for a = 0:1:3
        Q_Cube(c+1, :, a+1) = Q(c*4096 + a*1024 + 1 : c*4096 + a*1024 + 1024);
        I_Cube(c+1, :, a+1) = I(c*4096 + a*1024 + 1 : c*4096 + a*1024 + 1024);
    end
end

% Hamming window generation
for n = 1:1:1024
    w(n) = 0.54 - 0.46 * cos(2*pi*n/(1024-1)); % Hamming window
end

ADC_Cube = complex(I_Cube, Q_Cube); % Combine I_Cube and Q_Cube in I+jQ form

fft_1D = fft(ADC_Cube, 1024, 2); % Perform 1D FFT

% Perform 2D FFT
for ant = 1:1:4
    fft2d_data(:, :, ant) = fft(fft_1D(:, :, ant)); %performs non-coherent integration along the chirps
end

detection_matrix = sum(abs(fft2d_data), [3]); % non-coherent integration along the antenna dimension

range_profile = detection_matrix(1, :); % Extract the range profile, zeroth doppler

plot(range_profile); % Plot the range profile
xlabel('Range (bins)');
ylabel('Amplitude');
