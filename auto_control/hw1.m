denominator = [1,19335.38457];
sys = tf(191669.8311,denominator);
w = logspace(-1,1000,10000);
[mag,phase] = bode(sys,w);
mag2 = 20*log10(squeeze(mag)); %https://ww2.mathworks.cn/matlabcentral/answers/37158-bode-magnitude 有寫到
%bode(sys,{1,1000});
figure(1);
subplot(2,1,1);
x = linspace(0,2.8,28);
gain = [18.42,20.42,20.42,20.42,20.51,20.51,20.83,20.83,20.83,20.83,20.98,21.21,21.21,21.21,21.21,21.29,21.29,21.29,21.29,21.29,21.14,21.14,21.14,21.36,21.44,24.58,21.29,21.44];
exp_phase = [14.40,14.40,21.6,86.4,72,43.2,100.8,115.2,129.6,72,79.2,172.8,93.6,201.6,108,115.2,244.8,129.6,136.8,144,0,158.4,165.6,345.6,360,360,194.4,201.6];
%loglog(w, mag2 ,x,gain,'gp');
loglog(w, squeeze(-phase) ,x,exp_phase,'gp');
%title('overall gain對頻率圖 (綠點是實驗值，藍線是理論值)')
title('overall phase對頻率圖 (綠點是實驗值，藍線是理論值*-1)')
xlabel('w (rad/s)') 
ylabel('phase (deg)') 
%text(1, 9.9129045, 'Added Point\uparrow', 'HorizontalAlignment','right', 'VerticalAlignment','top');
grid on