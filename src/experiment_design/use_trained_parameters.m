function params_descriptor = use_trained_parameters(params_descriptor, validation_set_name)
    
    % Values for the trained parameters. These were hard-coded after training
    
    % Initialize descriptor parameter values
    params_descriptor.lambda = NaN;    % hyperparameter (only applicable to eFS, DHB, ISA, and ISA_opt) 
    params_descriptor.ds_scale = NaN;  % progress scale (only applicable to BILTS) 
    
    try
        switch params_descriptor.name
            case 'DHB'
                switch params_descriptor.progress_type
                    case 'arclength'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 100;        % 73.6%
                                params_descriptor.L = 0.1;    
                            case 'DLA'
                                params_descriptor.lambda = 10;          % 89%
                                params_descriptor.L = 0.1;  
                        end
                    case 'angle'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 10;          % 55%
                                params_descriptor.L = 0.3;    
                            case 'DLA'
                                params_descriptor.lambda = 0.1;         % 92.0%
                                params_descriptor.L = 0.9;  
                        end
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 100;         % 73.6%
                                params_descriptor.L = 0.3;    
                            case 'DLA'
                                params_descriptor.lambda = 0.1;         % 94.0%
                                params_descriptor.L = 0.7;  
                        end
                end
            case 'eFS'
                switch params_descriptor.progress_type
                    case 'arclength'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 10;          % 59.3%
                                params_descriptor.L = 0.7;    
                            case 'DLA'
                                params_descriptor.lambda = 0.1;         % 82.0%
                                params_descriptor.L = 0.1;  
                        end
                    case 'angle'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 1;           % 55%
                                params_descriptor.L = 0.1;    
                            case 'DLA'
                                params_descriptor.lambda = 0.001;       % 90.0%
                                params_descriptor.L = 0.9;  
                        end
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 10;          % 72.1%
                                params_descriptor.L = 0.1;    
                            case 'DLA'
                                params_descriptor.lambda = 0.01;        % 97.0%
                                params_descriptor.L = 0.5;  
                        end
                end
                       
            case 'ISA'
                switch params_descriptor.progress_type
                    case 'angle'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 10^(-3);     % 63.6%
                                params_descriptor.L = 0.7;    
                            case 'DLA'
                                params_descriptor.lambda = 0.0001;      % 89.0%
                                params_descriptor.L = 0.5;  
                        end
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 10^(-3);     % 62.9%
                                params_descriptor.L = 0.3;    
                            case 'DLA'
                                params_descriptor.lambda = 10^(-4);     % 90.0%
                                params_descriptor.L = 0.7;  
                        end
                end
            case 'ISA_opt'
                switch params_descriptor.progress_type
                    case 'angle'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 0.01;        % 84.3%
                                params_descriptor.L = 0.9;    
                            case 'DLA'
                                params_descriptor.lambda = 0.0001;      % 92.0%
                                params_descriptor.L = 0.3;  
                        end
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 1;           % 85.7%
                                params_descriptor.L = 0.3;    
                            case 'DLA'
                                params_descriptor.lambda = 0.001;       % 94.0%
                                params_descriptor.L = 0.3;  
                        end
                end
            case 'RRV'
                switch validation_set_name
                    case 'SYN'
                        params_descriptor.L = 0.9;                      % 54.3  
                    case 'DLA'
                        params_descriptor.L = 0.9;                      % 93.0
                end
            case 'DSRF'
                switch validation_set_name
                    case 'SYN'
                        params_descriptor.L = 0.9;                      % 88.6 
                    case 'DLA'
                        params_descriptor.L = 0.9;                      % 98.0
                end
            case 'BILTS_discrete'
                switch params_descriptor.progress_type
                    case 'angle'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.ds_scale = 20/180*pi; % 76.4%
                                params_descriptor.L = 0.9;    
                            case 'DLA'
                                params_descriptor.ds_scale = 10/180*pi; % 88.0%
                                params_descriptor.L = 0.9;  
                        end
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.ds_scale = 0.06;      % 75.0%
                                params_descriptor.L = 0.9;    
                            case 'DLA'
                                params_descriptor.ds_scale = 0.12;      % 91.0%
                                params_descriptor.L = 0.7;  
                        end
                end
            case 'BILTS_discrete_reg'
                switch params_descriptor.progress_type
                    case 'angle'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.ds_scale = 40/180*pi; % 100%
                                params_descriptor.L = 0.9;    
                            case 'DLA'
                                params_descriptor.ds_scale = 10/180*pi; % 96.0%
                                params_descriptor.L = 0.3;  
                        end
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.ds_scale = 0.15;      % 100%
                                params_descriptor.L = 0.9;    
                            case 'DLA'
                                params_descriptor.ds_scale = 0.12;      % 95.0%
                                params_descriptor.L = 0.3;  
                        end
                end
        end
    catch
        disp('In use_trained_parameters(), wrong descriptor name or progress type')
    end
end