function [errors, training, learner, classifier, lossFunction] = bootstrap(X, y, algorithms, trainCount)
    % Takes pairs of learners and classifiers in the form:
    %   
    % algorithms = {learner1, classfier1; learner2, classifier2; ...}
    %
    % Returns the errors, average training time, and best learner and corresponding classifier.

    %Initialize the errors cell array (very poorly). Fix this later.
    errors = algorithms(:, 1);
    [n, tmp] = size(algorithms);
    
    for j = 1:size(errors)
        errors{j, 2} = 0;
    end
    training = zeros(n, 1);

    for iter = 1:trainCount
        [Xtest, Xtrain, Ytest, Ytrain] = buildTestAndTrainBootstrap(X, y);
        [t, k] = size(Xtest);

        for iter2 = 1:size(algorithms)
            tic;
            
            model = algorithms{iter2, 1}(Xtrain, Ytrain);
            yhat = algorithms{iter2, 2}(Xtest, model);
            loss = algorithms{iter2, 3}(yhat, Ytest);
        
            trainTime(1) = toc;
        
            errors{iter2, 2} = errors{iter2, 2} + loss;
            training(iter2) = training(iter2) + trainTime(1);
        end
    end

    for iter3 = 1:size(errors)
        errors{iter3, 2} = errors{iter3, 2} / trainCount;
    end
    training = training ./ trainCount;

    [v, i] = min(cell2mat(errors(:, 2)));

    learner = algorithms{i, 1};
    classifier = algorithms{i, 2};
    lossFunction = algorithms{i, 3};
    
%      errors
%      training
%      learner
%      classifier
    
end
