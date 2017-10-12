clc;
clear;
close all;
imtool close all;

Nbest = [400, 500, 400, 1000, 500];
cylindrify = [0,0, 0,0,0];
showInBetweens = [1 1 1 1 0];
sets = GetImages('../Images');
panoramas = cell(1, size(sets, 2));
for i = 1 : 4
    panoramas{i} = ImageStitch(sets{i}, Nbest(i), cylindrify(i), showInBetweens(i));
    figure, imshow(panoramas{i});
end