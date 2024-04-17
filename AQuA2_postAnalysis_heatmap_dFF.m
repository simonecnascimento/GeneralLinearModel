%% Load .mat files 

% Change you Current Folder
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results

% Initialize an empty table
combinedTable = table();

% List of filenames per animal

fileNames_Pf4Ai162_2 = {
    'Pf4Ai162-2_221130_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-2_221130_FOV6_run1_reg_Z01_green_Substack(1-927)_analysis.mat'};

fileNames_Pf4Ai162_10 = {
    'Pf4Ai162-10_230628_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-10_230628_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-10_230628_FOV3_run1_reg_Z01_green_Substack(1-927)_analysis.mat',... 
    'Pf4Ai162-10_230628_FOV4_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-10_230628_FOV5_run1_reg_Z01_green_Substack(1-927)_analysis.mat',... 
    'Pf4Ai162-10_230628_FOV7_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-10_230628_FOV8_run1_reg_Z01_green_Substack(1-927)_analysis.mat'};

fileNames_Pf4Ai162_11 = {
    'Pf4Ai162-11_230630_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV3_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV4_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV5_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV6_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV7_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV8_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-11_230630_FOV9_run1_reg_Z01_green_Substack(1-927)_analysis.mat'};

fileNames_Pf4Ai162_12 = {
    'Pf4Ai162-12_230717_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV3_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV4_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV5_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV6_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV7_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV8_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV9_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-12_230717_FOV10_run1_reg_Z01_green_Substack(1-927)_analysis.mat'};

fileNames_Pf4Ai162_13 = {
    'Pf4Ai162-13_230719_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV2_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV3_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV4_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV5_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV6_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV7_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
    'Pf4Ai162-13_230719_FOV8_run1_reg_Z01_green_Substack(1-927)_analysis.mat'};

fileNames_Pf4Ai162_18 = {
    'Pf4Ai162-18_240221_FOV1_run1_reg_Z01_green_Substack(1-927)_analysis.mat'};

fileNames_Pf4Ai162_20 = {
    'Pf4Ai162-20_240229_FOV1_reg_green(Substack1-927)_analysis.mat'};    

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
    'Pf4Ai162-11_230630_FOV7_run1_reg_Z01_green_Substack(1-927)_analysis.mat',...
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

%% Extract and combine resultData from each experiment

fileNames = filesNamesAll;

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

%% Create heatmap of dFF data by cell

%Perivascular cells
for perivascular = resultsFinal.("Cell location (0,perivascular;1,adjacent;2,none)") == 0
    dFF_perivascular = resultsFinal{perivascular,"dFF"};
end

%Convert cell array to 2D matrix
dFF_perivascular = cell2mat(dFF_perivascular);


% Define the colormap
cmap = redbluecmap; % Or any other colormap you prefer
newCmap = imresize(cmap, [128, 3]); % Increase number of colors
newCmap = min(max(newCmap, 0), 1);

% Define the color limits based on your data range
maxDff = max(dFF_perivascular(:));
minDff = min(dFF_perivascular(:));
colorLimits = [minDff maxDff]; % Using the actual minimum and maximum values of the data

% Create the heatmap with the custom colormap and color limits using imagesc
imagesc(dFF_perivascular, colorLimits);

% Apply the custom colormap
colormap(newCmap);

% Add color bar
colorbar;

% Set titles and labels
title('dFF');
xlabel('Seconds');
ylabel('Cell ID');


%% 

%Non-perivascular cells
for non_perivascular = resultsFinal.("Cell location (0,perivascular;1,adjacent;2,none)") == 2
    dFF_Nperivascular = resultsFinal{non_perivascular,"dFF"};
end

%Convert cell array to 2D matrix
dFF_Nperivascular = cell2mat(dFF_Nperivascular);


% Define the colormap
cmap = redbluecmap; % Or any other colormap you prefer
newCmap = imresize(cmap, [128, 3]); % Increase number of colors
newCmap = min(max(newCmap, 0), 1);

% Define the color limits based on your data range
maxDff = max(dFF_Nperivascular(:));
minDff = min(dFF_Nperivascular(:));
colorLimits = [minDff maxDff]; % Using the actual minimum and maximum values of the data

% Create the heatmap with the custom colormap and color limits using imagesc
imagesc(dFF_Nperivascular, colorLimits);

% Apply the custom colormap
colormap(newCmap);

% Add color bar
colorbar;

% Set titles and labels
title('dFF');
xlabel('Seconds');
ylabel('Cell ID');


%% Multiple experiments

%all cells

