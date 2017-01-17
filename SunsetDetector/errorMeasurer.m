function [ trueNeg, truePos, falsePos, falseNeg, accuracy, TPR, precision, FPR, net ] = errorMeasurer( norm, outcome, outcomeTest, sigma, cp, threshold)
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
    
    %print max and min distances to get threshold ranges
    max(dist);
    min(dist);
    
    for i = 1:length(outcomeTest)
        aboveThreshold = dist(i)>=threshold;
        checkThreshold = -1;
        if aboveThreshold 
            checkThreshold = 1;
        end
        results = [i, outcomeTest(i), classes(i), checkThreshold, outcomeTest(i)==classes(i), outcomeTest(i)==checkThreshold;results]; %#ok<AGROW>

    end

    %Using threshold of 0
    %trueNeg = size(results(results(:,5) == 1 & results(:,2) == -1),1);
    %truePos = size(results(results(:,5) == 1 & results(:,2) == 1), 1);
    %falsePos = size(results(results(:,3) == 1 & results(:,2) == -1),1);
    %falseNeg = size(results(results(:,3) == -1 & results(:,2) == 1),1);
    
    %using dynamic threshold
    trueNeg = size(results(results(:,6) == 1 & results(:,2) == -1),1);
    truePos = size(results(results(:,6) == 1 & results(:,2) == 1), 1);
    falsePos = size(results(results(:,4) == 1 & results(:,2) == -1),1);
    falseNeg = size(results(results(:,4) == -1 & results(:,2) == 1),1);
    
    accuracy = (truePos + trueNeg) / (truePos + trueNeg + falsePos + falseNeg);
    TPR = truePos/ (truePos + falseNeg);
    precision = truePos / (truePos + falsePos);
    FPR = falsePos / (falsePos + trueNeg);
end

