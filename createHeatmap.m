function createHeatmap(pairwiseDistances)
    % Convert cell array to numeric matrix
    numMaps = size(pairwiseDistances, 1);
    numericMatrix = NaN(numMaps);  % Initialize with NaN for empty cells
    
    for i = 1:numMaps
        for j = 1:numMaps
            if ~isempty(pairwiseDistances(i, j))
                numericMatrix(i, j) = pairwiseDistances(i, j);
            end
        end
    end
    
    % Create heatmap
    figure;
    h = heatmap(numericMatrix, 'ColorLimits', [min(numericMatrix(:)), max(numericMatrix(:))]);
    title('Pairwise Distances Heatmap');
    xlabel('Cell Map Index');
    ylabel('Cell Map Index');
    colorbar;
end

