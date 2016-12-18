function circularities = shapeRecognizer(img)

    labeledShapes = bwlabel(img, 4);
    m = max(max(labeledShapes));
    labeledShapes2 = labeledShapes .* (255/m);
    
    for i = 1:m
        [row, col] = find(labeledShapes == i);
        [total, ~] = size(row);
        sumx = sum(col);
        sumy = sum(row);
        xbar = round(sumx / total);
        ybar = round(sumy / total);
        strcat(int2str(i), {' '}, '(', int2str(ybar), {', '}, int2str(xbar), {'), '})
        labeledShapes(ybar-3:ybar+3, xbar-3:xbar+3) = 0; 
    end
    
    imtool(labeledShapes)
    
    circularities = 0;
end