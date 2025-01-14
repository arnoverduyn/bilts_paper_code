function descriptor = calculate_eFS_descriptor(T,dt,params_descriptor,params_kalman)

    % Unpack parameters
    L = params_descriptor.L;
    lambda = params_descriptor.lambda;
    N = 100;

    % Reparametrize temporal trajectory to geometric domain
    [T_s,s] = reparameterize_trajectory(T,dt,N,params_descriptor);

    ds = s(end)/(N-1);

    % Perform smoothing
    params_kalman.dt = ds;
    [~,posetwist,posetwistdot,posetwistddot] = smooth_pose_data(T_s,params_kalman);

    switch params_descriptor.name
        case {'eFS'}
            
            % avoid division by exact zero
            posetwist = posetwist + 10^(-12);
            posetwistdot = posetwistdot + 10^(-12);
            
            % Calculate trajectory-shape descriptor
            descriptor_rot = calculate_FS_representation(posetwist(1:3,:), posetwistdot(1:3,:), posetwistddot(1:3,:));
            descriptor_pos = calculate_FS_representation(posetwist(4:6,:), posetwistdot(4:6,:), posetwistddot(4:6,:));
            descriptor = [descriptor_rot;descriptor_pos];   
            
        case {'eFS_opt'}
            
            descriptor_rot = calculate_optimal_FS(T_s(1:3,1:3,:), posetwist(1:3,:), posetwistdot(1:3,:), posetwistddot(1:3,:),...
                ds, 'rot', params_descriptor.opti_rot, params_descriptor.var_rot, params_descriptor.param_rot);
            descriptor_pos = calculate_optimal_FS(T_s(1:3,4,:), posetwist(4:6,:), posetwistdot(4:6,:), posetwistddot(4:6,:),...
                ds, 'pos', params_descriptor.opti_pos, params_descriptor.var_pos, params_descriptor.param_pos);
            
            descriptor = [descriptor_rot;descriptor_pos];
    end
    
    % Weigh the rotational component with the geometric scale factor L and
    % ad hoc scale factor lambda
    descriptor(1,:) =  L*descriptor(1,:); % omega
    descriptor(2,:) =  lambda*L*descriptor(2,:); % omega_2
    descriptor(3,:) =  lambda*L*descriptor(3,:); % omega_3
    descriptor(4,:) =  descriptor(4,:); % v
    descriptor(5,:) =  lambda*L*descriptor(5,:); % omega_2
    descriptor(6,:) =  lambda*L*descriptor(6,:); % omega_3

end