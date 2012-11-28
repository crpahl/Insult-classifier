
clear all
load ../data/data.mat;

tic

trainNum = 50;
testNum = 100;
mXtrain = Xtrain(1:trainNum, :);
mytrain = ytrain(1:trainNum);

% Classification -> Strong Probability
for i = 1:trainNum
    if ytrain(i) == 0
        mytrain(i) = ytrain(i) + 0.00001;
    else % ytrain(i) == 1
        mytrain(i) = ytrain(i) - 0.00001;
    end
end

[model] = train_kernel_sigmoid(mXtrain, mytrain, 0.5, 'bow_kernel', 'min');
yhat = pred_kernel_sigmoid(Xtest(1:testNum, :), model); 

err = abs(yhat - ytest(1:testNum))/length(yhat);

timespent(1) = toc;
timespent

err
totalErr = sum(err) / testNum
