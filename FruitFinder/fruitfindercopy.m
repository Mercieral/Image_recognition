% Aaron Mercier and Larry Gates
% CSSE463

function [apples, bananas, oranges] = fruitfindercopy(img)
    % imtool(img)
    imgHSV = rgb2hsv(img);
    imtool(imgHSV)
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
    %se = strel('square',2);
    %appleErode = imerode(appleMask, se);
    %appleErode2 = imerode(appleErode, se);
    %appleErode3 = imerode(appleErode2, se);
    %appleErode4 = imerode(appleErode3, se);
    
    
    % Closing to get holes closed
    se = strel('disk',4);
    appleClose = imclose(appleErode, se);
    
    %dilate to return apple to expected size
    se = strel('disk',3);
    appleDilate = imdilate(appleClose, se);
    
    % imtool(appleMask);
    % imtool(appleErode);
    % imtool(appleClose);
    % imtool(appleDilate);
    % newMaskCorrect = repmat(appleDilate, [1,1,3]) .* double(img);
    % imgCheckApple = uint8(newMaskCorrect);
    % imtool(imgCheckApple);
    % imtool(appleDilate);
    finalApple = appleDilate;
    
    %% Bananas
        
    yellowHue = imgHSV(:,:,1) >= 0.125 & imgHSV(:,:,1) <= 0.50;
    yellowSat = imgHSV(:,:,2) >= 0.6 & imgHSV(:,:,2) <= 0.9;
    yellowVal = imgHSV(:,:,3) >= .2;
    bananaMask(yellowHue & yellowSat & yellowVal) = 1;
    
    %imtool(bananaMask);
    
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
    %imtool(erodeBanana5)
    
    se = strel('square',3);
    closed1 = imclose(erodeBanana4, se);
    se = strel('square',16);
    closed2 = imclose(closed1, se);
    
    % expand banana to original size-ish
    se = strel('disk',4);
    dilateBanana = imdilate(closed2, se);
    
    
    %imtool(dilateBanana);
    
    %newMaskCorrect = repmat(dilateBanana, [1,1,3]) .* double(img);
    %imgCheckBanana = uint8(newMaskCorrect);
    %imtool(imgCheckBanana);
    
    
    finalBanana = dilateBanana;
    
    %% Oranges
    % Finding locations
        
    orangeColor= imgHSV(:,:,1) >= 0.0409 & imgHSV(:,:,1) < .12;
    orangeSat = imgHSV(:,:,2) >= .68;
    orangeVal = imgHSV(:,:,3) >= .53 & imgHSV(:,:,3) <= 1;
    yellowIGNORE = imgHSV(:,:,1) >=.12 & imgHSV(:,:,1) <= .15 & imgHSV(:,:,2) >=.82 & imgHSV(:,:,2) <= .95 & imgHSV(:,:,3) >=.5 &imgHSV(:,:,3) <=.7;
    
    orangeMask((orangeColor) & orangeSat & orangeVal & ~finalBanana) = 1;
    
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
    
    % Opening to get rid of extra extra noise
    se = strel('disk',1);
    orangeOpen = imopen(orangeClose, se);
    
    se = strel('disk',2);
    orangeDilate = imdilate(orangeOpen, se);
    
%     newMaskCorrect = repmat(orangeDilate, [1,1,3]) .* double(img);
%     imgCheckOrange = uint8(newMaskCorrect);
%     imtool(rgb2hsv(imgCheckOrange));
%     imtool(imgCheckOrange);
    
    finalOranges = orangeDilate;
    
    
    %% End results
    applesLabeled = bwlabel(finalApple);
    bananasLabeled = bwlabel(finalBanana);
    orangesLabeled = bwlabel(finalOranges);
    
    apples = max(max(applesLabeled));
    bananas = max(max(bananasLabeled));
    oranges = max(max(orangesLabeled));
    
    masks(:,:,1) = appleMask;
    masks(:,:,2) = bananaMask;
    masks(:,:,3) = orangeMask;

    final(:,:,1) = finalApple;
    final(:,:,2) = finalBanana;
    final(:,:,3) = finalOranges;
    
    for i = 1:apples
        [row, col] = find(applesLabeled == i);
        [total, ~] = size(row);
        sumx = sum(col);
        sumy = sum(row);
        x = round(sumx / total);
        y = round(sumy / total);
        final(y-2:y+2, x-2:x+2, :) = 1;
    end
    
    for i = 1:bananas
        [row, col] = find(bananasLabeled == i);
        [total, ~] = size(row);
        sumx = sum(col);
        sumy = sum(row);
        x = round(sumx / total);
        y = round(sumy / total);
        final(y-2:y+2, x-2:x+2, :) = 1;
    end
    
    for i = 1:oranges
        [row, col] = find(orangesLabeled == i);
        [total, ~] = size(row);
        sumx = sum(col);
        sumy = sum(row);
        x = round(sumx / total);
        y = round(sumy / total);
        final(y-2:y+2, x-2:x+2, :) = 1;
    end
    
    imtool(masks)
    imtool(final)
    
end