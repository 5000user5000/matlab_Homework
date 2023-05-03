clc;clear;
Nd = 10^15;
Na =0;
Nc = 2.8*10^19;
Nv = 1.04*10^19;
Eg = 1.12;
k = 8.62 * 10^-5;

for i= 1:252 %必須為正數,不能用0
    T(i) = (i + 49); %50~300
    ni(i) = (Nc * Nv)^0.5*exp(-Eg/(2*k*T(i)));
    n0(i) = (Nd-Na)/2 + ( ( (Nd-Na)/2 )^2 + ni(i)^2 )^0.5;
    p(i) = (Na-Nd)/2 + ( ( (Na-Nd)/2 )^2 + ni(i)^2 )^0.5;
    
    n02(i) = ni(i)^2/p(i);
    Ef(i) = k*T(i)*log(Nd/ni(i));%log10(x)才是一般的log
   nd(i) = Nd/(1+10^19*exp((-0.6*Ef(i))/(k*T(i))));
end

figure
plot(T,n0-nd,"LineWidth",2);
xlabel('T','fontname','Times New Roman','fontsize',20);
ylabel('cm^-3','fontname','Times New Roman','fontsize',20);

figure
plot(T,Ef,T,-Ef,"LineWidth",2); %x y x2 y2
xlabel('T','fontname','Times New Roman','fontsize',20);
ylabel('Ef','fontname','Times New Roman','fontsize',20);

