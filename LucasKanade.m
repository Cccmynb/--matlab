function [u, v] = LucasKanade(im1, im2, windowSize)

%Reference - http://crcv.ucf.edu/REU/2014/p4_opticalFlow.pdf
%Borrowed from University of Central Florida, Center for Research in
%Computer Vision.

[fx, fy, ft] = ComputeDerivatives(im1, im2);
u = zeros(size(im1));
v = zeros(size(im2));
halfWindow = floor(windowSize/2);
for i = halfWindow+1:size(fx, 1) - halfWindow
    for j = halfWindow+1:size(fx, 2) - halfWindow
        curFx = fx(i - halfWindow:i+halfWindow, j - halfWindow:j+halfWindow);
        curFy = fy(i - halfWindow:i+halfWindow, j - halfWindow:j+halfWindow);
        curFt = ft(i - halfWindow:i+halfWindow, j - halfWindow:j+halfWindow);
        
        curFx = curFx';
        curFy = curFy';
        curFt = curFt';
        
        curFx = curFx(:);
        curFy = curFy(:);
        curFt = - curFt(:);
        
        A = [curFx curFy];
        
        U = pinv(A'*A)* A'*curFt;
        
        u(i,j) = U(1);
        v(i,j) = U(2);
    end;
end;

v(isnan(u)) = 0;
v(isnan(v)) = 0;

function[fx, fy, ft] = ComputeDerivatives(im1, im2)
if(size(im1, 1) ~= size(im2,1)) | (size(im1,2)~= size(im2,2))
    error('input images are not the same size');
end;

if(size(im1, 3)~= 1) | (size(im2,3) ~= 1)
    error('method only works for gray-level images');
end;

fx = conv2(im1, 0.25*[-1 1; -1 1]) + conv2(im2, 0.25*[-1 1; -1 1]);
fy = conv2(im1, 0.25*[-1 -1; 1 1]) + conv2(im2, 0.25*[-1 -1; 1 1]);
ft = conv2(im1, 0.25*ones(2)) + conv2(im2, -0.25*ones(2));

fx = fx(1:size(fx,1)-1, 1:size(fx,2)-1);
fy = fy(1:size(fy,1)-1, 1:size(fy,2)-1);
ft = ft(1:size(ft,1)-1, 1:size(ft,2)-1);