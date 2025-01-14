function plot_confusion_matrix(results)

    figure()
    xy_map = heatmap(round(results.confusion_matrix_total*100,1));
%     X_labels = cell(1,x_N);
%     Y_labels = cell(1,y_N);
%     for x = 1:x_N
%         X_labels(x) = {num2str(x_vector(x))};    
%     end
%     for y = 1:y_N
%         Y_labels(y) = {num2str(y_vector(y))};
%     end
%     xy_map.XDisplayLabels = X_labels;
%     xy_map.YDisplayLabels = Y_labels;
%     xy_map.XLabel= 'X';
%     xy_map.YLabel= 'Y';
    xy_map.Colormap = flipud(gray);
    xy_map.ColorLimits = [0 100];
    xy_map.ColorbarVisible = 'off';
    
end