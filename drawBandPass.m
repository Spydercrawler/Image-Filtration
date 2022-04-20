function h= drawBandPass(width,height,W,C, gaussian)
%DRAWBandpass produces a bandpass filter with center of reject band C 
% and band reject width W defined from appropriate low and high pass
% filters
 h=1-drawBandReject(width,height,W,C,gaussian);
end