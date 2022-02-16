function SigVec = AMgenSig(t,A,f0,f1,psi0)

%Generate an Amplitude Modulated Sinusoid Signal
%S=AMgenSig(time,Amp,freq0,freq1,psi0)
% Generates an Amplitude Modulated Sinisoid Signal S. 'time' is the vector of
% time stamps at which the samples of the signal are to be computed. 'Amp'
% is the amplitude multiplying the signal. 'freq0' is sampling frequency.
% 'freq1' is reference frequency.
%FIXME Doc: Explain psi0 also.

%Luis Mario Bres Castro, February 2022


SigVec=cos(2*pi*f1*t).*sin(2*pi*f0*t+psi0); 
SigVec=A*SigVec./norm(SigVec);
end