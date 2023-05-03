clc;clear;
% m=1 V0 = 1
m=1;V = 0.1;E =2;h_bar = 1.05*10^(-34);a = 10; 
k1 = (2*m*(E-V))^0.5/h_bar;
k2 = (2*m*E)^0.5/h_bar;
S11_up = (k1^2-k2^2)*exp(1i*a*(k1+k2))+(k2^2-k1^2)*exp(1i*a*(k1-k2));
S11_down = (-k2^2+2*k1*k2-k1^2)*exp(1i*a*(k1+k2))+(k2^2+2*k1*k2+k1^2)*exp(1i*a*(k1-k2));
S11 = S11_up/S11_down;
R =S11^2;
S21_left = (k1^2+2*k1*k2+k2^2)/4/k1/k2*exp(1i*a*(k2-k1))+(-k1^2+2*k1*k2-k2^2)/4/k1/k2*exp(1i*a*(-k2-k1));
S21_right = S11*((-k1^2+k2^2)/4/k1/k2*exp(1i*a*(k2-k1))+(k1^2-k2^2)/4/k1/k2*exp(1i*a*(-k2-k1)));
S21 = S21_left+S21_right;
T = S21^2;

