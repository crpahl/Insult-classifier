function [yhat] = adjclassify(Ktest, a, b)
	yhat = sign(Ktest*a - b);
