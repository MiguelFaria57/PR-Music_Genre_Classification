function [remove_idx] = correlation_indicators(data, selection_threshold)
    % Correlation Matrix
    cm = corrcoef(data.X');

    % Show Matrix
    %figure;
    %heatmap(data.col_names, data.col_names, cm);

    % Select features that have correlation coefficient above selection_threshold
    [row, col] = find(abs(cm) >= selection_threshold & abs(cm) < 1);
    pairs = [row, col];
    sorted_pairs = sort(pairs, 2);
    unique_pairs = unique(sorted_pairs, 'rows');

    remove_idx = unique(unique_pairs(:,1));    
end

