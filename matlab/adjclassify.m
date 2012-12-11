function [yhat] = adjclassify(X, model)
% model = {X, a, b, kernel, kernelargs);

    a = model{2};
    b = model{3};
    Xtrain = model{1};
    kernel = model{4};
    kernelargs = model{5};
    
    Ktest = feval(kernel, X, Xtrain, kernelargs);

    % We need a better classifier!
%      yhat = sign(Ktest*a - b);
    yhat = (Ktest*a - b) >= 0;

end