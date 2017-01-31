%% Initializing variables
subdir = 'slices/82';
scale_factor = 4;
row_num = 240/scale_factor;
col_num = 320/scale_factor;
band_num = 3;
fileList = dir(subdir);

%% Reading images and resizing/reshaping
images = zeros(row_num*col_num*band_num, size(fileList,1)-3);
for i = 3:size(fileList,1)
    img = imread([subdir '/'  fileList(i).name]);
    imgResized = imresize(img, 1/scale_factor);
    imgCol = reshape(imgResized, size(imgResized,1) * size(imgResized,2) * size(imgResized, 3), 1);
    images(:, i) = imgCol;
    
end


%% determining eigenvectors using covariance matrix
meanImg = mean(images,2);
images = images - repmat(meanImg, 1, size(images,2));
c = images * transpose(images);
c = c ./ size(images,2);

[vectors, values] = eigs(c, 3);
mean2 = reshape(meanImg, row_num, col_num, band_num);
v1 = reshape(vectors(:,1), row_num, col_num, band_num);
v2 = reshape(vectors(:,2), row_num, col_num, band_num);
v3 = reshape(vectors(:,3), row_num, col_num, band_num);

v1Norm = normalize(v1);
v2Norm = normalize(v2);
v3Norm = normalize(v3);


%% Read through the images again and determine coefficient values for each eigenimage
C = zeros(size(fileList,1),3);
for i = 3:size(fileList,1)
    img = imread([subdir '/'  fileList(i).name]);
    imgResized = imresize(img, 1/scale_factor);
    
    syms c1 c2 c3
    eqn1 = imgResized(1,1,1) == mean2(1,1,1) + (c1 * v1(1,1,1)) + (c2 * v2(1,1,1)) + (c3 * v3(1,1,1));
    eqn2 = imgResized(1,1,2) == mean2(1,1,2) + (c1 * v1(1,1,2)) + (c2 * v2(1,1,2)) + (c3 * v3(1,1,2));
    eqn3 = imgResized(1,1,3) == mean2(1,1,3) + (c1 * v1(1,1,3)) + (c2 * v2(1,1,3)) + (c3 * v3(1,1,3));
    [A,B] = equationsToMatrix([eqn1, eqn2, eqn3], [c1, c2, c3]);
    X = linsolve(A,B);
    
    if (strcmp(fileList(i).name, '20060606_173500.jpg') || strcmp(fileList(i).name,'20060607_081800.jpg')) 
        disp(X)
        imtool(uint8(normalize(mean2 + (double(X(1)) .* v1) + (double(X(2)) .* v2) + (double(X(3)) .* v3))));
    end
    
    C(i,1) = double(X(1));
    C(i,2) = double(X(2));
    C(i,3) = double(X(3));
    
end

plot(1:size(fileList,1), C(:,1))
