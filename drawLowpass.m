function h= drawLowpass(width,height,D, gaussian)
%DRAWLOWPASS produces a lowpass filter for frequency space filtering of the
%specified size. if gaussian is set to true, it produces gaussian lowpass
%with 2dB curoff frequenyc D, otherwise, it uses a second order butterworth
%filter with 3dB cuttoff frequency D.
    centerx=(width+1)/2;
    centery=(height+1)/2;
    if gaussian
        h=drawGaussianCircle(width,height,centerx,centery,D);
    else
        h=drawButterworthCircle(width,height,centerx,centery,D,2);
    end
end