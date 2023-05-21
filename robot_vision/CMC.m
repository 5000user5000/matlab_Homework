% 讀取相機校準資料
load('camera_calibration_data.mat');

%必要參數
u0 = 3; % x 軸主點位置
v0 = 3; % y 軸主點位置
u_ = 1; % u'，cropped image x origin
v_ = 1; % v'，cropped image y origin
alpha = 1; % x 軸單位長度的像素（pixel/mm）
beta = 1; % y 軸單位長度的像素（pixel/mm）

% 將裁切坐標轉回為相片座標(XY)
X = (u + u_ - u0)/alpha; %修正
Y = (v + v_ - v0)/beta;  %修正

% two-stage

% step1
A = zeros(8, 5); % 初始化 8x5 的矩陣 A
% 把元素補上
for i = 1:8
    A(i,:) = [Xw(i)*Y(i), Yw(i)*Y(i), -Xw(i)*X(i), -Yw(i)*X(i), Y(i)];
end

% Aµ = u
%mu = A \ u.' ; % 矩陣左除（\）運算符 ， 转置矩陣(.') 把1*8的u轉成8*1
%mu = lsqr(A,X'); %least square (結果和上面的一樣) ，修正不是用u'而是X' (因為要用image座標，而非裁切座標)
mu = pinv(A)*X';

%U = sum(mu.^2); % mu所有元素平方和
U = mu(1)^2 + mu(2)^2 + mu(3)^2 + mu(4)^2; %應該是mu 1~4的平方和

threshold = mu(1)*mu(4)- mu(2)*mu(3) ; % 決定Ty的條件，暫定叫threshold

% 求Ty
if threshold == 0
    Ty = sqrt(1/U) ;
else 
    numerator = U - sqrt( U^2 - 4*(threshold)^2  ) ; %修正，外圍不用sqrt()
    denominator = 2*(threshold)^2;
    Ty = sqrt( numerator/denominator );
end

%check Ty正負
% P點選擇 世界座標第二個點
zeta_x = mu(1)*Ty*Xw(2) + mu(2)*Ty*Yw(2) + mu(5)*Ty;
zeta_y = mu(3)*Ty*Xw(2) + mu(4)*Ty*Yw(2) + Ty;

if zeta_x < 0 || zeta_y < 0
    Ty = -Ty;
end

% 求轉移矩陣 R
R = zeros(3,3);
R(1,1) = mu(1)*Ty;
R(1,2) = mu(2)*Ty;
R(1,3) = sqrt( 1 - R(1,1)^2 - R(1,2)^2 ) ;
R(2,1) = mu(3)*Ty;
R(2,2) = mu(4)*Ty;
R(2,3) = sqrt( 1 - R(2,1)^2 - R(2,2)^2 );

if ( R(1,1)*R(2,1) + R(1,2)*R(2,2) ) > 0
    R(2,3) = -R(2,3);
end

R(3,1) = R(1,2)*R(2,3) - R(1,3)*R(2,2);
R(3,2) = R(1,3)*R(2,1) - R(1,1)*R(2,3);
R(3,3) = R(1,1)*R(2,2) - R(1,2)*R(2,1);

% 求f，Tz %修正
B = zeros(8, 3); % 初始化 8x3 的矩陣 B
C = zeros(8,1); 
Tx = mu(5)*Ty;
for i = 1:8
    x_wave = R(1,1)*Xw(i)+R(1,2)*Yw(i)+Tx;
    B(i,:) = [x_wave  (u(i)^2+v(i)^2)*x_wave  -u(i)];
    C(i,:) =  ( R(3,1)*Xw(i) + R(3,2)*Yw(i) ) * u(i) ;
end
%param = B \ C; %結果和下面的least square相同
%param = lsqr(B,C);
param = pinv(B)*C;

f = param(1);
Tz = param(3);

T = zeros(3,1);
T(1) = Tx;
T(2) = Ty;
T(3) = Tz;
