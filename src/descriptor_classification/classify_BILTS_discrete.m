function index_recognized_class = classify_BILTS_discrete(descriptor,descriptor_name,models,motion_classes)

nb_models = length(models); % number of trials/neighbors in the model set

feature_signal_trial = descriptor(19:24,:);
N_trial = size(feature_signal_trial,2);

distances = inf(1,nb_models);
for i = 1:nb_models
    
    model = models(i);
    
    feature_signal_model = model.descriptor(19:24,:);
    N_model = size(feature_signal_model,2);
    
    %[DIST,IX,IY] = dtw(X,Y) additionally returns the warping path, IX and
    % IY, that minimizes the total Euclidean distance between X(IX) and Y(IY)
    % when X and Y are vectors and between X(:,IX) and Y(:,IY) when X and Y
    % are matrices.
    if size(feature_signal_trial,2) > 1 || size(feature_signal_model,2) > 1
        [~,IX,IY] = dtw(feature_signal_model,feature_signal_trial);
        %DIST = DIST/(N_trial+N_model-1);
    else
        IX = 1; IY = 1;
    end
    
    if strcmp(descriptor_name,'BILTS_discrete')

        % without rotation alignment
        dist = sum((model.descriptor(1:18,IX)-descriptor(1:18,IY)).^2,'all');

    elseif strcmp(descriptor_name,'BILTS_discrete_reg')
            
        % with rotation alignment
        dist = 0;
        for k = 1:length(IX)
            A_ = [model.descriptor(1:3,IX(k)),model.descriptor(4:6,IX(k)), ...
                model.descriptor(7:9,IX(k)),model.descriptor(10:12,IX(k)), ...
                model.descriptor(13:15,IX(k)),model.descriptor(16:18,IX(k))];
            B_ = [descriptor(1:3,IY(k)),descriptor(4:6,IY(k)), ...
                descriptor(7:9,IY(k)),descriptor(10:12,IY(k)), ...
                descriptor(13:15,IY(k)),descriptor(16:18,IY(k))];
            C = A_*B_';
            [U,~,V] = svd(C, 'econ');
            R = V*U';
            if det(R) < 0
                % ensure R is a right-handed rotation matrix
                U(:,end) = -U(:,end);
                R = V*U';
            end
            dist = dist + sum((R * A_ - B_).^2,'all');
        end
    else
        error('Wrong descriptor name for BILTS');
    end
    
    distances(i) = dist/(N_trial+N_model-1);
        
end

[~,index] = min(distances);
recognized_class = models(index).motion_class;
index_recognized_class = find(strcmp(motion_classes,recognized_class));

end