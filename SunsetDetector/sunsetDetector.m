addpath(genpath(pwd)) 

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
outcomeTest = [
    ones(size(fileLists{3},1)-2,1);
    ones(size(fileLists{4},1)-2,1)*-1;
    ones(size(fileLists{5},1)-2,1);
    ones(size(fileLists{6},1)-2,1)*-1];

lWeight = 100000;
sWeight = .0000000000001;
tWeight = .0000000000001;


norm = imageExtractor(fileLists, subdirs, lWeight, sWeight, tWeight);

expResults = []; %['Sigma' 'C' 'TrueNeg' 'TruePos' 'FalsePos' 'FalseNeg' 'Acc' 'TPR' 'Prec.' 'FPR'];

% To determine optimal sigma/c parameters for svm
% sigmaList = .1:.5:17;
% cpList = 10:5:100;
% for i = 1:size(sigmaList,2)
%    for j = 1:size(cpList,2)
%        [tn, tp, fp, fn, ac, TPR, p, FPR, net] = errorMeasurer(norm, outcome, outcomeTest, sigmaList(i), cpList(j), 0);
%        expResults = [expResults; sigmaList(i) cpList(j) tn tp fp fn ac TPR p FPR size(net.sv,1);]; %#ok<AGROW>
%    end
% end

% Use optimal sigma/c parameters to test different threshold levels and
%display ROC curve
for threshold = -4:0.1:4
    [tn, tp, fp, fn, ac, TPR, p, FPR, net] = errorMeasurer(norm, outcome, outcomeTest, 0.1, 20, threshold);
    expResults = [expResults; 0.1 20 tn tp fp fn ac TPR p FPR size(net.sv,1);]; %#ok<AGROW>
end
rocGenerator(expResults(:,8), expResults(:,10));

%displayResults(expResults);


%%% Commamnd to find the indicies
% find(max(expResults(find(expResults(:,11) < 250),7))==expResults(:,7))