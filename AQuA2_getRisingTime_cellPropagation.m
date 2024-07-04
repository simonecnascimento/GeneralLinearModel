% i = event number
for i = 1:numel(res.evtFavList1)
    imagesc(res.riseLst1{1, i}.dlyMap50)
    
    %propagation matrix
    matrix = res.riseLst1{1, i}.dlyMap50;

    % Find the maximum value
    maxValue = max(matrix(:));
    % Find all positions of the maximum value
    [maxRows, maxCols] = find(matrix == maxValue);
    
    % Find the minimum value
    minValue = min(matrix(:));
    % Find all positions of the minimum value
    [minRows, minCols] = find(matrix == minValue);
    
    % Display the results for maximum value
    disp(['Maximum value: ', num2str(maxValue)]);
    disp('Positions of max value:');
    for j = 1:length(maxRows)
        disp(['(', num2str(maxRows(j)), ', ', num2str(maxCols(j)), ')']);
    end
    
    % Display the results for minimum value
    disp(['Minimum value: ', num2str(minValue)]);
    disp('Positions of min value:');
    for j = 1:length(minRows)
        disp(['(', num2str(minRows(j)), ', ', num2str(minCols(j)), ')']);
    end

end

