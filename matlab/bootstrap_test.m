function [errors, bestLearner, results, loss, testTime] = bootstrap_test(algorithmSet, trainSize, testSize, trainCount)

    %%%%%%%%
    % Setup:
    %%%%%%%%

    % data
    load ../data/data.mat;

    % training sets with equal amounts of insults and noninsults
    [mXtrain mytrain] = getSubset(Xtrain, ytrain, trainSize);

    % randomly selected test sets
    [t,k] = size(Xtest);
    r = randperm(t);
    mXtest = Xtest(r, :);
    mXtest = mXtest(1:testSize, :);
    mytest = ytest(r, :);
    mytest = mytest(1:testSize);
    
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Training algorithms:
    %%%%%%%%%%%%%%%%%%%%%%

    % lse svm learners
    lse_learn_lin = @(X, y) adj_lsemargin(X, y, 0.5, 'linear_kernel');
    lse_learn_gauss = @(X, y) adj_lsemargin(X, y, 0.5, 'gauss_kernel', 20);
    lse_learn_min = @(X, y) adj_lsemargin(X, y, 0.5, 'bow_kernel', 'min');
    lse_learn_binary = @(X, y) adj_lsemargin(X, y, 0.5, 'bow_kernel', 'binary');
    
    lse_pred = @(X, model) adjclassify(X, model);
    svm_loss = @(y, Y) loss_svm(y, Y);

    % softmargin svm learners
    soft_learn_lin = @(X, y) adj_softmargin(X, y, 0.5, 'linear_kernel');
    soft_learn_gauss = @(X, y) adj_softmargin(X, y, 0.5, 'gauss_kernel', 20);
    soft_learn_min = @(X, y) adj_softmargin(X, y, 0.5, 'bow_kernel', 'min');
    soft_learn_binary = @(X, y) adj_softmargin(X, y, 0.5, 'bow_kernel', 'binary');
    
    % dual hardmargin learners
    hard_learn_lin = @(X, y) dual_hardmargin(X, y, 0.5, 'linear_kernel');
    hard_learn_gauss = @(X, y) dual_hardmargin(X, y, 0.5, 'gauss_kernel', 20);
    hard_learn_min = @(X, y) dual_hardmargin(X, y, 0.5, 'bow_kernel', 'min');
    hard_learn_binary = @(X, y) dual_hardmargin(X, y, 0.5, 'bow_kernel', 'binary');
    
    dual_pred = @(X, model) dualclassify(X, model);
    dual_loss = @(y, Y) loss_svm(y, Y);
    
    % sigmoid learners
    sigmoid_learn_lin = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'linear_kernel');
    sigmoid_learn_gauss = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'gauss_kernel', 20);
    sigmoid_learn_min = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'min');
    sigmoid_learn_binary = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'binary');
    
    sigmoid_pred = @(X, model) pred_kernel_sigmoid(X, model);
    sigmoid_loss = @(y, Y) loss_sigmoid(y, Y, 0.6666667);
    

    %%%%%%%%%%%%%%%%%
    % Algorithm sets:
    %%%%%%%%%%%%%%%%%
    
    lseAlgorithms = {
%          lse_learn_lin, lse_pred, svm_loss; DNW
        lse_learn_gauss, lse_pred, svm_loss;
%          lse_learn_min, lse_pred, svm_loss; DNW
%          lse_learn_binary, lse_pred, svm_loss
    };
    
    softAlgorithms = {
        soft_learn_lin, lse_pred, svm_loss;
        soft_learn_gauss, lse_pred, svm_loss;
%          soft_learn_min, lse_pred, svm_loss;
%          soft_learn_binary, lse_pred, svm_loss
    };
    
    hardAlgorithms = {
        hard_learn_lin, dual_pred, dual_loss;
        hard_learn_gauss, dual_pred, dual_loss;
%          hard_learn_min, dual_pred, dual_loss;
%          hard_learn_binary, dual_pred, dual_loss
    };
    
    sigmoidAlgorithms = {
        sigmoid_learn_lin, sigmoid_pred, sigmoid_loss;
        sigmoid_learn_gauss, sigmoid_pred, sigmoid_loss;
%          sigmoid_learn_min, sigmoid_pred, sigmoid_loss;
%          sigmoid_learn_binary, sigmoid_pred, sigmoid_loss
    };
    
    linAlgorithms = {
        lse_learn_lin, lse_pred, svm_loss;
        soft_learn_lin, lse_pred, svm_loss;  
        hard_learn_lin, dual_pred, dual_loss; 
        sigmoid_learn_lin, sigmoid_pred, sigmoid_loss
    };
    
    gaussAlgorithms = {
        lse_learn_gauss, lse_pred, svm_loss;
        soft_learn_gauss, lse_pred, svm_loss;
        hard_learn_gauss, dual_pred, dual_loss;
        sigmoid_learn_gauss, sigmoid_pred, sigmoid_loss
    };
    
    min1Algorithms = {
        lse_learn_min, lse_pred, svm_loss
    };
    
    min2Algorithms = {
        soft_learn_min, lse_pred, svm_loss
    };
    
    min3Algorithms = {
        hard_learn_min, dual_pred, dual_loss
    };
    
    min4Algorithms = {
        sigmoid_learn_min, sigmoid_pred, sigmoid_loss
    };
    
    binaryAlgorithms = {
        lse_learn_binary, lse_pred, svm_loss;
        soft_learn_binary, lse_pred, svm_loss;
        hard_learn_binary, dual_pred, dual_loss;
        sigmoid_learn_binary, sigmoid_pred, sigmoid_loss
    };
    
    % sigma algorithms
    
    % beta algorithms
    
    confidenceAlgorithms = {
        sigmoid_learn_binary, sigmoid_pred, @(y, Y) loss_sigmoid(y, Y, 0.5);
        sigmoid_learn_binary, sigmoid_pred, @(y, Y) loss_sigmoid(y, Y, 0.6666667);
        sigmoid_learn_binary, sigmoid_pred, @(y, Y) loss_sigmoid(y, Y, 0.8);
        sigmoid_learn_binary, sigmoid_pred, @(y, Y) loss_sigmoid(y, Y, 0.95)
    };
    
    allAlgorithms = {
        lse_learn_lin, lse_pred, svm_loss;
        lse_learn_gauss, lse_pred, svm_loss;
        lse_learn_min, lse_pred, svm_loss;
        lse_learn_binary, lse_pred, svm_loss;
        soft_learn_lin, lse_pred, svm_loss;
        soft_learn_gauss, lse_pred, svm_loss;
        soft_learn_min, lse_pred, svm_loss;
        soft_learn_binary, lse_pred, svm_loss;
        hard_learn_lin, dual_pred, dual_loss;
        hard_learn_gauss, dual_pred, dual_loss;
        hard_learn_min, dual_pred, dual_loss;
        hard_learn_binary, dual_pred, dual_loss;
        sigmoid_learn_lin, sigmoid_pred, sigmoid_loss;
        sigmoid_learn_gauss, sigmoid_pred, sigmoid_loss;
        sigmoid_learn_min, sigmoid_pred, sigmoid_loss;
        sigmoid_learn_binary, sigmoid_pred, sigmoid_loss
    };
 
    if strcmp(algorithmSet, 'lse')
        algorithms = lseAlgorithms;
    elseif strcmp(algorithmSet, 'soft')
        algorithms = softAlgorithms;
    elseif strcmp(algorithmSet, 'hard')
        algorithms = hardAlgorithms;
    elseif strcmp(algorithmSet, 'sigmoid')
        algorithms = sigmoidAlgorithms;
    elseif strcmp(algorithmSet, 'lin')
        algorithms = linAlgorithms;
    elseif strcmp(algorithmSet, 'gauss')
        algorithms = gaussAlgorithms;
    elseif strcmp(algorithmSet, 'min1')
        algorithms = min1Algorithms;
    elseif strcmp(algorithmSet, 'min2')
        algorithms = min2Algorithms;
    elseif strcmp(algorithmSet, 'min3')
        algorithms = min3Algorithms;
    elseif strcmp(algorithmSet, 'min4')
        algorithms = min4Algorithms;
    elseif strcmp(algorithmSet, 'binary')
        algorithms = binaryAlgorithms;
    elseif strcmp(algorithmSet, 'confidence')
        algorithms = confidenceAlgorithms;
    else
        algorithms = allAlgorithms;
    end
    

    %%%%%%%%%%%%%%%%%%%
    % Training results:
    %%%%%%%%%%%%%%%%%%%
    
    [errors, trainTimes, bestLearner, classifier, lossFunction] = bootstrap(mXtrain, mytrain, algorithms, trainCount);

    errors
    trainTimes
    bestLearner
    classifier
    lossFunction
    
    
    %%%%%%%%%%
    % Testing:
    %%%%%%%%%%
    
    tic
    
    model = bestLearner(mXtrain, mytrain);
    yhat = classifier(mXtest, model);
    loss = lossFunction(yhat, mytest);
    
    testTime(1) = toc;
    
    results = [mytest yhat];
    results
    loss
    
    testTime
    
    
    %%%%%%%%%%%%%%
    % Saving data:
    %%%%%%%%%%%%%%
    
    filename = strcat('bootstrap-test-results-', algorithmSet, '-', datestr(now), '.mat');
    
    save(filename, 'errors', 'trainTimes', 'bestLearner', 'classifier', 'lossFunction', 'results', 'loss', 'testTime');
    
end
