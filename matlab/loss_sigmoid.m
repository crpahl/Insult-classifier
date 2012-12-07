function [loss] = loss_sigmoid(yhat, ytest)

    [testNum, k] = size(ytest);

    % Probability -> Classification (66.66% confidence)
    for i = 1:testNum
        if yhat(i) >= 0.6666
            yhat(i) = 1;
        else 
            yhat(i) = 0;
        end
    end

    loss = sum(abs(yhat - ytest)) / testNum;

end
