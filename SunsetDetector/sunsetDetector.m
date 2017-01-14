subdir1 = 'sunsetDetectorImages/TrainSunset';
subdir2 = 'sunsetDetectorImages/TrainNonsunsets';
subdir3 = 'sunsetDetectorImages/TestSunset';
subdir4 = 'sunsetDetectorImages/TestNonsunsets';
subdir5 = 'sunsetDetectorImages/TestDifficultSunsets';
subdir6 = 'sunsetDetectorImages/TestDifficultNonsunsets';

subdirs = {subdir1, subdir2, subdir3, subdir4, subdir5, subdir6}; 
fileLists = {dir(subdir1), dir(subdir2), dir(subdir3), dir(subdir4), dir(subdir5), dir(subdir6)};

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

% Train svm with only the training sets from norm
% TODO

