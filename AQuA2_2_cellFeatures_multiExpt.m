%% Load .mat files  (FULL CRANIOTOMY BASELINE)

% Change you Current Folder
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\baseline\1._analysis.mat;

% Initialize an empty table
combinedTable = table();

% List of filenames per animal - fullCraniotomy

filesNamesAll = {
    'Pf4Ai162-2_221130_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-2_221130_FOV6_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-10_230628_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-10_230628_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-10_230628_FOV3_run1_reg_Z01_green_Substack(1-927)_analysis.mat',... 
    'Pf4Ai162-10_230628_FOV4_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-10_230628_FOV5_run1_reg_Z01_green_Substack(1-927)_analysis.mat',... 
    'Pf4Ai162-10_230628_FOV7_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-10_230628_FOV8_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV3_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV4_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV5_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV6_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV8_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV9_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV3_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV4_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV5_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV6_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV7_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV8_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV9_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV10_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV3_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV4_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV5_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV6_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV7_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV8_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-18_240221_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-20_240229_FOV1_reg_green(Substack1-927)_analysis.mat'};

% FOVs removed from analysis (all either perivascular or multinucleated)

% Pf4Ai162-2 FOV2
% Pf4Ai162-13 FOV3
% Pf4Ai162-12 FOV6

%% Load .mat files  (THIN BONE BASELINE)

% Change you Current Folder
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\thinBone\_analysis.mat

% Initialize an empty table
combinedTable = table();

filesNamesAll = {
    'Pf4Ai162-3_230322_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-5_230502_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-5_230502_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-5_230502_FOV4_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-6_230502_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-6_230502_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-6_230502_FOV3_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-6_230502_FOV4_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-8_230614_FOV1_run1_reg_Z01_green_Substack (1-927)_analysis.mat',...
    'Pf4Ai162-8_230614_FOV2_run1_reg_Z01_green_Substack (1-927)_analysis.mat',...
    'Pf4Ai162-8_230614_FOV3_run1_reg_Z01_green_Substack (1-927)_analysis.mat',...
    'Pf4Ai162-8_230614_FOV4_run1_reg_Z01_green_Substack (1-927)_analysis.mat',...
    'Pf4Ai162-8_230614_FOV5_run1_reg_Z01_green_Substack (1-927)_analysis.mat',...
    'Pf4Ai162-8_230614_FOV7_run1_reg_Z01_green_Substack (1-927)_analysis.mat',...
    'Pf4Ai162-9_230614_FOV2_run1_reg_Z01_green_Substack (1-927)_analysis.mat',...
    'Pf4Ai162-9_230614_FOV4_run1_reg_Z01_green_Substack (1-927)_analysis.mat',...
    'Pf4Ai162-9_230614_FOV5_run1_reg_Z01_green_Substack (1-927)_analysis.mat'};

% Pf4Ai162-3 FOV1
% Pf4Ai162-5 FOV1
% Pf4Ai162-5 FOV4
% Pf4Ai162-6 FOV1
% Pf4Ai162-6 FOV3
% Pf4Ai162-9 FOV2

%% Load .mat files  (FULL CRANIOTOMY CSD)

% Change you Current Folder
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\CSD\corrected_for_pinprick\1._analysis.mat

% Initialize an empty table
combinedTable = table();

% List of filenames per animal - fullCraniotomy CSD

