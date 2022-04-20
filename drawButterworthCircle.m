function output = drawButterworthCircle(width,height,xcenter,ycenter,radius, order)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%radius is the 3dB cuttoff radius
u=1:width;
u=u-xcenter;
v=1:height;
v=v-ycenter;

[U,V]=meshgrid(u,v);

D=sqrt(U.^2+V.^2);

output=1./(1+D/radius).^(2*order);

end