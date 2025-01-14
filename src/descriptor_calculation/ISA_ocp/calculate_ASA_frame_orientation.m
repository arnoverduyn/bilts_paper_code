function R_ASA = calculate_average_orientation(vector_trajectory)

N = size(vector_trajectory,2);

outer_product_sum = zeros(3,3);
for k = 1:N
    outer_product_sum = outer_product_sum + vector_trajectory(:,k)*vector_trajectory(:,k)';
end
outer_product_sum = outer_product_sum/N;

% Determine ASA frame orientation
[U_ASA,~,~] = svd(outer_product_sum); % retrieve matrix of singular vectors

% Select the signed directions of the axes of the initial moving frames
e_x = U_ASA(1:3,1);
e_y = U_ASA(1:3,2);

mean_vector = sum(vector_trajectory(:,1:round(N/2)),2)/(round(N/2));

if dot(e_x,mean_vector) < 0
    e_x = -e_x;
end
if dot(e_y,mean_vector) < 0
    e_y = -e_y;
end
e_z = cross(e_x,e_y);

% Update the orientation of the ASA with the signed directions
R_ASA = [e_x,e_y,e_z];

end
            