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
 