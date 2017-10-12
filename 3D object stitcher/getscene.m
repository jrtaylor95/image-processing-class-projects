function [ I, ID ] = getscene( path, scenenum, framenum )
%% Setup Paths and Read RGB and Depth Images 
SceneName = sprintf('%0.3d', scenenum);
FrameNum = num2str(framenum);

I = imread([path,'scene_',SceneName,'/frames/frame_',FrameNum,'_rgb.png']);
ID = imread([path,'scene_',SceneName,'/frames/frame_',FrameNum,'_depth.png']);

end

