function output = drawGaussianCircle(width,height,xcenter,ycenter,radius)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%radius is the 2dB cuttoff radius
u=1:width;%position in x, with center in the middle
u=u-xcenter;
v=1:height;
v=v-ycenter;

[U,V]=meshgrid(u,v);

DD=U.^2+V.^2;

output=exp(-DD/(2*radius^2));

end