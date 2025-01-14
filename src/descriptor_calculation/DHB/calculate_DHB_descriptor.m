function descriptor = calculate_DHB_descriptor(T,dt,params_descriptor,params_kalman)

    % Unpack parameters
    L = params_descriptor.L;
    lambda = params_descriptor.lambda;
    N = 100;
    
    % Reparametrize temporal trajectory to geometric domain
    [T_s,s] = reparameterize_trajectory(T,dt,N,params_descriptor);

    ds = s(end)/(N-1);
    
    % Perform smoothing
    params_kalman.dt = ds;
    [~,posetwist,~,~,] = smooth_pose_data(T_s,params_kalman);
    
    % Calculate trajectory-shape descriptor
    descriptor_rot = calculate_DHB_representation(posetwist(1:3,:));
    descriptor_pos = calculate_DHB_representation(posetwist(4:6,:));
    
    descriptor = [descriptor_rot;descriptor_pos];
    
    % Weigh the rotational component with the geometric scale factor L and
    % ad hoc scale factor lambda
    descriptor(1,:) =  L*descriptor(1,:); % omega
    descriptor(2,:) =  lambda*L*descriptor(2,:); % theta1
    descriptor(3,:) =  lambda*L*descriptor(3,:); % theta2
    descriptor(4,:) =  descriptor(4,:); % v
    descriptor(5,:) =  lambda*L*descriptor(5,:); % theta1
    descriptor(6,:) =  lambda*L*descriptor(6,:); % theta2

end