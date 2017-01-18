function norm = imageExtractor(fileLists, subdirs, lWeight, sWeight, tWeight)
% Used to shorten code. Commented out is the the code used to be a time
% saver. Cause interference with running multiple tests. Function was just
% commented out.


    % if exist(featureFilename, 'file')
    %     disp('If changing the weights, you must delete the file "feature.mat"');
    %     norm = load(featureFilename, 'norm');
    % else

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
                extractedFeatures = featureExtractor(img, lWeight, sWeight, tWeight);
                features(count,:) = extractedFeatures(:,1);
            %end
        end
    end

    features = features(1:count, 1:294);
    size(features);

    norm = normalizeFeatures01(features); 

    %     save(featureFilename, 'norm');
    %     norm = load(featureFilename, 'norm');

    % end

end

