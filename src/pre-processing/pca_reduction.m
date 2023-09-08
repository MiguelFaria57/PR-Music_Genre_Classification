function [data_train, data_test, k] = pca_reduction(data_training, data_testing, p)
    % Model
    model = pca(data_training.X);

    % Model that explains p % of variance
    explained_var = cumsum(model.eigval) / sum(model.eigval);
    k = find(explained_var >= p, 1); 
    model_k = pca(data_training.X, k);
    data_train = linproj(data_training.X, model_k);
    data_test = linproj(data_testing.X, model_k);
    
end

