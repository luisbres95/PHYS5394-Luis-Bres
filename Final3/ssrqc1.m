%LLR after maximizing over amplitude parameter
function ssrVal = ssrqc1(x,params)
%FIXME Missing documentation. Supply help comments for this function.

    %Generate normalized quadratic chirp
    phaseVec = x(1)*params.time + x(2)*params.time2 + x(3)*params.time3;
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