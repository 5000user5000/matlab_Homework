
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
H2 = [R1 T2'; 0 0 0 1];
% RY(20)
R2_2 = [0 0 sind(20) ; 0 1 0; -sind(20) 0 cosd(20) ];
T2_2 = [0 0 0];
H2_2 = [R2_2 T2_2'; 0 0 0 1];

%總和後
Hwc_minus = H2_2*H2; 

%%%%% 開始 (b) 小題 %%%%%
A =[alpha*f 0 u0 ; 0 beta*f v0 ; 0 0 1 ; 0 0 0]; %修正0 0 0



% [R T] 去除最後一個row,也就是0 0 0 1 的部分
plus_matrix = Hwc_plus(1:3,:);
minus_matrix = Hwc_minus(1:3,:);

%關係矩陣  A*[R T]
relation_plus = A*plus_matrix;
relation_minus = A*minus_matrix;

%%%%% 開始 (c) 小題 %%%%%
% two-view scene reconstruction

world_points = zeros(3,34);

for i = 1:34
    V =  [skew(Digital_points_plus(:,i))*relation_plus ; skew(Digital_points_minus(:,i))*relation_minus ] ;
    world_coord = V(:,1:3) \ -V(:,4);
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

