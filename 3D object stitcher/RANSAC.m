function [ outliers, outlier_color ] = RANSAC( pts, color, iter, thresh, IR )
%Based on the code from Sanket & Lee
num = size(pts, 1);
minOutliers = num;
for i = 1 : iter
    %Pick three random points
   idx = randperm(num , 3);
   sample = pts(idx, :);
   A = sample(1, :)';
   B = sample(2, :)';
   C = sample(3, :)';
   
   AB = B - A;
   AC = C - A;
   
   N = cross(AB, AC);
   a = N(1);
   b = N(2);
   c = N(3);
   
   d = -A' * N;
   
   X = pts(:, 1) .* a;
   Y = pts(:, 2) .* b;
   Z = pts(:, 3) .* c;
   
   plane = (X + Y + Z + d) ./ norm(N);
   
   idx = abs(plane) > thresh;
   
   % Check if this set of outliers has the less than the previous one.
   num_outliers = size(idx(idx == 1), 1);
   if num_outliers < minOutliers
      minOutliers = num_outliers;
      
      outliers = pts(idx, :);
      outlier_color = color(idx, :);
      
      if num_outliers / num <= IR
          break;
      end
   end
end

end

