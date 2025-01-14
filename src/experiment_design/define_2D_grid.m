function [x_vector,y_vector,xy_grid,x_N,y_N] = define_2D_grid(params_descriptor)
% Description:
% This function generates a 2D grid of parameter values for use in descriptor
% parameter training. The grid consists of two vectors, x_vector and y_vector, 
% representing the range of values for two parameters. The specific
% values depend on the descriptor type and its associated configuration settings.
%
% Inputs:
% - params_descriptor: A struct containing descriptor settings, including:
%     - name: Specifies the descriptor type (e.g., 'DHB', 'eFS', 'ISA', etc.).
%     - progress_type: Specifies the implemented progress type.
%
% Outputs:
% - x_vector: Vector of values for the first parameter: lambda or progress scale or null.
% - y_vector: Vector of values for the second parameter: L or null.
% - xy_grid: A 2D matrix initialized to zeros, with dimensions based on x_vector and y_vector.
  
    switch params_descriptor.name
        case {'DHB'}
            x_vector = [10^(-2), 10^(-1), 1, 10, 100];          % lambda [m]
            y_vector = linspace(0.1,0.9,5);                     % L [m]
        case {'eFS', 'eFS_opt'}
            x_vector = [10^(-3), 10^(-2), 10^(-1), 1, 10];      % lambda [m]
            y_vector = linspace(0.1,0.9,5);                     % L [m]
        case {'ISA', 'ISA_opt'}
            x_vector = [10^(-4), 10^(-3), 10^(-2), 10^(-1), 1]; % lambda [m]
            y_vector = linspace(0.1,0.9,5);                     % L [m]
        case {'BILTS_discrete', 'BILTS_discrete_reg'}
            switch params_descriptor.progress_type
                case 'angle'
                    x_vector = [1, 10, 20, 30, 40]/180*pi;      % [degrees]
                case 'screwbased'
                    x_vector = [0.03, 0.06, 0.09, 0.12, 0.15];  % [m] combined weighted rotation and translation!
            end
            y_vector = linspace(0.1,0.9,5);                     % L [m]
        case {'DSRF', 'RRV'}
            x_vector = 1;
            y_vector = 1;
            if strcmp(params_descriptor.progress_type,'screwbased')
                y_vector = linspace(0.1,0.9,5);                 % L [m]
            end
    end
    x_N = length(x_vector);
    y_N = length(y_vector);
    xy_grid = zeros(y_N,x_N);

end