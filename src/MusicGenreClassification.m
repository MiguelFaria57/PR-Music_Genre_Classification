% Music Genre Classification
% Miguel Faria | 2019216809

% Add all folders to MatLab Path
% Run this code with Matlab Current Folder being /src

clc
close all
clear all

%% Pre-Processing

%% Data treatment
[training_data_processed, testing_data_processed, genres] = data_treatment();

%% Feature Selection
%% Kruskal-Wallis Test
[table_kw, sorted_idx, remove_idx] = kruskal_wallis(training_data_processed, 0.9);
[training_data_selection, testing_data_selection] = update_datasets(training_data_processed, testing_data_processed, remove_idx, 1);

% Show KW Test Info - 176 Features
%disp(table_kw)

%% Correlation Indicators
remove_idx = correlation_indicators(training_data_selection, 0.75);
[training_data_selection, testing_data_selection] = update_datasets(training_data_selection, testing_data_selection, remove_idx, 1);

% Show Correlation matrix - 42 Features
cm = corrcoef(training_data_selection.X');
%figure;
%heatmap(training_data_selection.col_names, training_data_selection.col_names, cm);

%% Feature Reduction
%% PCA
% Testing
%pca_testing(training_data_selection, genres);

% Reduction - 29 PCs
[update.train, update.test, num_PC] = pca_reduction(training_data_selection, testing_data_selection, 0.95);
[training_data_reduction_pca, testing_data_reduction_pca] = update_datasets(training_data_selection, testing_data_selection, update, 2);

%% LDA
% Reduction - 29 PCs
[update.train, update.test] = lda_reduction(training_data_reduction_pca, testing_data_reduction_pca, num_PC);
[training_data_reduction_lda, testing_data_reduction_lda] = update_datasets(training_data_reduction_pca, testing_data_reduction_pca, update, 3);

%% 
%{
ix = cell(1, num_PC);
figure;
for i = 1:size(ix, 2)
    ix{1, i} = find(training_data_reduction_lda.y==i);
    plot(real(training_data_reduction_lda.X(ix{1, i})), zeros(1, numel(ix{1, i})));
    hold on
end
legend(genres);
%}

%% Classifiers

%% Minimum Distance Classifier
metrics_A_orig = minimum_distance_classifier(training_data_processed, testing_data_processed, genres, "A");
metrics_A_sel = minimum_distance_classifier(training_data_selection, testing_data_selection, genres, "A");
metrics_A_pca = minimum_distance_classifier(training_data_reduction_pca, testing_data_reduction_pca, genres, "A");
metrics_A_lda = minimum_distance_classifier(training_data_reduction_lda, testing_data_reduction_lda, genres, "A");

metrics_B_orig = minimum_distance_classifier(training_data_processed, testing_data_processed, genres, "B");
metrics_B_sel = minimum_distance_classifier(training_data_selection, testing_data_selection, genres, "B");
metrics_B_pca = minimum_distance_classifier(training_data_reduction_pca, testing_data_reduction_pca, genres, "B");
metrics_B_lda = minimum_distance_classifier(training_data_reduction_lda, testing_data_reduction_lda, genres, "B");

%% Fisher LDA Classifier


%% Bayesian Classifier


%% K-Nearest Neighbours Classifier





