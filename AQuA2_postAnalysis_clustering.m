%% Display sillouette to understand data VoI = variables of interest
% https://www.mathworks.com/help/stats/cluster-analysis-example.html#d126e68480

% From the silhouette plot, when most points in all clusters have a large silhouette value,
% this indicates that those points are well-separated from neighboring clusters. 
% However, when each cluster also contains a few points with low silhouette values, 
% this indicates that they are nearby to points from other clusters.

dataVoI = combinedTable{:, [4,5]};
dataVOI_Zscore = zscore(dataVoI);

[cidx2,cmeans2] = kmeans(dataVOI_Zscore,2,'dist','sqeuclidean'); %sqeuclidean (Euclidean distance) %cos (cosine distance)
[silh2,h] = silhouette(dataVOI_Zscore,cidx2,'sqeuclidean');
h.Visible = 'on';

[cidx3,cmeans3] = kmeans(dataVOI_Zscore,3,'dist','sqeuclidean'); %sqeuclidean (Euclidean distance) %cos (cosine distance)
[silh3,h] = silhouette(dataVOI_Zscore,cidx3,'sqeuclidean');
h.Visible = 'on';

[cidxCos,cmeansCos] = kmeans(dataVOI_Zscore,2,'dist','cos'); %sqeuclidean (Euclidean distance) %cos (cosine distance)
[silhCos,h] = silhouette(dataVOI_Zscore,cidxCos,'cos');
h.Visible = 'on';

[mean(silh2) mean(silh3) mean(silhCos)];

% display a 3D plot to see where data falls into
ptsymb = {'bs','r^','md','go','c+'};
for i = 1:2
    clust = find(cidxCos==i);
    plot3(dataVOI_Zscore(clust,1),dataVOI_Zscore(clust,2),dataVOI_Zscore(clust,3),ptsymb{i});
    hold on
end
plot3(cmeans2(:,1),cmeans2(:,2),cmeans2(:,3),'ko');
plot3(cmeans2(:,1),cmeans2(:,2),cmeans2(:,3),'kx');
hold off
xlabel('Max dFF');
ylabel('Duration 10 to 10');
zlabel('dFF AUC');
view(-137,10);I
grid on

%% Cluster analysis - k-means for different variables/columns within the combinedTable
% https://www.mathworks.com/help/stats/cluster-analysis-example.html#d126e68480

%Set variables to cluster
dataVoI = combinedTable{:, [13,5]};
dataVOI_Zscore = zscore(dataVoI);

% Initialize variables
maxClusters = 10; % Maximum number of clusters to consider
silhouetteValues = zeros(1, maxClusters);

% Calculate silhouette values for different numbers of clusters
for k = 2:maxClusters
    [idx, ~] = kmeans(dataVoI, k);
    silhouetteValues(k) = mean(silhouette(dataVoI, idx));
end

% Determine the optimal number of clusters based on silhouette values
[~, optimalNumClusters] = max(silhouetteValues);

% Perform k-means clustering with the optimal number of clusters
[idx, centroids] = kmeans(dataVoI, optimalNumClusters);

% Define custom colors for clusters
numClusters = max(idx);
colors = parula(numClusters); % Choose a colormap and adjust if necessary

% % Adjust axis limits to make the plot more compact
% xlim([1, numel(dataColumn)]); % Set x-axis limits to cover all data points 
% ylim([min(dataColumn), max(dataColumn)]); % Set y-axis limits based on the range of values in dataColumn

% Convert cellID_all to a numeric array
cellID_all_numeric = cellfun(@str2double, cellID_all);

% Visualize the clustering results
figure;
scatter(dataVoI(:,1), dataVoI(:,2), 50, colors(idx, :), 'filled'); % X-axis represents data point indices
title('K-Means Clustering');
xlabel('Circularity');
ylabel('Max dFF');
colorbar; % Display colorbar to show mapping of cluster indices to colors


% Determine which values belong to which cluster
for i = 1:k
    cluster_i_indices = find(idx == i); % Indices of data points in cluster i
    disp(['Data points in cluster ', num2str(i), ': ', num2str(cluster_i_indices)]);
end


%% DTW - time series clustering for dFF

% Extract dFF data from combinedTable, converting cell array to matrix
dFF_data = cell2mat(combinedTable.dFF);

% Apply z-score normalization to the dFF data
dFF_data_zscore = zscore(dFF_data, [], 1);

% Calculate the pairwise distance matrix using Dynamic Time Warping
distance_matrix_zscore = zeros(size(dFF_data_zscore, 1));

for i = 1:size(dFF_data_zscore, 1)
    for j = i+1:size(dFF_data_zscore, 1)
        distance_matrix_zscore(i, j) = dtw(dFF_data_zscore(i, :), dFF_data_zscore(j, :));
        distance_matrix_zscore(j, i) = distance_matrix_zscore(i, j);
    end
end

%% kmeans clustering

% Perform k-means clustering with the determined number of clusters
optimal_num_clusters = 8; % Change this to the determined optimal number of clusters
[idx, centroids] = kmeans(distance_matrix_zscore, optimal_num_clusters);

disp(size(idx));
disp(min(idx));
disp(max(idx));

dFF_data_zscore_limits = [min(dFF_data_zscore(:)), max(dFF_data_zscore(:))];

