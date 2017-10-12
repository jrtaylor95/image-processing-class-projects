function show3Dpoints( I, ID, pts, color )
%% Display Images and 3D Points
% Note this needs the computer vision toolbox: you'll have to run this on
% the server

figure,
subplot 121
imshow(I);
title('RGB Input Image');
subplot 122
imagesc(ID);
axis equal, axis tight
title('Depth Input Image');

figure,
pcshow(pts, color/255);
title('3D Point Cloud');
% drawnow;

end

