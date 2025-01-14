function descriptor = calculate_descriptor(T,dt,params_descriptor,params_kalman)
    switch params_descriptor.name
        case {'DHB'}
            descriptor = calculate_DHB_descriptor(T,dt,params_descriptor,params_kalman);
        case {'eFS', 'eFS_opt'}
            descriptor = calculate_eFS_descriptor(T,dt,params_descriptor,params_kalman);
        case {'ISA', 'ISA_opt'}
            descriptor = calculate_ISA_descriptor(T,dt,params_descriptor,params_kalman);
        case 'RRV'
            descriptor = calculate_RRV_descriptor(T,dt,params_descriptor);
        case 'DSRF'
            descriptor = calculate_DSRF_descriptor(T,dt,params_descriptor);
        case {'BILTS_discrete','BILTS_discrete_reg'}
            descriptor = calculate_BILTS_discrete(T,dt,params_descriptor);
        otherwise
            error('wrong descriptor name')
    end
end