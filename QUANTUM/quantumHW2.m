clc;clear;
%x = linspace(0, 10);
m=1;V = 0.1;h_bar = 1.05*10^(-34);a = 10;
%k2 = (2*m*V*x)/h_bar;
for x1 = 1:101
    x(x1) = (x1-1);
    y(x1) = 4*x(x1)*(x(x1)-1)/(4*x(x1)*(x(x1)-1)+sin((2*m*V*x(x1))/h_bar*a)^2);
end


figure
plot(x,y,x,1-y,"LineWidth",2);
xlabel('E/V0','fontname','Times New Roman','fontsize',20);
ylabel('T or R','fontname','Times New Roman','fontsize',20);