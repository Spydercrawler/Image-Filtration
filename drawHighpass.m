function h= drawHighpass(width,height,D,gaussian)
%DRAWHIGHPASS produces a Highpass filter for frequency space filtering of the
%specified size. if gaussian is set to true, it produces gaussian lowpass
%with 2dB cutoff frequenyc D, otherwise, it uses a second order butterworth
%filter with 3dB cuttoff frequency D.
   h=1-drawLowpass(width,height,D,gaussian);
end