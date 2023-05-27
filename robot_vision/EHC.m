load('hand_eye_data.mat');

%%%% 第一小題 %%%%
Hc12 = Hc2 / Hc1; % Hc12 = Hc2 * inv( Hc1 )
Hg12 =Hg2 \ Hg1; %H g12 =inv(Hg2)*Hg1

Hc23 =  Hc3 / Hc2;
Hg23 =Hg3 \ Hg2;

Rc12 = Hc12(1:3, 1:3);
Tc12 = Hc12(1:3, 4);

Rc23 = Hc23(1:3, 1:3);
Tc23 = Hc23(1:3, 4);

Rg12 = Hg12(1:3, 1:3);
Tg12 = Hg12(1:3, 4);

Rg23 = Hg23(1:3, 1:3);
Tg23 = Hg23(1:3, 4);

%%%%  第二小題 %%%%

% theta c12
cos_theta_c12 = ( Rc12(1,1) + Rc12(2,2) + Rc12(3,3) - 1 ) / 2 ;
theta_c12 = acosd(cos_theta_c12); % 單位 acosd是degree ，acos是 rad

% theta g12
cos_theta_g12 = ( Rg12(1,1) + Rg12(2,2) + Rg12(3,3) - 1 ) / 2 ;
theta_g12 = acosd(cos_theta_g12); % 單位 acosd是degree ，acos是 rad

% theta c23
cos_theta_c23 = ( Rc23(1,1) + Rc23(2,2) + Rc23(3,3) - 1 ) / 2 ;
theta_c23 = acosd(cos_theta_c23); % 單位 acosd是degree ，acos是 rad

% theta g23
cos_theta_g23 = ( Rg23(1,1) + Rg23(2,2) + Rg23(3,3) - 1 ) / 2 ;
theta_g23 = acosd(cos_theta_g23); % 單位 acosd是degree ，acos是 rad

% Nr for c12
Nr_c12 = [Rc12(3,2) - Rc12(2,3) ; Rc12(1,3) - Rc12(3,1) ; Rc12(2,1) - Rc12(1,2) ];
Nr_c12 = Nr_c12/(2*sind(theta_c12)); % sind for degree ， sin for rad

% Nr for g12
Nr_g12 = [Rg12(3,2) - Rg12(2,3) ; Rg12(1,3) - Rg12(3,1) ; Rg12(2,1) - Rg12(1,2) ];
Nr_g12 = Nr_g12/(2*sind(theta_g12));

% Nr for c23
Nr_c23 = [Rc23(3,2) - Rc23(2,3) ; Rc23(1,3) - Rc23(3,1) ; Rc23(2,1) - Rc23(1,2) ];
Nr_c23 = Nr_c23/(2*sind(theta_c23)); % sind for degree ， sin for rad

% Nr for g23
Nr_g23 = [Rg23(3,2) - Rg23(2,3) ; Rg23(1,3) - Rg23(3,1) ; Rg23(2,1) - Rg23(1,2) ];
Nr_g23 = Nr_g23/(2*sind(theta_g23));


% Pr for c
Pr_c12 = 2*sind(theta_c12/2) * Nr_c12;
Pr_g12 = 2*sind(theta_g12/2) * Nr_g12;
Pr_c23 = 2*sind(theta_c23/2) * Nr_c23;
Pr_g23 = 2*sind(theta_g23/2) * Nr_g23;


%%%%  第三小題 %%%%
%Pcg_prime = lsqr (skew(Pr_g + Pr_c), ( Pr_c - Pr_g ) );
skew_set = [skew(Pr_g12 + Pr_c12) ; skew(Pr_g23 + Pr_c23)];
another_set = [( Pr_c12 - Pr_g12 ) ; ( Pr_c23 - Pr_g23 )];
Pcg_prime = pinv(skew_set)*another_set; %偽逆求解

distances = sqrt(sum(Pcg_prime.^2)); % 計算矩陣大小，Frobenius 范數
%distances = sum( abs(Pcg_prime) ); %用絕對值

theta_Rcg = 2*atand(distances);
Pcg = 2*Pcg_prime /( sqrt( 1 + distances^2) );

%%%%  第四小題 %%%%

identity_matrix = eye(3); % 3*3的單位矩陣
alpha = sqrt(4-sum(Pcg.^2));
%alpha = sqrt(4 - sum( abs(Pcg) )^2);
R_cg = (1 - sum(Pcg.^2)/2)*identity_matrix + 0.5*(Pcg*Pcg' + alpha*skew(Pcg));
%R_cg = (1 - sum(abs(Pcg))^2/2)*identity_matrix + 0.5*(Pcg*Pcg' + alpha*skew(Pcg));

%T_cg = lsqr ( (Rg12 - identity_matrix) , ( R_cg*Tc12-Tg12 ) ) ;
R_set = [Rg12 - identity_matrix ; Rg23 - identity_matrix ];
RT_set = [R_cg*Tc12 - Tg12 ; R_cg*Tc23 - Tg23 ];
T_cg = pinv(R_set)*(RT_set);


%%% skew() 函式
function S = skew(v)
    S = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
end






