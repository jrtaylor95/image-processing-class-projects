function [ Cimg ] = cylindrify( im )
%CYINDRIFY Summary of this function goes here
%   Detailed explanation goes here

Xsize = size(im, 2);
Ysize = size(im, 1);
Xc = Xsize / 2;
Yc = Ysize / 2;
focal = 500;

Cimg = zeros(size(im));

for i = 1 : numel(im(:, :, 1))
    [y, x] = ind2sub(size(im), i);
    d = (x - Xc) / focal;
    xprime = round(focal * tan(d) + Xc);
    yprime = round(((y - Yc) / cos(d)) + Yc);
    
    if xprime >= 1 && xprime <= Xsize && yprime >= 1 && yprime <= Ysize
        Cimg(y, x, :) = im(yprime, xprime, :);
    end
end
end

