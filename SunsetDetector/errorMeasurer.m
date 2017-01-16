function [ trueNeg, truePos, falsePos, falseNeg, accuracy, TPR, precision, FPR, net ] = errorMeasurer( norm, outcome, outcomeTest, sigma, cp )
    % Calculates the error measurements for a given set. 
    % Given a stucture, true outcomes for the training, and the correct 
    % outcomes for the tests, kernal parameter (sigma), and additional 
    % parameters (c), will produce the true negative, true
    % positive, false positive, false negative, accuracy, true positive
    % ration, precision, and false positive ratio.
    
    net = svm(size(norm.norm, 2), 'rbf', [sigma], cp);
    net = svmtrain(net, norm.norm(1:size(outcome,1),:), outcome); %#ok<SVMTRAIN>
    [classes, dist] = svmfwd(net, norm.norm(size(outcome,1)+1:size(norm.norm,1),:));
    results = [];
    for i = 1:length(outcomeTest)
        results = [i, outcomeTest(i), classes(i), outcomeTest(i)== classes(i), dist(i);results]; %#ok<AGROW>
    end

    trueNeg = size(results(results(:,4) == 1 & results(:,2) == -1),1);
    truePos = size(results(results(:,4) == 1 & results(:,2) == 1), 1);
    falsePos = size(results(results(:,3) == 1 & results(:,2) == -1),1);
    falseNeg = size(results(results(:,3) == -1 & results(:,2) == 1),1);
    accuracy = (truePos + trueNeg) / (truePos + trueNeg + falsePos + falseNeg);
    TPR = truePos/ (truePos + falseNeg);
    precision = truePos / (truePos + falsePos);
    FPR = falsePos / (falsePos + trueNeg);
end