filesNamesAll = {
    'Pf4Ai162-1_221122_FOV1_reg_green_Substack(1-4949)_analysis',...
    'Pf4Ai162-11_230712_FOV1_reg_green_Substack(1-4949)_adjusted090_analysis',...
    'Pf4Ai162-13_230728_FOV1_reg_green_Substack(1-4949)_analysis',...
    'Pf4Ai162-14_231121_FOV1_reg_green_Substack(1-4949)_analysis',...
    'Pf4Ai162-15_231121_FOV1_reg_green_Substack(1-4949)_analysis',...
    'Pf4Ai162-16_240209_FOV1_reg_green_Substack(1-4949)_analysis',...
    'Pf4Ai162-18_240228_FOV1_reg_green_Substack(1-4949)_analysis',...
    'Pf4Ai162-21_241028_FOV1_reg_green_Substack(1-4949)_analysis',...
    'Pf4Ai162-21_241031_FOV1_reg_green_Substack(1-4949)_adjusted085_analysis',...
    'Pf4Ai162-22_241029_FOV1_reg_green_Substack(1-4949)_analysis',...
    'Pf4Ai162-22_241105_FOV1_reg_green_Substack(1-4949)_analysis',...
    'Pf4Ai162-23_241030_FOV1_reg_green_Substack(1-4949)_analysis',...
    'Pf4Ai162-23_241106_FOV1_reg_green_Substack(1-4949)_analysis'};


%% Extract and combine resultData from each experiment

fileNames = filesNamesAll;
combinedTable = [];

% Loop through each file
for i = 1:length(fileNames)
    % Load the .mat file
    data = load(fileNames{i});
    
    % Extract data from the structure (assuming variable names are consistent across files)
    % Here, assuming the variable name is 'result' in each .mat file
    resultData = data.resultsFinal;

    % Create a column with the filename
    fileNameColumn = repelem(fileNames(i), size(resultData, 1), 1); % Repeat filename for each row
  
    % Append resultData to combinedTable
    combinedTable = [combinedTable; resultData, table(fileNameColumn)];
end


%%
%for fullCraniotomy data - load spreadsheet and add Var3
load('D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\baseline\AQuA2_data_fullCraniotomy_features_baseline.mat')
load('D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\baseline\multinucleated cells\multinucleatedCells.mat');
fullCraniotomy_combinedTable = addvars(combinedTable, multinucleatedCells.Var3, 'NewVariableNames', 'Multinucleated');
fullCraniotomy_multinucleated = fullCraniotomy_combinedTable{:,17};
fullCraniotomy_cellLocation = fullCraniotomy_combinedTable{:,13};
fullCraniotomy_redLabel = fullCraniotomy_combinedTable{:,14};
fullCraniotomy_all_NM_indices = fullCraniotomy_multinucleated == 0;
fullCraniotomy_numOnes = sum(fullCraniotomy_all_NM_indices);

%fullCraniotomy_multinucleated_indices = fullCraniotomy_multinucleated == 1;
%sum(fullCraniotomy_multinucleated_indices);

%for thinBone data - create a new table 'multinucleatedCells' and add Var1
load('V:\2photon\Simone\Simone_Macrophages\AQuA2_Results\thinBone\AQuA2_data_thinBone.mat')
thinBone_multinucleated = zeros(94,1);
thinBone_combinedTable = addvars(combinedTable, thinBone_multinucleated.Var1, 'NewVariableNames', 'Multinucleated');
thinBone_cellLocation = thinBone_combinedTable{:,13};
thinBone_all_NM_indices = thinBone_multinucleated == 0;
thinBone_numOnes = sum(thinBone_all_NM_indices);
combinedTable_thinBone = combinedTable(thinBone_all_NM_indices,:);

%% By cell type
perivascular_NM_indices = fullCraniotomy_cellLocation == 0 & fullCraniotomy_multinucleated == 0; % Indices of cells belonging to group 0
nonPerivascular_NM_indices = fullCraniotomy_cellLocation == 2 & fullCraniotomy_multinucleated == 0; % Indices of cells belonging to group 2
fullCraniotomy_combinedTable_perivascular = fullCraniotomy_combinedTable(perivascular_NM_indices,:);
fullCraniotomy_combinedTable_nonPerivascular = fullCraniotomy_combinedTable(nonPerivascular_NM_indices,:);

%% Features by Cell

