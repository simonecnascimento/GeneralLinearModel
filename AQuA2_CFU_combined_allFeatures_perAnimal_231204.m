%% Combine results for each animal

clear all;

% Info to be populated by the user
mouse = 'Pf4Ai162-1';
treatment = 'Baseline'; %CSD

% Retrieve excel files of specific mouse
folder_path = fullfile('D:\2photon\Simone\Simone_Macrophages\', mouse, '\', 'AQuA2_Results', treatment);
files = dir(fullfile(folder_path, '*_resultsFinal.xls'));

% List the contents/files of the folder
contents = dir(folder_path);

% Exclude '.', '..', and 'Thumbs.db' entries, so 'contents' contains only the actual files and folders in the directory
excludeList = {'.', '..', 'Thumbs.db'};
contents = contents(~ismember({contents.name}, excludeList));

% Specify the names of the features that will be the rows of final table
featuresNames = {'Area', ...
    'Perimeter', ...
    'Circularity', ...
    'Curve - Max Dff', ...
    'Curve - Duration 50% to 50%', ...
    'Curve - Duration 10% to 10%', ...
    'Curve - Rising duration 10% to 90%', ...
    'Curve - Decaying duration 90% to 10%', ...
    'Curve - dat AUC', ...
    'Curve - dff AUC'};

% Create an empty table with just features as rows, leaving columns empty that will be populated later
combinedCellsTable = table('Size', [numel(featuresNames), 0], 'VariableNames', {}, 'RowNames', featuresNames);

% Loop through each excel file, read data and populate table(combinedCellsTable)
for i = 1:length(files)
    % Read the Excel file
    currentFile = fullfile(folder_path, files(i).name);
    currentData = readtable(currentFile);

    % Extract the information of currentData, excluding 1st row which has the name of the features
    currentColumns = currentData{:, 2:end};
    
    % Generate unique variable names based on the file index (FileX_CellX)
    currentColumnNames = strcat('File', num2str(i), '_', 'Cell', arrayfun(@num2str, 1:size(currentColumns, 2), 'UniformOutput', false));

    % Add the values of all columns to the combined table
    combinedCellsTable = [combinedCellsTable, array2table(currentColumns, 'VariableNames', currentColumnNames)];
end

% Save the combinedCellTable
fileTemp = [mouse, '_AQuA2_Results_', treatment];
writetable(combinedCellsTable,fullfile(folder_path,strcat(fileTemp,"_combinedCellTable")),"WriteRowNames",true,"WriteVariableNames", true, "FileType","spreadsheet");

% Specify the number of rows and columns in the combined table
[numRows, numCols] = size(combinedCellsTable);
xPositions = 1:numCols;


%% Create scatterplots for each feature
% Iterate over each row of combinedTable (feature)
for feature = 1:(numRows - 2)
    % Extract values from the current row
    rowData = combinedTable{feature, :};

    currentFeature = featuresNames{1, feature};

    % Detect outliers using the 'isoutlier' function
    isOutlier = isoutlier(rowData);

    % Calculate mean
    meanValue = mean(rowData);
    roundedMean = round(meanValue, 2);

    % Create a scatter plot
    figure;
    scatter(xPositions, rowData, 'o', 'filled');
    hold on;

    % Detect outliers and highlight them
    isOutlier = isoutlier(rowData);
    xOutliers = xPositions(isOutlier);
    scatter(xOutliers, rowData(isOutlier), 'p', 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');

    % Check if cell is perivascular highlight with a star --- TEST LATER
    if combinedTable{end, feature} == 1
        scatter(xPositions(end), rowData(end), 's', 'filled', 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g');
    end

    % Plot labels and title
    xlabel('Cell');
    ylabel(featuresNames{feature});
    title(['Mean = ', num2str(roundedMean)]);

    % Optionally, save the figure
    saveas(gcf, ['Scatterplot_' currentFeature '.png']);
end