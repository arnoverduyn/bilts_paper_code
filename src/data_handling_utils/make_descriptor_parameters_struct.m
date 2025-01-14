function params_descriptor = make_descriptor_parameters_struct(name,progress_type,L,lambda,ds_scale)
    params_descriptor = struct();
    params_descriptor.name = name;
    params_descriptor.progress_type = progress_type;
    params_descriptor.L = L;
    params_descriptor.lambda = lambda;
    params_descriptor.ds_scale = ds_scale;

    % Build Opti specification for the descriptors calculated using Optimal Control
    N = 100;
    opti_screw = NaN; var_screw = NaN; param_screw = NaN;
    if strcmp(name,'ISA_opt')
        [opti_screw, var_screw, param_screw] = build_ocp_screw(L,N,2/180*pi,0.002);
    end
    
    params_descriptor.opti_screw = opti_screw;
    params_descriptor.var_screw = var_screw;
    params_descriptor.param_screw = param_screw;
    
end