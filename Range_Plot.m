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
%Pre-allocation of variables to optimize performance
Q_Cube=zeros(16,1024,4); 
I_Cube=zeros(16,1024,4);
fft2d_data=zeros(16,1024,4);
w=zeros(1024,1);
% Cube formation
for c = 0:1:15 %chirp index
    for a = 0:1:3 %antenna index
        Q_Cube(c+1,:, a+1) = Q(c*4096 + a*1024 + 1 : c*4096 + a*1024 + 1024);
        I_Cube(c+1,:, a+1) = I(c*4096 + a*1024 + 1 : c*4096 + a*1024 + 1024);
    end
end
% Hamming window generation
for n = 1:1:1024
    w(n) = 0.54 - 0.46 * cos(2*pi*n/(1024-1)); % Hamming window
     Q_Cube(:,n,:) = Q_Cube(:,n,:) .* w(n); % Multiply Q_Cube with the window
     I_Cube(:,n,:) = I_Cube(:,n,:) .* w(n); % Multiply I_Cube with the window
end
ADC_Cube = complex(I_Cube, Q_Cube); % Combine I_Cube and Q_Cube in I+jQ form
fft_1D = fft(ADC_Cube, 1024, 2); % Perform 1D FFT
% Perform 2D FFT
for ant = 1:1:4
    fft2d_data(:, :, ant) = fft(fft_1D(:, :, ant)); %performs non-coherent integration along the chirps
end
%mmwavelib implements the abs function using an optimized approach listed
%below however while using MATLAB, there is no intent of optimization
% fft2d_data_abs = max(abs(real(fft2d_data)), abs(imag(fft2d_data))) + min(abs(real(fft2d_data)), abs(imag(fft2d_data))) * 3/8;% this is exact implementation used by mmwavelib to calculate the abs value of the complex FFT values in detection matrix
fft2d_data_abs=abs(fft2d_data);
log2Abs32_data = round(log2(fft2d_data_abs) * 2^8); %the log2 is performed using MATLAB function however the mmwave sdk uses a lookup table, multiplication by 2^8 is to convert the fractional number into Q8 format, 16 bit number with first 8 bits for integer and last 8 digits for fraction. rounding is performed at the end to generate a whole number for ease of storage
detection_matrix = sum(log2Abs32_data, 3); % Perform non-coherent integration by summing along the third dimension
% Perform saturation to 16-bit range, the mmwavelib performs right shift to
% avoid saturation beyond 0xFFFF while reducing the size of adder by number
% of virtual antennas, which in this case is 04(1 Tx,04 Rx). This leads to
% performance optimization
detection_matrix = min(detection_matrix, 65535);
% Extract the range profile, zeroth doppler
range_profile = detection_matrix(1, :);
plot(range_profile); % Plot the range profile
xlabel('Range (bins)');
ylabel('Amplitude');
CFAR_Threshold_dB=20;
CFAR_Threshold_Lin=10^(CFAR_Threshold_dB/20);
CFAR_Threshold_Log2=log2(CFAR_Threshold_Lin);
CFAR_Threshold_Q8=round(CFAR_Threshold_Log2*2^8);
winLen = 4;
guardLen = 2;

% Assuming you have the detection matrix 'detection_matrix' and the CFAR threshold 'CFAR_Threshold_Q8'

numCols = size(detection_matrix, 2);

% Iterate over each range bin from index 9 to index 1000
for col = winLen+guardLen+1:numCols-winLen-guardLen
    sumWindow = 0;
    
    % Calculate the sum of cells within the window, excluding the guard cells
    for j = col-winLen-guardLen:col+winLen+guardLen
        guard_cells=col-guardLen:col+guardLen;
        if(~ismember(j, guard_cells))
            sumWindow = sumWindow + detection_matrix(1, j);
        end
    end
    
    % Calculate the average noise level within the window, excluding the guard cells
    averageNoise = sumWindow / (2 * winLen);
  
    % Check if the current cell exceeds the CFAR threshold
    if detection_matrix(1, col) > CFAR_Threshold_Q8 + averageNoise
        % Print the index of the range bin where the target is present
        disp(['Target detected at range bin: ', num2str(col)]);
    end
end
