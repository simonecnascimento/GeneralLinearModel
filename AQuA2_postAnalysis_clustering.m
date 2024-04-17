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

%% Circularity Perivascular x Non-Perivascular

% Extract data from the table
dataVoI = combinedTable{:, [13,4]};
cellLocation = dataVoI(:,1);
circularity = dataVoI(:,2);

% Convert numeric group labels to strings
group_str = cell(size(cellLocation));
group_str(cellLocation == 0) = {'Perivascular'};
group_str(cellLocation == 2) = {'NonPerivascular'};

% Separate data points belonging to each group
group_0_indices = (cellLocation == 0); % Indices of cells belonging to group 0
group_2_indices = (cellLocation == 2); % Indices of cells belonging to group 2

data_group_0 = circularity(group_0_indices); % Data points belonging to group 0
data_group_2 = circularity(group_2_indices); % Data points belonging to group 2

% Add jitter to y-values
jitter_amount = 0.3; % Adjust the amount of jitter as needed
jitter_0 = (rand(sum(group_0_indices), 1) - 0.5) * jitter_amount;
jitter_2 = (rand(sum(group_2_indices), 1) - 0.5) * jitter_amount;

% Plot scatterplot with jitter
figure;
scatter(repmat(0, sum(group_0_indices), 1) + jitter_0, data_group_0, 'bo'); hold on;
scatter(repmat(1, sum(group_2_indices), 1) + jitter_2, data_group_2, 'ro'); 

% Calculate mean of each group
mean_group_0 = mean(data_group_0);
mean_group_2 = mean(data_group_2);

% Plot means
plot(0, mean_group_0, 'bx', 'MarkerSize', 20, 'LineWidth', 2);
plot(1, mean_group_2, 'rx', 'MarkerSize', 20, 'LineWidth', 2);

% Customize plot
ylabel('RedLabel');
xticks([0 1]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('Circularity Perivascular x NonPerivascular');
% Increase y-axis range
ylim([0, 0.6]);

% Perform t-test
[h, p_value] = ttest2(data_group_0, data_group_2);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(p_value)]);

