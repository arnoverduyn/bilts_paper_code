function descriptor = calculate_RRV_descriptor(T,dt,params_descriptor)
   
    % Unpack parameters
    N = 50;
    
    % Normalize the point trajectory to a length of one
    [~,arclength] = reparameterize_trajectory_arclength(T,dt,false,N);
    
    % Reparameterize the trajectory
    switch params_descriptor.progress_type
        case 'arclength'
            T(1:3,4,:) = T(1:3,4,:)/arclength(end);
            [T_s,s] = reparameterize_trajectory_arclength(T,dt,false,N);
            ds = s(end)/(N-1);
        case 'angle'
            T(1:3,4,:) = T(1:3,4,:)/arclength(end);
            [T_s,s] = reparameterize_trajectory_angle(T,dt,false,N);
            ds = s(end)/(N-1);
        case 'screwbased'
            [T_s,~,s] = reparametrize_trajectory_screwbased(T,params_descriptor.L,dt,false,N);
            T_s(1:3,4,:) = T_s(1:3,4,:)/arclength(end);
            ds = s(end)/arclength(end)/(N-1);
    end
    
    % Smooth the reparameterized trajectory
    [pos,quat] = pose2quat(T_s);
    pos = smoothdata(pos,2,"gaussian",3);
    quat = smoothdata(quat,2,"gaussian",3);
    for i=1:size(quat,2)
        % Normalize the quaternions after smoothing
        quat(:,i) = quat(:,i)/norm(quat(:,i)); 
    end
    % Convert position and quaternion coordinates to heterogenous transformation matrices
    T_s = quat2pose(pos, quat);

    %% Calculate the equivalent rotation axis vectors
    A = zeros(3,N-1);
    beta = zeros(1,N-1);
    omega = zeros(3,N-1);
    vel = zeros(3,N-1);
    for k=1:N-1
        omega(:,k) = extract_vector_from_skew(logm(T_s(1:3,1:3,k+1)*T_s(1:3,1:3,k)'))/ds;
        vel(:,k) = (T_s(1:3,4,k+1)-T_s(1:3,4,k))/ds;
        beta(k) = norm(omega(:,k));
        A(:,k) = omega(:,k)/(beta(k)+10^(-10));
    end
    [U,~,~] = svd(A);

    average = sum(A,2)/(N-1);
    if dot(average,U(:,1)) < 0
        U(:,1) = -U(:,1);
    end
    if dot(average,U(:,2)) < 0
        U(:,2) = -U(:,2);
    end
    U(:,3) = cross(U(:,1),U(:,2));

    A_in_global_invariant_frame = U'*A;
    vel_in_global_invariant_frame = U'*vel;
    
    %% Quaternions representing the increment in rotation in an invariant way
    S_r = zeros(4,N-1);
    for k = 1:N-1
        S_r(1,k) = cos(beta(k)/2);
        S_r(2:4,k) = A_in_global_invariant_frame(:,k)*sin(beta(k)/2);
    end

    %% Calculate local orientation frame
    ROT_local = zeros(3,3,N-1);
    vel_in_local_invariant_frame = zeros(3,N-1);
    for k = 1:N-1
        ROT_local(:,:,k) = quat2rotm(S_r(:,k)');
        vel_in_local_invariant_frame(:,k) = ROT_local(:,:,k)'*vel_in_global_invariant_frame(:,k);
    end

    vel_SQVF = zeros(3,N-1);
    for k = 1:N-1
        vel_SQVF(:,k) = vel_in_local_invariant_frame(:,k)/sqrt(norm(vel_in_local_invariant_frame(:,k))+10^(-10));
    end

    descriptor = [S_r;vel_SQVF];
    
end