function params_kalman = get_kalman_smoother_parameters(params_descriptor)
    if ismember(params_descriptor.name,{'DHB','eFS','ISA','ISA_opt'})
        params_kalman = struct('sigma_rot',1/180*pi, ...          % uncertainty on the orientation measurements [rad]
                              'sigma_pos', 0.002, ...             % uncertainty on the position measurements [m]
                              'P'        , [1 10^2 10^4 10^6], ...% diagonal elements of the initial state covariance matrix
                              'Q'        , 50);                   % Process noise covariance value, related to the standard deviation of the white noise jerk model
    else
        params_kalman = NaN;
    end
end