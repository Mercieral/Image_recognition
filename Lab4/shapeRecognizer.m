function circularities = shapeRecognizer(img)

    labeledShapes = bwlabel(img, 4);
    m = max(max(labeledShapes));
    %labeledShapes2 = labeledShapes .* (255/m);
    %imshow(img, []);
    %hold on;
    
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
        eigValMin = min(values);
        eigValMax = max(values);
        elog = sqrt(eigValMax/eigValMin);
        
        disp(['elog = ' num2str(elog) ]);
        
        perimeter = bwtraceboundary(img, [max(find(labeledShapes(:,min(c)) == i)), min(c)], 'NE');
        %plot(perimeter(:,2), perimeter(:,1), 'g', 'LineWidth', 2);
        psum = 1;
        for j = 2:size(perimeter, 1)
            previous = perimeter(j-1, :);
            current = perimeter(j, :);
            if previous(1) == current (1) | previous(2) == current(2)
                psum = psum + 1;
            else
                psum = psum + sqrt(2);
            end
        end
        
        circularity = (psum ^ 2) / N;
        
        type = '';
        if circularity >= 15 & elog >= 1 & elog <= 1.5 
            type = 'Square';
        elseif circularity < 15 & elog >= 1 & elog <= 1.5
            type = 'Circle';
        elseif circularity <= 4.2336*elog + 8.2 & elog > 1.5
            type = 'Ellipses';
        else 
            type = 'Rectangle';
        end
        
        disp(['Circularity = ' num2str(circularity) ' Centroid= (' num2str(cMean) ', ' num2str(rMean) ') Shape= ' type]);
        circularities(i) = circularity;
        
        disp('-----');
    end
    
    % imtool(labeledShapes)
    
end