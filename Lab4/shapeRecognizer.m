function circularities = shapeRecognizer(img)

    labeledShapes = bwlabel(img, 4);
    m = max(max(labeledShapes));
    %labeledShapes2 = labeledShapes .* (255/m);
    
    for i = 1:m
        disp('-----');
        disp(['Shape ' num2str(i)]);
        [r, c] = find(labeledShapes == i);
        [N, ~] = size(r);
        cMean = mean(c);
        rMean = mean(r);
        
        cNorm = c - cMean;
        rNorm = r - rMean;
        
        cNormSquared = cNorm .^ 2;
        rNormSquared = rNorm .^ 2;
        crNorm = cNorm .* rNorm;
        
        cSumSquared = sum(cNormSquared);
        rSumSquared = sum(rNormSquared);
        crSum = sum(crNorm);
        
        
        m(1,1) = cSumSquared / N; 
        m(1,2) = crSum / N;
        m(2,1) = crSum / N;
        m(2,2) = rSumSquared/ N;
        
        values = eig(m);
        % disp('-----');
        % disp('Centroid Location');
        % disp(['(' num2str(cMean) ', ' num2str(rMean) ')']);
        % disp('-----');
        eigValMin = min(values);
        eigValMax = max(values);
        elog = sqrt(eigValMax/eigValMin);
        
        disp(['elog = ' num2str(elog) ]);
        disp('-----');
        
        

%         sumx = sum(col);
%         sumy = sum(row);
%         xbar = round(sumx / total);
%         ybar = round(sumy / total);
%         strcat(int2str(i), {' '}, '(', int2str(ybar), {', '}, int2str(xbar), {'), '})
%         labeledShapes(ybar-3:ybar+3, xbar-3:xbar+3) = 0; 
    end
    
    % imtool(labeledShapes)
    
    circularities = 0;
end