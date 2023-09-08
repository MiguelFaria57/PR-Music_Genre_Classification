function [data_training, data_testing] = update_datasets(data_training, data_testing, changes, operation)
    switch(operation)
        case 1 % Remove features - after feature selection
            data_training.X(changes, :) = [];
            data_training.dim = size(data_training.X, 1);
            data_training.col_names(changes) = [];
        
            data_testing.X(changes, :) = [];
            data_testing.dim = size(data_testing.X, 1);
            data_testing.col_names(changes) = [];

        case 2 % Create new data structure - after pca
            data_training.X = changes.train;
            data_training.dim = size(data_training.X, 1);
            data_training.col_names = [];

            data_testing.X = changes.test;
            data_testing.dim = size(data_training.X, 1);
            data_testing.col_names = [];

        case 3 % Create new data structure - after lda
            data_training.X = real(changes.train.X);
            data_training.y = changes.train.y;
            data_training.dim = size(data_training.X, 1);
            data_training.num_data = size(data_training.X, 2);
            data_training.col_names = [];
    
            data_testing.X = real(changes.test.X);
            data_testing.y = changes.test.y;
            data_testing.dim = size(data_testing.X, 1);
            data_testing.num_data = size(data_testing.X, 2);
            data_testing.col_names = [];
            
    end
    
end

