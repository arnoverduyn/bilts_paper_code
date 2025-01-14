function p_ASA = calculate_ASA_origin(screw_trajectory,regul_origin)

N = size(screw_trajectory,2);

% Calculate different average sums from the screw components
cross_product_sum = zeros(3,1);
skew_product_sum = zeros(3,3);
for k = 1:N
    d = screw_trajectory(1:3,k); % direction component (rot. vel or force)
    m = screw_trajectory(4:6,k); % moment component (transl. vel or moment)
    
    cross_product_sum = cross_product_sum + cross(d,m);
    skew_product_sum = skew_product_sum + skew(d)*skew(d);
end
cross_product_sum = cross_product_sum/N;
skew_product_sum = skew_product_sum/N;

% Determine ASA frame origin
p_ASA = (-skew_product_sum + regul_origin*eye(3)) \ cross_product_sum ;

end