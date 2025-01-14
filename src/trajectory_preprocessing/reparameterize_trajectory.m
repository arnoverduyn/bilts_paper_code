function [T_s,s] = reparameterize_trajectory(T,dt,N,params_descriptor)

    % Reparametrize temporal trajectory to geometric domain
    switch params_descriptor.progress_type
        case 'arclength'
            [T_s,s] = reparameterize_trajectory_arclength(T,dt,false,N);
        case 'angle'
            [T_s,s] = reparameterize_trajectory_angle(T,dt,false,N);
        case 'screwbased'
            [T_s,~,s] = reparametrize_trajectory_screwbased(T,params_descriptor.L,dt,false,N);
    end
    
end

