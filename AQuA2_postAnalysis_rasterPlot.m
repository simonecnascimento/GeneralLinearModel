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
