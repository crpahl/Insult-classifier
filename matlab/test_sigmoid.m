
clear all
load ../data/data.mat;

trainNum = 50;
testNum = 100;
mXtrain = Xtrain(1:trainNum, :);
mytrain = ytrain(1:trainNum);

tic

% Classification -> Strong Probability
for i = 1:trainNum
    if ytrain(i) == 0
        mytrain(i) = ytrain(i) + 1e-6;
    else % ytrain(i) == 1
        mytrain(i) = ytrain(i) - 1e-6;
    end
end

[model] = train_kernel_sigmoid(mXtrain, mytrain, 0.5, 'bow_kernel', 'min');
yhat = pred_kernel_sigmoid(Xtest(1:testNum, :), model); 

% Probability -> Classification (95% confidence)
for i = 1:testNum
    if yhat(i) >= 0.95
        yhat(i) = 1;
    else 
        yhat(i) = 0;
    end
end

timespent(1) = toc;

err = (yhat ~= ytest(1:testNum))
totalAvgErr = sum(err) / testNum

timespent
