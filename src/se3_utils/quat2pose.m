function T = quat2pose(pos, quat)
% Convert position and quaternion coordinates to heterogenous transformation matrices
    N = size(pos,2);
    ROT = zeros(3,3,N);
    T = zeros(4,4,N);
    for j = 1:N
        ROT(:,:,j) = quat2rotm(quat(:,j)');
        T(1:3,1:3,j) = ROT(:,:,j);
        T(1:3,4,j) = pos(:,j);
        T(4,4,j) = 1;
    end
end