function [errors, bestLearner, results, loss, testTime] = bootstrap_test(trainSize, testSize, trainCount)

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
    svm_learn_lin = @(X, y) adj_lsemargin(X, y, 0.5, 'linear_kernel');
    svm_learn_gauss = @(X, y) adj_lsemargin(X, y, 0.5, 'gauss_kernel', 20);
    svm_classify = @(X, model) adjclassify(X, model);
    svm_loss = @(y, Y) loss_svm(y, Y);

    % softmargin svm learners
    soft_learn_lin = @(X, y) adj_softmargin(X, y, 0.5, 'linear_kernel');
    soft_learn_gauss = @(X, y) adj_softmargin(X, y, 0.5, 'gauss_kernel', 20);
    
    % sigmoid learners
    sigmoid_learn_min = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'min');
    sigmoid_learn_mult = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'mult');
    sigmoid_learn_add = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'addition');
    sigmoid_learn_binary = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'binary');
    sigmoid_pred = @(X, model) pred_kernel_sigmoid(X, model); 
    sigmoid_loss = @(y, Y) loss_sigmoid(y, Y, 0.6666667);
    
    algorithms = {svm_learn_lin, svm_classify, svm_loss;
                  svm_learn_gauss, svm_classify, svm_loss;
                  soft_learn_lin, svm_classify, svm_loss;
                  soft_learn_gauss, svm_classify, svm_loss;
                  sigmoid_learn_min, sigmoid_pred, sigmoid_loss;
                  sigmoid_learn_mult, sigmoid_pred, sigmoid_loss;
                  sigmoid_learn_add, sigmoid_pred, sigmoid_loss;
                  sigmoid_learn_binary, sigmoid_pred, sigmoid_loss};
 

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

end
