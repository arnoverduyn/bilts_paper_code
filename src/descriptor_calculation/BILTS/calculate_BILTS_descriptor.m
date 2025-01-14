function descriptor = calculate_BILTS_descriptor(T,dt,params_descriptor,params_kalman)

    % Unpack parameters
    L = params_descriptor.L;
    ds = params_descriptor.ds;
    ds_scale = params_descriptor.ds_scale;
    
    % Reparametrize temporal trajectory to geometric domain
    T_s = reparameterize_trajectory_angle(T,dt,ds);

    % Perform smoothing
    [T_s,posetwist,posetwistdot,posetwistddot] = smooth_pose_data(T_s,params_kalman);

    % Transform pose twist to screw twist
    [screwtwist,screwtwistdot,screwtwistddot] = transform_posetwist_to_spatialscrewtwist(T_s,posetwist,posetwistdot,posetwistddot);

    % avoid division by exact zero
    screwtwist = screwtwist + 10^(-12);
    screwtwistdot = screwtwistdot + 10^(-12);

    descriptor = calculate_BILTS_representation(screwtwist',screwtwistdot',screwtwistddot',L,ds_scale,params_descriptor);
    
end