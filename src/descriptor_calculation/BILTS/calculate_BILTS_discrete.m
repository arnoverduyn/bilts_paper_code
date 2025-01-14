function descriptor = calculate_BILTS_discrete(T,dt,params_descriptor)

    % Unpack parameters
    L = params_descriptor.L;
    ds_scale = params_descriptor.ds_scale;
    N = 100;

    % Reparametrize temporal trajectory to geometric domain
    [T_s,s] = reparameterize_trajectory(T,dt,N,params_descriptor);
    ds = s(end)/(N-1);
            
    % Ensure M does not exceeds the maximum allowed value
    m = max(1,round(ds_scale/ds));
    if m > 48
        m = 48;
    end
    M = 2*m+1;
    
    % Setting regularized vs unregularized case
    if strcmp(params_descriptor.name,'BILTS_discrete_reg')
        regularization = true;
        N_gauss = 20;
    else
        regularization = false;
        N_gauss = 30; % need for more smoothing to reduce sensitivity to noise near singularisties
    end
    
    [pos,quat] = pose2quat(T_s);
    pos = smoothdata(pos,2,"gaussian",N_gauss); 
    quat = smoothdata(quat,2,"gaussian",N_gauss); 
    
    for i=1:size(quat,2)
        % Normalize the quaternions after smoothing
        quat(:,i) = quat(:,i)/norm(quat(:,i)); 
    end
    
    % Convert position and quaternion coordinates to heterogenous transformation matrices
    T_s = quat2pose(pos, quat);
    
    % Calculate spatial screwtwist from poses
    screwtwist = calculate_screwtwist_from_poses_central(T_s,ds);
    screwtwist = screwtwist + randn(6,size(screwtwist,2))*10^(-12); % avoid exact singularities (might raise error otherwise)

    % Calculate discrete bi-invariant descriptor fY
    N = size(screwtwist,2);
    A = [0,-1,1;1,0,0;0,1,0];
    A_inv = A^(-1);
    fY_traj = zeros(6,3,N-M+1);
    for k = 1+m:N-m
        wY = zeros(6,3);
        for i = 1:3
            wY(:,i) = screwtwist(:,k-m+(i-1)*m);
        end
        p_obj = T_s(1:3,4,k);
        [R,~,~] = eQR(wY*A,regularization,L,p_obj);
        fY = R*A_inv;
    
        fY_traj(1:3,:,k-m) = L*fY(1:3,:);
        fY_traj(4:6,:,k-m) = fY(4:6,:);
    end
    N_descriptor = size(fY_traj,3); 
    descriptor = reshape(fY_traj, 18, N_descriptor);
    
    % Calculate singular values as invariant features for DTW alignment
    singular_values = zeros(6,N_descriptor);
    for k = 1:N_descriptor
        test1 = fY_traj(1:3, :, k) * fY_traj(1:3, :, k)';
        E1 = eig(test1);
        
        test2 = fY_traj(4:6, :, k) * fY_traj(4:6, :, k)';
        E2 = eig(test2);
        
        singular_values(:,k) = sqrt([E1;E2]);
    end
    descriptor(19:24,:) = singular_values;

end