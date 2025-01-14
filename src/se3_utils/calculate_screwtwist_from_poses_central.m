function screwtwist = calculate_screwtwist_from_poses_central(T,ds)

    N = size(T,3);
    screwtwist = zeros(6,N);
    twist_cross = logm_pose(T(:,:,2)*inverse_T(T(:,:,1)))/(2*ds);
    skew_omega = twist_cross(1:3,1:3);
    screwtwist(1:3,1) = extract_vector_from_skew(skew_omega);
    screwtwist(4:6,1) = twist_cross(1:3,4);
    for k = 2:N-1
        twist_cross = logm_pose(T(:,:,k+1)*inverse_T(T(:,:,k-1)))/(2*ds);
        skew_omega = twist_cross(1:3,1:3);
        screwtwist(1:3,k) = extract_vector_from_skew(skew_omega);
        screwtwist(4:6,k) = twist_cross(1:3,4);
    end
    twist_cross = logm_pose(T(:,:,N)*inverse_T(T(:,:,N-1)))/(2*ds);
    skew_omega = twist_cross(1:3,1:3);
    screwtwist(1:3,N) = extract_vector_from_skew(skew_omega);
    screwtwist(4:6,N) = twist_cross(1:3,4);

end