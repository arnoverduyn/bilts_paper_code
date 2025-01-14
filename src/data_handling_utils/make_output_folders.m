function make_output_folders(trials,nb_trials,model_set,experiment,outputpath)

    for i = 1:nb_trials
        trial = trials(i);

        if strcmp(trial.context,model_set) 

            % Reference trials are used for both the training and testing
            output_folder = fullfile(outputpath, experiment, trial.motion_class, trial.context);
            if (~exist(output_folder,'dir')); mkdir(output_folder); end % Make the folder if it does not exist yet

        else
            if strcmp(experiment,'training') && strcmp(trial.name(end-4),'1') % trial_1.csv

                % Only the first trial of every context (apart from the reference context) is used for parameter training
                output_folder = fullfile(outputpath, experiment, trial.motion_class, trial.context);
                if (~exist(output_folder,'dir')); mkdir(output_folder); end % Make the folder if it does not exist yet

            elseif strcmp(experiment,'test') && not(strcmp(trial.name(end-4),'1'))

                % The remaining trials within every context (apart from the reference context) is used for descriptor testing
                output_folder = fullfile(outputpath, 'test', trial.motion_class, trial.context);
                if (~exist(output_folder,'dir')); mkdir(output_folder); end % Make the folder if it does not exist yet
                
            end
        end
    end
end