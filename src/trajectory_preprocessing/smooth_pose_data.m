function [T_smooth,twist,twistdot, twistddot] = smooth_pose_data(T,params) 
% This function smooths the input pose trajectory using a Kalman smoother
% with white noise jerk model
% INPUT: T (4x4xN)
% OUTPUT: T_smooth (4x4xN) -> smoothed pose trajectory
%         twist    (6xN)   -> smooth pose twist
%         twistdot (6xN)   -> smooth derivative of the pose twist

    [pos,quat] = pose2quat(T);
    raw_data = [pos;quat]';
    
    % Apply Kalman smoother
    [data_s,d_data_s,dd_data_s,ddd_data_s] = kalman_smoother(raw_data,params);

    % Retrieve smoothed position coordinates and their derivatives
    smooth_pos = data_s(:,1:3)';
    twist(4:6,:) = d_data_s(:,1:3)';
    twistdot(4:6,:) = dd_data_s(:,1:3)';
    twistddot(4:6,:) = ddd_data_s(:,1:3)';

    % Retrieve smoothed quaternion coordinates and their derivatives
    smooth_quat = data_s(:,4:7)';
    for i=1:size(smooth_quat,2)
        % Normalize the quaternions after smoothing
        smooth_quat(:,i) = smooth_quat(:,i)/norm(smooth_quat(:,i)); 
    end
    [omega,omegadot,omegaddot] = quat_deriv_to_omega_deriv(smooth_quat,d_data_s(:,4:7)',dd_data_s(:,4:7)',ddd_data_s(:,4:7)');
    twist(1:3,:) = omega;
    twistdot(1:3,:) = omegadot;
    twistddot(1:3,:) = omegaddot;
    
    % Convert position and quaternion coordinates to heterogenous transformation matrices
    T_smooth = quat2pose(smooth_pos, smooth_quat);

end