%perivascular cells
for perivascular = combinedTable.("Cell location (0,perivascular;1,adjacent;2,none)") == 0
    dFF_data_Perivascular = combinedTable{perivascular,"dFF"};
end
dFF_data_Perivascular = cell2mat(dFF_data_Perivascular);

%Non-perivascular cells
for non_perivascular = combinedTable_sorted.("Cell location (0,perivascular;1,adjacent;2,none)") == 2
    dFF_data_NonPerivascular = combinedTable{non_perivascular,"dFF"};
end
dFF_data_NonPerivascular = cell2mat(dFF_data_NonPerivascular);
dFF_data_NonPerivascular_reduced = dFF_data_NonPerivascular(1:134,:);

% Apply z-score normalization to the dFF data
dFF_data_Perivascular_zscore = zscore(dFF_data_Perivascular, [], 1);
dFF_data_NonPerivascular_zscore = zscore(dFF_data_NonPerivascular, [], 1);
dFF_data_NonPerivascular_reduced_zscore = zscore(dFF_data_NonPerivascular_reduced, [], 1);

% Combine the data from both groups
combined_data = [dFF_data_Perivascular_zscore; dFF_data_NonPerivascular_reduced_zscore];

% Determine the colorbar limits based on the combined data
caxis_limits = [min(combined_data(:)), max(combined_data(:))];


%Heatmap all
figure;
imagesc(dFF_data_zscore);
colormap(jet);
colorbar;
caxis(caxis_limits); % Set colorbar limits
title('dFF zscore');
xlabel('Time(sec)');
ylabel('Cell');

% Heatmap Perivascular
figure;
imagesc(dFF_data_Perivascular_zscore);
colormap(jet);
colorbar;
caxis(caxis_limits); % Set colorbar limits
title('dFF zscore Perivascular');
xlabel('Time(sec)');
ylabel('Cell');

% Heatmap NonPerivascular
figure;
imagesc(dFF_data_NonPerivascular_reduced_zscore);
colormap(jet);
colorbar;
caxis(caxis_limits); % Set colorbar limits
title('dFF zscoreNonPerivascular');
xlabel('Time(sec)');
ylabel('Cell');

%% Order cells in order of number of events and plot dFF

% Sort combinedTable by number of events
combinedTable_sorted = sortrows(combinedTable, 'Number of Events', 'descend');

%perivascular cells
for perivascular_sorted = combinedTable_sorted.("Cell location (0,perivascular;1,adjacent;2,none)") == 0
    dFF_data_Perivascular_sorted = combinedTable_sorted{perivascular_sorted,"dFF"};
end
dFF_data_Perivascular_sorted = cell2mat(dFF_data_Perivascular_sorted);

%Non-perivascular cells
for non_perivascular_sorted = combinedTable_sorted.("Cell location (0,perivascular;1,adjacent;2,none)") == 2
    dFF_data_NonPerivascular_sorted = combinedTable_sorted{non_perivascular_sorted,"dFF"};
end
dFF_data_NonPerivascular_sorted = cell2mat(dFF_data_NonPerivascular_sorted);
dFF_data_NonPerivascular_sorted_reduced = dFF_data_NonPerivascular_sorted(1:134,:);

% Apply z-score normalization to the dFF data
dFF_data_Perivascular_sorted_zscore = zscore(dFF_data_Perivascular_sorted, [], 1);
dFF_data_NonPerivascular_sorted_zscore = zscore(dFF_data_NonPerivascular_sorted, [], 1);
dFF_data_NonPerivascular_sorted_reduced_zscore = zscore(dFF_data_NonPerivascular_sorted_reduced, [], 1);

% Combine the data from both groups
combined_data_sorted = [dFF_data_Perivascular_sorted_zscore; dFF_data_NonPerivascular_sorted_reduced_zscore];

% Determine the colorbar limits based on the combined data
caxis_limits_sorted = [min(combined_data_sorted(:)), max(combined_data_sorted(:))];

% Heatmap Perivascular
figure;
imagesc(dFF_data_Perivascular_sorted_zscore);
colormap(jet);
colorbar;
caxis(caxis_limits); % Set colorbar limits
title('dFF zscore Perivascular');
xlabel('Time(sec)');
ylabel('Cell');

% Heatmap NonPerivascular
figure;
imagesc(dFF_data_NonPerivascular_sorted_reduced_zscore);
colormap(jet);
colorbar;
caxis(caxis_limits); % Set colorbar limits
title('dFF zscoreNonPerivascular');
xlabel('Time(sec)');
ylabel('Cell');


%%


