function [ dist ] = dist_matr( pts_1, pts_2 )
%Finds the distance between two sets of 3D points
    diff_x = pts_1(:, 1) - pts_2(:, 1);
    diff_y = pts_1(:, 2) - pts_2(:, 2);
    diff_z = pts_1(:, 3) - pts_2(:, 3);

    dist = sqrt(diff_x.^2 + diff_y.^2 + diff_z.^2);
end

