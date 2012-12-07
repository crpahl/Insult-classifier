
clear all
load ../data/data.mat;

trainNum = 10;
testNum = 20;
[mXtrain mytrain] = getSubset(Xtrain, ytrain, trainNum);

[t,k] = size(Xtest);
r = randperm(t);

mXtest = Xtest(r, :);
mXtest = mXtest(1:testNum, :);
mytest = ytest(r, :);
mytest = mytest(1:testNum);

%  [model] = train_kernel_sigmoid(mXtrain, mytrain, 0.5, 'bow_kernel', 'min');

sigmoid_learn = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'min');
sigmoid_pred = @(X, model) pred_kernel_sigmoid(X, model); 
sigmoid_loss = @(y, Y) sigmoid_loss(y, Y);

algorithms = {{sigmoid_learn, sigmoid_pred, sigmoid_loss}};

tic

[learner, classifier] = bootstrap(mXtrain, mytrain, algorithms, 1);

trainTime(1) = toc;
tic

%  yhat = pred_kernel_sigmoid(mXtest, model); 

% Probability -> Classification (66.66% confidence)
%  for i = 1:testNum
%      if yhat(i) >= 0.6666
%          yhat(i) = 1;
%      else 
%          yhat(i) = 0;
%      end
%  end

%  testTime(1) = toc;

%  err = abs(yhat - mytest);
%  results = [yhat mytest err]
%  totalAvgErr = sum(err) / testNum

trainTime
%  testTime
