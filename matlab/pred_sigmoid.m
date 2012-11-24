% unkernelized regularized sigmoid prediction

function[yhat] = pred_sigmoid(Xtest, model)
% Xtest is a texn matrix, model is [a; b], where a is a nx1 vector of weights,
% and b is a scalar.

% yhat is the tex1 vector of probabilities on the test inputs.

    [te, n] = size(Xtest);

    yhat = sigmoid(Xtest*model(1:n) - model(n+1)); % z_hat = Xtest*a - b
        
end
