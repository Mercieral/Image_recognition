function featureVector = featureExtractor(img)
    
    [rowLength, colLength, ~] = size(img);
    
    %calculate the size of each cell
    rowBlockSize = floor(rowLength / 7);
    colBlockSize = floor(colLength / 7);
    
    % resize the img to be splittable (cuts off at most 6 pixels from the
    % right and bottom)
    imgResized = img(1:rowBlockSize*7, 1:colBlockSize*7, :);
    
    %7x7 grid of cells referenced like cells{1,2}(3,4,5) where {1,2}
    %specifies cell in 7x7 grid and (3,4,5) specifies the cell's pixel
    cells = mat2cell(imgResized, ones(7,1)*rowBlockSize, ones(7,1)*colBlockSize, 3);
    
    featureVector = zeros(294,1);
   
    for i = 1:7 
        for j = 1:7
            %fun math... it works
            startingIndex = ((i-1)*7*6) + ((j-1)*6) + 1;
            
            %calculate following values from cells{i,j}
            %TODO
            
            currentCell = cells{i,j};
            currentCellRed = currentCell(:,:,1);
            currentCellGreen = currentCell(:,:,2);
            currentCellBlue = currentCell(:,:,3);
            [ccL, ccS, ccT] = unscaledColorConv(double(currentCellRed), double(currentCellGreen), double(currentCellBlue));
            
            
            %Store values in the output TODO
            % L
            featureVector(startingIndex) = mean2(ccL);       % mean of L at ij
            featureVector(startingIndex + 1) = std2(ccL);   % standard deviation of L at ij
            
            % S
            featureVector(startingIndex + 2) = mean2(ccS);   % mean of S at ij
            featureVector(startingIndex + 3) = std2(ccS);   % standard deviation of S at ij
            
            % T
            featureVector(startingIndex + 4) = mean2(ccT);   % mean of T at ij
            featureVector(startingIndex + 5) = std2(ccT);   % standard deviation of T at ij
        end
    end
    
end

function [L, S, T] = unscaledColorConv(red, green, blue)
    % Taken from specificaton
    L = red + green + blue;
    S = red - blue;
    T = red - 2*green + blue;

end
