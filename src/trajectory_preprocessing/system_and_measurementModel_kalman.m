function [F,Q,H,R] = system_and_measurementModel_kalman(param,trajectory_type)
%Construct system model equations and measurement model equations for Kalman Filter/smoother constant djerk model
%
% Input: kalman_model_parameters = parameters % TODO break this up again into separate parameters
% 
% Output: F = system equations, 5x5 matrix
%         Q = process error covariance, 5x5 matrix
%         H = measurement equations, 1x5 matrix
%         R = measurement error covariance, 5x5 matrix

% Loading parameters
if strcmp(trajectory_type,'pos')
    sigma_m = param.sigma_pos;
elseif strcmp(trajectory_type,'quat')
    sigma_m = param.sigma_rot;
end
dt = param.dt;

%System matrix (this is basically a Taylor series expansion of the position (first row), velocity (second row), etc.
F=[[1 0 0 0]' [dt 1 0 0]' [dt^2/2 dt 1 0]' [dt^3/6 dt^2/2 dt 1]'];

%Process disturbance factor (final term of Taylor series expansion)
q=[dt^4/24 dt^3/6 dt^2/2 dt];
qq=q'*q;
Q=(param.Q)^2*(qq);

%Measurement system
H=[1 0 0 0; 0 1 0 0]; % position measurement + virtual velocity measurement to increase damping

%Noise covariance matrix
R=[sigma_m^2, 0; 0, 10^6*sigma_m^2/dt^2]; 

end
