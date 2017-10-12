function [ sets ] = GetImages( directory)
%GETIMAGES Summary of this function goes here
%   Detailed explanation goes here

folders = dir(char([directory '/']));
folders = folders(3 : end);
sets = cell(1, size(folders, 1));

for i = 1 : size(folders, 1)
    if folders(i).name(1) ~= '.'
        files = dir(char([folders(i).folder '/' folders(i).name '/*']));
        files = files(3 : end);
        images = cell(1, size(files, 1));
        for j = 1 : size(files, 1)
            if files(j).name(1) ~= '.'
                im = imread(char([files(j).folder '/' files(j).name]));
                images{j} = im2double(im);
            end
        end
        sets{i} = images;
    end
end

a = cellfun(@isempty, sets);
sets = sets(~a);
end

