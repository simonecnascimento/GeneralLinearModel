%% PCA

%Dimensionality Reduction: dataset is too complex
[coeff, score, latent, ~, explained] = pca(dataAll);

% %iteractive mapping
% mapcaplot(dataAll, cellID_all);

%% Correlation matrix of variables

% Compute correlation coefficient matrix
corr_matrix = corrcoef(dataAll);

% Create heatmap
heatmap(corr_matrix, 'Colormap', jet(256), 'ColorbarVisible', 'on');

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
variable_names = combinedTable.Properties.VariableNames(2:14);
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

%% Calculate Eigenvalues

% Compute eigenvalues
eigenvalues = eig(corr_matrix);

% Check if all eigenvalues are roughly of similar magnitude
if std(eigenvalues) < threshold
    disp('Data appears to be linear.');
else
    disp('Data may exhibit non-linear relationships.');
end


%% Coefficienct (loading) Matrix - Loadings - correlation between the original variables and the principal components
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
    disp(['Component 11: ', num2str(coeff(i, 11))]);
    disp(['Component 12: ', num2str(coeff(i, 12))]);
    disp(['Component 13: ', num2str(coeff(i, 13))]);
    % Repeat for additional components as needed
    disp(' ');
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
pc_names = [{'PC1'}, {'PC2'}, {'PC3'}, {'PC4'}, {'PC5'}, {'PC6'}, {'PC7'}, {'PC8'}, {'PC9'}, {'PC10'}, {'PC11'},{'PC12'},{'PC13'}];

% X and Y labels
xticks(1:length(pc_names)); xticklabels(pc_names); xtickangle(0); 
yticks(1:length(variable_names)); yticklabels(variable_names); ytickangle(0);

% Adjust x-axis tick label font size
fontSize = 8; % Adjust as needed
set(gca, 'FontSize', fontSize); % Set font size for x-axis tick labels


%% Cumulative explained variance
% proportion of the total variance explained by each principal component, sorted in descending order. 
% By looking at the plot, one can identify the number of principal components that capture a significant amount of variation.

% Calculate cumulative explained variance
cumulative_explained = cumsum(explained);

% Plot cumulative explained variance
figure;
plot(1:length(cumulative_explained), cumulative_explained, 'o-');
xlabel('Number of Principal Components');
ylabel('Cumulative Explained Variance (%)');
title('Cumulative Explained Variance Plot');
grid on;

%% Plot eigenvalues
figure;
bar(1:length(latent), latent);
xlabel('Principal Component');
ylabel('Eigenvalue');
title('PCA Eigenvalues');
grid on;

%% PLOT - Covariance matrix of PCA data (?)
% Helps to visualize how strong the dependency of two features is with each other in the feature space.
% 
% Compute the covariance matrix of the principal components
% covariance_matrix = cov(score);
% 
% Plot the covariance matrix using a heatmap
% figure;
% imagesc(covariance_matrix);
% colorbar;
% xlabel('Principal Component Index');
% ylabel('Principal Component Index');
% title('Covariance Matrix of PCA-transformed Data');
% caxis([-1, 1]); % Example: Set color scale to range from -1 to 1
% 
% Add text annotations to each cell
% [num_rows, num_cols] = size(covariance_matrix);
% for i = 1:num_rows
%     for j = 1:num_cols
%         text(j, i, sprintf('%.1f', covariance_matrix(i,j)), ...
%             'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 12);
%     end
% end
% 
% Adjust colormap
% colormap('gray'); % Change the colormap to parula (or any other colormap of your choice)
% 
% X and Y labels
% variable_names = combinedTable.Properties.VariableNames(2:11);
% xticks(1:length(variable_names)); xticklabels(variable_names); xtickangle(60); 
% yticks(1:length(variable_names)); yticklabels(variable_names); ytickangle(0);
% 
% Adjust x-axis tick label font size
% fontSize = 8; % Adjust as needed
% set(gca, 'FontSize', fontSize); % Set font size for x-axis tick labels