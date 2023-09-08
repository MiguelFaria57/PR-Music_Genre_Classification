function [results] = label_results(true_labels, predicted_labels, classes, scenario)
    switch(scenario)
        case "A"
            cm = confusionmat(true_labels, predicted_labels);
            labels = unique(true_labels);
            %figure;
            %confusionchart(cm, labels);
            
            results = zeros(1,4);
            results(1,1) = cm(1,1); %TP
            results(1,2) = cm(2,2); %TN
            results(1,3) = cm(2,1);%cm(1,2); %FP
            results(1,4) = cm(1,2);%cm(2,1); %FN
            %results
            
        case "B"
            cm = confusionmat(true_labels, predicted_labels);
            results = zeros(length(classes)+1, 4);
            
            for c = 1:length(classes)
                results(c,1) = cm(c,c); %TP
                temp = cm;
                temp(:,c) = [];
                temp(c,:) = [];
                results(c,2) = sum(sum(temp)); %TN
                results(c,3) = sum(cm(:,c))-results(1,1); %FP
                results(c,4) = sum(cm(c,:))-results(1,1); %FN
            end

            results(end,1) = sum(results(:,1)); %TP total
            results(end,2) = sum(results(:,2)); %TN total
            results(end,3) = sum(results(:,3)); %FP total
            results(end,4) = sum(results(:,4)); %FN total

    end

end

