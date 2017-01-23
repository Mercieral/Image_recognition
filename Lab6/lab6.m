function result = lab6(img)
    k = 5;
    seed = 0;
    rand('state', seed);
    % Initialize k-cluster means, 3-D point
    means = rand(k, 3);
    
    result = zeros(size(img, 1), size(img,2), size(img, 3));
    
    for r = 1:size(img, 1)
        for c = 1:size(img,2)
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
            minK
            result(r, c, 1) = minK;
        end
    end

end 


function dist = euclideanDist(x1, y1, z1, x2, y2, z2)
    x = pow2(x1 - x2);
    y = pow2(y1 - y2);
    z = pow2(z1 - z2);
    dist = sqrt(x + y + z);
end 