function [loss] = loss_svm(yhat, ytest)

    [testNum, k] = size(ytest);

    loss = sum(abs(yhat - ytest)) / testNum;

end