% % Visualization
% figure;
% for i = 1:optimal_num_clusters
%     subplot(optimal_num_clusters, 1, i);
%     cluster_idx = find(idx == i);
%     imagesc(dFF_data_zscore(cluster_idx,:)', 'Color', rand(1,3));
%     colormap(jet);
%     caxis(dFF_data_zscore_limits);
%     title(['Cluster ', num2str(i)]);
% end

%Heatmap according to cluster
% Concatenate the time series data for all clusters
concatenated_data = [];
cluster_titles = {};
for i = 1:optimal_num_clusters
    cluster_idx = find(idx == i);
    cluster_data = dFF_data_zscore(cluster_idx, :);
    concatenated_data = [concatenated_data; cluster_data];
    cluster_titles{i} = ['Cluster ', num2str(i)];
    if i > 1
        cluster_start_positions(i) = cluster_start_positions(i-1) + size(cluster_data, 1) + 1; % Add 1 for space between clusters
    else
        cluster_start_positions(i) = 1;
    end
end

% Plot the concatenated data as a heatmap
figure;
imagesc(concatenated_data);
colormap(jet); % Use a single colormap for the entire heatmap
caxis(dFF_data_zscore_limits);
colorbar;
xlabel('Time');
ylabel('Cell');
title('dFF zScore');

% Add cluster titles at the beginning of each cluster
num_time_points = size(dFF_data_zscore, 2);
set(gca, 'XTick', 1:100:num_time_points, 'XTickLabel', 1:100:num_time_points);
set(gca, 'YTick', cluster_start_positions);
set(gca, 'YTickLabel', cluster_titles);


%% Hierarchical clustering
% https://www.mathworks.com/help/stats/cluster-analysis-example.html#d126e68637

% Perform hierarchical clustering using the distance matrix
tree = linkage(distance_matrix_zscore, 'complete'); 

% Ward's linkage minimizes the increase in variance when merging clusters. 
% It tends to produce compact, well-separated clusters and is less sensitive to noise and outliers. 
% Ward's linkage might be particularly useful for clustering calcium signaling waves if you're 
% interested in identifying distinct patterns while minimizing the impact of noise.

% Visualize the dendrogram
figure;
hDendrogram = dendrogram(tree, 0);
title('Hierarchical Clustering Dendrogram');

% Allow the user to select the height to cut the dendrogram
prompt = 'Enter the height to cut the dendrogram (press Enter to continue without cutting): ';
height = input(prompt);

% Cut the dendrogram to obtain clusters if a height is provided
if ~isempty(height)
    % Determine the clusters based on the selected height
    clusters = cluster(tree, 'cutoff', height);
    
    % Visualize the clustering results
    figure;
    dendrogram(tree, 'ColorThreshold', height); % Plot dendrogram with color threshold
    title(['Hierarchical Clustering Dendrogram (Height = ' num2str(height) ')']);
    
    % Optional: Display the number of clusters
    num_clusters = max(clusters);
    disp(['Number of clusters: ' num2str(num_clusters)]);
else
    % If no height is provided, use the full dendrogram
    clusters = cluster(tree, 'maxclust', size(tree, 1) + 1);
    
    % Optional: Display the number of clusters
    num_clusters = max(clusters);
    disp(['Number of clusters: ' num2str(num_clusters)]);
end

%% kmeans + elbow method for cluster 

% Perform hierarchical clustering using the distance matrix
tree = linkage(squareform(distance_matrix), 'average'); % 'average' linkage method

% Compute the within-cluster sum of squares for different numbers of clusters (k)
max_k = 10; % Maximum number of clusters to consider
sumd = zeros(1, max_k);
for k = 1:max_k
    [~, ~, sumd(k)] = kmeans(dFF_data_zscore, k);
end

% Plot the sum of distances for different values of k
figure;
plot(1:max_k, sumd, 'bx-');
title('Elbow Method for Optimal k');
xlabel('Number of Clusters (k)');
ylabel('Within-Cluster Sum of Squares');

% Determine the optimal number of clusters based on the elbow method
% You can use other criteria here, such as silhouette analysis
% For simplicity, let's choose the number of clusters at the "elbow point"
% Alternatively, you can use methods like the "silhouette method" to determine the optimal number of clusters

% Perform k-means clustering with the optimal number of clusters
optimal_k = 3; % Adjust based on the elbow method or other criteria
[idx, centroids] = kmeans(dFF_data_zscore, optimal_k);

% Visualize the clustered data
figure;
gscatter(dFF_data_zscore(:,1), dFF_data_zscore(:,2), idx);
hold on;
plot(centroids(:,1), centroids(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
title('K-means Clustering');
xlabel('Variable 1');
ylabel('Variable 2');
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Centroids');
hold off;


%% Classification using known groups - gscatter(x,y,g)
% https://www.mathworks.com/help/stats/classification-example.html

% Classification is a supervised learning technique that aims to categorize objects into predefined classes or labels;
% it tries to predict the output label for a given input object
% Clustering is an unsupervised learning technique that aims to group similar objects into clusters based on their characteristics; 
% it tries to discover the grouping structure in a dataset. 

% Extract the column(s) you want to plot 
dataColumn = combinedTable{:, 2:14};
dataColumnZscore = zscore(dataColumn);

f = figure;
gscatter(dataColumn(:,3), dataColumn(:,11), dataColumn(:,12), 'rgb','osd');
xlabel('Red label');
ylabel('Cell location');

%% Soft clustering
%https://www.mathworks.com/help/stats/cluster-gaussian-mixture-data-using-soft-clustering.html
