function rocGenerator(lineColor, pointColor, truePos, falsePos, titleIn)
    plot(falsePos, truePos, lineColor, 'LineWidth', 2);
    plot(falsePos, truePos, pointColor, 'MarkerSize', 6, 'LineWidth', 2);
    
    % You could repeat here with a different color/style if you made 
    % an enhancement and wanted to show that it outperformed the baseline.

    title(titleIn, 'fontSize', 18);
    xlabel('False Positive Rate', 'fontWeight', 'bold');
    ylabel('True Positive Rate', 'fontWeight', 'bold');
    axis([0 1 0 1]);

end

