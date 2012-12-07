function [yhat] = adjclassify(X, model)
	a = model.a;
	b = model.b;
	Xtrain = model.Xtrain;
	kernel = model.kernel;
	
	Ktest = kernel(X, Xtrain);
	yhat = sign(Ktest*a - b);
