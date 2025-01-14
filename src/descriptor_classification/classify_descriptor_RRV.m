function index_recognized_class = classify_descriptor_RRV(descriptor,models,motion_classes)

nb_models = length(models); % number of trials/neighours in the model set
distances = NaN(1,nb_models); % distances to the model trials
    
N_trial = size(descriptor,2);

for i = 1:nb_models
    
    model = models(i).descriptor;
    N_model = size(model,2);
    
    %[DIST,IX,IY] = dtw(X,Y) additionally returns the warping path, IX and
    % IY, that minimizes the total Euclidean distance between X(IX) and Y(IY)
    % when X and Y are vectors and between X(:,IX) and Y(:,IY) when X and Y
    % are matrices.
    if N_trial > 1 || N_model > 1
        [distance,~,~] = dtw(model, descriptor);
    else
        distance = RRV_distance(model,descriptor);
    end
    distance = distance/( N_trial + N_model - 1);   
    distances(i) = distance;
end

[~,index] = min(distances);
recognized_class = models(index).motion_class;
index_recognized_class = find(strcmp(motion_classes,recognized_class));

end

% function dist = RRV_distance(S1, S2)
%     dist = min(norm(S1(1:4)-S2(1:4)),norm(S1(1:4)+S2(1:4))) + norm(S1(5:7)-S2(5:7));
% end