subdir1 = 'sunsetDetectorImages/TrainSunset';
subdir2 = 'sunsetDetectorImages/TrainNonsunsets';
subdir3 = 'sunsetDetectorImages/TestSunset';
subdir4 = 'sunsetDetectorImages/TestNonsunsets';
subdir5 = 'sunsetDetectorImages/TestDifficultSunsets';
subdir6 = 'sunsetDetectorImages/TestDifficultNonsunsets';

subdirs = {subdir1, subdir2, subdir3, subdir4, subdir5, subdir6}; 
fileLists = {dir(subdir1), dir(subdir2), dir(subdir3), dir(subdir4), dir(subdir5), dir(subdir6)};

count = 0;
for i = 1:size(fileLists, 2)
    for j = 3:size(fileLists{i})
        %img = imread([subdir i '/'  fileLists{i}(j).name]);
        count = count + 1;
        % TODO: insert code of function call here to operate on image.
        % Hint: debug the loop body on 1-2 images BEFORE looping over lots of them...
    end
end
count

