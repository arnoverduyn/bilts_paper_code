function [pos,quat] = pose2quat(T)
% Convert heterogenous transformation matrix to position and quaternion coordinates
    ROT = T(1:3,1:3,:);
    pos = squeeze(T(1:3,4,:));
    quat = rot2quat(ROT)';
end