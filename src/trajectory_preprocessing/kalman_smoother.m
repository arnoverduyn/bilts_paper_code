function [data_s, d_data_s, dd_data_s, ddd_data_s] = kalman_smoother(data, param)
% Smooth the data using a Kalman smoother with a constant Derk model.
% The Kalman smoother eliminates lag in the Kalman Filter estimation by doing a backward pass over the states.
%
% Input:
%   data - NxM input data with N samples and M different coordinates
%   param - parameters for the Kalman filter and smoother
%
% Output:
%   data_smooth - smoothed data
%   datadot_smooth - smoothed first derivative of data
%   datadotdot_smooth - smoothed second derivative of data

[N, M] = size(data);

% Initialize results structure
data_s = zeros(N, M);     % smooth data
d_data_s = zeros(N, M);   % smooth first derivative
dd_data_s = zeros(N, M);  % smooth second derivative
ddd_data_s = zeros(N, M); % smooth third derivative

% Loop over all coordinates in the data
for k = 1:M
    % Build system and measurement equations, process error covariance matrix, and measurement error covariance matrix
    if k <= 3
        % Position coordinates 
        [F, Q, H, R] = system_and_measurementModel_kalman(param, 'pos');
    else
        % Quaternions 
        [F, Q, H, R] = system_and_measurementModel_kalman(param, 'quat');
    end

    % Five states: data, first derivative and second derivative
    nb_states = size(F,2);
    X_FILT = zeros(nb_states, N); 
    X_PRED = zeros(nb_states, N);
    P_FILT = cell(1, N);
    P_PRED = cell(1, N);
    
    z = data(:, k)'; % Measurements
    
    % Initial state and initial state covariance matrix
    x_old = zeros(nb_states,1);
    x_old(1) = z(1);
    P_old = diag(param.P);
    
    % Kalman filter iteration (forward pass)
    for j = 1:N
        % Kalman predict: Prediction of current state using old state
        x_pred = F * x_old; 
        P_pred = F * P_old * F' + Q; 
        
        % Kalman correct: Correction of current state using predicted state
        nu = [z(j); 0] - H * x_pred; 
        
        % Innovation covariance
        S = H * P_pred * H' + R; 
        
        % Kalman gain
        K = P_pred * H' / S; 
        
        % Corrected state
        x_filt = x_pred + K * nu; 
        
        % Corrected state covariance
        P_filt = (eye(nb_states) - K * H) * P_pred; 
        
        % Store result of this iteration
        X_PRED(:, j) = x_pred;
        X_FILT(:, j) = x_filt;
        P_PRED{j} = P_pred;
        P_FILT{j} = P_filt;

        % Initialize next step
        x_old = x_filt;
        P_old = P_filt;
    end
    
    % Initialize smoothing vector with the last filtered state
    data_s(N, k) = x_filt(1);
    d_data_s(N, k) = x_filt(2);
    dd_data_s(N, k) = x_filt(3);
    ddd_data_s(N, k) = x_filt(4);
    
    % Start from last state
    x_new = X_FILT(:, N);
    P_new = P_FILT{N};
    
    % Kalman Smoother iteration (backward pass)
    for j = N-1:-1:1
        % Kalman smooth (Rauch-Tung-Striebel)
        x_filt = X_FILT(:, j);
        P_filt = P_FILT{j};
        x_pred = X_PRED(:, j + 1);
        P_pred = P_PRED{j + 1};
        
        J = P_filt * F' / P_pred; 
        x_smooth = x_filt + J * (x_new - x_pred);
        P_smooth = P_filt + J * (P_new - P_pred) * J';
        
        data_s(j, k) = x_smooth(1);
        d_data_s(j, k) = x_smooth(2);
        dd_data_s(j, k) = x_smooth(3);
        ddd_data_s(j, k) = x_smooth(4);
        
        % Next step
        x_new = x_smooth;
        P_new = P_smooth;
    end
end

end