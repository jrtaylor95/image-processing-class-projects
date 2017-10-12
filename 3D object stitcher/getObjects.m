function [ I, ID, cloud ] = getObjects( path, scene, frame )
%Gets the object in a 3D point cloud by taking in color and depth images
% path  =   path of the directory containing scenes
% scene =   number of the scene
% frame =   number of the frame

%% Setup Paths and Read RGB and Depth Images 
SceneName = sprintf('%0.3d', scene);
FrameNum = num2str(frame);

I = imread([path,'scene_',SceneName,'/frames/frame_',FrameNum,'_rgb.png']);
ID = imread([path,'scene_',SceneName,'/frames/frame_',FrameNum,'_depth.png']);

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

[pcx, pcy, pcz, r, g, b,~, ~, ~, ~] = depthToCloud_full_RGB(ID, I, './params/calib_xtion.mat');

pts = [pcx pcy pcz];
color = [r g b];
color = uint8(color);


%% Crop the image

[pts, color] = crop3d(pts,color, 0);

%% Remove large planes
for i = 1 : 2
    [pts, color] = RANSAC(pts, color, 4000, 15, .1);
end

%% Outlier rejection
% cloud = pointCloud(pts, 'Color', color);
% cloud = pcdenoise(cloud);

pts_mean = mean(pts, 1);
dist = dist_matr(pts, pts_mean);

pts = pts(dist < 200, :);
color = color(dist < 200, :);

cloud = pointCloud(pts, 'Color', color);
end

