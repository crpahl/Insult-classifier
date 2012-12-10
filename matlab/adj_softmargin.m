function [model] = adj_softmargin(X, y, beta, kernel, varargin)
% X is a txt kernel matrix, y is a tx1 vector, and beta is a positive scalar.
% a is the tx1 example weights, and b is the scalar offset, corresponding to
% the minimum regularized soft-margin linear discriminant classifier.

    K = feval(kernel, X, X, varargin);

    [t, t] = size(K);
    H = [0.5*beta*K zeros(t, t+1) ; zeros(t+1, t) zeros(t+1, t+1)];
%      Hshift = H + [1e-15*eye(t+1, t) zeros(t, t+1); zeros(t+1, t) zeros(t+1, t+1)];
    q = [zeros(t+1, 1); ones(t, 1)];
    A = [-1*diag(y)*K y -1*eye(t); zeros(t, t+1) -1*eye(t)];
    A_ub = [-1*ones(t, 1); zeros(t, 1)];
    
%      [x, obj, info, lambda] = quadprog([], Hshift, q, [], [], [], [], [], A, A_ub);
    opt = optimset('TolFun',0e-6, 'LargeScale', 'off',  'display', 'off', 'Algorithm', 'interior-point-convex');
    [x, obj, info, lambda] = quadprog(H, q, A, A_ub, [], [], [], [], [], opt);
    
    a = x(1:t);
    b = x(t+1);

    model = {X, a, b, kernel, varargin};
    
end
