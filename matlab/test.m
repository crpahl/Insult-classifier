clear all

load data.mat;

Ktrain = Xtrain*Xtrain';
Ktest = Xtest*Xtrain';

[a c] = adj_lsemargin(Ktrain, ytrain, 0.5);
yhat = adjclassify(Ktest, a, c);	

err = (yhat == ytest)/length(yhat);

sum
