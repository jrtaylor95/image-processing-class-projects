function [ pts, color, D_, X, Y, validInd ] = pointcloud( I, ID )
%% Extract 3D Point cloud
% Inputs:
% ID - the depth image
% I - the RGB image
% calib_file - calibration data path (.mat) 
%              ex) './param/calib_xtion.mat'
%              
% Outputs:
% pts               - point cloud (valid points only, in RGB
%                     cameracoordinate frame), in [pcx, pcy, pcz]
% color             - color of pts, in [r g b]
% D_                - registered z image (NaN for invalid pixel) 
% X,Y               - registered x and y image (NaN for invalid pixel)
% validInd          - indices of pixels that are not NaN or zero
% NOTE:
% - pcz equals to D_(validInd)
% - pcx equals to X(validInd)
% - pcy equals to Y(validInd)

[pcx, pcy, pcz, r, g, b, D_, X, Y,validInd] = depthToCloud_full_RGB(ID, I, './params/calib_xtion.mat');

pts = [pcx pcy pcz];
color = [r g b];
end

