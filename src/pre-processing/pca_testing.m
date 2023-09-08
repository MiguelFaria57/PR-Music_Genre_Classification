function pca_testing(data, genres)
    % Model
    model = pca(data.X);

    % Eigenvalues plot
    figure;
    plot(model.eigval,'o');
    xlabel('Principal Component');
    ylabel('Eigen Value');
    
    total_variance = sum(model.eigval)
    
    figure;
    plot(cumsum(model.eigval)/sum(model.eigval)*100,'o-')
    xlabel('Principal Component')
    ylabel('% of variance')
    
    % Variance explained by the k most important eigenvalues
    k = 10;
    training_var_k = (sum(model.eigval(1:k).^2)/sum(model.eigval.^2))*100
    
    % Projection
    k = 10;
    model_k = pca(data.X, k);
    data_reduction = linproj(data.X, model_k);
    
    ix = cell(1, k);
    figure;
    for i = 1:size(ix, 2)
        ix{1, i} = find(data.y==i);
        %plot(training_data_reduction(ix{1, i}), zeros(1, numel(ix{1, i})));
        plot3(data_reduction(ix{1, i}), data_reduction(ix{1, i}), data_reduction(ix{1, i}), '.', 'MarkerSize', 10);
        hold on
    end
    legend(genres);
    
    %figure;
    %ppatterns(training_data_selection.X, 'xk', 10);
    
end

