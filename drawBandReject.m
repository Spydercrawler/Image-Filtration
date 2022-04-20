function h= drawBandReject(width,height,W,C, gaussian)
%DRAWHIGHPASS produces a bandpass filter with center of reject band C 
% and band reject width W defined from appropriate low and high pass
% filters
 xcenter=(width+1)/2;
 ycenter=(height+1)/2;
    
   u=1:width;%position in x, with center in the middle
u=u-xcenter;
v=1:height;
v=v-ycenter;

[U,V]=meshgrid(u,v);

DD=U.^2+V.^2;
D=sqrt(DD);

if gaussian
    h=1-exp(-((DD-C^2)./(D*W)).^2);
else
    n=2;
    h=1./(1+((D*W)./(DD-C^2)).^(2*n));
end