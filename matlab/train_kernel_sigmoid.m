% kernelized regularized sigmoid prediction

function [model] = train_kernel_sigmoid(Xtrain, ytrain, beta, kernel, varargin)
% Xtrain is a txn matrix, ytrain is a tx1 vector, beta is a positive scalar,
% kernel is a string indicating the name of the kernel transformation to use,
% and varargin are the additional arguments to the kernel function (aside from
% the 2 matrices).

% model is [a b Xtrain kernel arg] where a is the tx1 weights, and b is the
% scalar offset, corresponding to the minimum regularized sigmoid error.

    Ktrain = feval(kernel, Xtrain, Xtrain, varargin);

    [t, t] = size(Ktrain);
    H = [0.5*beta*Ktrain zeros(t, 1) ; zeros(1, t) 0];
    
    phi = @(x)sigmoid_err(x, H, Ktrain, ytrain);
    opt = optimset('TolFun',0e-6, 'LargeScale', 'off',  'display', 'off');
    
    z = fminunc(phi, zeros(t+1, 1), opt);

    model = {z(1:t), z(t+1), Xtrain, kernel, varargin};
    
end

function [x] = sigmoid_err(w, H, K, y)
% x is the regularized sigmoid error.
% sigmoid error = y*log(y/y_hat) + (1-y)*log((1-y)/(1-y_hat))

    [t, t] = size(K);
    y_hat = sigmoid(K*w(1:t) - w(t+1)); % sigmoid(K*w - b)

    x = w'*H*w + y'*log(y./y_hat) + (1-y)'*log((1-y)./(1-y_hat));

end
