function descriptor = calculate_ISA_descriptor(T,dt,params_descriptor,params_kalman)

    % Unpack parameters
    L = params_descriptor.L;
    lambda = params_descriptor.lambda;
    N = 50;
    
    % Reparametrize temporal trajectory to geometric domain
    [T_s,s] = reparameterize_trajectory(T,dt,N,params_descriptor);
    ds = s(end)/(N-1);

    % Perform smoothing
    params_kalman.dt = ds;
    [T_s,posetwist,posetwistdot,posetwistddot] = smooth_pose_data(T_s,params_kalman);

    % Transform pose twist to screw twist
    [screwtwist,screwtwistdot,screwtwistddot] = transform_posetwist_to_spatialscrewtwist(T_s,posetwist,posetwistdot,posetwistddot);

    switch params_descriptor.name
        case {'ISA'}
            
            % avoid division by exact zero
            screwtwist = screwtwist + 10^(-12);
            screwtwistdot = screwtwistdot + 10^(-12);
            
            descriptor = calculate_ISA_representation(screwtwist',screwtwistdot',screwtwistddot');
            
        case {'ISA_opt'}
   
            R_ASA = calculate_ASA_frame_orientation(screwtwist(1:3,:));
            p_ASA = calculate_ASA_frame_origin(screwtwist,10^(-6));
            T_ASA = [R_ASA,p_ASA; 0 0 0 1];
            
            inv_T_ASA = inverse_T(T_ASA);

            % Calculate initial values for the invariants
            trajectory_in_ASA = zeros(N,6);
            for k =1:N
                trajectory_in_ASA(k,:) = transform_screw(inv_T_ASA,screwtwist(:,k));
            end

            % Initialize variables and parameters
            opti = params_descriptor.opti_screw;
            var = params_descriptor.var_screw;
            param = params_descriptor.param_screw;
            
            for k = 1:N
                opti.set_initial(var.T_obj{k},[T_s(1:3,1:3,k),T_s(1:3,4,k)])
                opti.set_initial(var.T_isa{k},[T_ASA(1:3,1:3),T_ASA(1:3,4)]);
                opti.set_value(param.T_obj_m{k}, [T_s(1:3,1:3,k),T_s(1:3,4,k)])
            end
            
            for k = 1:N-1
                opti.set_initial(var.U([1 4],k),trajectory_in_ASA(k,[1 4])')
                opti.set_initial(var.U([2 3 5 6],k),0.01*ones(4,1))
            end
            
            opti.set_value(param.h, ds)
            
            try
                solution = opti.solve_limited();
                descriptor = solution.value(var.U); 
            catch
                % avoid division by exact zero
                screwtwist = screwtwist + 10^(-12);
                screwtwistdot = screwtwistdot + 10^(-12);

                descriptor = calculate_ISA_representation(screwtwist',screwtwistdot',screwtwistddot');
            end

    end
    
    % Weigh the rotational component with the geometric scale factor L and hyperparameter lambda
    descriptor(1,:) =  L*descriptor(1,:); % omega
    descriptor(2,:) =  lambda*L*descriptor(2,:); % omega_2
    descriptor(3,:) =  lambda*L*descriptor(3,:); % omega_3
    descriptor(4,:) =  descriptor(4,:); % v
    descriptor(5,:) =  lambda*descriptor(5,:); % v_2
    descriptor(6,:) =  lambda*descriptor(6,:); % v_3
    
end