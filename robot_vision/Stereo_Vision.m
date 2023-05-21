
%世界座標
Xw = [0.5, -0.5, -0.5, 0.5, 0.5, 0.5, -0.5, -0.5];
Yw = [0.5, 0.5, -0.5, -0.5, -0.5, 0.5, 0.5, -0.5];
Zw = [0.5, 0.5, 0.5, 0.5, -0.5, -0.5, -0.5, -0.5];


% 讀取相機資料
load('uv_plus.mat');
load('uv_minus.mat');

% 相機内參矩陣
f = 1.2; % 焦距
alpha = 1; % 水平像素尺度因子
beta = 1; % 垂直像素尺度因子
k1 = 0; % 径向畸变系数
u0 = 0; % 水平光心偏移
v0 = 0; % 垂直光心偏移



%平移向量
T1 = [2,1,5];
T2 = [3,1,5];

% 外參矩陣
% 以(1,0,0)也就是x軸轉200度
R1 = [1 0 0 ; 0 cosd(200) -sind(200); 0 sind(200) cosd(200) ]; %修正 sin->sind , cos也是 (rad->deg)
H1 = [R1 T1'; 0 0 0 1];
% Rx(-20)
R1_2 = [1 0 0 ; 0 cosd(-20) -sind(-20); 0 sind(-20) cosd(-20) ];
T1_2 = [0 0 0];
H1_2 = [R1_2 T1_2'; 0 0 0 1];

%總和後
Hwc_plus = H1_2*H1;

% Rx(170)
R2 = [1 0 0 ; 0 cosd(170) -sind(170); 0 sind(170) cosd(170) ];
H2 = [R2 T2'; 0 0 0 1]; %修正，R1改成R2
% RY(20)
R2_2 = [cosd(20) 0 sind(20) ; 0 1 0; -sind(20) 0 cosd(20) ];%修正
T2_2 = [0 0 0];
H2_2 = [R2_2 T2_2'; 0 0 0 1];

%總和後
Hwc_minus = H2_2*H2; 

%%%%% 開始 (b) 小題 %%%%%
A =[alpha*f 0 u0 0; 0 beta*f v0 0; 0 0 1 0]; %修正成3*4


%驗算是否Hwc+-正確
% [R T] 留下最後一個row,也就是0 0 0 1 的部分 %修正
plus_matrix = [Hwc_plus(1:3,:); 0 0 0 1] ;
minus_matrix =[Hwc_minus(1:3,:); 0 0 0 1] ;
Pw = zeros(4,8); %世界座標的8個點
for i = 1:8
    Pw(:,i) = [Xw(i) Yw(i) Zw(i) 1]; %多一個1是為了和pinv(Hwc_plus)能夠相乘，避免維度不對
end
Pc_plus = pinv(Hwc_plus)*Pw; %轉換成相機座標
Pc_minus = pinv(Hwc_minus)*Pw;

f_matrix = [f 0 0 0;0 f 0 0; 0 0 1 0];
image_coord = f_matrix*Pc_plus; % Camera coordinate -> Image plane
image_coord_minus = f_matrix*Pc_minus;
for i=1:8
    image_coord(:,i) = image_coord(:,i)/image_coord(3,i);
    image_coord_minus(:,i) = image_coord_minus(:,i)/image_coord_minus(3,i);
end

I2Dconvert_martix = [alpha 0 u0 ; 0 beta v0; 0 0 1]; % Image plane -> Digital image
digital_plane = I2Dconvert_martix*image_coord;
digital_plane_minus = I2Dconvert_martix*image_coord_minus;


%關係矩陣  A*[R T]
relation_plus = A*pinv(Hwc_plus); %P+
relation_minus = A*pinv(Hwc_minus); %P-

%%%%% 開始 (c) 小題 %%%%%
% two-view scene reconstruction

world_points = zeros(3,34);

for i = 1:34
    V =  [skew(Digital_points_plus(:,i))*relation_plus ; skew(Digital_points_minus(:,i))*relation_minus ] ;
    %world_coord = V(:,1:3) \ -V(:,4);
    world_coord = pinv( V(:,1:3) ) * ( -V(:,4) );
    world_points(:,i) = world_coord;
end


% plot world points in different colors
plot_world_points(world_points, 'blue');

% set plot properties
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');

% plot function for world points with different colors
function plot_world_points(world_points, colors)
    scatter3(world_points(1,:), world_points(2,:), world_points(3,:), [], colors, 'filled');
    hold on;
end


function S = skew(v)
    S = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
end
