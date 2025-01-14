function [T_interp, s] = reparameterize_trajectory_angle(T,dt,ds,N_min)

    N = size(T,3);
    omega = zeros(3,N-1);
    for j = 1 : N-1
        omega(:,j) = extract_omega(T(1:3,1:3,j),T(1:3,1:3,j+1),dt);
    end
    omega1 = sqrt(sum(omega.^2,1));

    s = [0];
    for k = 1:N-1
        s(k+1) = s(k) + omega1(k)*dt;
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
