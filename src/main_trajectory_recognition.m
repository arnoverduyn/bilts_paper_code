% This script processes structured (labeled) datasets to calculate trajectory descriptors
% and classify motions using a 1-NN (1-Nearest Neighbor) classifier. The workflow consists of:
%
% 1. Descriptor Parameter Training:
%    - Perform a grid search to train the parameters of the trajectory descriptors.
%    - Use a designated subset of the dataset for training.
%
% 2. Testing:
%    - Evaluate the trained descriptor parameters on a separate test set to assess descriptor recognition accuracy.
%

clc; clear; close all;

% Reset MATLAB search path to default
restoredefaultpath;

%% Specify the Matlab Paths

addpath(genpath('..\Libraries\'));       % Path to CasADi
addpath(genpath('..\src\'));             % Path to src folder

datasets_path = '..\Data\Datasets';      % Path to the rigid-body motion datasets
outputpath = '..\Output\';               % Folder where intermediate results are stored

%% High-level Settings

% Experiment type: 'training' or 'test'
experiment = 'test'; 

% Available descriptors: 'ISA', 'ISA_opt', 'DHB', 'eFS', 'RRV', 'DSRF', 'BILTS_discrete', 'BILTS_discrete_reg'
params_descriptor = struct('name', 'BILTS_discrete_reg');     

% Available progress parameters: 'arclength', 'angle', 'screwbased'
params_descriptor.progress_type = 'screwbased'; 

%% Specify the dataset 
dataset = struct('name','SYN',...           % 'DLA' or 'SYN'
                 'model_set','Original');  %  The subset from which references or 'models' will be taken: 'normal_V2' or 'Original'
dataset.path = fullfile(datasets_path, dataset.name);

% Only applicable for DLA datasets
dataset.adapted_version = 0;
% 0 ---> original dataset
% 1 ---> adapted DLA 1: change in body reference point
% 2 ---> adapted DLA 2: successive motions in diverse directions

%% Run the experiment
switch experiment
    case 'training'
        train_parameters(params_descriptor, dataset, outputpath);
    case 'test'
        params_descriptor = use_trained_parameters(params_descriptor,dataset.name,dataset.adapted_version);
        results = run_classification_experiment(params_descriptor,dataset,outputpath,'test');
        plot_confusion_matrix(results)
end
