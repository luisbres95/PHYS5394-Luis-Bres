%LLR after maximizing over amplitude parameter
%Luis Mario Bres Castro
function ssrVal = ssrqc1(x,params)
    %Generate normalized quadratic chirp
    phaseVec = x(1)*params.timeVec + x(2)*params.time2 + x(3)*params.time3;
    qc = sin(2*pi*phaseVec);
    % Inner product of signal with itself
    normSigSqrd = innerprodpsd(qc,qc,params.samplFreq,params.psdVec);
    % Normalization factor
    normFac = params.snr/sqrt(normSigSqrd);
    % Normalize qc signal
    qc = normFac*qc;
    
    %Compute fitness
    ssrVal = -innerprodpsd(params.dataY,qc,params.samplFreq,params.psdVec)^2;
end