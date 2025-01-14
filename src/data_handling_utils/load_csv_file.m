function [T, dt] = load_csv_file(csv_file)
% This function loads the .csv file in the data folder
% It is assumed that this .csv file has the following format:
% - its first column contains the time vector
% - its second to fourth columns contain the xyz position coordinates 
% - its fifth to eighth columns contain the quaternion coordinates [w x y z]
    
    raw_data = csvread(csv_file);
    time_vector = raw_data(:,1);
    time_vector = time_vector - time_vector(1);
        
    pos = raw_data(:,2:4)';
    quat = raw_data(:,5:8)';
    
    T = quat2pose(pos, quat);

    % Resample to an equidistant sampling interval (50Hz)
    dt = 0.02; % [s]
    N = round(1 + floor(time_vector(end)/dt));
    time_new = linspace(0,time_vector(end),N);
    T = interpT(time_vector,T,time_new);
end