function [model] = dual_hardmargin(X, y, beta, kernel, varargin)
% K is a txt kernel matrix, y is a tx1 training vector, and beta is a positive
% scalar regularization parameter.
% lambda is the tx1 vector of Lagrange multipliers, and b is the scalar offset,
% corresponding to the dual formulation of the maximum hard-margin classifer.

    for i = 1:size(y)
        if y(i) == 0
            y(i) = -1;
    end

    K = feval(kernel, X, X, varargin);

    [t, t] = size(K);
    H = diag(y)*K*diag(y);
%      Hshift = H + 1e-15*eye(t);
    q = -1*ones(t, 1);
    A_in = -1*eye(t);
    A_ub = zeros(t, 1);
    A = y';
    b_ = 0;

%      [z, obj, info, lambda] = qp([], H, q, A, b_, [], [], [], A_in, A_ub);
    opt = optimset('TolFun',0e-6, 'LargeScale', 'off',  'display', 'off', 'Algorithm', 'active-set');
    [z, obj, info, lambda_] = quadprog(H, q, A_in, A_ub, A, b_, [], [], [], opt);
    lambda = z;
    
    % Fix for infeasible problems
%      if info.info == 6
%          lambda = randn(t, 1);
%          b = median(K*lambda);
%          if sign(K*lambda - b)'*y < 0
%              b = -b;
%          end
%          return
%      end
    
    % max_i = argmax(lambda)
    max_i = 1;
    for i = 1:t
        if lambda(i) > lambda(max_i)
            max_i = i;
        end
    end
    b = K(i, :) * diag(y) * lambda - y(i);
    
    model = {X, lambda, b, y, beta, kernel, varargin};    
    
end
