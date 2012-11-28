function [a, b] = adj_softmargin(K, y, beta)
% X is a txt kernel matrix, y is a tx1 vector, and beta is a positive scalar.
% a is the tx1 example weights, and b is the scalar offset, corresponding to
% the minimum regularized soft-margin linear discriminant classifier.

    [t, t] = size(K);
    H = [0.5*beta*K zeros(t, t+1) ; zeros(t+1, t) zeros(t+1, t+1)];
%      Hshift = H + [1e-15*eye(t+1, t) zeros(t, t+1); zeros(t+1, t) zeros(t+1, t+1)];
    q = [zeros(t+1, 1); ones(t, 1)];
    A = [-1*diag(y)*K y -1*eye(t); zeros(t, t+1) -1*eye(t)];
    A_ub = [-1*ones(t, 1); zeros(t, 1)];
    
%      [x, obj, info, lambda] = quadprog([], Hshift, q, [], [], [], [], [], A, A_ub);
    [x, obj, info, lambda] = quadprog(H, q, A, A_ub);
    
    a = x(1:t);
    b = x(t+1);
end
