function [a, b] = adj_lsemargin(K, y, beta)
	[t, n] = size(K);

	f = @(x) (beta/2)*(x(1:n)'*K*x(1:n)) + sum(log(1 + exp(-y.*(K*x(1:n) - x(n+1)))));
	opt = optimset('TolFun',0e-6, 'LargeScale', 'off',  'display', 'off');
	x = fminunc(f, zeros(n+1,1), opt);

	a = x(1:n);
	b = x(n+1);