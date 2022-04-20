function h= drawNotchPass(width,height,centerx,centery, radius)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

%this will only use buterworth.

%shift to center of image
imcentx=(width+1)/2;
imcenty=(height+1)/2;

xcenter=centerx+imcentx;
ycenter=centery+imcenty;


%will draw two circles with appropriate symmetry.
xsym=-centerx+imcentx;
ysym=-centery+imcenty;

h=drawButterworthCircle(width,height,xcenter,ycenter,radius,6);
h=h+drawButterworthCircle(width,height,xsym,ysym,radius,6);
end