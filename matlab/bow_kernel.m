% the bag-of-words kernel

function [K] = bow_kernel(X1, X2, varargin)
% varargin = {cmp_str}
    
    [te, n] = size(X1);
    [t, n] = size(X2);
    cmp_str = varargin{1};
    
    if strcmp(cmp_str, 'mult')
        cmp = @(x, y) (x * y);
    elseif strcmp(cmp_str, 'sqrt')
        cmp = @(x, y) sqrt(x + y);
    elseif strcmp(cmp_str, 'average')
        cmp = @(x, y) (0.5 * (x + y));
    elseif strcmp(cmp_str, 'binary')
        cmp = @(x, y) ((x ~= 0) && (y ~= 0));
    else    % addition
        cmp = @(x, y) (x + y);
    end
    
    K = zeros(te, t);
    
    for i = 1:te
        for j = 1:t
            K(i, j) = num_words_in_common(X1(i, :), X2(j, :), cmp);
        end
    end

end

function [count] = num_words_in_common(X1, X2, cmp)
% count is the sum of the application of cmp on X1 and X2, where X1 and X2 are
% not zero.

    n = size(X1);
    count = 0;
    
    for i = 1:n
        count = count + cmp(X1(i), X2(i));
    end

end