%Perivascular
area_perivascular_NM = fullCraniotomy_combinedTable_perivascular(:,"Area(um2)");
perimeter_perivascular_NM = fullCraniotomy_combinedTable_perivascular(:,"Perimeter");
circularity_perivascular_NM = fullCraniotomy_combinedTable_perivascular(:,"Circularity");
numberOfEvents_perivascular_NM = fullCraniotomy_combinedTable_perivascular(:,"Number of Events");
maxDFF_perivascular_NM = fullCraniotomy_combinedTable_perivascular(:,"Max dFF");
dFFAUC_perivascular_NM = fullCraniotomy_combinedTable_perivascular(:,"dFF AUC");

%Perivascular
area_nonPerivascular_NM = fullCraniotomy_combinedTable_nonPerivascular(:,"Area(um2)");
perimeter_nonPerivascular_NM = fullCraniotomy_combinedTable_nonPerivascular(:,"Perimeter");
circularity_nonPerivascular_NM = fullCraniotomy_combinedTable_nonPerivascular(:,"Circularity");
numberOfEvents_nonPerivascular_NM = fullCraniotomy_combinedTable_nonPerivascular(:,"Number of Events");
maxDFF_nonPerivascular_NM = fullCraniotomy_combinedTable_nonPerivascular(:,"Max dFF");
dFFAUC_nonPerivascular_NM = fullCraniotomy_combinedTable_nonPerivascular(:,"dFF AUC");

%% Perivascular By FOV

% Extract unique identifiers (e.g., up to "_run1")
perivascular_extractedNames = cellfun(@(x) extractBefore(x, '_r'), fullCraniotomy_combinedTable_perivascular.fileNameColumn, 'UniformOutput', false);
fullCraniotomy_combinedTable_perivascular.Group = perivascular_extractedNames;

perivascular_uniqueGroups = unique(fullCraniotomy_combinedTable_perivascular.Group);
perivascular_averagedTable = table();

for x = 1:length(perivascular_uniqueGroups)
    perivascular_groupName = perivascular_uniqueGroups{x};
    
    % Get rows corresponding to the current group
    perivascular_groupData = fullCraniotomy_combinedTable_perivascular(strcmp(fullCraniotomy_combinedTable_perivascular.Group, perivascular_groupName), :);
    perivascular_selectedVariableNames = perivascular_groupData.Properties.VariableNames(2:12);

    % Compute averages for numeric columns
     if size(perivascular_groupData, 1) == 1
        % Only one row, directly use the values
        perivascular_avgValues = perivascular_groupData{1, perivascular_selectedVariableNames};
     else
        % Compute averages for numeric columns
        perivascular_avgValues = mean(perivascular_groupData{:, perivascular_selectedVariableNames}, 1);
     end

    % Append to result table
    perivascular_tempTable = table({perivascular_groupName}, perivascular_avgValues(1),...
        perivascular_avgValues(2),perivascular_avgValues(3),perivascular_avgValues(4),...
    perivascular_avgValues(5),perivascular_avgValues(6),perivascular_avgValues(7),...
    perivascular_avgValues(8),perivascular_avgValues(9),perivascular_avgValues(10),...
    perivascular_avgValues(11),'VariableNames', [{'Group'}, perivascular_selectedVariableNames]);

    perivascular_averagedTable = [perivascular_averagedTable; perivascular_tempTable];
end

%% nonPerivascular By FOV

% Extract unique identifiers (e.g., up to "_run1")
nonPerivascular_extractedNames = cellfun(@(x) extractBefore(x, '_r'), fullCraniotomy_combinedTable_nonPerivascular.fileNameColumn, 'UniformOutput', false);
fullCraniotomy_combinedTable_nonPerivascular.Group = nonPerivascular_extractedNames;

nonPerivascular_uniqueGroups = unique(fullCraniotomy_combinedTable_nonPerivascular.Group);
nonPerivascular_averagedTable = table();

