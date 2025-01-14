function T = adapt_trial(T,trial,model_set,dataset_adapted_version)
% 1. Version 1 (dataset_adapted_version == 1): 
%    - The adaptation is based on changes in the body-reference point.
%    - If the context of the trial differs from the reference context, the body reference point gets displaced by delta_p = [-0.2; 0; 0]. 
%    - This is done by adding delta_p to the translation component of the transformation matrix for each time step.
%  
% 2. Version 2 (dataset_adapted_version == 2):
%    - The adaptation involves applying successive motions in diverse directions
%    - The first motion is the original motion
%    - The second motion is rotated by 45° (clockwise or counter-clockwise, depending on the trial's motion_class).

    if dataset_adapted_version == 1
    
        % Change in body-reference point
        if ~strcmp(trial.context,model_set)
            delta_p = [-0.2;0;0];
        else
            delta_p = [0;0;0];
        end
    
        for k = 1:size(T,3)
            T(1:3,4,k) = T(1:3,4,k) + T(1:3,1:3,k)*delta_p;
        end
    
    elseif dataset_adapted_version == 2
    
        % Successive motions in diverse directions
        N_successive = round(2*size(T,3));
        T_successive = zeros(4,4,N_successive);
        T_successive(:,:,1:size(T,3)) = T;
        if strcmp(trial.motion_class,'cutting') || strcmp(trial.motion_class,'pouring_with_cup') || ...
                strcmp(trial.motion_class,'quarter_turn') || strcmp(trial.motion_class,'scooping_food') || ...
                strcmp(trial.motion_class,'sinus')
            sign_angle = 1;
        else
            sign_angle = -1;
        end
    
        if strcmp(trial.context,model_set)
            rotation = rotz(45*sign_angle);
        else
            rotation = rotz(-45*sign_angle);
        end
    
        for k = 1:size(T,3)
            T_successive(:,:,size(T,3)+k) = [rotation, [0;0;0] ;0 0 0 1]*T(:,:,k);
        end
        T = T_successive;
    end

end