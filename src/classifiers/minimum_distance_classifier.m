function [metrics] = minimum_distance_classifier(data_training, data_testing, genres, scenario)
    % Classifier
    [true_labels, predicted_labels] = mdc(data_training, data_testing, scenario);

    % Metrics
    if scenario == "A"
        results = zeros(length(genres), 4);
        metrics = repmat(struct("accuracy",0,"sensitivity",0,"specificity",0,"f_measure",0), length(genres), 1);
        for r = 1:length(genres)
            results(r,:) = label_results(true_labels(r,:), predicted_labels(r,:), genres, scenario);
            metrics(r) = performance_evaluation(results(r,:), genres, scenario);
        end
    elseif scenario == "B"
        results = label_results(true_labels, predicted_labels, genres, scenario);
        metrics = performance_evaluation(results, genres, scenario);
    end
end


function [true_labels, predicted_labels] = mdc(data_training, data_testing, scenario)
    switch(scenario)
        case "A"
            % Binary Classes
            classes = unique(data_training.y);
            n_classes = length(classes);
            binary_classes = repmat(data_training.y, n_classes, 1);
            for i = 1:n_classes
                idx1 = (binary_classes(i,:) == i);
                idx2 = (binary_classes(i,:) ~= i);
                binary_classes(i,idx1) = 1;
                binary_classes(i,idx2) = 2;
            end
            
            % Training
            c = unique(binary_classes(i,:));
            num_c = length(c);
            means = zeros(size(data_training.X, 1), num_c, n_classes);
            for i = 1:n_classes
                for j = 1:num_c
                    idx = (binary_classes(i,:) == c(j));
                    means(:, j, i) = mean(data_training.X(:, idx), 2)';
                end
            end

            % Predicted Labels
            predicted_labels = zeros(n_classes, size(data_testing.X, 2));
            for i = 1:n_classes
                distances = pdist2(data_testing.X', means(:,:,i)');
                
                n_test = size(data_testing.X, 2);
                predictions = zeros(1, n_test);
                for j = 1:n_test
                    [~, min_idx] = min(distances(j,:));
                    predictions(j) = classes(min_idx);
                end

                predicted_labels(i, :) = predictions;
            end

            % True Labels
            u = unique(data_testing.y);
            n = length(u);
            true_labels = repmat(data_testing.y, n, 1);
            for i = 1:n
                idx1 = (true_labels(i,:) == i);
                idx2 = (true_labels(i,:) ~= i);
                true_labels(i,idx1) = 1;
                true_labels(i,idx2) = 2;
            end
            
        case "B"
            % Training
            c = unique(data_training.y);
            num_c = length(c);
            means = zeros(size(data_training.X, 1), num_c);
            for i = 1:num_c
                idx = (data_training.y == c(i));
                means(:,i) = mean(data_training.X(:,idx), 2);
            end

            distances = pdist2(data_testing.X', means');
                
            n_test = size(data_testing.X, 2);
            predictions = zeros(1, n_test);
            for j = 1:n_test
                [~, min_idx] = min(distances(j,:));
                predictions(j) = c(min_idx);
            end

            predicted_labels = predictions;
            true_labels = data_testing.y;
    end    

end
