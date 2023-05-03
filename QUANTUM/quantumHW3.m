clc;clear;
h_bar = 1.05*10^(-34);
me = 9.11*10^(-31);
a = 10;b=1;V=100;

p1 = me*V*b*a/(h_bar)^2;
n =1;

for i=1:121
    x(i) = (i-60);
    e(i) = (i)/10;
    ep2(i) = (x(i)/a*h_bar)^2/(2*me);  % beta gama
    x2(i) = (2*me*a^2*e(i))^0.5/h_bar*10^-20;
    up(i) = 1;
    down(i) = -1;
    
    p(i) = p1/(x2(i))*sin(x2(i))+cos(x2(i));
    alpha(i) = x(i)/a; %題目的alpha是定值,其實題目根本沒有給E,所以E是變數,alpha*a-> alpha = x/a
    %alpha(i) = x2(i)/a;
    beta(i) = (2*me*(ep2(i)-V))^0.5/h_bar;
    %beta(i) = (2*me*(e(i)-V))^0.5/h_bar;
    gama(i) = (2*me*(V- ep2(i)))^0.5/h_bar;
    %gama(i) = (2*me*(V- e(i)))^0.5/h_bar;
    
    theta(i) = atan(-(alpha(i)^2+ beta(i)^2)/(2*alpha(i)*beta(i))*tan(beta(i)*b));
    psi(i) = atan((alpha(i)^2+ gama(i)^2)/(2*alpha(i)*gama(i))*tan(gama(i)*b));
    if x(i) > V
         p2(i) = ( 1+ (alpha(i)^2-beta(i)^2)^2/(4*alpha(i)^2*beta(i)^2)*sin(beta(i)*b)^2 )^0.5*cos(x(i)-theta(i));
    else 
         p2(i) = ( 1+ (alpha(i)^2+gama(i)^2)^2/(4*alpha(i)^2*gama(i)^2)*sin(gama(i)*b)^2 )^0.5*cos(x(i)-psi(i));
    end
    k(i) = acos(p2(i))/(a+b);
    k2(i) = acos(p(i))/a;
    A(i) = x(i)/(x(i)^2+81*pi^2)^0.5; % 此為cos(..),把p合成為cos(k(a+b))所添加
    E(i) = (h_bar*x(i)*pi/a)^2/(2*me)*10^36-0.5*cos(2*pi*x(i)/a);
      
    
end

%figure
%plot(x,p2,x,up,x,down,"LineWidth",2);
%xlabel('αa','fontname','Times New Roman','fontsize',20);
%ylabel('f(αa)p2','fontname','Times New Roman','fontsize',20);

figure
plot(x,E*10,x,up,x,down,"LineWidth",2);
xlabel('k','fontname','Times New Roman','fontsize',20);
ylabel('E','fontname','Times New Roman','fontsize',20);

%figure
%plot(x,p,x,up,x,down,"LineWidth",2);
%xlabel('αa','fontname','Times New Roman','fontsize',20);
%ylabel('f(αa)','fontname','Times New Roman','fontsize',20);





