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

lWeights = [1];
sWeights = [1];
tWeights = [1];
% lWeights = [1 1 1 1 1 1 2 100 1000 .0000000001 .01 .001 .01 .001 .5 .25];
% sWeights = [1 1 1 .0000000001 .5 .25 2 .01 .001 1 100 1000 .01 .001 .5 .25];
% tWeights = [1 100 .0000000001 1 .5 .25 2 .01 1000 1 .01 1000 100 1000 .5 .25];

if (size(lWeights) ~= size(sWeights)) & (size(lWeights) ~= size(tWeights))
    return
end 

for i = 1:size(lWeights,2)
    norm{i} = imageExtractor(fileLists, subdirs, lWeights(i), sWeights(i), tWeights(i));
end

%%% To determine optimal sigma/c parameters for svm
% sigmaList = .1:.5:17;
% cpList = 10:5:100;
% for i = 1:size(sigmaList,2)
%    for j = 1:size(cpList,2)
%        [tn, tp, fp, fn, ac, TPR, p, FPR, net] = errorMeasurer(norm{1}, outcome, outcomeTest, sigmaList(i), cpList(j), 0);
%        expResults = [expResults; sigmaList(i) cpList(j) tn tp fp fn ac TPR p FPR size(net.sv,1);]; %#ok<AGROW>
%    end
% end
%%% Commamnd to find the optimal accuracy with reasonable # of SV's through
%expResults(find(max(expResults(find(expResults(:,11) < 250),7))==expResults(:,7)))

%%% Use optimal sigma/c parameters to test different threshold levels and
%%% weights of the color bands and display the ROC curve. WARNING this
%%% takes a long time
% figure;
% hold on;
% lineColors = ['y-' 'm-' 'c-' 'r-' 'g-' 'b-' 'w-' 'k-' 'y-' 'm-' 'c-' 'r-' 'g-' 'b-' 'w-' 'k-' 'y-' 'm-' 'c-' 'r-' 'g-' 'b-' 'w-' 'k-' 'y-' 'm-' 'c-' 'r-' 'g-' 'b-' 'w-' 'k-' 'y-' 'm-' 'c-' 'r-' 'g-' 'b-' 'w-' 'k-' ];
% pointColors = ['yo' 'mo' 'co' 'ro' 'go' 'bo' 'wo' 'ko' 'yo' 'mo' 'co' 'ro' 'go' 'bo' 'wo' 'ko' 'yo' 'mo' 'co' 'ro' 'go' 'bo' 'wo' 'ko' 'yo' 'mo' 'co' 'ro' 'go' 'bo' 'wo' 'ko' 'yo' 'mo' 'co' 'ro' 'go' 'bo' 'wo' 'ko' ];
% for i = 1:size(lWeights,2)
%     expResults = []; %['Sigma' 'C' 'TrueNeg' 'TruePos' 'FalsePos' 'FalseNeg' 'Acc' 'TPR' 'Prec.' 'FPR' '#sv'];
%     for threshold = -4:0.1:4
%         [tn, tp, fp, fn, ac, TPR, p, FPR, net] = errorMeasurer(norm{i}, outcome, outcomeTest, 0.1, 20, threshold);
%         expResults = [expResults; 0.1 20 tn tp fp fn ac TPR p FPR size(net.sv,1);]; %#ok<AGROW>
%     end
%     rocGenerator(lineColors(max(mod(i, size(lWeights,2)),1)), pointColors(max(mod(i, size(lWeights,2)),1)), expResults(:,8), expResults(:,10));
% end
% displayResults(expResults);

%%% Use optimal sigma/c parameters to test different threshold levels and display ROC curve
figure;
hold on;
expResults = []; %['Sigma' 'C' 'TrueNeg' 'TruePos' 'FalsePos' 'FalseNeg' 'Acc' 'TPR' 'Prec.' 'FPR' '#sv'];
for threshold = -4:0.1:4
    [tn, tp, fp, fn, ac, TPR, p, FPR, net] = errorMeasurer(norm{1}, outcome, outcomeTest, 0.1, 20, threshold);
    expResults = [expResults; 0.1 20 tn tp fp fn ac TPR p FPR size(net.sv,1);]; %#ok<AGROW>
end
rocGenerator(['b-'], ['bo'], expResults(:,8), expResults(:,10));