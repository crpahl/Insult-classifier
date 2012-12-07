function [Xsub, ysub] = getSubset(X, y, num)
% Return X and y of size num with an equal ammount of insults
% and non insults

%shuffle X and y
[t,k] = size(X);
r = randperm(t);
X = X(r, :);
y = y(r, :);

%insult subsets
X1 = X(logical(y), :);
Y1 = y(logical(y), :);

%non-insult subsets
X2 = X(~logical(y), :);
Y2 = y(~logical(y), :);

Xsub = [X1(1:floor(num/2)); X2(1:floor(num/2))];
ysub = [Y1(1:floor(num/2)); Y2(1:floor(num/2))];
