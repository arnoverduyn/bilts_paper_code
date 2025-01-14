function [name,progress_type,L,lambda,ds_scale] = get_descriptor_parameters(params_descriptor)
    name = params_descriptor.name;
    progress_type = params_descriptor.progress_type;
    L = params_descriptor.L;
    lambda = params_descriptor.lambda;
    ds_scale = params_descriptor.ds_scale;
end