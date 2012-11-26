function [Xtrain,ytrain,Xtest,ytest] = processCSV(XtrainFilename, ytrainFilename, XtestFilename, ytestFilename)
'Converting XTrain...'
Xtrain = csvread(XtrainFilename, 1,0);
'Converting ytrain...'
ytrain = csvread(ytrainFilename);
'Converting XTest...'
Xtest = csvread(XtestFilename,1,0);
'Converting ytest..'
ytest = csvread(ytestFilename);

'Creating file data.mat..'
save('data.mat','Xtrain','ytrain','Xtest','ytest');

end
