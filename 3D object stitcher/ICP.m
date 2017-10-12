function [ p_prime ] = ICP( p, q )
%Iterativley matches points between p and q until p matches q
%	p: source cloud
%	q: destination cloud

%	p_prime: transformed cloud
%Remember that p and q are row vectors, unlike in the paper,
%where they are column vectors

if size(q.Location, 1) > size(p.Location, 1)
    [p_sub, q_sub] = matchNearestNeighbors(p, q);
elseif size(q.Location, 1) < size(p.Location, 1)
    [q_sub, p_sub] = matchNearestNeighbors(q, p);
else
    q_sub = q;
    p_sub = p;
end
q_normal = pcnormals(q_sub, 6);

tf = isfinite(q_normal);
validIdx = sum(tf, 2) == 3;
q_normal = q_normal(validIdx, :);
q_sub = cloudSubset(q_sub, validIdx);
p_sub = cloudSubset(p_sub, validIdx);



s_old = SSD(p_sub, q_sub, q_normal);
s = s_old;

s_diff = 0;

p_prime = p_sub;

while s_diff < 1 || s_diff > 1.01
% while s > p_sub.Count*5
    %% Find transformation matrix
    M = CP(p_prime, q_sub, q_normal);
    p_prime = pctransform(p_prime, M);

    s = SSD(p_prime, q_sub, q_normal);
    s_diff = s ./ s_old;
    s_old = s;
end
end

function [M, X] = CP( p, q, q_n )
p_x = p.Location(:, 1);
p_y = p.Location(:, 2);
p_z = p.Location(:, 3);
q_x = q.Location(:, 1);
q_y = q.Location(:, 2);
q_z = q.Location(:, 3);
q_n_x = q_n(:, 1);
q_n_y = q_n(:, 2);
q_n_z = q_n(:, 3);

A = [q_n_z .* p_y - q_n_y .* p_z, ...
    q_n_x .* p_z - q_n_z .* p_x, ...
    q_n_y .* p_x - q_n_x .* p_y, ...
    q_n_x, q_n_y, q_n_z];
b = q_n_x .* q_x + q_n_y .* q_y + ...
    q_n_z .* q_z - q_n_x .* p_x - ...
    q_n_y .* p_y - q_n_z .* p_z;

x = pinv(A) * b;
X = x';
M = transformation(x);
end

function [M] = transformation( x )
% Creates an affine 3D transformation matrix from a vector
%	x: vector in the form of [a b y t_x t_y t_z]
a = x(1);	% roll
b = x(2);	% pitch
y = x(3);	% yaw
t_x = x(4);	% X shift
t_y = x(5);	% Y shift
t_z = x(6);	% Z shift
cy = cos(y);
sy = sin(y);
ca = cos(a);
sa = sin(a);
cb = cos(b);
sb = sin(b);
r_11 = cy .* cb;
r_12 = -sy .* ca + cy .* sb .* sa;
r_13 = sy .* sa + cy .* sb .* ca;
r_21 = sy .* cb;
r_22 = cy .* ca + sy .* sb .* sa;
r_23 = -cy .* sa + sy .* sb .* ca;
r_31 = -sb;
r_32 = cb .* sa;
r_33 = cb .* ca;

M = affine3d([r_11 r_12 r_13 t_x; r_21 r_22 r_23 t_y; r_31 r_32 r_33 t_z; 0 0 0 1]');
end

function [p_sub, q_sub] = matchNearestNeighbors( p, q)
%	p: source points
%	q: dest points
%	thresh: threshold for outliers

%	p_sub: subset of matching points in p
%	q_sub: subset of matching points in q

[q_idx, D] = knnsearch(q.Location, p.Location);

upperBound = round(p.Count * .85);

[~, idx] = sort(D);

p_sub = pointCloud(p.Location(idx(1 : upperBound), :), 'Color', p.Color(idx(1 : upperBound), :));
q_sub = pointCloud(q.Location(q_idx(idx(1 : upperBound)), :), 'Color', q.Color(q_idx(idx(1 : upperBound)), :));
end

function [dist] = SSD(source, dest, n)
%Finds the sum of squared distances between source and dest clouds
%	source: source cloud
%	dest: destination cloud
%	n: normals of dest
dist = sum(norm((source.Location - dest.Location) .* n).^2);
end

function [cloud] = cloudSubset(cloud, idx)
    cloud = pointCloud(cloud.Location(idx, :), 'Color', cloud.Color(idx, :));
end
