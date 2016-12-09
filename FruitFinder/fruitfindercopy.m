% Aaron Mercier and Larry Gates
% CSSE463

function [apples, bananas, oranges] = fruitfindercopy(img)
    imgHSV = rgb2hsv(img);

    % Defining masks
    appleMask = zeros(size(imgHSV, 1), size(imgHSV, 2));
    bananaMask = zeros(size(imgHSV, 1), size(imgHSV, 2));
    orangeMask = zeros(size(imgHSV, 1), size(imgHSV, 2));

    %% Apples 
    % Finding locations
    upperRed = imgHSV(:,:,1) >= .8;
    lowerRed = imgHSV(:,:,1) <= .059;
    redVal = imgHSV(:,:,3) >= .035 & imgHSV(:,:,3) <= .6;
    appleMask((upperRed | lowerRed) & redVal) = 1;
    
    % Eroding all extra noise
    appleErode = medfilt2(appleMask, [15,15]);
    
    % Closing to get holes closed
    se = strel('disk',4);
    appleClose = imclose(appleErode, se);
    
    %dilate to return apple to expected size
    se = strel('disk',3);
    appleDilate = imdilate(appleClose, se);
   
    finalApple = appleDilate;
    
    %% Bananas
        
    yellowHue = imgHSV(:,:,1) >= 0.125 & imgHSV(:,:,1) <= 0.30;
    yellowSat = imgHSV(:,:,2) >= 0.6 & imgHSV(:,:,2) <= 0.9;
    yellowVal = imgHSV(:,:,3) >= .2;
    bananaMask(yellowHue & yellowSat & yellowVal) = 1;

    %close initial gaps
    se = strel('square',3);
    fill = imclose(bananaMask, se);
    se = strel('square',6);
    fill2 = imclose(fill, se);
    
    % Eroding to get rid of extra noise
    bigse = strel('square',4);
    littlese = strel('square',2);
    erodeBanana1 = imerode(fill2, bigse);
    erodeBanana2 = imerode(erodeBanana1, bigse);
    erodeBanana3 = imerode(erodeBanana2, littlese);
    erodeBanana4 = imerode(erodeBanana3, littlese);

    % close any remaining holes
    se = strel('square',3);
    closed1 = imclose(erodeBanana4, se);
    se = strel('square',17);
    closed2 = imclose(closed1, se);
    
    % expand banana to original size-ish
    se = strel('disk',4);
    dilateBanana = imdilate(closed2, se);
    
    finalBanana = dilateBanana;
    
    %% Oranges
    % Finding locations
    orangeColor= imgHSV(:,:,1) >= 0.0409 & imgHSV(:,:,1) < .12;
    orangeSat = imgHSV(:,:,2) >= .68;
    orangeVal = imgHSV(:,:,3) >= .53 & imgHSV(:,:,3) <= 1;
    
    orangeMask((orangeColor) & orangeSat & orangeVal) = 1;
    
    % The orange that is green 
    greenishColor = imgHSV(:,:,1) >= .12 & imgHSV(:,:,1) <= .19;
    greenishSat = imgHSV(:,:,2) > .85;
    greenishValue = imgHSV(:,:,3) < .6;
    orangeMask(greenishColor & greenishSat & greenishValue) = 1;
    
    % Eroding to get rid of extra noise
    se = strel('disk', 2);
    erodeOrange = imerode(orangeMask, se);
    
    % Closing to get holes closed
    se = strel('disk',7);
    orangeClose = imclose(erodeOrange, se);
    
    se = strel('disk',2);
    orangeDilate = imdilate(orangeClose, se);

    finalOrange = orangeDilate;
    
    
    %% End results
    applesLabeled = bwlabel(finalApple);
    bananasLabeled = bwlabel(finalBanana);
    orangesLabeled = bwlabel(finalOrange);
    
    apples = max(max(applesLabeled));
    bananas = max(max(bananasLabeled));
    oranges = max(max(orangesLabeled));
    
    averageAppleSize = size(find(finalApple == 1), 1) / apples;
    averageBananaSize = size(find(finalBanana == 1), 1) / bananas;
    averageOrangeSize = size(find(finalOrange == 1), 1) / oranges;
    
    masks(:,:,1) = appleMask;
    masks(:,:,2) = bananaMask;
    masks(:,:,3) = orangeMask;

    centroids = zeros(size(appleMask));
    
    for i = 1:apples
        [row, col] = find(applesLabeled == i);
        [total, ~] = size(row);
        if total > (averageAppleSize / 2)
            sumx = sum(col);
            sumy = sum(row);
            x = round(sumx / total);
            y = round(sumy / total);
            centroids(y-3:y+3, x-3:x+3, :) = 1;
        else
            apples = apples - 1;
            finalApple(applesLabeled == i) = 0;
        end
    end
    
    for i = 1:bananas
        [row, col] = find(bananasLabeled == i);
        [total, ~] = size(row);
        if total > (averageBananaSize / 2)
            sumx = sum(col);
            sumy = sum(row);
            x = round(sumx / total);
            y = round(sumy / total);
            centroids(y-3:y+3, x-3:x+3, :) = 1;
        else
            bananas = bananas - 1;
            finalBanana(bananasLabeled == i) = 0;
        end
    end
    
    for i = 1:oranges
        [row, col] = find(orangesLabeled == i);
        [total, ~] = size(row);
        if total > (averageOrangeSize / 2)
            sumx = sum(col);
            sumy = sum(row);
            x = round(sumx / total);
            y = round(sumy / total);
            centroids(y-3:y+3, x-3:x+3, :) = 1;
        else
            oranges = oranges - 1;
            finalOrange(orangesLabeled == i) = 0;
        end
    end
    
    final(:,:,1) = finalApple;
    final(:,:,2) = finalBanana;
    final(:,:,3) = finalOrange;
    
    centroids = repmat(centroids, 1, 1, 3);
    
    final(centroids == 1) = 1;
    
    imtool(masks)
    imtool(final)
    
end