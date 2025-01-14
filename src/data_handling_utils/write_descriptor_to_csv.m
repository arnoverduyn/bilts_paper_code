function write_descriptor_to_csv(descriptor,outputpath,experiment,trial)
    output_folder = fullfile(outputpath, experiment, trial.motion_class, trial.context);
    descriptor_location = fullfile(output_folder, strcat([trial.name]));
    csvwrite(descriptor_location,descriptor)
end