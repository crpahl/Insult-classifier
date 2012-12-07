
clear all
load ../data/data.mat;

trainNum = 200;
testNum = 250;
[mXtrain mytrain] = getSubset(Xtrain, ytrain, trainNum);

[t,k] = size(Xtest);
r = randperm(t);

mXtest = Xtest(r, :);
mXtest = mXtest(1:testNum);
mytest = ytest(r, :);
mytest = mytest(1:testNum);

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

trainTime(1) = toc;
tic

yhat = pred_kernel_sigmoid(mXtest, model); 

% Probability -> Classification (66.66% confidence)
for i = 1:testNum
    if yhat(i) >= 0.6666
        yhat(i) = 1;
    else 
        yhat(i) = 0;
    end
end

testTime(1) = toc;

err = abs(yhat - mytest);
results = [yhat mytest err]
totalAvgErr = sum(err) / testNum

trainTime
testTime
