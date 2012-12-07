
clear all
load ../data/data.mat;

trainNum = 150;
testNum = 200;
[mXtrain mytrain] = getSubset(Xtrain, ytrain, trainNum);

[t,k] = size(Xtest);
r = randperm(t);

mXtest = Xtest(r, :);
mXtest = mXtest(1:testNum, :);
mytest = ytest(r, :);
mytest = mytest(1:testNum);

%  [model] = train_kernel_sigmoid(mXtrain, mytrain, 0.5, 'bow_kernel', 'min');

sigmoid_learn_min = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'min');
sigmoid_learn_mult = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'mult');
sigmoid_learn_add = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'addition');
sigmoid_learn_binary = @(X, y) train_kernel_sigmoid(X, y, 0.5, 'bow_kernel', 'binary');
sigmoid_pred = @(X, model) pred_kernel_sigmoid(X, model); 
loss_sigmoid = @(y, Y) loss_sigmoid(y, Y);

linear_kernel = @(X1, X2)(X1*X2');
svm_learn = @(X, y)adj_lsemargin(X, y, 0.5, linear_kernel); 
svm_classify = @(X, model)adjclassify(X, model);
loss_svm = @(y, Y)loss_svm(y, Y);

algorithms = {svm_learn, svm_classify, loss_svm;
	      sigmoid_learn_min, sigmoid_pred, loss_sigmoid;
	      sigmoid_learn_mult, sigmoid_pred, loss_sigmoid;
	      sigmoid_learn_add, sigmoid_pred, loss_sigmoid;
	      sigmoid_learn_binary, sigmoid_pred, loss_sigmoid};

tic

[learner, classifier] = bootstrap(mXtrain, mytrain, algorithms, 1);

trainTime(1) = toc;

%tic

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
