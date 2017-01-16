featureFilename = 'feature.mat';
trainingCount = 0;
subdir1 = 'sunsetDetectorImages/TrainSunset';
subdir2 = 'sunsetDetectorImages/TrainNonsunsets';
subdir3 = 'sunsetDetectorImages/TestSunset';
subdir4 = 'sunsetDetectorImages/TestNonsunsets';
subdir5 = 'sunsetDetectorImages/TestDifficultSunsets';
subdir6 = 'sunsetDetectorImages/TestDifficultNonsunsets';

subdirs = {subdir1, subdir2, subdir3, subdir4, subdir5, subdir6}; 
fileLists = {dir(subdir1), dir(subdir2), dir(subdir3), dir(subdir4), dir(subdir5), dir(subdir6)};
trainingCount = trainingCount + size(fileLists{1},1)- 4 + size(fileLists{2},1);
outcome = [ones(size(fileLists{1},1)-2,1); ones(size(fileLists{2},1)-2, 1)*-1];
outcomeTest = [ones(size(fileLists{3},1)-2,1);ones(size(fileLists{4},1)-2,1)*-1;ones(size(fileLists{5},1)-2,1);ones(size(fileLists{6},1)-2,1)*-1];

if exist(featureFilename, 'file')
    norm = load(featureFilename, 'norm');
else
    % preallocate memory to prevent inefficient reallocation at each iteration.
    % 10000 is assumed to be the maximum, and it will shrink the array to the
    % exact size at the end (suggested by MATLAB spec)
    features = zeros(10000, 294);

    count = 0;
    for i = 1:size(fileLists, 2)
        for j = 3:size(fileLists{i})
            %if count < 10
                count = count + 1;
                img = imread([subdirs{i} '/'  fileLists{i}(j).name]);
                extractedFeatures = featureExtractor(img);
                features(count,:) = extractedFeatures(:,1);
            %end
        end
    end

    features = features(1:count, 1:294);
    size(features)

    norm = normalizeFeatures01(features);

    save(featureFilename, 'norm');
end

% Train svm with only the training sets from norm
% TODO

% The total number of cells that need to be trained with are in
% trainingCount 

net = svm(size(norm.norm, 2), 'rbf', [8], 100);
net = svmtrain(net, norm.norm(1:size(outcome,1),:), outcome);
% plotboundary(net, [0 294], [0 294]);
[classes, dist] = svmfwd(net, norm.norm(size(outcome,1)+1:size(norm.norm,1),:));
results = [];
for i = 1:length(outcomeTest)
    results = [i, outcomeTest(i), classes(i), outcomeTest(i)== classes(i), dist(i);results];
end

trueNeg = size(results(results(:,4) == 1 & results(:,2) == -1),1)
truePos = size(results(results(:,4) == 1 & results(:,2) == 1), 1)
falsePos = size(results(results(:,3) == 1 & results(:,2) == -1),1)
falseNeg = size(results(results(:,3) == -1 & results(:,2) == 1),1)
accuracy = (truePos + trueNeg) / (truePos + trueNeg + falsePos + falseNeg);
TPR = truePos/ (truePos + falseNeg)
precision = truePos / (truePos + falsePos);
FPR = falsePos / (falsePos + trueNeg)
