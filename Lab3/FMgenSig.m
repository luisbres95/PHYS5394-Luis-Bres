function SigVec = FMgenSig(t,A,b,f0,f1)

%Generate a Frequency Modulated Sinusoid Signal
%S=FMgenSig(time,Amp,freq0,freq1,psi0)
% Generates an Frequency Modulated Sinisoid Signal S. 'time' is the vector of
% time stamps at which the samples of the signal are to be computed. 'Amp'
% is the amplitude multiplying the signal.
%FIXME Doc: 'b' does not appear in the comment lines above.
%'b' is the amplitude for the cosine function 
% inside major sine function. 'freq0' is sampling frequency.


%Luis Mario Bres Castro, February 2022


SigVec=sin(2*pi*f0*t+b*cos(2*pi*f1*t)); 
SigVec=A*SigVec./norm(SigVec);
end