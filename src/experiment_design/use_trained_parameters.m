function params_descriptor = use_trained_parameters(params_descriptor, validation_set_name, adapted_version)
    
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
                                params_descriptor.lambda = 100;       
                                params_descriptor.L = 0.3;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 10;         
                                        params_descriptor.L = 0.1; 
                                    case 1
                                        params_descriptor.lambda = 10;         
                                        params_descriptor.L = 0.1; 
                                    case 2
                                        params_descriptor.lambda = 10;         
                                        params_descriptor.L = 0.1; 
                                end 
                        end
                    case 'angle'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 100;         
                                params_descriptor.L = 0.3;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 0.1;         
                                        params_descriptor.L = 0.9; 
                                    case 1
                                        params_descriptor.lambda = 0.1;         
                                        params_descriptor.L = 0.9; 
                                    case 2
                                        params_descriptor.lambda = 0.1;         
                                        params_descriptor.L = 0.7; 
                                end  
                        end
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 100;       
                                params_descriptor.L = 0.3;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 0.05;         
                                        params_descriptor.L = 0.5; 
                                    case 1
                                        params_descriptor.lambda = 1;         
                                        params_descriptor.L = 0.5; 
                                    case 2
                                        params_descriptor.lambda = 0.01;         
                                        params_descriptor.L = 0.5; 
                                end  
                        end
                end
            case 'eFS'
                switch params_descriptor.progress_type
                    case 'arclength'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 10;          
                                params_descriptor.L = 0.1;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 0.1;         
                                        params_descriptor.L = 0.1; 
                                    case 1
                                        params_descriptor.lambda = 0.1;         
                                        params_descriptor.L = 0.1; 
                                    case 2
                                        params_descriptor.lambda = 0.001;         
                                        params_descriptor.L = 0.1; 
                                end 
                        end
                    case 'angle'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 0.1;           
                                params_descriptor.L = 0.7;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 0.001;         
                                        params_descriptor.L = 0.7; 
                                    case 1
                                        params_descriptor.lambda = 0.01;         
                                        params_descriptor.L = 0.9; 
                                    case 2
                                        params_descriptor.lambda = 0.001;         
                                        params_descriptor.L = 0.9; 
                                end
                        end
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 10;       
                                params_descriptor.L = 0.1;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 0.01;         
                                        params_descriptor.L = 0.5; 
                                    case 1
                                        params_descriptor.lambda = 0.01;         
                                        params_descriptor.L = 0.7; 
                                    case 2
                                        params_descriptor.lambda = 0.001;         
                                        params_descriptor.L = 0.5; 
                                end
                        end
                end
                       
            case 'ISA'
                switch params_descriptor.progress_type
                    case 'angle'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 0.001;   
                                params_descriptor.L = 0.1;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 0.0001;         
                                        params_descriptor.L = 0.5; 
                                    case 1
                                        params_descriptor.lambda = 0.0001;         
                                        params_descriptor.L = 0.5; 
                                    case 2
                                        params_descriptor.lambda = 0.001;         
                                        params_descriptor.L = 0.3; 
                                end 
                        end
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 0.01;     
                                params_descriptor.L = 0.3;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 0.0001;         
                                        params_descriptor.L = 0.5; 
                                    case 1
                                        params_descriptor.lambda = 0.0001;         
                                        params_descriptor.L = 0.5; 
                                    case 2
                                        params_descriptor.lambda = 0.0001;         
                                        params_descriptor.L = 0.7; 
                                end
                        end
                end
            case 'ISA_opt'
                switch params_descriptor.progress_type
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.lambda = 1;           
                                params_descriptor.L = 0.3;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 0.0001;         
                                        params_descriptor.L = 0.3; 
                                    case 1
                                        params_descriptor.lambda = 0.01;         
                                        params_descriptor.L = 0.3; 
                                    case 2
                                        params_descriptor.lambda = 0.0001;         
                                        params_descriptor.L = 0.3; 
                                end
                        end
                end
            case 'RRV'
                switch validation_set_name
                    case 'SYN'
                        params_descriptor.L = 0.9;                      
                    case 'DLA'       
                        switch adapted_version
                            case 0       
                                params_descriptor.L = 0.9; 
                            case 1       
                                params_descriptor.L = 0.9; 
                            case 2         
                                params_descriptor.L = 0.9; 
                        end
                end
            case 'DSRF'
                switch validation_set_name
                    case 'SYN'
                       params_descriptor.L = 0.9;       
                    case 'DLA'
                        switch adapted_version
                            case 0      
                                params_descriptor.L = 0.5; 
                            case 1   
                                params_descriptor.L = 0.7; 
                            case 2     
                                params_descriptor.L = 0.1; 
                        end 
                end
            case 'BILTS_discrete'
                switch params_descriptor.progress_type
                    case 'angle'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.ds_scale = 10/180*pi;
                                params_descriptor.L = 0.9;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 20/180*pi;         
                                        params_descriptor.L = 0.3; 
                                    case 1
                                        params_descriptor.lambda = 20/180*pi;         
                                        params_descriptor.L = 0.3; 
                                    case 2
                                        params_descriptor.lambda = 30/180*pi;         
                                        params_descriptor.L = 0.9; 
                                end
                        end
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.ds_scale = 0.06;    
                                params_descriptor.L = 0.3;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 0.15;         
                                        params_descriptor.L = 0.7; 
                                    case 1
                                        params_descriptor.lambda = 0.15;         
                                        params_descriptor.L = 0.7; 
                                    case 2
                                        params_descriptor.lambda = 0.03;         
                                        params_descriptor.L = 0.9; 
                                end
                        end
                end
            case 'BILTS_discrete_reg'
                switch params_descriptor.progress_type
                    case 'screwbased'
                        switch validation_set_name
                            case 'SYN'
                                params_descriptor.ds_scale = 0.12;      
                                params_descriptor.L = 0.7;    
                            case 'DLA'
                                switch adapted_version
                                    case 0
                                        params_descriptor.lambda = 0.03;         
                                        params_descriptor.L = 0.3; 
                                    case 1
                                        params_descriptor.lambda = 0.15;         
                                        params_descriptor.L = 0.7; 
                                    case 2
                                        params_descriptor.lambda = 0.03;         
                                        params_descriptor.L = 0.1; 
                                end
                        end
                end
        end
    catch
        disp('In use_trained_parameters(), wrong descriptor name or progress type')
    end
end