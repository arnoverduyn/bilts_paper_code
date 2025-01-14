function results = run_classification_experiment(params_descriptor,dataset,outputpath,experiment)
    
    outputpath_descriptors = fullfile(outputpath, 'Descriptors', params_descriptor.name, dataset.name);

    % Clean the output directory before you calculate the descriptors again
    if isfolder(outputpath_descriptors) 
        rmdir(outputpath_descriptors,'s')
    end
    
    % Calculate the descriptors
    disp('Calculating descriptors ...')
    calculate_and_store_descriptors(dataset,outputpath_descriptors,params_descriptor,experiment);
    
    % Classify the motions
    disp('Classifying motions ...')
    results = classify_all_trials(outputpath_descriptors,params_descriptor,dataset,experiment);         
end