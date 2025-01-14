function results = classify_all_trials(inputpath_descriptors,params_descriptor,dataset,experiment)

% Initialization

% Load the calculated descriptors of all the trials
files = find_all_trials_in_dataset(fullfile(inputpath_descriptors,experiment),'false');
nb_trials = length(files);

% Gather the model trials
model_trials = struct();
model_set = dataset.model_set;
counter = 0;
for i = 1:nb_trials
    trial = files(i);
    if strcmp(trial.context,model_set)
        counter = counter+1;
        model_trials(counter).motion_class = trial.motion_class;
        trial_location = fullfile(inputpath_descriptors,experiment,trial.motion_class,trial.context,trial.name);
        model_trials(counter).descriptor = csvread(trial_location);
    end
end

if counter == 0
    error('No models found. Check if model_set is written correctly')
end

%% Initialization of results. The parfor loop writes into the following shared arrays

% for each trial, the value ranges from 1 to nb_motion_classes, registering the original motion class of the trial
idx_original_class = zeros(nb_trials,1);

% for each trial, the value ranges from 1 to nb_motion_classes, registering as which motion class the trial was recognized
idx_recognized_class = zeros(nb_trials,1); 

% for each trial, the value ranges from 1 to nb_contexts, registering the original context of the trial
idx_context = zeros(nb_trials,1);

%% precompute relevant parameters
motion_classes = unique({files.motion_class});
contexts = unique({files.context});
contexts = contexts(~strcmp(contexts,model_set)); % remove the model set from the lists of contexts
descriptor_name = params_descriptor.name;

parfor i=1:nb_trials %%% PAR %%%
     
    trial = files(i);
    
    if ~strcmp(trial.context,model_set) % only classify trials that do not belong to the model set
        
        trial_location = fullfile(inputpath_descriptors,experiment,trial.motion_class,trial.context,trial.name);
        descriptor = csvread(trial_location);

        % Classify the trial to a certain motion class
        switch descriptor_name
           case {'eFS', 'eFS_opt', 'DHB', 'ISA', 'ISA_opt','RRV'}
                idx_recognized_class(i) = classify_descriptor(descriptor,model_trials,motion_classes);
            case {'BILTS_discrete', 'BILTS_discrete_reg'}
                idx_recognized_class(i) = classify_BILTS_discrete(descriptor,descriptor_name,model_trials,motion_classes);
            case 'DSRF'
                idx_recognized_class(i) = classify_descriptor_DSRF(descriptor,model_trials,motion_classes);
            otherwise
                error('During classification: wrong descriptor name')
        end

        % Store the index of the motion
        idx_original_class(i) = find(strcmp(motion_classes,trial.motion_class));
        % Store the index of the execution type
        idx_context(i) = find(strcmp(contexts,trial.context));
    end
end

% Initialize the confusion matrices
nb_motion_classes = length(motion_classes);
nb_contexts = length(contexts); 
confusion_matrix_total = zeros(nb_motion_classes,nb_motion_classes);
confusion_matrix_per_context = struct();
for k = 1:nb_contexts
    confusion_matrix_per_context(k).matrix = zeros(nb_motion_classes,nb_motion_classes);
    confusion_matrix_per_context(k).context = contexts(k);
end

% Calculate the confusion matrices
for i=1:nb_trials
    
    trial_context = files(i).context;
    
    if ~strcmp(trial_context,model_set) % only classify trials that do not belong to the model set
        
        orig = idx_original_class(i);
        recog = idx_recognized_class(i);
        cont = idx_context(i);
        
        % Construct confusion matrices: shows how many motions of a certain class were classified to the other motions
        confusion_matrix_total(orig,recog) = confusion_matrix_total(orig,recog) + 1;
        confusion_matrix_per_context(cont).matrix(orig,recog) = confusion_matrix_per_context(cont).matrix(orig,recog) + 1;
    end

end

% Calculate total recognition rate
nb_corrects = 0;
for i = 1:nb_motion_classes
    nb_corrects = nb_corrects + confusion_matrix_total(i,i);
end
recognition_rate = nb_corrects/sum(confusion_matrix_total,'all');

% Normalize the confusion matrices
for i = 1:nb_motion_classes
    confusion_matrix_total(i,:) = confusion_matrix_total(i,:)/sum(confusion_matrix_total(i,:));
    for k = 1:nb_contexts
        confusion_matrix_per_context(k).matrix(i,:) = confusion_matrix_per_context(k).matrix(i,:)/...
            sum(confusion_matrix_per_context(k).matrix(i,:));
    end
end
    
% Display the results
disp(' ')
disp('**********************')
disp(['Recognition rate: ' , num2str(round(recognition_rate*100,1))]);
disp('**********************')
disp(' ')

% store the results in a struct
results.recognition_rate = recognition_rate;
results.confusion_matrix_total = confusion_matrix_total;
results.confusion_matrix_per_context = confusion_matrix_per_context;
    
end