function [ matchedPoints1, matchedPoints2 ] = MatchImageFeatures( featureDescriptors1, featureDescriptors2, X1, Y1, X2, Y2, Nbest)
%MATCHFEATURES Summary of this function goes here
%   Detailed explanation goes here

ratios = zeros(Nbest, 1);
I = zeros(Nbest, 1);

% count = 1;
for pic1_i = 1 : Nbest
    diff = sum((featureDescriptors2 - featureDescriptors1(:, pic1_i)).^2);
    [tmp, index] = sort(diff, 'ascend');
    
    bestMatch = tmp(1);
    secondBestMatch = tmp(2);
    
    ratios(pic1_i) = bestMatch / secondBestMatch;
    I(pic1_i) = index(1);
end

subset = ratios < .6;
matchedPoints1 = [X1(subset) Y1(subset)];
matchedPoints2 = [X2(I(subset)) Y2(I(subset))];

end