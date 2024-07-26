% function minDistance = computeShortestDistanceBetweenCenters(cleanedCellMaps)
%     % cellMaps: A cell array where each cell contains a matrix
% 
%     % Number of matrices
%     numMaps = numel(cleanedCellMaps);
%     
%     % Initialize a variable to store the minimum distance
%     minDistance = inf;
% 
%     % Loop over each pair of matrices
%     for i = 1:numMaps
%         % Extract coordinates of non-zero elements in the i-th matrix
%         [row1, col1] = find(cleanedCellMaps{i} ~= 0);
%         
%         % Compute the center coordinates for cells in the i-th matrix
%         centers1 = [mean(row1), mean(col1)];
%         
%         for j = i:numMaps
%             % Skip comparing the same matrix
%             if i == j
%                 continue;
%             end
% 
%             % Extract coordinates of non-zero elements in the j-th matrix
%             [row2, col2] = find(cleanedCellMaps{j} ~= 0);
%             
%             % Compute the center coordinates for cells in the j-th matrix
%             centers2 = [mean(row2), mean(col2)];
%             
%             % Compute the Euclidean distance between the centers of the two matrices
%             distance = sqrt((centers1(1) - centers2(1))^2 + (centers1(2) - centers2(2))^2);
%             
%             % Update the minimum distance if this distance is smaller
%             if distance < minDistance
%                 minDistance = distance;
%             end
%         end
%     end
% end



function distancesCellArray = computePairwiseDistances(cleanedCellMaps)
    % cellMaps: A cell array where each cell contains a matrix
    
    % Number of matrices
    numMaps = numel(cleanedCellMaps);
    
    % Initialize a cell array to store pairwise distances
    distancesCellArray = cell(numMaps, numMaps);

    % Loop over each pair of matrices
    for i = 2:numMaps
        % Extract coordinates of non-zero elements in the i-th matrix
        [row1, col1] = find(cleanedCellMaps{i} ~= 0);
        centers1 = [row1, col1]; % Coordinates of non-zero cells in the i-th matrix
        
        for j = i:numMaps
            % Skip comparing the same matrix
            if i == j
                continue;
            end

            % Extract coordinates of non-zero elements in the j-th matrix
            [row2, col2] = find(cleanedCellMaps{j} ~= 0);
            centers2 = [row2, col2]; % Coordinates of non-zero cells in the j-th matrix
            
            % Initialize matrix to store distances between all pairs of cells
            distMatrix = zeros(size(centers1, 1), size(centers2, 1));
            
            % Compute pairwise distances between all cells
            for k = 1:size(centers1, 1)
                for l = 1:size(centers2, 1)
                    % Euclidean distance between centers of cells
                    distMatrix(k, l) = sqrt((centers1(k, 1) - centers2(l, 1))^2 + ...
                                            (centers1(k, 2) - centers2(l, 2))^2);
                end
            end
            
            % Store the distance matrix in the cell array
            distancesCellArray{i, j} = distMatrix;
            if i ~= j
                distancesCellArray{j, i} = distMatrix'; % Distance matrix is symmetric
            end
        end
    end
end




