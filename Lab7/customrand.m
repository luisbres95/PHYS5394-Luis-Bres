function Y = customrand(a,b)
%Generates pseudo-random number with boundaries of a and b.
%This uses the function rand which draws a trial value from the 
% uniform PDF: U(x;0,1).
%It uses the following form: Y=(b-a)*X+a
%X is the rand function in the form of U(x,0,1). b and a are the limits.

%Luis Mario Bres Castro, March 2022

Y=(b-a)*rand+a;
end 
