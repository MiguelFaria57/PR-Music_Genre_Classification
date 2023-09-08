function [training_data_N, testing_data_N, genres] = data_treatment()
    %% Read the data
    %fullPath = mfilename('fullpath');
    %[current_path, ~, ~] = fileparts(fullPath);
    
    current_path = pwd;
    sepIndex = strfind(current_path, filesep);
    lastSepIndex = sepIndex(end);
    data_path = current_path(1:lastSepIndex-1);
    data_path = fullfile(data_path, 'data', 'dados.csv');
    data_csv = readtable(data_path);
    
    %disp(current_path);
    %disp(data_path);
    
    %% Convert string columns to double
    data_csv.filename = string(data_csv.filename);
    data_csv.label = string(data_csv.label);
    
    for i=1:size(data_csv,1)
        filename_splitted = split(data_csv{i,1}, '.');
        
        switch filename_splitted{1} 
            case "blues"
                data_csv{i,1} = {['1', filename_splitted{2}]};
                data_csv{i,199} = 1;
            case "classical"
                data_csv{i,1} = {['2', filename_splitted{2}]};
                data_csv{i,199} = 2;
            case "country"
                data_csv{i,1} = {['3', filename_splitted{2}]};
                data_csv{i,199} = 3;
            case "disco"
                data_csv{i,1} = {['4', filename_splitted{2}]};
                data_csv{i,199} = 4;
            case "hiphop"
                data_csv{i,1} = {['5', filename_splitted{2}]};
                data_csv{i,199} = 5;
            case "jazz"
                data_csv{i,1} = {['6', filename_splitted{2}]};
                data_csv{i,199} = 6;
            case "metal"
                data_csv{i,1} = {['7', filename_splitted{2}]};
                data_csv{i,199} = 7;
            case "pop"
                data_csv{i,1} = {['8', filename_splitted{2}]};
                data_csv{i,199} = 8;
            case "reggae"
                data_csv{i,1} = {['9', filename_splitted{2}]};
                data_csv{i,199} = 9;
            case "rock"
                data_csv{i,1} = {['10', filename_splitted{2}]};
                data_csv{i,199} = 10;
        end
    end
    
    %% Split the data for training (80%) and testing (20%)
    training_table = table();
    testing_table = table();
    
    for i = 1:999
        if mod(i, 100) <= 79
            training_table = [training_table; data_csv(i,:)];
        else
            testing_table = [testing_table; data_csv(i,:)];
        end
    end
    
    col_names = data_csv.Properties.VariableNames;
    data_csv = double(table2array(data_csv));
    training_table = double(table2array(training_table));
    testing_table = double(table2array(testing_table));
    genres =  ["blues", "classical", "country", "disco", "hip-hop", "jazz", "metal", "pop", "reggae", "rock"];
    
    save("data/Data_Tables.mat", "genres", "col_names", "data_csv", "training_table", "testing_table");
    
    %% Create training and testing data structures
    training_data.name = 'Music Genre Training Dataset';
    training_data.X = training_table(:,2:end-1)';
    training_data.y = training_table(:, end)';
    training_data.dim = size(training_data.X,1);
    training_data.num_data = size(training_data.X,2);
    training_data.col_names = col_names(2:end-1);
    
    testing_data.name = 'Music Genre Testing Dataset';
    testing_data.X = testing_table(:,2:end-1)';
    testing_data.y = testing_table(:,end)';
    testing_data.dim = size(testing_data.X,1);
    testing_data.num_data = size(testing_data.X,2);
    testing_data.col_names = col_names(2:end-1);
    
    save("data/Data_Structures.mat", "training_data", "testing_data");
    
    %% Correlation Matrix
    % Since there are too many features, the graphical representation of the 
    % correlation matrix is not very helpfull
    cm = corrcoef(training_data.X);
    %figure;
    %heatmap(col_names(2:end),col_names(2:end),cm);
    
    %% Distribuiton Histograms
    % Since there are too many features, the graphical representation of the 
    % distribution histograms is not very helpfull
    %{
    figure;
    for i = 1:training_data.dim
        subplot(14,15,i);
        histfit(training_data.X(i,:));
        title(col_names_struc{i});
    end
    %}
    
    %% Normalized/Standadized data
    training_data_N = training_data;
    testing_data_N = testing_data;
    
    % Remove features with no variance
    variance = var(training_data_N.X, 0, 2);
    nonzero_variance_indices = variance > 0;
    training_data_N.X = training_data_N.X(nonzero_variance_indices, :);
    training_data_N.dim = size(training_data_N.X, 1);
    training_data_N.col_names = training_data_N.col_names(nonzero_variance_indices);
    
    %For the testing data, the removed features should be the same as training
    %variance = var(testing_data_N.X, 0, 2);
    %nonzero_variance_indices = variance > 0;
    testing_data_N.X = testing_data_N.X(nonzero_variance_indices, :);
    testing_data_N.dim = size(testing_data_N.X, 1);
    testing_data_N.col_names = testing_data_N.col_names(nonzero_variance_indices);
    
    % Normalize
    training_data_N = scalestd(training_data_N);
    testing_data_N = scalestd(testing_data_N);
    
    save("data/Data_Structures_Normalized.mat", "training_data_N", "testing_data_N")

end

