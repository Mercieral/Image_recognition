% toyProblem.m
% Written by Matthew Boutell, 2006.
% Modified by Aaron Mercier and Larry Gates
% Feel free to distribute at will.

clear all;

% We fix the seeds so the data sets are reproducible
seedTrain = 137;
seedTest = 138;
% This tougher data set is commented out.
%[xTrain, yTrain] = GenerateGaussianDataSet(seedTrain);
%[xTest, yTest] = GenerateGaussianDataSet(seedTest);

% This one isn't too bad at all
[xTrain, yTrain] = GenerateClusteredDataSet(seedTrain);
[xTest, yTest] = GenerateClusteredDataSet(seedTest);


% Add your code here.
% KNOWN ISSUE: the linear decision boundary doesn't work 
% for this data set at all. Don't know why...

net = svm(size(xTrain, 2), 'rbf', (8));
net = svmtrain(net, xTrain, yTrain);
plotboundary(net, [0,20], [0,20]);

[classes, dist] = svmfwd(net, xTest);
results = [];
for i = 1:length(yTest)
    fprintf('Point %d, True class: %d, detected class: %d, Correct: %d, distance: %0.2f\n', i, yTest(i), classes(i),yTest(i) == classes(i), dist(i));
    results = [i, yTest(i), classes(i),yTest(i) == classes(i), dist(i); results];
end

trueNeg = size(results(results(:,4) == 1 & results(:,2) == -1),1)
truePos = size(results(results(:,4) == 1 & results(:,2) == 1), 1)
falsePos = size(results(results(:,3) == 1 & results(:,2) == -1),1)
falseNeg = size(results(results(:,3) == -1 & results(:,2) == 1),1)
accuracy = (truePos + trueNeg) / (truePos + trueNeg + falsePos + falseNeg);
TPR = truePos/ (truePos + falseNeg)
precision = truePos / (truePos + falsePos);
FPR = falsePos / (falsePos + trueNeg)




