function display_training_results(validation_result,y_optimal,x_optimal,params_descriptor)
    disp(' ')
    disp('***************************************')
    disp('Validation results')
    message = strcat(['   Highest Recognition Accuracy: ' num2str(round(validation_result*100,1)) '%']);
    disp(message);
    if ismember(params_descriptor.name,{'DHB','eFS','ISA','ISA_opt'})
        x_name = 'lambda';
        x_units = ' ';
    elseif ismember(params_descriptor.name,{'BILTS_discrete','BILTS_discrete_reg'})
        x_name = 'xi';
        switch params_descriptor.progress_type
            case 'angle'
                x_units = 'degrees'; 
                x_optimal = x_optimal*180/pi;
            case 'screwbased'
                x_units = 'm'; 
        end
    else
        x_name = 'na';
        x_units = 'na';
    end
    
    message = strcat(['   Optimal parameters: L: ', num2str(y_optimal), 'm   , ', x_name, ': ', num2str(x_optimal), ' ', x_units]); 
    disp(message);
    disp('***************************************')
end


