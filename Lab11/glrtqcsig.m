function llr = glrtqcsig(dataVec,timeVec,psdPosFreq,a)
%function llr = glrtqcsig(dataVec,timeVec,psdPosFreq,a,nSamples)
%FIXME Doc: There isn't any documentation of this function.
%SDM Follow Matlab or DATASCIENCE_COURSE function documentation style.

%Luis Mario Bres Castro
%Task 3
%FIXME Should not addpath inside a function
%addpath ../Func&data
% This is the target 
%% Parameters for data realization
% Number of samples and sampling frequency.
%FIXME Error: There should not be any hard-coded values in this function
%FIXME: The time stamps should be supplied as an input argument.
%FIXME: nSamples in the input argument is not needed since CRCBGENQCSIG handles the actual signal generation
%FIXME: Var: Variable name 'a' is poorly chosen
% sampFreq = 1024;
%SDM
sampFreq = 1/(timeVec(2)-timeVec(1));
% timeVec = (0:(nSamples-1))/sampFreq;
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
%FIXME Should not be printing out numbers from within this function
%disp(llr);


end