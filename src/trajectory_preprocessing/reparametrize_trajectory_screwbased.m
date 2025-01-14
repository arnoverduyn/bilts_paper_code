function [T_s,N,s_t] = reparametrize_trajectory_screwbased(T,L,dt,ds,N_min)
% This function reparameterizes a pose trajectory to the geometric progress 
% domain using the geometric regulated screw-based progress.
%
%   Inputs:
%       T       - 4x4xN array of homogeneous transformation matrices representing the pose trajectory.
%       L       - Regularization parameter [m] defining the radius of the spherical region around the initial reference point for translation.
%       dt      - Time interval between successive poses.
%       ds      - Desired progress step size (set to 0 when you want to enforce a predefined number of geometric samples in the reparameterized pose trajectory).
%       N_min   - Minimum number of samples in the reparameterized trajectory.
%
%   Outputs:
%       T_s     - 4x4xM array of reparameterized homogeneous transformation matrices.
%       N       - Number of poses in the reparameterized trajectory.
%       s_t     - Cumulative geometric progress values for the original trajectory.
%
%   The function performs the following steps:
%   1. Computes the body-fixed twist between successive poses.
%   2. Regularizes the screw-based velocities based on the given parameter L.
%   3. Calculates the geometric progress rate and updates the cumulative progress.
%   4. Uses interpolation to reparameterize the trajectory based on either the
%      desired progress step size (ds) or a predefined number of samples.
%
%   See also: LOGM, EXPM, INTERP1

% Initialize variables
N = size(T,3);
s_t = zeros(1,N);
for k = 1:N-1
    % Calculate the body-fixed twist
    if sum((inverse_T(T(:,:,k))*T(:,:,k+1)).^2,'all')>10^(-8)
        twist_cross = logm_pose(inverse_T(T(:,:,k))*T(:,:,k+1))/dt;
    else
        twist_cross = zeros(4,4);
    end
    omega = [twist_cross(3, 2); twist_cross(1, 3); twist_cross(2, 1)];
    vel = twist_cross(1:3,4);
    
    % Calculate regularized screw-based velocities
    if norm(omega) == 0
        v1 = norm(vel);
    else
        p_perp = cross(omega,vel)/dot(omega,omega);
        if norm(p_perp) > L
            p_boundary = L*p_perp/norm(p_perp);
            vel_ref = vel + cross(omega,p_boundary);
            v1 = norm(vel_ref);
        else
            v1 = dot(vel,omega)/norm(omega);
        end
    end
    
    % Calculate the geometric progress rate and update the cumulative progress
    s_dot = sqrt(L^2*dot(omega,omega) + v1^2);
    s_t(k+1) = s_t(k) + norm(s_dot)*dt;
end

% Determine the predefined progress step or predefined number of samples
if ds 
    % a predefined progress step is used
    N_s = round(1 + floor(s_t(end)/ds));
    if N_s < N_min
        s = linspace(0,s_t(end),N_min);
    else
        s = linspace(0,s_t(end),N_s);
    end
    
else
    % a predefined number of samples is used
    s = linspace(0,s_t(end),N_min);
end

% Perform the reparameterization using interpolation
T_s = interpT(s_t,T,s);
N = size(T_s,3);

end