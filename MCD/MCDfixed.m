%Mock Data Challenge
%Luis Mario Bres Castro
addpath '/Users/luisbres/Desktop/Spring 2022/StatisticalMethods/Func&data'
addpath '/Users/luisbres/Desktop/Spring 2022/StatisticalMethods/SDMBIGDAT19-master/CODES'
addpath '/Users/luisbres/Desktop/Spring 2022/StatisticalMethods/Final4'

%Parameters
a1=[40, 100];

a2=[1, 50];


a3=[1, 15];


tn = 3;
%Vectors covering a1, a2, and a3 parameters
v1 = [randi(a1), randi(a2), randi(a3)];
v2 = [63,27,10]; %PSO values
v3 = [76,51,4];   %Random values

%TrainingData.mat and AnalysisData.mat
trainingData=load('TrainingData.mat');
tData=trainingData.trainData; %Training Data vector
sampFreq=trainingData.sampFreq; %Sampling Frequency
dataVec=load('AnalysisData.mat');
dataVec=dataVec.dataVec; %Analysis Data Vector

%Time vector
nSamples=length(dataVec);
dataLen=nSamples/sampFreq;
timeVec=(0:(nSamples-1))/sampFreq;


%Estimate PSD

[pxx,posFreq]=pwelch(tData,1024,[],[],sampFreq);

PSD = interp1(1:length(pxx),pxx,linspace(1,length(pxx),1025),'cubic');
posFreq = interp1(1:length(posFreq),posFreq,linspace(1,length(posFreq),1025),'linear');


%From SNRcalcMod1&2, to obtain LLR values for multiple noise realizations
M=1000;
H01=zeros(1,M);
H02=zeros(1,M);
H03=zeros(1,M);
sqrtPSD = sqrt(PSD);
b = fir2(100,posFreq/posFreq(end),sqrtPSD);

for i= 1:M 
    inNoise = randn(1,nSamples); 
    noiseVec = sqrt(sampFreq)*fftfilt(b,inNoise);
    H01(i) = glrtqcsig(noiseVec,timeVec,PSD,v1,sampFreq);
end

for i= 1:M 
    inNoise = randn(1,nSamples); 
    noiseVec = sqrt(sampFreq)*fftfilt(b,inNoise);
    H02(i) = glrtqcsig(noiseVec,timeVec,PSD,v2,sampFreq);
end

for i= 1:M 
    inNoise = randn(1,nSamples); 
    noiseVec = sqrt(sampFreq)*fftfilt(b,inNoise);
    H03(i) = glrtqcsig(noiseVec,timeVec,PSD,v3,sampFreq);
end
% GLRT for data files
Gamma1 = glrtqcsig(dataVec,timeVec,PSD,v1,sampFreq);
Gamma2 = glrtqcsig(dataVec,timeVec,PSD,v2,sampFreq);
Gamma3 = glrtqcsig(dataVec,timeVec,PSD,v3,sampFreq);

%Significance Results
alpha1 = sum(H01>=Gamma1)/M  %For Trial 1
alpha2 = sum(H02>=Gamma2)/M  %For Trial 2
alpha3 = sum(H03>=Gamma3)/M  %For Trial 3


%There is a detected signal, using parameters from PSO
%it was found that it was a significance of ~0 for trial 2.

%Calling PSO

% parameter structrue for glrtqc4pso
nite=2000;
nruns=8;
snr=1;
In = struct('timeVec',timeVec,...
                'time2',timeVec.^2,...
                'time3',timeVec.^3,...
                'dataY',dataVec,...
                'samplFreq',sampFreq,...
                'psdVec',PSD,...
                'snr',snr,...
                'rmin',[a1(1),a2(1),a3(1)],...
                'rmax',[a1(2),a2(2),a3(2)]);

psoParams = struct('steps',nite);
outStruct = glrtqcpso(In,psoParams,nruns);

% generate colored noise
filtOrdr = 100;

fl = floor(nSamples/10+1); 
noiseVec1 = statgaussnoisegen(nSamples+fl,[posFreq(:),PSD(:)],filtOrdr,sampFreq);
noiseVec1 = noiseVec1(fl+1:end);

% generate qc and normalize to snr
sigVec1 = crcbgenqcsig(timeVec,1,v2);
% norm of the signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sigVec1,sigVec1,sampFreq,PSD);
sigVec1 = snr*sigVec1/sqrt(normSigSqrd);

EstVec = noiseVec1 + sigVec1;
figure 
plot(timeVec,EstVec)
legend('Estimated Signal amplitude');
title('Estimated Signal');
ylabel('Amplitude');
xlabel('Time (s)');

figure
hold on
plot(timeVec,dataVec);
plot(timeVec,outStruct.bestSig)
hold off
legend('Analysis Data','PSO Best Data');
title('Data and Best Estimate');
ylabel('Amplitude');
xlabel('Time (s)');
disp(['Estimated parameters: a1=',num2str(outStruct.bestQcCoefs(1)),...
                          '; a2=',num2str(outStruct.bestQcCoefs(2)),...
                          '; a3=',num2str(outStruct.bestQcCoefs(3))]);

% figure
% for lpruns = 1:nruns
%     plot(timeVec,outStruct.allRunsOutput(lpruns).estSig);
% end
% hold off
% legend(['Estimated Signals from ',num2str(nruns),' runs']);
% title('Data, Signal, and Best Estimates');
% ylabel('Amplitude');
% xlabel('Time (s)');
