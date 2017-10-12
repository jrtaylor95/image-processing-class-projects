function [ X, Y ] = ANMS( Cimg, Nbest )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%find local maxima
BW = imregionalmax(Cimg);

[y, x] = find(BW);
Ci = Cimg(BW);

y = y(Ci ~= 0);
x = x(Ci ~= 0);
Ci = Ci(Ci ~= 0);
% C = sparse(Ci > Ci');
CiSize = size(Ci, 1);
r = inf(1, CiSize);

for i = 1 : CiSize
    %     subset = C(:, i);
    subset = Ci > Ci(i);
    if any(subset)
        B = (x(subset) - x(i)).^2 + (y(subset) - y(i)).^2;
        r(i) = min(B);
    end
end

[~, points] = sort(r, 'descend');

best = points(1 : Nbest);

Y = y(best);
X = x(best);
end

