function [ vectors ] = FeatureDescriptor(im , X, Y, Nbest)
%FEATUREDESCRIPTOR Summary of this function goes here
%   Detailed explanation goes here

gauss = fspecial('gaussian');
p = padarray(im, [20 20]);

filteredPatch = zeros(40, 40, size(X, 1));
Yfirst = Y;
Ylast = Y + 39;
Xfirst = X;
Xlast = X + 39;
for i = 1 : Nbest
    pat = p(Yfirst(i) : Ylast(i), Xfirst(i) : Xlast(i));
    filteredPatch(:, :, i) = imfilter(pat, gauss, 'same');
    %     filteredPatch = imgaussfilt(pat);
    %     subsample = imresize(filteredPatch, .2);
end
subsample = filteredPatch(1 : 5 : 40, 1 : 5 : 40, :);
vectors = reshape(subsample, 64, Nbest);
m = mean(vectors, 1);
vectors = vectors - m;
stddev = std(vectors, 0, 1);
vectors = vectors ./ stddev;
end

