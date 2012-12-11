function [yhat] = dualclassify(X, model)
% model = {X, lambda, b, y, beta, kernel, varargin}.
% yhat is the tex1 vector of class labels.
    
    lambda = model{2};
    b = model{3};
    y = model{4};
    beta = model{5};
    Xtrain = model{1};
    kernel = model{6};
    kernelargs = model{7};
    
    Ktest = feval(kernel, X, Xtrain, kernelargs);

%      yhat = sign(Ktest*diag(y)*lambda*(beta') - b);
    yhat = (Ktest*diag(y)*lambda*(beta') - b) >= 0;
    
end
