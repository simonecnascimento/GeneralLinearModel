function distMatrix = computePairwiseCenterDistances(cleanedCellMaps)
    % cellMaps: A cell array where each cell contains a matrix with cells (non-zero elements)
    
    % Number of matrices
    numMaps = numel(cleanedCellMaps);
    
    % Initialize a matrix to store pairwise distances
    distMatrix = NaN(numMaps, numMaps); % Use NaN to indicate no self-comparison
    
    % Loop over each pair of matrices
    for i = 1:numMaps
        % Extract coordinates of non-zero elements in the i-th matrix
        [rows1, cols1] = find(cleanedCellMaps{i} ~= 0);
        
        % Compute the center coordinates for cells in the i-th matrix
        centers1 = [mean(rows1), mean(cols1)];
        
        for j = 1:numMaps
            % Skip comparing the same matrix
            if i == j
                continue;
            end

            % Extract coordinates of non-zero elements in the j-th matrix
            [rows2, cols2] = find(cleanedCellMaps{j} ~= 0);
            
            % Compute the center coordinates for cells in the j-th matrix
            centers2 = [mean(rows2), mean(cols2)];
            
            % Compute the Euclidean distance between the centers of the two matrices
            distance = sqrt((centers1(1) - centers2(1))^2 + (centers1(2) - centers2(2))^2);
            
            % Store the distance in the matrix
            distMatrix(i, j) = distance;
        end
    end
end
