%%  t-SNE (t-distributed Stochastic Neighbor Embedding)

%Event-based features (area, perimeter, circularity, 
eventBased_features = combinedTable{:, [2,3,4,7]};
eventBased_features_zScore = zscore(eventBased_features);
rng(123); % Set a fixed random seed or set 
tSNE = tsne(eventBased_features_zScore, "Perplexity",20);
scatter(tSNE(:,1), tSNE(:,2));

%% kmeans clustering
numClusters = 2; % Specify the number of clusters
[idx, centroids] = kmeans(tSNE, numClusters);
gscatter(tSNE(:,1), tSNE(:,2), idx);

%% Extract the coordinates of the t-SNE plot

% Extract x and y coordinates
x_coords = tSNE(:, 1);
y_coords = tSNE(:, 2);

% Plot t-SNE
scatter(x_coords, y_coords);
xlabel('t-SNE Dimension 1');
ylabel('t-SNE Dimension 2');
title('t-SNE Plot');

% Match points with table entries (replace this with your own table)
% Assuming your table is named 'dataTable' and contains the original data points
% Note: This is just a conceptual example and might require adjustments based on your actual data structure
for i = 1:size(tSNE, 1)
    % Find the corresponding entry in the table for each point
    % For example, you might compare the coordinates to find the closest match
    % Here, we're just printing the coordinates
    fprintf('Point %d: x = %f, y = %f\n', i, tSNE(i, 1), tSNE(i, 2));
end
