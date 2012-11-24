% the sigmoid function for transforming a real number into a probability

function [p] = sigmoid(z)

    p = (1 + exp(-z)).^-1;
    
end
