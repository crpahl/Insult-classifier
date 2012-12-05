function [] = processCSV()
'Converting XTrain...'
Xtrain = csvread('../data/Xtrain.csv', 1,0);
'Converting ytrain...'
ytrain = csvread('../data/Ytrain.csv');
'Converting XTest...'
Xtest = csvread('../data/Xtest.csv',1,0);
'Converting ytest..'
ytest = csvread('../data/Ytest.csv');

'Creating file data.mat..'
save('../data/data.mat','Xtrain','ytrain','Xtest','ytest');

end
