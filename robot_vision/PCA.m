
% 讀取圖像
I  = imread('Rainbow_Lory.jpg');
% 將圖像轉換成 double 類型 0~1，double()會是 0~255，但是顯示的圖很差
I = im2double(I);

% 像素值会在0到1之间
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

% 显示图像 (確認圖片正常)
%imshow(I);

% 平均值
mean_R  = mean(R,'all');
mean_G  = mean(G,'all');
mean_B  = mean(B,'all');

 % 用成列向量
R_vec = reshape(R, 1, 852*852);
G_vec = reshape(G, 1, 852 * 852);
B_vec = reshape(B, 1, 852 * 852);

% 扣除平均
R_hat = R_vec - mean_R;
G_hat = G_vec - mean_G;
B_hat = B_vec - mean_B;

% 取得 covariance matrix
x = [R_hat ; G_hat ; B_hat];
C = x*x'/(852*852);

% 取得特徵值
[V,D] = eig(C);

% 取出每个特征向量和特征值 (特徵值要大到小)
eigvec_1 = V(:, 3); %特徵值最大
eigval_1 = D(3, 3);


eigvec_2 = V(:, 2);
eigval_2 = D(2, 2);

eigvec_3 = V(:, 1);
eigval_3 = D(1, 1);



% step 4
A = [eigvec_1' ; eigvec_2' ; eigvec_3'];
P = A*x;

% 用成T1~T3
T1 = reshape(P(1,:),[852,852]);
T2 = reshape(P(2,:),[852,852]);
T3 = reshape(P(3,:),[852,852]);

new_pciture = [T1;T2;T3];
imshow(new_pciture);


