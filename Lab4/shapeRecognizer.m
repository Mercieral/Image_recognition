function circularities = shapeRecognizer(img)

    labeledShapes = bwlabel(img, 4);
    m = max(max(labeledShapes));
    %imshow(img, []);
    %hold on;
    circularities = zeros(1,m);
    
    for i = 1:m       
        %% Calculate the 4 entries to the covariance matrix using formula
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
        
        %% Determine the maximum and minimum eigenvalues to determine elongation
        values = eig(m);
        eigValMin = min(values);
        eigValMax = max(values);
        elog = sqrt(eigValMax/eigValMin);
        
        %% Trace the perimter and find the length 
        perimeter = bwtraceboundary(img, [max(find(labeledShapes(:,min(c)) == i)), min(c)], 'NE');
        %plot(perimeter(:,2), perimeter(:,1), 'r', 'LineWidth', 2);
        psum = 1;
        for j = 2:size(perimeter, 1)
            previous = perimeter(j-1, :);
            current = perimeter(j, :);
            if previous(1) == current (1) || previous(2) == current(2)
                psum = psum + 1;
            else
                psum = psum + sqrt(2);
            end
        end
        
        %% Determine circularity using |P|^2/N
        circularity = (psum ^ 2) / N;
        
        
        %% Determine shape using simple thresholds
        type = ''; %#ok<NASGU>
        if circularity >= 15 && elog >= 1 && elog <= 1.5 
            type = 'Square';
        elseif circularity < 15 && elog >= 1 && elog <= 1.5
            type = 'Circle';
        elseif circularity <= 4.2336*elog + 8.2 && elog > 1.5
            type = 'Ellipses';
        else 
            type = 'Rectangle';
        end
        
        %% Display Results
        disp('-----');
        disp(['Shape ' num2str(i)]);
        disp(['Circularity = ' num2str(circularity) ' elog = ' num2str(elog) ' Centroid= (' num2str(cMean) ', ' num2str(rMean) ') Shape= ' type]);
        
        %% Add circularity to return matrix of all circularities
        circularities(i) = circularity;
    end    
end