function [ H ] = RANSAC( matchedPoints1, matchedPoints2, N)
%RANSAC Summary of this function goes here
%   Detailed explanation goes here

highestInliers = zeros(1, 1);
highestPoints = zeros(1, 1);
highestH = maketform('affine', eye(3));
for i = 1 : N
    index = randperm(size(matchedPoints1, 1), 4);
    
    points1 = matchedPoints1(index, :);
    points2 = matchedPoints2(index, :);
    
    H = est_homography(points2(:, 1), points2(:, 2), points1(:, 1), points1(:, 2));
    H = H ./ H(3,3);
    [HpX, HpY] = apply_homography(H, matchedPoints1(:, 1), matchedPoints1(:, 2));
    diff = sqrt((matchedPoints2(:, 1) - HpX).^2 + (matchedPoints2(:, 2) - HpY).^2);
    
    inliers = diff < 1;
    tmp = [HpX(inliers) HpY(inliers)];
    points = matchedPoints1(inliers, :);
    if size(tmp, 1) > size(highestInliers, 1)
%         highestH = maketform('projective',[points2(1:4,1) points2(1:4,2)], [points1(1:4,1) points1(1:4,2)]);
        highestInliers = tmp;
        highestPoints = points;
    end
    if (size(tmp, 1) / size(matchedPoints1, 1)) > .9
        break;
    end
end

% H2 = fitgeotrans(highestPoints, highestInliers, 'projective');
% H =  maketform('projective', H2.T ./ H2.T(3,3));
% H = highestH;
H = est_homography(highestInliers(:, 1), highestInliers(:, 2), highestPoints(:, 1), highestPoints(:, 2));
H = H ./ H(3,3);
% % H = H';
H = maketform('projective', H');
% H = maketform('projective', H ./ H(3,3));
end

