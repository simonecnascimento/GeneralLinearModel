function [networkData, newTempMap] = propagationCellMap(networkData, currentEvent, a)
    
    % Function to process event network and propagate event data

    % Cell Map
    tempMap = networkData.cellMap_all{currentEvent}{a};
    nonZeroMask = tempMap > 0;
    countTempMap = nnz(tempMap);
    imshow(nonZeroMask);

    % Event Propagation
    tempPropagation = networkData.propagationMap_all{currentEvent}{a};
    countTempPropagation = nnz(~isnan(tempPropagation));

    % Get the linear indices of non-zero elements in tempMap
    nonZeroIndicesTempMap = find(tempMap ~= 0);

    % Get the linear indices of non-NaN elements in tempPropagation
    nonNaNIndicesTempPropagation = find(~isnan(tempPropagation));

    % Ensure both have the same number of elements
    if length(nonZeroIndicesTempMap) ~= length(nonNaNIndicesTempPropagation)
        error('The number of non-zero elements in temp must equal the number of non-NaN elements in matrix.');
    end

    % Create a new variable to hold the result
    newTempMap = tempMap;

    % Insert the values from matrix tempPropagation into the newTempMap at the corresponding positions
    newTempMap(nonZeroIndicesTempMap) = tempPropagation(nonNaNIndicesTempPropagation);

    % Replace all zeros with NaN in newTempMap
    newTempMap(newTempMap == 0) = NaN;

    % Substitute networkData table
    networkData.eventNetwork_cellMap_all{currentEvent}{end+1} = newTempMap;

    % Plot image of eventNetwork_cellMap_all
    imagesc(newTempMap);
    matrixTemp = newTempMap;

    % Find the maximum value
    maxValue = max(matrixTemp(:));
    % Find all positions of the maximum value
    [maxRows, maxCols] = find(matrixTemp == maxValue);

    % Find the minimum value
    minValue = min(matrixTemp(:));
    % Find all positions of the minimum value
    [minRows, minCols] = find(matrixTemp == minValue);

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
