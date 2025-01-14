function train_parameters(bools, params_descriptor, dataset, outputpath)
    
    % Define the 2D grid for the parameters on which the grid search is performed
    [x_vector,y_vector,xy_grid,x_N,y_N] = define_2D_grid(params_descriptor);
    
    %% Perform the parameter training
    counter_xy = 0;
    for x = 1:x_N
        for y = 1:y_N
            % Initialize descriptor parameter values
            params_descriptor.lambda = NaN;    % hyperparameter (only applicable to eFS, DHB, ISA, and ISA_opt) 
            params_descriptor.ds_scale = NaN;  % progress scale (only applicable to BILTS) 
            
            % Implement descriptor specific parameter values
            params_descriptor.L = y_vector(y); % [m] geometric scale factor to weigh rotations and translations        
            switch params_descriptor.name
                case {'DHB', 'eFS', 'eFS_opt', 'ISA', 'ISA_opt'}
                    params_descriptor.lambda = x_vector(x);   % [m^-1] or [rad^-1] depending on the progress type
                case {'BILTS_discrete', 'BILTS_discrete_reg'}
                    params_descriptor.ds_scale = x_vector(x); % [m]
            end
            
            % Run the recognition experiment with the current values for the descriptor parameters
            results = run_classification_experiment(params_descriptor,dataset,outputpath,'training');
            
            % Store the result
            xy_grid(y,x) = results.recognition_rate; 

            % Print computation progress
            computation_progress = counter_xy/(x_N*y_N)*100;
            display(strcat(['Computation progress: ', num2str(computation_progress), ' %']));
            disp(' ')
            counter_xy = counter_xy + 1;
        end
    end

    %% Post-process and visualize the results

    % Apply the Moving Average Filter
    xy_grid_smoothed = smoothdata(xy_grid, 'gaussian', [2 2]);

    % Find the maximum value and its linear index
    [~, linear_index] = max(xy_grid_smoothed(:));
    
    % Convert the linear index to row and column indices
    [row, col] = ind2sub(size(xy_grid), linear_index);
    
    display_training_results(xy_grid(row,col),y_vector(row),x_vector(col))
    plot_training_results(xy_grid,x_vector,y_vector,x_N,y_N,'raw')
    plot_training_results(xy_grid_smoothed,x_vector,y_vector,x_N,y_N,'after moving average smoother')   

end