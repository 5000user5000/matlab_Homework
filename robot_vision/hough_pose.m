load('pla_data.mat');

% 參數
f = 5; % 焦距
d = 5; % 圓半徑
s = 10; %方塊邊長


%%%  (a) 小題  %%%
% hough_transform，取得 a、b 參數
[a1,b1] = hough_transform(L1);
[a2,b2] = hough_transform(L2);
[a3,b3] = hough_transform(L3);


%%% (b) 小題 %%%

% 世界座標上的位置 (依序)P1~P7 (x，y ，z)
world_point = [
  0 0 0 ;  
  s 0 0 ;
  s 0 s ;
  0 0 s ;
  0 s 0 ;
  0 s s ;
  s s s ;
];




% image plane上的(依序)P1~P7 (X，Y)
image_point = [
    0.0841 , 1.7152 ;
    1.3391 , 1.4641 ;
    2.5292 , 0.9381 ;
    1.1133 , 1.1547 ;
   -0.3001 , 0.2001 ;
    0.4466 ,-0.7044 ;
    1.7722 ,-0.5907
    ];

% POINT
M = zeros(14,12);
for i =  1:7
    idx1 = 2*i - 1; %  1 3 5 7 ... 13
    idx2 = idx1+1 ; %  2 4 6 ... 14
    M(idx1,:) = [ f*world_point(i,1) f*world_point(i,2) f*world_point(i,3)  0  0  0 -image_point(i,1)*world_point(i,1) -image_point(i,1)*world_point(i,2) -image_point(i,1)*world_point(i,3) f  0  -image_point(i,1)] ;
    M(idx2,:) = [0 0 0 f*world_point(i,1) f*world_point(i,2) f*world_point(i,3) -image_point(i,2)*world_point(i,1) -image_point(i,2)*world_point(i,2) -image_point(i,2)*world_point(i,3) 0 f -image_point(i,2)] ;
end

% LINE
L1_N = [1 0 0]; % L1 的 世界座標的單位向量 A B C
L1_P = [0 0 0]; % L1 的 世界座標的起點 Px Py Pz
coeff1 = polyfit([image_point(1,1) image_point(2,1)] , [image_point(1,2) image_point(2,2)]  , 1);
L1_image_lineEQ = [ -coeff1(1)  1  -coeff1(2)] ; %image 上 L1 的線性方程， au + bv + c = 0 ， 此即 [ a b c ] ， b 指定為1

L2_N = [0 0 1];
L2_P = [s 0 0];
coeff2 = polyfit([image_point(2,1) image_point(3,1)] , [image_point(2,2) image_point(3,2)]  , 1);
L2_image_lineEQ = [ -coeff2(1)  1  -coeff2(2)] ; 

L3_N = [0 1 0];
L3_P = [s 0 s];
coeff3 = polyfit([image_point(3,1) image_point(7,1)] , [image_point(3,2) image_point(7,2)]  , 1);
L3_image_lineEQ = [ -coeff3(1)  1  -coeff3(2)] ; 

total_N = [L1_N ; L2_N ; L3_N ];
total_P = [L1_P ;  L2_P ;  L3_P];
total_image_lineEQ = [L1_image_lineEQ  ;  L2_image_lineEQ  ; L3_image_lineEQ];

H = zeros(6,12);
for i = 1:3
    idx1 = 2*i - 1;
    idx2 = idx1+1 ; 
    H(idx1,:) = [total_N(i,1)*total_image_lineEQ(i,1)*f  total_N(i,2)*total_image_lineEQ(i,1)*f  total_N(i,3)*total_image_lineEQ(i,1)*f ...
                 total_N(i,1)*total_image_lineEQ(i,2)*f  total_N(i,2)*total_image_lineEQ(i,2)*f  total_N(i,3)*total_image_lineEQ(i,2)*f ...
                 total_N(i,1)*total_image_lineEQ(i,3)    total_N(i,2)*total_image_lineEQ(i,3)    total_N(i,3)*total_image_lineEQ(i,3) ...
                 0                                       0                                       0  ...
    ];
   
    H(idx2,:) = [total_P(i,1)*total_image_lineEQ(i,1)*f  total_P(i,2)*total_image_lineEQ(i,1)*f  total_P(i,3)*total_image_lineEQ(i,1)*f ...
                 total_P(i,1)*total_image_lineEQ(i,2)*f  total_P(i,2)*total_image_lineEQ(i,2)*f  total_P(i,3)*total_image_lineEQ(i,2)*f ...
                 total_P(i,1)*total_image_lineEQ(i,3)  total_P(i,2)*total_image_lineEQ(i,3)  total_P(i,3)*total_image_lineEQ(i,3)  ...
                 total_image_lineEQ(i,1)*f                 total_image_lineEQ(i,2)*f                 total_image_lineEQ(i,3) ...
    ];


end

% circle
Nc = [0.433 -0.5 -0.75];
Oc = [7.9006 0.6699 26.3157];
No = [ 0 0 1];
Oo = [ s/2 s/2 s];

Q = zeros(6,12);
for i = 1:3
    idx_q = 3*i - 2; % 1 4 7 
    Q(i,idx_q:idx_q+2) = [No(1) No(2) No(3)] ;
    j = i+3; % 4 5 6
    Q(j,idx_q:idx_q+2) = [Oo(1) Oo(2) Oo(3)] ;
    Q(j,i+9) = 1;
end

k = [Nc Oc];

% 總計算
b = zeros(1,26); % (2k+2J+6l)*1
b(21:26) = k;

W = [M ; H ; Q];

% WV = b
%V = W \ b' ; % 這是使用LU分解來求解
V = lsqr(W,b'); % least-square ，和 W \ b 結果有些不同

R = [ V(1:3)' ; V(4:6)' ; V(7:9)' ] ;
T = V(10:12);

% 確認 inv(R)*R = I
% 建立3x3單位矩陣I
I = eye(3);
R_inv = inv(R);
result = R_inv * R; %很接近I

function [a_max, b_max] = hough_transform(points)
    % points: 2x12 matrix representing the (x, y) coordinates of 12 points
    % Returns the (a, b) values corresponding to the maximum vote count
    % Initialize vote accumulator
    max_vote = 0;
    vote = zeros(102, 300); % a  range from -50 to 50 ， b -130~130
    
    % Loop over all pairs of points
    for i = 1:12
        for a = -50:50
            % Calculate the b values for the line passing through the points
            x = points(1, i); 
            y = points(2, i);
            b = - a*x + y ;
            
            % Vote for (a, b)
            a_idx = a + 51; % shift to positive indices
            b_idx = round(b + 130);
            vote(a_idx, b_idx) = vote(a_idx, b_idx) + 1;
            
            % Update maximum vote count and corresponding (a, b) values
            if vote(a_idx, b_idx) > max_vote
                max_vote = vote(a_idx, b_idx);
                a_max = a ; % 注意這裡不是 a_idx，而是當前這個循環的a、b 值
                b_max = round(b);
            end
        end
    end
end



