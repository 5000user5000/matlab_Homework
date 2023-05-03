numerator = [2,24,70];
denominator = [1,10,25,0];
sys = tf(numerator,denominator);
%bode(sys)
rlocus(sys)