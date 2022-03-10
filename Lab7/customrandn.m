function Y = customrandn(mu,sigma)
%Generates pseudo-random number.
%This uses the function rand which draws a trial value from the 
% normal PDF: N(x;mu,sigma).
%It uses the following form: Y=sigma*X+mu
%X is the randn function in the form of N(x,0,1). mu is the mean and sigma is the standard deviation.

%Luis Mario Bres Castro, March 2022

Y=sigma*randn+mu;
end