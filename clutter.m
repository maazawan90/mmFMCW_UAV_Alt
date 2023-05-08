
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
R=150;
az=60;
el=30;
c=3e8;
freq=78.5e9;
rcs=zeros(10,90);
nrcs_type(1)= ["Rugged Mountains"];
nrcs_type(2)= ["Mountains"];
nrcs_type(3)= ["Urban"];
nrcs_type(4)= ["Wooded Hills"];
nrcs_type(5)= ["Rolling Hills"];
nrcs_type(6)= ["Woods"];
nrcs_type(7)= ["Farm"];
nrcs_type(8)= ["Desert"];
nrcs_type(9)= ["Flatland"];
nrcs_type(10)= ["Smooth"];
for count=1:1:10
for graz=1:1:90    
nrcs_num(count,graz) = landreflectivity(nrcs_type(count),graz,freq);
end
end
for count=1:1:10
for graz=1:1:90    
rcs(count,graz) = surfclutterrcs(nrcs_num(count,graz),R,az,el,90,0.1,c);
end
end
graz=1:1:90;
for p=1:1:10
hold on
plot(graz,rcs(p,:),'DisplayName',nrcs_type(p)); 
legend
end
 
