% the gaussian kernel

function [K] = gauss_kernel(X1, X2, varargin)
% varargin = {sigma}

    distance = repmat(sum(X1.^2,2),1,size(X2,1)) ...
        + repmat(sum(X2.^2,2)',size(X1,1),1) ...
        - 2*X1*X2';

    K = exp(-distance/(2*cell2mat(varargin{1})^2));

end
