function index_recognized_class = classify_descriptor_DSRF(descriptor,models,motion_classes)
nb_models = length(models); % number of trials/neighours in the model set
distances = NaN(1,nb_models); % distances to the model trials
    
N_trial = size(descriptor,2);

for i = 1:nb_models
    
    model = models(i).descriptor;
    N_model = size(model,2);
    
    % Global rotation alignment
    A_ = [model(1:3,:),model(4:6,:)];
    B_ = [descriptor(1:3,:),descriptor(4:6,:)];
    C = A_*B_';
    [U,~,V] = svd(C, 'econ');
    R = V*U';
    if det(R) < 0
        U(:,end) = -U(:,end);
        R = V*U';
    end
    rotated_model(1:3,:) = R*model(1:3,:);
    rotated_model(4:6,:) = R*model(4:6,:);
    
    if N_trial > 1 || N_model > 1
        [distance,~,~] = dtw(rotated_model,descriptor);
    else
        distance = sqrt(sum((rotated_model-descriptor).^2));
    end
    distance = distance/( N_trial + N_model - 1);   
    distances(i) = distance;
end

[~,index] = min(distances);
recognized_class = models(index).motion_class;
index_recognized_class = find(strcmp(motion_classes,recognized_class));

end