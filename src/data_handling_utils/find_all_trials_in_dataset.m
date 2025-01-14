function files = find_all_trials_in_dataset(dataset_path,experiment)
%This function locates .csv data files in the given directories and
%its subdirectories and saves these in a structure.

if isempty(dataset_path)
    error('No data found in this directory, check if written correctly')
end

files = [];
if ismember(experiment,{'test','training'})
    dataset_path = [dataset_path '/' experiment];
end

[motion_classes, number_of_classes] = find_all_subfolders_in_folder(dataset_path);   

counter = 0; % increases everytime a trial is found
for j = 1:number_of_classes 
    
    [contexts, number_of_contexts] = find_all_subfolders_in_folder([dataset_path '/' motion_classes(j).name]);
    
    for k = 1:number_of_contexts 
        
        [trials, number_of_trials] = find_all_subfolders_in_folder([dataset_path '/' motion_classes(j).name '/' contexts(k).name]);

        for l = 1:number_of_trials 
            counter = counter+1;
            files(counter).motion_class = motion_classes(j).name;
            files(counter).context = contexts(k).name;
            files(counter).name = trials(l).name;
        end
    end
end