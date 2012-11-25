function [Xtest, Xtrain, Ytest, Ytrain] = buildTestAndTrainBootstrap(X, y)
    [t, k] = size(X);

    randomTrain = randi(t, t, 1);
    randomTest = ones(t, 1);
    randomTest(randomTrain) = 0; 

    %generating Xtest and Xtrain
    Xtrain = X(randomTrain, :);
    Xtest = X(logical(randomTest), :);

    %generating Ytest and Ytrain
    Ytrain = y(randomTrain, :);
    Ytest = y(logical(randomTest), :);
