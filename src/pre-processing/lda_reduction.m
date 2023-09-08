function [data_train, data_test] = lda_reduction(data_training, data_testing, k)
    % Model
    model_k = lda(data_training, k);
    data_train = linproj(data_training, model_k);
    data_test = linproj(data_testing, model_k);

end

