function SigVec = AMSigGen_new(t,A,P)
%FIXME Doc: The documentation of the function was not updated.
%Generate an Amplitude Modulated Sinusoid Signal
%S=AMgenSig(time,Amp,freq0,freq1,psi0)
% Generates an Amplitude Modulated Sinisoid Signal S. 'time' is the vector of
% time stamps at which the samples of the signal are to be computed. 'Amp'
% is the amplitude multiplying the signal. 'freq0' is sampling frequency.
% 'freq1' is reference frequency. 'psi0' is the phase of the signal.
%P is the struct variable containing all of the signal parameters.
%Luis Mario Bres Castro, February 2022



SigVec=cos(2*pi*P.f1*t).*sin(2*pi*P.f0*t+P.psi0); 
SigVec=A*SigVec./norm(SigVec);
end