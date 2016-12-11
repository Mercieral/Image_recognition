function [dx, dy, sums, magnitudes, directions, filteredDirections] = sobel(img)

    sobelx = (1/8) .* [-1 0 1; -2 0 2; -1 0 1];
    sobely = (1/8) .* [1 2 1; 0 0 0; -1 -2 -1];
    
    dx = filter2(sobelx, img);
    dy = filter2(sobely, img);
    sums = dy + dx;
    magnitudes = sqrt((dx .* dx) + (dy .* dy));
    directions = atan2(dy, dx);
    
    maximum = max(max(magnitudes));
    minimum = min(min(magnitudes));
    threshold = (maximum + minimum) / 10;
    
    
    
    filteredDirections = directions;
    filteredDirections(magnitudes <= threshold) = 0;
    
end

