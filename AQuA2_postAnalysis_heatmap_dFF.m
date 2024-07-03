%% Create heatmap of dFF data by experiment

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


% All cells

% Extract dFF data from combinedTable, converting cell array to matrix
dFF_data = cell2mat(combinedTable_sorted.dFF);
% Apply z-score normalization to the dFF data
dFF_data_zscore = zscore(dFF_data, [], 1);

%perivascular cells
for perivascular = combinedTable_sorted.("Cell location (0,perivascular;1,adjacent;2,none)") == 0
    dFF_data_Perivascular = combinedTable_sorted{perivascular,"dFF"};
end
dFF_data_Perivascular = cell2mat(dFF_data_Perivascular);

%Non-perivascular cells
for non_perivascular = combinedTable_sorted.("Cell location (0,perivascular;1,adjacent;2,none)") == 2
    dFF_data_NonPerivascular = combinedTable_sorted{non_perivascular,"dFF"};
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
dFF_data_NonPerivascular_sorted_reduced = dFF_data_NonPerivascular_sorted(1:122,:);

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
caxis(caxis_limits_sorted); % Set colorbar limits
title('dF/F0 Perivascular');
xlabel('Time(sec)');
ylabel('Cell');

% Heatmap NonPerivascular
figure;
imagesc(dFF_data_NonPerivascular_sorted_reduced_zscore);
colormap(jet);
colorbar;
caxis(caxis_limits_sorted); % Set colorbar limits
title('dF/F0 NonPerivascular');
xlabel('Time(sec)');
ylabel('Cell');


%%


