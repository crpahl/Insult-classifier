
clear all
load ../data/data.mat;

trainNum = 200;
testNum = 400;
mXtrain = Xtrain(1:trainNum, :);
mytrain = ytrain(1:trainNum);
trainData = mytrain;

tic

% Classification -> Strong Probability
for i = 1:trainNum
    if ytrain(i) == 0
        mytrain(i) = ytrain(i) + 1e-6;
    else % ytrain(i) == 1
        mytrain(i) = ytrain(i) - 1e-6;
    end
end

[model] = train_kernel_sigmoid(mXtrain, mytrain, 0.5, 'bow_kernel', 'binary');

trainTime(1) = toc;
tic

yhat = pred_kernel_sigmoid(Xtest(1:testNum, :), model); 

% Probability -> Classification (95% confidence)
%  for i = 1:testNum
%      if yhat(i) >= 0.85
%          yhat(i) = 1;
%      else 
%          yhat(i) = 0;
%      end
%  end

testTime(1) = toc;

err = abs(yhat - ytest(1:testNum));
trainData
results = [yhat ytest(1:testNum) err]
totalAvgErr = sum(err) / testNum

trainTime
testTime
