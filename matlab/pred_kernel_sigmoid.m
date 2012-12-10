% kernelized regularized sigmoid prediction

function [yhat] = pred_kernel_sigmoid(Xtest, model)
% Xtest is a texn matrix, model is {a, b, Xtrain, kernel, arg} where a is the
% tx1 weights, and b is the scalar offset, corresponding to the minimum
% regularized sigmoid error.

% yhat is the tex1 vector of probabilities on the test inputs.

    [te, n] = size(Xtest);
    Ktest = feval(model{4}, Xtest, model{3}, model{5});

    yhat = sigmoid(Ktest*model{1} - model{2}); % z_hat = Ktest*a - b
    
end
