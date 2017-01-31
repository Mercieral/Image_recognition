subdir = 'slices/82';
scale_factor = 4;
row_num = 240/scale_factor;
col_num = 320/scale_factor;
band_num = 3;
fileList = dir(subdir);

images = zeros(row_num*col_num*band_num, size(fileList,1)-3);
for i = 3:size(fileList,1)
%     [subdir  '/' fileList(i).name]
    img = imread([subdir '/'  fileList(i).name]);
    imgResized = imresize(img, 1/scale_factor);
%     [num2str(size(imgResized,1)) 'x' num2str(size(imgResized,2)) 'x' num2str(size(imgResized,3))]
    imgCol = reshape(imgResized, size(imgResized,1) * size(imgResized,2) * size(imgResized, 3), 1);
    images(:, i) = imgCol;
    
end
meanImg = mean(images,2);
images = images - repmat(meanImg, 1, size(images,2));

c = images * transpose(images);
c = c ./ size(images,2);

%vals = eigs(c, 10)
[vectors, values] = eigs(c, 3);
mean2 = reshape(meanImg, row_num, col_num, band_num);
v1 = reshape(vectors(:,1), row_num, col_num, band_num);
v2 = reshape(vectors(:,2), row_num, col_num, band_num);
v3 = reshape(vectors(:,3), row_num, col_num, band_num);

v1Norm = normalize(v1);
v2Norm = normalize(v2);
v3Norm = normalize(v3);

% img1 = imread([subdir '/20060606_173500.jpg']);
% img2 = imread([subdir '/20060607_081800.jpg']);
% 
% syms c1 c2 c3
% eqn1 = img1(1,1,1) == mean2(1,1,1) + (c1 * v1(1,1,1)) + (c2 * v2(1,1,1)) + (c3 * v3(1,1,1));
% eqn2 = img1(1,1,2) == mean2(1,1,2) + (c1 * v1(1,1,2)) + (c2 * v2(1,1,2)) + (c3 * v3(1,1,2));
% eqn3 = img1(1,1,3) == mean2(1,1,3) + (c1 * v1(1,1,3)) + (c2 * v2(1,1,3)) + (c3 * v3(1,1,3));
% [A,B] = equationsToMatrix([eqn1, eqn2, eqn3], [c1, c2, c3]);
% X = linsolve(A,B)
% 
% resImg1 = normalize(mean2 + (double(X(1)) .* v1) + (double(X(2)) .* v2) + (double(X(3)) .* v3));
% 
% syms c4 c5 c6
% eqn4 = img2(1,1,1) == mean2(1,1,1) + (c4 * v1(1,1,1)) + (c5 * v2(1,1,1)) + (c6 * v3(1,1,1));
% eqn5 = img2(1,1,2) == mean2(1,1,2) + (c4 * v1(1,1,2)) + (c5 * v2(1,1,2)) + (c6 * v3(1,1,2));
% eqn6 = img2(1,1,3) == mean2(1,1,3) + (c4 * v1(1,1,3)) + (c5 * v2(1,1,3)) + (c6 * v3(1,1,3));
% [A2,B2] = equationsToMatrix([eqn4, eqn5, eqn6], [c4, c5, c6]);
% X2 = linsolve(A2,B2)
% 
% resImg2 = normalize(mean2 + (double(X2(1)) .* v1) + (double(X2(2)) .* v2) + (double(X2(3)) .* v3));
% solve(img1 = mean2 + (c1 * v1) + (c2 * v2) + (c3 * v3))
C = zeros(size(fileList,1),3);

for i = 3:size(fileList,1)
%     [subdir  '/' fileList(i).name]
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
