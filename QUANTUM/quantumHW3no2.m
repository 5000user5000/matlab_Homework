clc;clear;
k = linspace(-pi, pi, 99);  % 0 < k < 3pi , crystal momentum.
E = linspace(0.1,  3.5, 99);% Energy.
[X, Y] = meshgrid(k, E); % meshgrid是把k E都換成99X99矩陣(X就是k 堆疊99層)
%%%
h_bar = 1.05*10^(-34);
me = 9.11*10^(-31);
a = 10;  b=1;   V=100;
p1 = me*V*b*a/(h_bar)^2*10^-40.3;
%%%

P = 5;                      % 2mU_0b/hbar^2.
Z = cos(X)  - ( p1 * pi * sinc( 5.12*a * sqrt(Y)/pi ) )  - cos( 5.12 *a* sqrt(Y) ); % sinc(x)  = sin(x)/x ;根號E而不是2mE/h^2,因為要調整到好看
contour(X, Y, Z,[0,0],'linewidth',2,'linecolor','k'); %x y座標,z值一樣連一線(等高線)
for i=1:3
  line((i-2)*[pi,pi],[0,3.5],'color','k','linestyle','--') %line([起點橫座標，終點橫座標],[起點縱座標，終點縱座標])
end

xlabel('k')
ylabel('E(k)')
%legend('cos(K) - P * sin(E) - cos(E)')
%title('Dispersion relation for periodic potential in extended zone.')