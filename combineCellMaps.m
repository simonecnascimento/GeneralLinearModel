function [networkData, combinedMatrix, pairwiseDistances] = combineCellMaps(networkData, currentEvent)
    % Function to combine cell maps, remove duplicates, and compute pairwise distances

    % Extract cell numbers and cell maps
    cellNumbers = num2cell(networkData{currentEvent, 'cellNumber_all'}{1}); % Assuming cellNumber_all is a cell array
    cellMaps = networkData{currentEvent, 'cellMap_all'}{1}; % cellMap_all might already be a cell array

    if iscell(cellNumbers)
        % Flatten the cell array and find unique numbers
        cellNumbers = [cellNumbers{:}];
    end

    % Remove duplicates in cellNumbers
    [uniqueCellNumbers, ia] = unique(cellNumbers, 'stable');

    % Extract corresponding cellMaps for unique cellNumbers
    cleanedCellMaps = cellMaps(ia);

    % Update the cleaned table with unique cell numbers and cleaned cell maps
    networkData{currentEvent, 'cellNumber_all_unique'} = {uniqueCellNumbers};
    networkData{currentEvent, 'cellMap_all_unique'}{:} = cleanedCellMaps;

    % Initialize the combined matrix with zeros
    combinedMatrix = zeros(size(cleanedCellMaps{1}));

    % Loop over each cellMap and combine non-zero values
    for k = 1:numel(cleanedCellMaps)
        currentCellMap = cleanedCellMaps{k};
        % Create binary mask for non-zero elements
        currentMask = currentCellMap ~= 0;

        % Combine non-zero values into the combinedMatrix
        combinedMatrix(currentMask) = currentCellMap(currentMask);
    end
    
%     figure;
%     imshow(combinedMatrix, []); % Display the combined matrix
%     title('Combined Non-Zero Values from All Cell Maps');

    % Store the combined matrix in networkData
    networkData.eventNetwork_cellMap_all{currentEvent} = combinedMatrix;

    % Compute the shortest distance between centers
    pairwiseDistances = computePairwiseCenterDistances(cleanedCellMaps);
    networkData.shortestDistanceBetweenCenters{currentEvent} = pairwiseDistances;

    % Optionally create a heatmap of the distance matrix (commented out here)
    % createHeatmap(pairwiseDistances);

end
