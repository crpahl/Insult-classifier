function [learner, classifier] = bootstrap(X, y, algorithms, trainCount)
    % Takes pairs of learners and classifiers in the form:
    %   
    % algorithms = {learner1, classfier1; learner2, classifier2; ...}
    %
    % And returns the best learner and corresponding classifier.

    %Initialize the errors cell array (very poorly). Fix this later.
    errors = algorithms(:, 1);
    for j = 1:size(errors)
	errors{j, 2} = 0;
    end

    for iter = 1:trainCount
	[Xtest, Xtrain, Ytest, Ytrain] = buildTestAndTrainBootstrap(X, y);
	[t, k] = size(Xtest);

	for iter2 = 1:length(algorithms)
	    model = algorithms{iter2, 1}(Xtrain, Ytrain);
	    yhat = algorithms{iter2, 2}(Xtest, model);
	    %This loss calculation will have to be updated for the project
	    loss = sum(sum((yhat == convert(Ytest))') == 7)/t;	
	    errors{iter2, 2} = errors{iter2, 2} + loss;
	end
    end

    for iter3 = 1:size(errors)
	errors{iter3, 2} = errors{iter3, 2} / trainCount;
    end 

    [v, i] = max(cell2mat(errors(:, 2)));

    learner = algorithms{i, 1};
    classifier = algorithms{i, 2};
    
    errors
    learner
    classifier
