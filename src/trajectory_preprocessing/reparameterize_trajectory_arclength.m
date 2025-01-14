function [T_interp, s] = reparameterize_trajectory_arclength(T,dt,ds,N_min)
% Reparameterize a given time-based trajectory such that it becomes a function of a geometric progress variable
%   Symbolically : T(t) -> T(xi)
% Practically, it means that motions with a different velocity profile or a different duration have the same coordinates
%
% Input:    meas_traj_time = trajectory as a function of time
%           dt = timestep
% Output:   meas_traj = trajectory as a function of xi
%           s = vector containing geometric degree of advancement (arclength) as a function of time

    N = size(T,3);
    p = squeeze(T(1:3,4,:));
    
    Pdot = diff(p,1,2)/dt;
    v = sqrt(sum(Pdot.^2,1));

    s = [0];
    for k = 1:N-1
        s(k+1) = s(k) + v(k)*dt;
    end

    % equidistant s
    if ds
        if s(end) < ds
            s_equi = [0 , s(end)];
        else
            N_s = round(1 + floor(s(end)/ds));
            s_equi = linspace(0,s(end),N_s);
        end
        T_interp = interpT(s,T,s_equi);
    else
        s_equi = linspace(0,s(end),N_min);
        T_interp = interpT(s,T,s_equi);
    end

end
