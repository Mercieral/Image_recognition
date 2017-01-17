function rocGenerator(truePos, falsePos)

    figure;
    hold on;
    plot(falsePos, truePos, 'b-', 'LineWidth', 2);
    plot(falsePos, truePos, 'bo', 'MarkerSize', 6, 'LineWidth', 2);
    
    % You could repeat here with a different color/style if you made 
    % an enhancement and wanted to show that it outperformed the baseline.

    title('Performance of Detector X', 'fontSize', 18);
    xlabel('False Positive Rate', 'fontWeight', 'bold');
    ylabel('True Positive Rate', 'fontWeight', 'bold');
    axis([0 1 0 1]);

end

