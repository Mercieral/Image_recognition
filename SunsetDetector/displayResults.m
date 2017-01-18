function displayResults( expResults )
%DISPLAYRESULTS = Put the results of the given experiment results in a
%nicely printed out table

    %%% Making row labels
    for i=1:size(expResults,1)
        row{i} = ['ROW ' num2str(i)];  %#ok<AGROW>
    end

    row_labels = reshape(row, 1, length(row));
    rows = strrep(row_labels, ' ', '_');
    r_out = [];
    for n = 1:length(rows)
        r_out = [r_out, rows{n}, ' ']; %#ok<AGROW>
    end 
    r_out = r_out(1:end-1);

    printmat(expResults, 'Experiment Results', r_out, 'Sigma C TrueNeg TruePos FalsePos FalseNeg Acc TPR Prec. FPR SV')

end

