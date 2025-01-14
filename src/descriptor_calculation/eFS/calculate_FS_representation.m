function descriptor = calculate_FS_representation(vector, vector_dot, vector_ddot)

%Save interim results
norm_vector = sqrt(sum(vector.^2,1));                     % norm(vector)
vectorXvectordot = cross(vector,vector_dot,1);            % vector x vector_dot
norm_vectorXvectordot = sqrt(sum(vectorXvectordot.^2,1)); % norm(vector x vector_dot)
vectorXvectorddot = cross(vector,vector_ddot,1);          % vector x vector_ddot


e_x = vector./norm_vector; 
omega_kappa = norm_vectorXvectordot./norm_vector.^2; 
omega_tau = dot(cross(vectorXvectordot,vectorXvectorddot,1)./norm_vectorXvectordot.^2, e_x ,1); 

descriptor = [norm_vector; omega_kappa; omega_tau];

