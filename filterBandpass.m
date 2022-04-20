function out = filterBandpass(image,C,W, gaussian)
%Does highpass filtering on the image, returns filtered image of the same
%size. D is appropriate for the type of filter, gaussian or 2nd order
%butterworth. 
%   Detailed explanation goes here
    image=double(image);
    [startr,startc]=size(image);

    %find correct size for fft
    r=nextpow2(startr);
    c=nextpow2(startc);
    
    %make image correct size, store this size to generate filter
    r=2^r;
    c=2^c;
    f=padarray(image,[r-startr c-startc],'post');

    F=fft2(f);
    Fc=fftshift(F);%bring center frequencies to center of array
    H=drawBandPass(c,r,W,C,gaussian);

    Yc=Fc.*H;
    y=ifft2(Yc);
    y= y(1:startr,1:startc);%take same subset as starting with

    out=mat2gray(abs(y));
    

end