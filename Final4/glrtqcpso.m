function O = glrtqcpso(I,P,N)

%O = CRCBQCPPSO(I,P,N)
%I is the input struct with the fields given below.  P is the PSO parameter
%struct. Setting P to [] will invoke default parameters (see CRCBPSO). N is
%the number of independent PSO runs. The output is returned in the struct
%O. The fields of I are:
% 'dataY': The data vector (a uniformly sampled time series).
% 'dataX': The time stamps of the data samples.
% 'dataXSq': dataX.^2
% 'dataXCb': dataX.^3
% 'rmin', 'rmax': The minimum and maximum values of the three parameters
%                 a1, a2, a3 in the candidate signal:
%                 a1*dataX+a2*dataXSq+a3*dataXCb
%The fields of O are:
% 'allRunsOutput': An N element struct array containing results from each PSO
%              run. The fields of this struct are:
%                 'fitVal': The fitness value.
%                 'qcCoefs': The coefficients [a1, a2, a3].
%                 'estSig': The estimated signal.
%                 'totalFuncEvals': The total number of fitness
%                                   evaluations.

%Luis Mario Bres Castro

nSamples = length(I.timeVec);

fHandle = @(x) glrtqcsig4pso(x,I);

nDim = 3;
outStruct = struct('bestLocation',[],...
                   'bestFitness', [],...
                   'totalFuncEvals',[]);
                    
O = struct('allRunsOutput',struct('fitVal', [],...
                                           'qcCoefs',zeros(1,3),...
                                           'estSig',zeros(1,nSamples),...
                                           'totalFuncEvals',[]),...
                    'bestRun',[],...
                    'bestFitness',[],...
                    'bestSig', zeros(1,nSamples),...
                    'bestQcCoefs',zeros(1,3));

%Allocate storage for outputs: results from all runs are stored
for lpruns = 1:N
    outStruct(lpruns) = outStruct(1);
    O.allRunsOutput(lpruns) = O.allRunsOutput(1);
end
%Independent runs of PSO in parallel. Change 'parfor' to 'for' if the
%parallel computing toolbox is not available.
parfor lpruns = 1:N
    %Reset random number generator for each worker
    rng(lpruns);
    outStruct(lpruns)=crcbpso(fHandle,nDim,P);
end

%Prepare output
fitVal = zeros(1,N);
for lpruns = 1:N   
    fitVal(lpruns) = outStruct(lpruns).bestFitness;
    O.allRunsOutput(lpruns).fitVal = fitVal(lpruns);
    [~,qcCoefs] = fHandle(outStruct(lpruns).bestLocation);
    O.allRunsOutput(lpruns).qcCoefs = qcCoefs;
    estSig = crcbgenqcsig(I.timeVec,1,qcCoefs);
    
    normSigSq = innerprodpsd(estSig,estSig,I.samplFreq,I.psdVec);
    
    normFac = 1/sqrt(normSigSq);
    estSig = normFac*estSig;
    estAmp = innerprodpsd(I.dataY,estSig,I.samplFreq,I.psdVec);
    estSig = estAmp*estSig;
    O.allRunsOutput(lpruns).estSig = estSig;
    O.allRunsOutput(lpruns).totalFuncEvals = outStruct(lpruns).totalFuncEvals;
end
%Find the best run
[~,bestRun] = min(fitVal(:));
O.bestRun = bestRun;
O.bestFitness = O.allRunsOutput(bestRun).fitVal;
O.bestSig = O.allRunsOutput(bestRun).estSig;
O.bestQcCoefs = O.allRunsOutput(bestRun).qcCoefs;

end