% Add p-value to the graph
text(0.5, 0.5, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');


%% RedLabel Perivascular x NonPerivascular

%Set variables to cluster
dataVoI = combinedTable{:, [13,14]};

cellLocation = dataVoI(:,1);
redLabel = dataVoI(:,2);

% Count perivascular cells labeled with red and those not labeled with red
perivascular_red = sum(cellLocation == 0 & redLabel == 1);
perivascular_not_red = sum(cellLocation == 0 & redLabel == 0);
non_perivascular_red = sum(cellLocation == 2 & redLabel == 1);
non_perivascular_not_red = sum(cellLocation == 2 & redLabel == 0);

% Create grouped bar chart with custom colors
figure;
bar_data = [perivascular_red, perivascular_not_red; non_perivascular_red, non_perivascular_not_red];
bar_handle = bar(bar_data, 'grouped');

% Set custom colors
set(bar_handle(1), 'FaceColor', 'red');
set(bar_handle(2), 'FaceColor', 'green');

% Customize plot
ylabel('Number of Cells');
xticklabels({'Perivascular', 'Non-Perivascular'}); % Adjusted position for clarity
legend({'Red Label', 'No Red Label'}, 'Location', 'best');
title('Presence of red dextran by cell location');
ylim([0, 350]);

% % Add text annotations above each bar
% for i = 1:size(bar_data, 1)
%     for j = 1:size(bar_data, 2)
%         x_coord = j + (i - 1) * (size(y_values, 2) + 1);
%         text(x_coord, bar_data(i, j), num2str(bar_data(i, j)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
%     end
% end


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

%% Correlation matrix of variables

% Compute correlation coefficient matrix
corr_matrix = corrcoef(dataAll);

% Create heatmap
heatmap(corr_matrix, 'Colormap', 'jet', 'ColorbarVisible', 'on');

% Add title and axis labels
title('Correlation Coefficient Heatmap');
xlabel('Variables');
ylabel('Variables');

% Extract upper triangular part of the matrix
lower_triangle = tril(corr_matrix, 1); % 1 indicates the main diagonal is not included

% Plot heatmap
figure;
imagesc(corr_matrix);
colormap(jet);
colorbar;
title('Correlation Coefficient of Variables');
xlabel('Variables');
ylabel('Variables');

% X and Y labels
variable_names = combinedTable.Properties.VariableNames(2:11);
xticks(1:length(variable_names)); xticklabels(variable_names); xtickangle(60); 
yticks(1:length(variable_names)); yticklabels(variable_names); ytickangle(0);

% Add text annotations to each cell
[num_rows, num_cols] = size(corr_matrix);
for i = 1:num_rows
    for j = 1:num_cols
        text(j, i, sprintf('%.1f', corr_matrix(i,j)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 12);
    end
end

%% PCA

%Dimensionality Reduction: dataset is too complex
[coeff, score, ~, ~, explained] = pca(dataAll);

%iteractive mapping
mapcaplot(dataAll, cellID_all);

%% Loadings Matrix - Loadings - correlation between the original variables and the principal components
%The loadings are stored as a matrix where each column represents a principal component and each row represents a variable.
% A high loading value (close to 1 or -1) indicates a strong association between the variable and the component. 
% Positive loadings indicate positive association, while negative loadings indicate negative association

% Access loadings
loadings = coeff;

% Display variable names and their associations with components
disp('Loadings (Association between Variables and Components):');
disp(loadings);

for i = 1:length(variable_names)
    disp(['Variable: ', variable_names{i}]);
    disp(['Component 1: ', num2str(coeff(i, 1))]);
    disp(['Component 2: ', num2str(coeff(i, 2))]);
    disp(['Component 3: ', num2str(coeff(i, 3))]);
    disp(['Component 4: ', num2str(coeff(i, 4))]);
    disp(['Component 5: ', num2str(coeff(i, 5))]);
    disp(['Component 6: ', num2str(coeff(i, 6))]);
    disp(['Component 7: ', num2str(coeff(i, 7))]);
    disp(['Component 8: ', num2str(coeff(i, 8))]);
    disp(['Component 9: ', num2str(coeff(i, 9))]);
    disp(['Component 10: ', num2str(coeff(i, 10))]);
    % Repeat for additional components as needed
    disp(' ');
end

% Create a table to store the associations
variables = cell2table(variable_names);

% Add variable names and their associations with components to the table
for i = 1:size(variables,2)
    var_name = variables{1,i};
    associations = coeff(i, :);
    component_numbers = (1:numel(associations))';
    row = table(var_name, associations(1:10)); % Adjust based on the number of components
    loadings = [loadings; row];
end

% Plot the covariance matrix using a heatmap
figure;
imagesc(loadings);
colorbar;
xlabel('Principal Component');
ylabel('Variable');
title('Principal Component Coefficients');
caxis([-1, 1]); % Example: Set color scale to range from -1 to 1

% Add text annotations to each cell
[num_rows, num_cols] = size(loadings);
for i = 1:num_rows
    for j = 1:num_cols
        text(j, i, sprintf('%.1f', loadings(i,j)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 12);
    end
end

%Index of Principal Components
pc_names = [{'PC1'}, {'PC2'}, {'PC3'}, {'PC4'}, {'PC5'}, {'PC6'}, {'PC7'}, {'PC8'}, {'PC9'}, {'PC10'}];

% X and Y labels
xticks(1:length(pc_names)); xticklabels(pc_names); xtickangle(0); 
yticks(1:length(variable_names)); yticklabels(variable_names); ytickangle(0);

% Adjust x-axis tick label font size
fontSize = 8; % Adjust as needed
set(gca, 'FontSize', fontSize); % Set font size for x-axis tick labels

%% PLOT - Covariance matrix of PCA data
%Helps to visualize how strong the dependency of two features is with each other in the feature space.

% Compute the covariance matrix of the principal components
covariance_matrix = cov(score);

% Plot the covariance matrix using a heatmap
figure;
imagesc(covariance_matrix);
colorbar;
xlabel('Principal Component Index');
ylabel('Principal Component Index');
title('Covariance Matrix of PCA-transformed Data');
caxis([-1, 1]); % Example: Set color scale to range from -1 to 1

% Add text annotations to each cell
[num_rows, num_cols] = size(covariance_matrix);
for i = 1:num_rows
    for j = 1:num_cols
        text(j, i, sprintf('%.1f', covariance_matrix(i,j)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 12);
    end
end

% Adjust colormap
colormap('gray'); % Change the colormap to parula (or any other colormap of your choice)

% X and Y labels
variable_names = combinedTable.Properties.VariableNames(2:11);
xticks(1:length(variable_names)); xticklabels(variable_names); xtickangle(60); 
yticks(1:length(variable_names)); yticklabels(variable_names); ytickangle(0);

% Adjust x-axis tick label font size
fontSize = 8; % Adjust as needed
set(gca, 'FontSize', fontSize); % Set font size for x-axis tick labels
