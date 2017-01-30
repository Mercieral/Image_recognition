subdir = 'slices/82';
row_num = 60;
col_num = 80;
band_num = 3;
fileList = dir(subdir);

images = zeros(row_num*col_num*band_num, size(fileList,1)-3);
for i = 3:size(fileList,1)
%     [subdir  '/' fileList(i).name]
    img = imread([subdir '/'  fileList(i).name]);
    imgResized = imresize(img, 1/4);
    %[num2str(size(imgResized,1)) 'x' num2str(size(imgResized,2)) 'x' num2str(size(imgResized,3))]
    imgCol = reshape(imgResized, size(imgResized,1) * size(imgResized,2) * size(imgResized, 3), 1);
    images(:, i) = imgCol;
end
meanImg = mean(images,2);
images = images - repmat(meanImg, 1, size(images,2));

c = images * transpose(images);
c = c ./ size(images,2);

%vals = eigs(c, 10)
[vectors, values] = eigs(c, 3);
v1 = reshape(vectors(:,1), row_num, col_num, band_num);
v2 = reshape(vectors(:,2), row_num, col_num, band_num);
v3 = reshape(vectors(:,3), row_num, col_num, band_num);

v1Norm = normalize(v1);
v2Norm = normalize(v2);
v3Norm = normalize(v3);

