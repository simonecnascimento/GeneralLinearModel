% Initialize the matrix to store scores
[numCells, ~] = size(simultaneousMatrixDelaybyCell); % Assuming square matrix
scoreMatrix = nan(numCells, numCells); % NaN for cells with no delays

for cell1 = 1:numCells
    for cell2 = 1:numCells
        % Extract data from the current cell
        data = simultaneousMatrixDelaybyCell{cell1, cell2};
        
        if ~isempty(data)
            % Remove zeros if they exist
            nonZeroData = data(data ~= 0);
            
            if ~isempty(nonZeroData)
                % Calculate the score as sum/delay count
                scoreMatrix(cell1, cell2) = sum(nonZeroData) / numel(nonZeroData);
            end
        end
    end
end

% Replace NaN with Inf for visualization (optional, based on use case)
scoreMatrix(isnan(scoreMatrix)) = Inf;

figure;
heatmap(scoreMatrix, 'Colormap', jet, 'MissingDataColor', [0.8 0.8 0.8]);
colorbar;
title('Cell Pair Synchronization Scores');
xlabel('Cell 2');
ylabel('Cell 1');

% Find the best pair (minimum score)
[minScore, linearIdx] = min(scoreMatrix(:));
[cell1, cell2] = ind2sub(size(scoreMatrix), linearIdx);

fprintf('Best synchronized pair: Cell %d and Cell %d with score %.2f\n', cell1, cell2, minScore);

