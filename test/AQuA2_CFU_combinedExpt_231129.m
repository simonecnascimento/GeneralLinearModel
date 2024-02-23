%% Combine results for each animal

clear all;
mouse = 'Pf4Ai162-1';
treatment = 'Baseline'; %CSD
folder_path = fullfile('D:\2photon\Simone\Simone_Macrophages\', mouse, '\', 'AQuA2_Results', treatment);
files = dir(fullfile(folder_path, '*_resultsFinal.xls'));

% List the contents of the folder
contents = dir(folder_path);

% Exclude '.', '..', and 'Thumbs.db' entries, so 'contents' contains only the actual files and folders in the directory
excludeList = {'.', '..', 'Thumbs.db'};
contents = contents(~ismember({contents.name}, excludeList));

% Initialize subfolder name
subfolderName = '';

% Specify the names of the rows
featuresNames = {'Basic - Area', ...
    'Basic - Perimeter (only for 2D video)', ...
    'Basic - Circularity', 'Curve - Max Dff', ...
    'Curve - Duration 50% to 50%', ...
    'Curve - Duration 10% to 10%', ...
    'Curve - Rising duration 10% to 90%', ...
    'Curve - Decaying duration 90% to 10%', ...
    'Curve - dat AUC', 'Curve - dff AUC'};

% Create an empty table with row names and a single first column
combinedTable = table('Size', [numel(featuresNames), 0], 'VariableNames', {}, 'RowNames', featuresNames);

% Loop through each file and read data
for i = 1:length(files)
    % Read the Excel file
    currentFile = fullfile(folder_path, files(i).name);
    currentData = readtable(currentFile);

    % Extract the data from the desired column (assuming it's the first one)
    currentColumns = currentData{:, 2:end};
    
    % Generate unique variable names based on the file index
    currentColumnNames = strcat('File_', num2str(i), '_', arrayfun(@num2str, 1:size(currentColumns, 2), 'UniformOutput', false));

    % Add the columns to the combined table
    combinedTable = [combinedTable, array2table(currentColumns, 'VariableNames', currentColumnNames)];
end

% Write the combined table to a new Excel file
fileTemp = [mouse, '_AQuA2_Results_', treatment];
writetable(combinedTable,fullfile(folder_path,strcat(fileTemp,"_combinedTable")),"WriteRowNames",true,"WriteVariableNames", true, "FileType","spreadsheet");



%% Save results file for combined experiments 

% Set the output directory to save files
AQuA2_results_outputDir = fullfile('D:\2photon\Simone\Simone_Macrophages\', mouse, '\', 'AQuA2_results\');
AQuA2_CFUinfo = load(AQuA2_CFUinfo_filePath);


cd(outputDir); %change directory of current folder

D:\2photon\Simone\Simone_Macrophages\Pf4Ai162-1\AQuA2_Results
