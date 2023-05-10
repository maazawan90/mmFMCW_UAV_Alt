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

close all; % Close all figures
clear all; % Clear all variables
clc; % Clear command window

% Given parameters
IF = 5e6; % Intermediate frequency in Hz
c = 3e8; % Speed of light in m/s
k=1.380649e-23; %Boltzmann's constant
T=333; %Temperature in Kelvin
F_dB=15; % Noise figure in dB
F= 10^(F_dB / 10);
Num_Chirps=16; %Number of chirps in a frame
S = 5e12; % Sweep bandwidth in Hz
t = 300e-6; % Sweep time in s
Tmeas=t*Num_Chirps; %Observation window as product of chirp duration and number of chirps
B = S * t; % Sweep bandwidth in Hz
Range = (IF * c) / (2 * S); % Maximum unambiguous range in meters
Resolution = c / (2 * B); % Range resolution in meters
Pt_dBm = 12; % Transmit power in dBm
freq = 78.5e9; % Operating frequency in Hz
RCS = 1093; % Radar cross section in m^2
R = 150; % Range in meters
% Calculating received power
Pt_dB = Pt_dBm - 30; % Transmit power in dB
Pt_w = 10^(Pt_dB / 10); % Transmit power in watts
Gt = 10.5; % Transmit antenna gain in dBi
Gr = 10.5; % Receive antenna gain in dBi
Gt_w = 10^(Gt / 10); % Transmit antenna gain in linear
Gr_w = 10^(Gr / 10); % Receive antenna gain in linear
lambda = c / freq; % Wavelength in meters
Pr = (Pt_w * Gt_w * Gr_w * (lambda^2) * RCS) / ((4 * pi)^3 * R^4); % Received power in watts
Pr_dBm = 10 * log10(Pr * 1000); % Received power in dBm
Noise_w= k*T*F/ Tmeas; %Noise power in Watts
Noise_dBm=30+10*log10(Noise_w);%Noise power in dBm
SNR=abs(Pr_dBm-Noise_dBm); %Signal to noise Ratio
% Displaying results
disp("Maximum unambiguous range (Rmax): " + Range + " m");
disp("Range resolution (delta_R): " + Resolution + " m");
disp("Received power (Pr): " + Pr_dBm + " dBm");
disp("Noise power (Pr): " + Noise_dBm + " dBm");
disp("SNR: " + SNR + " dB");