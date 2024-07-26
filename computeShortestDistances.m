function minDistance = computeShortestDistance(cellMaps)
    % cellMaps: A cell array where each cell contains a matrix

    % Number of matrices
    numMaps = numel(cellMaps);
    
    % Initialize a variable to store the minimum distance
    minDistance = inf;

    % Loop over each pair of matrices
    for map = 1:numMaps
        % Extract coordinates of non-zero elements in the i-th matrix
        [row1, col1] = find(cellMaps{map} ~= 0);
        
        for j = map:numMaps
            % Skip comparing the same matrix
            if map == j
                continue;
            end

            % Extract coordinates of non-zero elements in the j-th matrix
            [row2, col2] = find(cellMaps{j} ~= 0);

            % Initialize the distance matrix for this pair
            numCells1 = numel(row1);
            numCells2 = numel(row2);
            distMatrix = zeros(numCells1, numCells2);
            
            % Compute pairwise distances
            for k = 1:numCells1
                for l = 1:numCells2
                    % Euclidean distance
                    distMatrix(k, l) = sqrt((row1(k) - row2(l))^2 + (col1(k) - col2(l))^2);
                end
            end
            
            % Find the minimum distance in this distance matrix
            currentMinDistance = min(distMatrix(:));
            
            % Update the global minimum distance
            if currentMinDistance < minDistance
                minDistance = currentMinDistance;
            end
        end
    end
end