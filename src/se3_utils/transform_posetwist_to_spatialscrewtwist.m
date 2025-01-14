function [screwTwist,screwTwistDot,screwTwistDotDot] = transform_posetwist_to_spatialscrewtwist(T,Twist,TwistDot,TwistDotDot)
    N = size(Twist,2);
    screwTwist = zeros(6,N);
    screwTwistDot = zeros(6,N);
    screwTwistDotDot = zeros(6,N);
    pos = squeeze(T(1:3,4,:));
    for k = 1:N
        cross_p = skew(pos(:,k));
        dot_cross_p = skew(Twist(4:6,k));
        dotdot_cross_p = skew(TwistDot(4:6,k));
        M_obj_w = [eye(3), zeros(3,3); cross_p, eye(3)];
        dot_M_obj_w = [zeros(3,3), zeros(3,3); dot_cross_p, zeros(3,3)];
        dotdot_M_obj_w = [zeros(3,3), zeros(3,3); dotdot_cross_p, zeros(3,3)];
        screwTwist(:,k) = M_obj_w*Twist(:,k);
        screwTwistDot(:,k) = M_obj_w*TwistDot(:,k) + dot_M_obj_w*Twist(:,k);
        screwTwistDotDot(:,k) = M_obj_w*TwistDotDot(:,k) + 2*dot_M_obj_w*TwistDot(:,k) + dotdot_M_obj_w*Twist(:,k);
    end
end