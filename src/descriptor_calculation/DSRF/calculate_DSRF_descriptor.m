function descriptor = calculate_DSRF_descriptor(T,dt,params_descriptor)

    % Unpack parameters
    N = 50;
    
    % Calculate the total arclength traced by the body reference point
    [~,arclength] = reparameterize_trajectory_arclength(T,dt,false,N);

    % Reparameterize the trajectory
    switch params_descriptor.progress_type

        case 'arclength'

            % Normalize the point trajectory to a length of one
            T(1:3,4,:) = T(1:3,4,:)/arclength(end);

            % Reparameterize the normalized trajectory
            [T_s,s] = reparameterize_trajectory_arclength(T,dt,false,N);
            ds = s(end)/(N-1);

        case 'angle'

            % Normalize the point trajectory to a length of one
            T(1:3,4,:) = T(1:3,4,:)/arclength(end);

            % Reparameterize the normalized trajectory
            [T_s,s] = reparameterize_trajectory_angle(T,dt,false,N);
            ds = s(end)/(N-1);

        case 'screwbased'

            % Reparameterize the trajectory (L has units [m])
            [T_s,~,s] = reparametrize_trajectory_screwbased(T,params_descriptor.L,dt,false,N);

            % Normalize the reparameterized point trajectory
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
    
    SRVF_omega = zeros(3,N-1);
    SRVF_vel = zeros(3,N-1);
    for k = 1:N-1
        omega = extract_vector_from_skew(logm(T_s(1:3,1:3,k+1)*T_s(1:3,1:3,k)'))/ds;
        vel = (T_s(1:3,4,k+1)-T_s(1:3,4,k))/ds;
        SRVF_omega(:,k) = omega/(sqrt(norm(omega))+10^(-10));
        SRVF_vel(:,k) = vel/(sqrt(norm(vel))+10^(-10));
    end
    descriptor = [SRVF_omega;SRVF_vel];

end