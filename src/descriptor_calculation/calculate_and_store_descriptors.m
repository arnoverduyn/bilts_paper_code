function calculate_and_store_descriptors(dataset,outputpath,params_descriptor,experiment)
% Calculate and store the descriptors

% Reduces the need to repeatedly access fields of the struct 
dataset_path = dataset.path;
model_set = dataset.model_set;
dataset_adapted_version = 0;
if strcmp(dataset.name,'DLA')
    dataset_adapted_version = dataset.adapted_version;
end

% Gather all the data contained in the specified directories plus subdirectories
trials = find_all_trials_in_dataset(dataset_path,'false');
nb_trials = length(trials);

% Specify the parameters of the Kalman smoother (white noise derivative jerk model)
% This smoother is only applied for the descriptors: 'DHB','eFS','ISA','ISA_opt'
params_kalman = get_kalman_smoother_parameters(params_descriptor);
                        
% Initialize the output folders where the calculated descriptors are saved
make_output_folders(trials,nb_trials,model_set,experiment,outputpath)

%% Compute the descriptors (parallellisation for faster computation)

% Partition the data (depends on the number of cores available)
nb_partitions = 2*8; %
partition_size = round(nb_trials/nb_partitions);

% Copy the necessary information to initialize the parfor threads and reduce communication overhead
[name,progress_type,L,lambda,ds_scale] = get_descriptor_parameters(params_descriptor);
trials_copy = trials;

parfor Q = 1:nb_partitions+1

    % Initialize parameters and variables for the current partition (parfor thread)
    trials = trials_copy;
    params_descriptor = make_descriptor_parameters_struct(name,progress_type,L,lambda,ds_scale);
   
    % Perform the calculation
    start_index = 1+(Q-1)*partition_size;
    end_index = 1+Q*partition_size;
    
    for i= start_index:end_index
        
        if i <= nb_trials
            
            % Retrieve the current trial
            trial = trials(i);

            % Load the data
            trial_location = fullfile(dataset_path, trial.motion_class, trial.context, trial.name);
            [T, dt] = load_csv_file(trial_location);
            
            % Adapt the pose trajectories in case of the adapted DLA datasets
            T = adapt_trial(T,trial,model_set,dataset_adapted_version);
            
            % Calculate the invariant descriptor and save the result as a .csv file
            if strcmp(trial.context,model_set)

                descriptor = calculate_descriptor(T,dt,params_descriptor,params_kalman);
                write_descriptor_to_csv(descriptor,outputpath,experiment,trial)

            else
                if strcmp(experiment,'training') && strcmp(trial.name(end-4),'1')

                    descriptor = calculate_descriptor(T,dt,params_descriptor,params_kalman);
                    write_descriptor_to_csv(descriptor,outputpath,experiment,trial)
                    
                elseif strcmp(experiment,'test') && not(strcmp(trial.name(end-4),'1'))

                    descriptor = calculate_descriptor(T,dt,params_descriptor,params_kalman);
                    write_descriptor_to_csv(descriptor,outputpath,experiment,trial)

                end
            end
        end
    end
end

end