for x = 1:length(nonPerivascular_uniqueGroups)
    nonPerivascular_groupName = nonPerivascular_uniqueGroups{x};
    
    % Get rows corresponding to the current group
    nonPerivascular_groupData = fullCraniotomy_combinedTable_nonPerivascular(strcmp(fullCraniotomy_combinedTable_nonPerivascular.Group, nonPerivascular_groupName), :);
    nonPerivascular_selectedVariableNames = nonPerivascular_groupData.Properties.VariableNames(2:12);

    % Compute averages for numeric columns
     if size(nonPerivascular_groupData, 1) == 1
        % Only one row, directly use the values
        nonPerivascular_avgValues = nonPerivascular_groupData{1, nonPerivascular_selectedVariableNames};
     else
        % Compute averages for numeric columns
        nonPerivascular_avgValues = mean(nonPerivascular_groupData{:, nonPerivascular_selectedVariableNames}, 1);
     end

    % Append to result table
    nonPerivascular_tempTable = table({nonPerivascular_groupName}, nonPerivascular_avgValues(1), ...
        nonPerivascular_avgValues(2),nonPerivascular_avgValues(3),nonPerivascular_avgValues(4),...
    nonPerivascular_avgValues(5),nonPerivascular_avgValues(6),nonPerivascular_avgValues(7),...
    nonPerivascular_avgValues(8),nonPerivascular_avgValues(9),nonPerivascular_avgValues(10),...
    nonPerivascular_avgValues(11),'VariableNames', [{'Group'}, nonPerivascular_selectedVariableNames]);

    nonPerivascular_averagedTable = [nonPerivascular_averagedTable; nonPerivascular_tempTable];
end

%% Features by FOV

% Perivascular
area_perivascular = perivascular_averagedTable{:,2};
perimeter_perivascular = perivascular_averagedTable{:,3};
circularity_perivascular = perivascular_averagedTable{:,4};
maxDFF_perivascular = perivascular_averagedTable{:,5};
dFFAUC_perivascular = perivascular_averagedTable{:,11};
numberOfEvents_perivascular = perivascular_averagedTable{:,12};

% nonPerivascular
area_nonPerivascular = nonPerivascular_averagedTable{:,2};
perimeter_nonPerivascular = nonPerivascular_averagedTable{:,3};
circularity_nonPerivascular = nonPerivascular_averagedTable{:,4};
maxDFF_nonPerivascular = nonPerivascular_averagedTable{:,5};
dFFAUC_nonPerivascular = nonPerivascular_averagedTable{:,11};
numberOfEvents_nonPerivascular = nonPerivascular_averagedTable{:,12};

%% duplicating table to manually delete a cell if necessary

figure;
plot(combinedTable.dFF{425,:})
combinedTable2 = combinedTable; %duplicating table to manually delete a cell if necessary

%% Sort combinedTable by number of events

combinedTable_sorted = sortrows(combinedTable, 'Cell location (0,perivascular;1,adjacent;2,none)', 'descend');

%% Filter data by cell location

varTypes = varfun(@class, combinedTable_sorted, 'OutputFormat', 'cell'); %check data types

%create table with all variables but cell ID and dFF
dataAll = combinedTable_sorted{:, 2:14};
dataAll_Zscore = zscore(dataAll);
dataAll2 = combinedTable_sorted{:, [2:9,11:14]};


% Separate cells by location
cellLocation = combinedTable_sorted{:, 13};

logicalIndex0 = cellLocation == 0; %perivascular
rowsWithValue0 = combinedTable_sorted(logicalIndex0, :);
dataPerivascular = rowsWithValue0{:, 2:14};

logicalIndex2 = cellLocation == 2; %non-perivascular
rowsWithValue2 = combinedTable_sorted(logicalIndex2, :);
dataNonPerivascular = rowsWithValue2{:, 2:14};

%% Renumber cells in combinedTable to simplify cell identification

%create cellID to substitute cell numbers
cellID_all = (1:544)';
cellID_all = num2cell(cellID_all);
cellID = combinedTable_sorted{:, 1};
cellID_combined = [cellID_all, cellID];
cellID_combinedTable = cell2table(cellID_combined);
