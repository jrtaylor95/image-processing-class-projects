function [panorama] = ImageStitch(imageSet, Nbest, isHorizontal, showInBetween)

if isHorizontal
    imageSet = cellfun(@cylindrify, imageSet, 'UniformOutput', false);
end
numIms = size(imageSet, 2);
H(1 : size(imageSet, 2)) = maketform('affine', eye(3));
prevIm = imageSet{1};
output = imageSet{1};
imageSize = size(imageSet{1});
for i = 2 : numIms
    image = imageSet{i};
    
    if numel(imageSize) > 2
        outputG = rgb2gray(prevIm);
    else
        outputG = prevIm;
    end
    [prevX, prevY] = ANMS(cornermetric(outputG), Nbest);
    prevFeatures = FeatureDescriptor(outputG, prevX, prevY, Nbest);
    
    if showInBetween == 1
        figure,
        imshow(output);
        hold on;
        plot(prevX, prevY, '.r');
        hold off;
    end
    
    if numel(imageSize) > 2
        imGray = rgb2gray(image);
    else
        imGray = image;
    end
    [X, Y] = ANMS(cornermetric(imGray), Nbest);
    featureDescriptor = FeatureDescriptor(imGray, X, Y, Nbest);
    if showInBetween == 1
        figure,
        imshow(image);
        hold on;
        plot(X, Y, '.r');
        hold off;
    end
    [matchedPoints1, matchedPoints2] = MatchImageFeatures(prevFeatures, featureDescriptor, prevX, prevY, X, Y, Nbest);
    if showInBetween == 1
        figure,
        showMatchedFeature(output, image, matchedPoints1, matchedPoints2, 'montage');
    end
    H(i - 1) = RANSAC(matchedPoints1, matchedPoints2, 4000);
    %         H(i).tdata.T = H(i).tdata.T * H(i - 1).tdata.T;
    [~, xdataim2t, ydataim2t] = imtransform(output, H(i - 1), 'XYScale', 1);
    xdataout=[min(1,xdataim2t(1)) max(imageSize(2), xdataim2t(2))];
    ydataout=[min(1,ydataim2t(1)) max(imageSize(1), ydataim2t(2))];
    
    prevIm=imtransform(image, H(i), 'XData', xdataout, 'YData', ydataout, 'XYScale', 1);
    im1t=imtransform(output, H(i - 1), 'XData',xdataout, 'YData', ydataout, 'XYScale', 1);
    
    output = max(im1t, prevIm);
end

panorama = output;
end