function [pts, color] = crop3d(pts,color, num_std)

if nargin < 3
    num_std = 1;
end

medOfPts = median(pts);
distToMed = dist_matr(pts, medOfPts);
stddevDist = std(distToMed);
meanDist = mean(distToMed);
closepts = find(distToMed < meanDist + stddevDist*num_std);
pts = pts(closepts, :);
color = color(closepts, :);