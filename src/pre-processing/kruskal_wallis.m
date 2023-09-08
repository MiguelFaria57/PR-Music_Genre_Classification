function [table_kw, sorted_idx, remove_idx] = kruskal_wallis(data, selection_percentage)
    % Get KW Values
    for i = 1:size(data.X,1)
        [p, tbl, stats] = kruskalwallis(data.X(i,:), data.y, 'off');
    
        p_values(i) = p;
        h_values(i) = tbl{2,5};
            
        ranks{i,1} = data.col_names{i};
        ranks{i,2} = h_values(i);
        ranks{i,3} = p;
    end
    
    % Sort Ranks
    [sorted_ranks,sorted_idx] = sort([ranks{:,2}],2,'descend');
    
    display = [];
    for i=1:size(data.X,1)
       display = [display sprintf('%s\t\t\t%.2f\n', ranks{sorted_idx(i),1}, ranks{sorted_idx(i),2})];
    end
    %disp(display)
    
    % Make Table
    table_kw = table([1:length(sorted_idx)]', sorted_idx', data.col_names(sorted_idx)',sorted_ranks',cell2mat(ranks(sorted_idx,3)));
    table_kw.Properties.VariableNames = {'rank', 'feature_ID', 'feature', 'chi_sq','p_value'};
    save("data/KW_Info.mat", "table_kw", "sorted_idx")
    
    % Get % of the highest chi_sq values features that have p-value < 0.05
    % If % equals 1, select only features that have p-value < 0.05
    filtered_table_kw = table_kw(table_kw.p_value < 0.05, :);
    remove_idx = setdiff(table_kw.feature_ID, filtered_table_kw.feature_ID);
    %disp(filtered_table_kw)

    if selection_percentage < 1
        n_features = round(selection_percentage * height(filtered_table_kw));
        table_kw = filtered_table_kw(1:n_features, :);
        remove_idx = [remove_idx sorted_idx(n_features+1:end)];
        sorted_idx = sorted_idx(1:n_features);

        save("data/KW_Info_Selection.mat", "table_kw", "sorted_idx")
    end

end

