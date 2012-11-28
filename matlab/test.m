tic
clear all

load ../data/data.mat;

Ktrain = bow_kernel(Xtrain(1:50, :), Xtrain(1:50, :), 'min');
Ktest = bow_kernel(Xtest(1:100, :), Xtrain(1:50, :), 'min');

[a b] = adj_softmargin(Ktrain, ytrain(1:50), 0.5);
yhat = adjclassify(Ktest, a, b);

err = (yhat ~= ytest(1:100));

timespent(1) = toc;
err
totalAvgErr = sum(err) / 100
timespent
