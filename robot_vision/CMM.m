% 內部參數
f = 2; % 焦距
alpha = 1; % x 軸單位長度的像素（pixel/mm）
beta = 1; % y 軸單位長度的像素（pixel/mm）
u0 = 3; % x 軸主點位置
v0 = 3; % y 軸主點位置
k1 = 0; % 畸變參數
u_ = 1; % u'，cropped image x origin
v_ = 1; % v'，cropped image y origin

% 外部參數
R = rotx(150); % 旋轉矩陣
T = [0, 2.5, 4.3]; % 平移向量

% 世界座標系下的特徵點坐標
Xw = [0.667,0.4714,0,-0.4714,-0.6667,-0.4714,0,0.4714];
Yw = [0,0.4714,0.6667,0.4714,0,-0.4714,-0.6667,-0.4714];
Zw = [0 ,0, 0, 0, 0, 0, 0, 0];

% 將 3D 特徵點轉換為相機座標系下的坐標
Xc = R(1,1)*Xw + R(1,2)*Yw + R(1,3)*Zw + T(1);
Yc = R(2,1)*Xw + R(2,2)*Yw + R(2,3)*Zw + T(2);
Zc = R(3,1)*Xw + R(3,2)*Yw + R(3,3)*Zw + T(3);

% 將相機座標系下的坐標轉換為相片座標(XY)
X = f*Xc ./Zc ; % ./是矩陣運算符號，表示對矩陣進行逐元素除法運算
Y = f*Yc ./Zc ;

% 轉到裁切影像座標(uv)，單位pixel
u = alpha*X + u0 - u_ ; %修正
v = beta*Y + v0 - v_ ;  %修正

% 顯示像素座標
disp([u;v]);

%作圖
plot(u,v);
%plot(Xw,Yw);

%儲存
save("camera_calibration_data.mat","u","v","Xw","Yw"); %變數也要雙引號