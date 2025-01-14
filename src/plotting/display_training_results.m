function display_validation_results(validation_result,y_optimal,x_optimal)
    disp(' ')
    disp('***************************************')
    disp('Validation results')
    message = strcat(['   Highest Recognition Accuracy: ' num2str(round(validation_result*100,1)) '%']);
    disp(message);
    message = strcat(['   Optimal parameters: L: ', num2str(y_optimal), 'm   ds: ', num2str(x_optimal),' degrees']); 
    disp(message);
    disp('***************************************')
end


