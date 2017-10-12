clc
clearvars
close all

[I, ID, dest_cloud] = getObjects('../Data/SingleObject/', 0, 0);

for i = 30 :30: 270
    disp(num2str(i));
    [I, ID, p] = getObjects('../Data/SingleObject/', 0, i);
    [p_prime] = ICP(p, dest_cloud);
    
	dest_cloud = pcmerge(dest_cloud, p_prime, 1);
end
figure,
pcshow(dest_cloud)
view([0 -90])