function llr = glrtqcsig(dataVec,timeVec,psdPosFreq,a,sampFreq)
%Luis Mario Bres Castro
%Task 3
addpath ../Func&data
% This is the target 
%% Parameters for data realization
% Number of samples and sampling frequency.



A=1;
%% Compute GLRT
%Generate the unit norm signal (i.e., template). Here, the value used for
%'A' does not matter because we are going to normalize the signal anyway.
%Note: the GLRT here is for the unknown amplitude case, that is all other
%signal parameters are known
sigVec = crcbgenqcsig(timeVec,A,[a(1),a(2),a(3)]);
%We do not need the normalization factor, just the  template vector
[templateVec,~] = normsig4psd(sigVec,sampFreq,psdPosFreq,1);
% Calculate inner product of data with template
llr = innerprodpsd(dataVec,templateVec,sampFreq,psdPosFreq);
%GLRT is its square
llr = llr^2;
disp(llr);


end