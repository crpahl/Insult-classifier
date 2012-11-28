% unkernelized regularized sigmoid training

function [model] = train_sigmoid(Xtrain, ytrain, beta)
% Xtrain is a txn matrix, ytrain is a tx1 vector, and beta is a positive scalar.

% model is [a; b], where a is the nx1 weights, and b is the scalar offset,
% corresponding to the minimum regularized sigmoid error.

    [t, n] = size(Xtrain);
    H = [0.5*beta*eye(n) zeros(n, 1) ; zeros(1, n) 0];
    
    phi = @(x)sigmoid_err(x, H, Xtrain, ytrain);
    opt = optimset('TolFun',0e-6, 'LargeScale', 'off',  'display', 'off');
    
    model = fminunc(phi, zeros(n+1, 1), opt);

end

function [x] = sigmoid_err(w, H, X, y)
% x is the regularized sigmoid error.
% sigmoid error = y*log(y/y_hat) + (1-y)*log((1-y)/(1-y_hat))

    [t, n] = size(X);
    y_hat = sigmoid(X*w(1:n) - w(n+1)); % sigmoid(K*w - b)

    x = w'*H*w + y'*log(y./y_hat) + (1-y)'*log((1-y)./(1-y_hat));
    
end
