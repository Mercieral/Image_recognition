function results = lab6(img, k, seed, iterations)
%     k = 5;
%     seed = 0;
%    rand('state', seed);
    % Initialize k-cluster means, 3-D point
    means = rand(k, 3);
    
    result = zeros(size(img, 1), size(img,2));
    
    for iter = 1:iterations
        for r = 1:size(img, 1)
            for c = 1:size(img,2)
                % Going through and finding distance from each cluster
                minMean = size(img,1) * size(img, 2);
                minK = 0;
                red = double(img(r, c, 1))/255;
                green = double(img(r, c, 2))/255;
                blue = double(img(r, c, 3))/255;
                for i = 1:k
                    d = euclideanDist(red, green, blue, means(i, 1), means(i, 2), means(i, 3));
                    if d < minMean
                        minMean = d;
                        minK = i;
                    end
                end
                result(r, c) = minK;
            end
        end
        % Re-compute the mean of all clusters
        for i = 1:k
            % Handling cluster with zero pixels
            if size(find(result(:,:)==i),1) == 0
                continue;
            else 
                [x, y] = find(result(:,:)==i);
                means(i,1) = mean2(img(x, y, 1))/255;
                means(i,2) = mean2(img(x, y, 2))/255;
                means(i,3) = mean2(img(x, y, 3))/255;
            end
        end
    end 
    % Add color
    results = zeros(size(img, 1), size(img,2), size(img, 3));
    for i = 1:k
        [x,y] = find(result==i);
        for p = 1:size(x,1)
            results(x(p),y(p),1) = means(i,1);
            results(x(p),y(p),2) = means(i,2);
            results(x(p),y(p),3) = means(i,3);
        end
    end
    %         if size(find(results(:,:,1) == i),1) == 0
%             continue;
%         else 
% %             [x,y,z] = find(results(:,:,1)==i);
% %             results(x,y,1) = means(i,1);
%         end
%         results(x,y,2) = means(i,2);
%         results(x,y,3) = means(i,3);
%         [x, y] = find(result==i)
%         results(x, y, 1) = i;%means(i,1);
%         results(x, y, 2) = i;%means(i,2);
%         results(x, y, 3) = i;%means(i,3);
end 


function dist = euclideanDist(x1, y1, z1, x2, y2, z2)
    x = (x1 - x2) ^ 2;
    y = (y1 - y2) ^ 2;
    z = (z1 - z2) ^ 2;
    dist = sqrt(x + y + z);
end 