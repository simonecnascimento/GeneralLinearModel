rasterPlot_data = res_dbg.featureTable1{[2,3,4,10],:}';
rasterPlot_data = rasterPlot_data';

% temporal resolution = 0.97 seconds/frame

% Preallocate new column
end_time = cell(size(rasterPlot_data, 1), 1);


% Calculate new column values
for i = 1:size(rasterPlot_data, 1)
    event_size = rasterPlot_data{i, 3}; % Extract the event size
    start_time = rasterPlot_data{i, 2}; % Extract the start time
    event_duration = rasterPlot_data{i,4};
    end_time{i} = start_time + event_duration; % Perform calculation
end

% Add the new column to the cell array
rasterPlot_data(:, 5) = end_time;

%% Create plot

% Sample data (replace these with your actual data)
events = rasterPlot_data(:,1); % Event numbers
start_times = rasterPlot_data(:,2); % Start times of events
sizes = rasterPlot_data(:,3); % Size of events
end_times = rasterPlot_data(:,5); % End times of events


% Create figure
figure;
hold on;

% Normalize sizes to colormap range
cmap = colormap(jet); % Choose the colormap
n_colors = size(cmap, 1);
norm_sizes = round((sizes - min(sizes)) / (max(sizes) - min(sizes)) * (n_colors - 1)) + 1;

% Plot each event as a patch (rectangle)
for i = 1:length(start_times)
    duration = end_times(i) - start_times(i);
    color = cmap(norm_sizes(i), :); % Color based on normalized size
    patch([start_times(i), start_times(i) + duration, start_times(i) + duration, start_times(i)], ...
          [events(i) - 0.4, events(i) - 0.4, events(i) + 0.4, events(i) + 0.4], ...
          color, 'EdgeColor', 'none');
end

% Add colorbar
colorbar;

% Label axes
xlabel('Time');
ylabel('Event Number');

% Title
title('Raster Plot with Event Durations and Colormap by Size');

% Ensure the colorbar reflects the size of events
caxis([min(sizes) max(sizes)]);

% Enhance visualization
grid on; % Add grid lines for better readability
set(gca, 'FontSize', 12); % Set font size for better readability

% Set the y-axis limits to properly display the events
ylim([0 max(events) + 1]);

hold off;





%% TEST


% Sample data (replace these with your actual data)
events = cell2mat(rasterPlot_data(:, 1)); % Event numbers
start_times = cell2mat(rasterPlot_data(:, 2)); % Start times of events
sizes = cell2mat(rasterPlot_data(:, 3)); % Size of events
duration = cell2mat(rasterPlot_data(:, 4));
end_times = cell2mat(rasterPlot_data(:, 5)); % End times of events

% Convert cell array to table for easier handling (optional but recommended)
rasterPlot_table = cell2table(rasterPlot_data, 'VariableNames', {'EventNumber', 'StartTime', 'Size', 'Duration', 'EndTime'});

% Define the events combined according to your provided list
events_combined = {
    [12; 15; 16; 22; 24; 26];
    [3; 4; 6; 7; 10];
    [8; 30; 32];
    [9; 13; 18];
    [14; 23; 25];
    [27; 29; 31];
    [1; 2];
    [20; 21];
    5;
    11;
    17;
    19;
    28;
};

events_combined = cell2struct(events_combined);

for m = 1:size(events_combined, 1)
    % Extract cell indices to merge
    eventIndices = events_combined(m, :);
    validIndices = ~isnan(eventIndices);
    validCellIndices = cellIndices(validIndices);

    % Combine events of CFUs
    combinedCellEvents = cat(1, resultsTable(validCellIndices).eventList);
    % Update the first CFU with the combined events
    resultsTable(validCellIndices(1)).eventList = combinedCellEvents;

    % Extract dFF values for the specified cell indices
    dFF_values_to_combine = cell2mat(dFF_list(validCellIndices));
    combined_dFF = mean(dFF_values_to_combine);
    % Update the first CFU with the combined dFF
    resultsTable(validCellIndices(1)).dFF_list = combined_dFF;
end

% Remove the extra CFUs
cellsToMergeCell = cell(size(events_combined));
for i = 1:size(events_combined, 1)
    for c = 1:size(events_combined, 2)
        if isnan(events_combined(i, c))
            cellsToMergeCell{i, c} = [];
        else
            cellsToMergeCell{i, c} = events_combined(i, c);
        end
    end
end



rasterPlot_table_combined(i, 1) = rasterPlot_table(2*i-1, 1); % Event number from the first row
rasterPlot_table_combined(i, 2) = rasterPlot_table(2*i-1, 2); % Start time from the first row
rasterPlot_table_combined(i, 3) = rasterPlot_table(2*i-1, 3); % Size from the first row
rasterPlot_table_combined(i, 4) = rasterPlot_table(2*i, 4);   % Duration from the second row
rasterPlot_table_combined(i, 5) = rasterPlot_table(2*i, 5);   % End time from the second row


% Initialize an empty cell array to store grouped data
grouped_data = cell(size(events_combined));

% Group events according to events_combined
for i = 1:length(events_combined)
    if iscell(events_combined{i})
        % Extract events for this group
        event_numbers = events_combined{i};
        group_data = sorted_table(ismember(sorted_table.EventNumber, event_numbers), :);
    else
        % Single event number case
        event_number = events_combined{i};
        group_data = sorted_table(sorted_table.EventNumber == event_number, :);
    end
    
    % Store group data in grouped_data
    grouped_data{i} = group_data;
end


% Sort the table by EventNumber (optional)
sorted_table = sortrows(rasterPlot_table, 'EventNumber');

% Group events according to events_combined
for i = 1:length(events_combined)
    if iscell(events_combined{i})
        % Extract events for this group
        event_numbers = events_combined{i};
        group_data = sorted_table(ismember(sorted_table.EventNumber, event_numbers), :);
    else
        % Single event number case
        event_number = events_combined{i};
        group_data = sorted_table(sorted_table.EventNumber == event_number, :);
    end
    
    % Store group data in grouped_data
    grouped_data{i} = group_data;
end

% Display grouped_data or use it for further analysis
disp(grouped_data);

% Create figure
figure;
hold on;

% Normalize sizes to colormap range
cmap = colormap(jet); % Choose the colormap
n_colors = size(cmap, 1);
norm_sizes = round((sizes - min_size) / (max(sizes) - min_size) * (n_colors - 1)) + 1;

% Plot each event as a patch (rectangle)
for i = 1:length(start_times)
    duration = end_times(i) - start_times(i);
    color = cmap(norm_sizes(i), :); % Color based on normalized size
    patch([start_times(i), start_times(i) + duration, start_times(i) + duration, start_times(i)], ...
          [events(i) - 0.4, events(i) - 0.4, events(i) + 0.4, events(i) + 0.4], ...
          color, 'EdgeColor', 'none');
end

% Add colorbar
colorbar;

% Label axes
xlabel('Time');
ylabel('Event Number');

% Title
title('Raster Plot with Event Durations and Colormap by Size');

% Set colormap limits and enhance colorbar
min_size = min(sizes);
max_size = max(sizes);
caxis([min_size, max_size]);
colorbar;

% Enhance visualization
grid on;
set(gca, 'FontSize', 12);
ylim([0, max(events) + 1]); % Set the y-axis limits to properly display the events

hold off;
