function [loss] = loss_sigmoid(yhat, ytest, varargin)

    confidence = varargin{1};
    [testNum, k] = size(ytest);

    % Probability -> Classification (% confidence)
    for i = 1:testNum
        if yhat(i) >= confidence
            yhat(i) = 1;
        else 
            yhat(i) = 0;
        end
    end

    loss = sum(abs(yhat - ytest)) / testNum;

end
