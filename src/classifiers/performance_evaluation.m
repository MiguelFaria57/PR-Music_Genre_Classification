function metrics = performance_evaluation(results, classes, scenario)
    switch(scenario)
        case "A"
            TP = results(1,1);
            TN = results(1,2);
            FP = results(1,3);
            FN = results(1,4);

            % Metrics
            metrics.accuracy = (TP + TN) / (TP + TN + FP + FN);
            metrics.sensitivity = TP / (TP + FN);
            metrics.specificity = TN / (TN + FP);
            metrics.f_measure = 2 * ((metrics.sensitivity * metrics.accuracy) / (metrics.sensitivity + metrics.accuracy));
            %metrics
            
        case "B"
            metrics = repmat(struct, length(classes)+1, 1);
            
            for c = 1:length(classes)+1
                TP = results(c,1);
                TN = results(c,2);
                FP = results(c,3);
                FN = results(c,4);
                
                metrics(c).accuracy = (TP + TN) / (TP + TN + FP + FN);
                metrics(c).sensitivity = TP / (TP + FN);
                metrics(c).specificity = TN / (TN + FP);
                metrics(c).f_measure = 2 * ((metrics(c).sensitivity * metrics(c).accuracy) / (metrics(c).sensitivity + metrics(c).accuracy));
            end
    end

end
