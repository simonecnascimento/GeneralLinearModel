
%% Separate data points belonging to each group

cellLocation = combinedTable{:,13};
redLabel = combinedTable{:,14};
perivascular_indices = (cellLocation == 0); % Indices of cells belonging to group 0
nonPerivascular_indices = (cellLocation == 2); % Indices of cells belonging to group 2

% Convert numeric group labels to strings
group_str = cell(size(cellLocation));
group_str(cellLocation == 0) = {'Perivascular'};
group_str(cellLocation == 2) = {'NonPerivascular'};

% Convert numeric group labels to strings
group_str = cell(size(cellLocation));
group_str(redLabel == 0) = {'RedLabel'};
group_str(redLabel == 1) = {'NotRedLabel'};

% Add jitter to y-values
jitter_amount = 0.05; % Adjust the amount of jitter as needed
jitter_perivascular = (rand(sum(perivascular_indices), 1) - 0.5) * jitter_amount;
jitter_nonPerivascular = (rand(sum(nonPerivascular_indices), 1) - 0.5) * jitter_amount;

% Define spacing factor for x-axis data points
x_spacing_factor = 0.02; % Adjust as needed

%% RedLabel Perivascular x NonPerivascular

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
%xticklabels({'Perivascular', 'Non-Perivascular'}); % Adjusted position for clarity
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

%% RedLabel x Not red label (Non-Perivascular only bar graph)

% Count non-perivascular cells labeled with red and those not labeled with red
non_perivascular_red = sum(cellLocation == 2 & redLabel == 1);
non_perivascular_not_red = sum(cellLocation == 2 & redLabel == 0);

% Create bar chart
figure;
bar_data = [non_perivascular_red, non_perivascular_not_red];

bar_handle = bar(bar_data);

% Set custom colors for each bar using CData
bar_handle.FaceColor = 'flat';  % Allow different colors per bar
bar_handle.CData(1, :) = [1, 0, 0];   % Red for red-labeled cells
bar_handle.CData(2, :) = [0, 1, 0];   % Green for not-red-labeled cells

% Customize plot
ylabel('Number of Cells');
%xticklabels({'Red Labeled', 'Not Red Labeled'});
legend({'Labeled', 'Non-Labeled'}, 'Location', 'northeast');
title('Presence of Red Dextran in cells', FontSize=30);
ylim([0, 350]);

% Add custom legend by plotting invisible bars
hold on;
h1 = bar(nan, 'FaceColor', [1, 0, 0]); % Invisible red bar
h2 = bar(nan, 'FaceColor', [0, 1, 0]); % Invisible green bar
legend([h1, h2], {'Labeled', 'Non-Labeled'}, 'Location', 'northeast');

% Remove numeric ticks from x-axis
set(gca, 'xtick', []);


%% Circularity Perivascular x Non-Perivascular - SCATTERPLOT

% Extract data from the table
circularity = combinedTable{:,4};
circularity_perivascular = circularity(perivascular_indices); % Data points belonging to group 0
circularity_nonPerivascular = circularity(nonPerivascular_indices); % Data points belonging to group 2

% Plot scatterplot with jitter
figure;
scatter(0 - x_spacing_factor + jitter_perivascular, circularity_perivascular, 'ro'); hold on;
scatter(0.2 + x_spacing_factor + jitter_nonPerivascular, circularity_nonPerivascular, 'bo'); 

% Calculate mean of each group
meanCircularity_perivascular = mean(circularity_perivascular);
meanCircularity_nonPerivascular = mean(circularity_nonPerivascular);

% Plot means
plot(0 - x_spacing_factor, meanCircularity_perivascular, 'kx', 'MarkerSize', 10, 'LineWidth', 5);
plot(0.2 + x_spacing_factor, meanCircularity_nonPerivascular, 'kx', 'MarkerSize', 10, 'LineWidth', 5);

% Customize plot
ylabel('Circularity');
xticks([(0 - x_spacing_factor)  (0.2 + x_spacing_factor)]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
%title('Circularity Perivascular x NonPerivascular');
% Increase y-axis range
xlim([-0.1, 0.3]);
ylim([0, 0.7]);

% Perform t-test
[h, circularity_p_value] = ttest2(circularity_perivascular, circularity_nonPerivascular);

% Add p-value to the graph
if circularity_p_value < 0.001
    text(0.1, 0.6, 'p-value < 0.001', 'HorizontalAlignment', 'center');
else
    text(0.1, 0.6, ['p-value = ', num2str(circularity_p_value)], 'HorizontalAlignment', 'center');
end

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(circularity_p_value)]);

% Add p-value to the graph
%text(0.1, 0.6, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');
text(0.1, 0.6, 'p-value<0.001')

%% Circularity Perivascular x Non-Perivascular - BAR GRAPH

figure;
circularityGraph = bar([meanCircularity_perivascular, meanCircularity_nonPerivascular]); hold on;
xticks([1, 2]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
ylabel('Circularity');
ylim([0, 0.4]);
box off;

% Define colors for each bar
circularityGraph.FaceColor = 'flat';
circularityGraph.CData(1,:) = [0.6350 0.0780 0.1840];

% Calculate SEM
semCircularity_perivascular = std(circularity_perivascular) / sqrt(length(circularity_perivascular));
semCircularity_nonPerivascular = std(circularity_nonPerivascular) / sqrt(length(circularity_nonPerivascular));

% Add error bars representing SEM
errorbar([1, 2], [meanCircularity_perivascular, meanCircularity_nonPerivascular], ...
    [semCircularity_perivascular, semCircularity_nonPerivascular], ...
    'k.', 'LineWidth', 1.5);

% Set aspect ratio
pbaspect([1 1 2]); % Adjust the aspect ratio for a more rectangular shape

% Add p-value to the graph
if circularity_p_value < 0.001
    text(1.5, 0.3, 'p-value < 0.001', 'HorizontalAlignment', 'center');
else
    text(1.5, 0.3, ['p-value = ', num2str(circularity_p_value)], 'HorizontalAlignment', 'center');
end

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(circularity_p_value)]);

%% Circularity Perivascular x Non-Perivascular - BOXPLOT GRAPH

% Extract circularity data for each group
groupCircularity_data = {circularity_perivascular, circularity_nonPerivascular};

% Plot boxplot with specified colors
figure;
boxplot(groupCircularity_data); hold on;
xticks([1, 2]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
ylabel('Circularity');
ylim([0, 0.7]);

boxplot(groupCircularity_data, 'Colors', barColors, 'Symbol', 'k.');

% Calculate SEM
semCircularity_perivascular = std(circularity_perivascular) / sqrt(length(circularity_perivascular));
semCircularity_nonPerivascular = std(circularity_nonPerivascular) / sqrt(length(circularity_nonPerivascular));

% Add error bars representing SEM
errorbar([1, 2], [meanCircularity_perivascular, meanCircularity_nonPerivascular], ...
    [semCircularity_perivascular, semCircularity_nonPerivascular], ...
    'k.', 'LineWidth', 1.5);

% Set aspect ratio
pbaspect([2 1 1]); % Adjust the aspect ratio for a more rectangular shape

% Remove top and right lines
box off;

% Add p-value to the graph
if circularity_p_value < 0.001
    text(1.5, 0.6, 'p-value < 0.001', 'HorizontalAlignment', 'center');
else
    text(1.5, 0.6, ['p-value = ', num2str(circularity_p_value)], 'HorizontalAlignment', 'center');
end

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(circularity_p_value)]);



%% Number of Events Perivascular x Non-Perivascular - SCATTERPLOT

numberOfEvents = combinedTable{:,12};
numberOfEvents_perivascular = numberOfEvents(perivascular_indices); % Data points belonging to group 0
numberOfEvents_nonPerivascular = numberOfEvents(nonPerivascular_indices); % Data points belonging to group 2

% Customize plot
legend('Perivascular', 'NonPerivascular', 'Mean Perivascular', 'Mean NonPerivascular', 'Outliers');

% Plot scatterplot with jitter
figure;
scatter(repmat(0, sum(perivascular_indices), 1) + jitter_perivascular, numberOfEvents_perivascular, 'bo'); hold on;
scatter(repmat(1, sum(nonPerivascular_indices), 1) + jitter_nonPerivascular, numberOfEvents_nonPerivascular, 'ro'); 

% Calculate mean of each group
meanNumberOfEvents_perivascular = mean(numberOfEvents_perivascular);
meanNumberOfEvents_nonPerivascular = mean(numberOfEvents_nonPerivascular);

% Plot means
plot(0, meanNumberOfEvents_perivascular, 'bx', 'MarkerSize', 20, 'LineWidth', 2);
plot(1, meanNumberOfEvents_nonPerivascular, 'rx', 'MarkerSize', 20, 'LineWidth', 2);

% Customize plot
ylabel('Number of Events');
xticks([0 1]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('Number of Events Perivascular x NonPerivascular');
% Increase y-axis range
max(numberOfEvents(:));
min(numberOfEvents(:));
ylim([0, 44]);

% Perform t-test
[h, NumberOfEvents_p_value] = ttest2(numberOfEvents_perivascular, numberOfEvents_nonPerivascular);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(NumberOfEvents_p_value)]);

% Add p-value to the graph
text(0.5, 35, ['p-value = ', num2str(NumberOfEvents_p_value)], 'HorizontalAlignment', 'center');

%% Number of Events Perivascular x Non-Perivascular - BAR GRAPH

figure;
numberOfEventsGraph = bar([meanNumberOfEvents_perivascular, meanNumberOfEvents_nonPerivascular]); hold on;
xticks([1, 2]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
ylabel('Number of Events');
ylim([0, 4]);
box off;

% Define colors for each bar
numberOfEventsGraph.FaceColor = 'flat';
numberOfEventsGraph.CData(1,:) = [0.6350 0.0780 0.1840];

% Calculate SEM
semNumberOfEvents_perivascular = std(numberOfEvents_perivascular) / sqrt(length(numberOfEvents_perivascular));
semNumberOfEvents_nonPerivascular = std(numberOfEvents_nonPerivascular) / sqrt(length(numberOfEvents_nonPerivascular));

% Add error bars representing SEM
errorbar([1, 2], [meanNumberOfEvents_perivascular, meanNumberOfEvents_nonPerivascular], ...
    [semNumberOfEvents_perivascular, semNumberOfEvents_nonPerivascular], ...
    'k.', 'LineWidth', 1.5);

% Set aspect ratio
pbaspect([1 1 2]); % Adjust the aspect ratio for a more rectangular shape

% Add p-value to the graph
if NumberOfEvents_p_value < 0.001
    text(1.5, 3.5, 'p-value < 0.001', 'HorizontalAlignment', 'center');
else
    text(1.5, 3.5, ['p-value = ', num2str(NumberOfEvents_p_value)], 'HorizontalAlignment', 'center');
end

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(NumberOfEvents_p_value)]);


%% Area (um2) Perivascular x Non-Perivascular  - SCATTERPLOT

% Extract data from the table
area = combinedTable{:,2};
area_perivascular = area(perivascular_indices); 
area_nonPerivascular = area(nonPerivascular_indices);

% Customize plot
legend('Perivascular', 'NonPerivascular', 'Mean Perivascular', 'Mean NonPerivascular', 'Outliers');

% Plot scatterplot with jitter
figure;
scatter(repmat(0 - x_spacing_factor, sum(perivascular_indices), 1) + jitter_perivascular, area_perivascular, 'bo'); hold on;
scatter(repmat(0.35 + x_spacing_factor, sum(nonPerivascular_indices), 1) + jitter_nonPerivascular, area_nonPerivascular, 'ro');

% Calculate mean of each group
meanArea_perivascular = mean(area_perivascular);
meanArea_nonPerivascular = mean(area_nonPerivascular);

% Plot means
plot(0 - x_spacing_factor, mean_perivascular, 'kx', 'MarkerSize', 10, 'LineWidth', 5);
plot(0.35 + x_spacing_factor, mean_nonPerivascular, 'kx', 'MarkerSize', 10, 'LineWidth', 5);

% Customize plot
ylabel('Area (um2)');
xticks([-0.05, 0.4]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('Area Perivascular x NonPerivascular');
% Increase y-axis range
max(area(:));
min(area(:));
ylim([100, 800]);

% Perform t-test
[h, area_p_value] = ttest2(area_perivascular, area_nonPerivascular);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(area_p_value)]);

% Add p-value to the graph
text(0.25, 750, ['p-value = ', num2str(area_p_value)], 'HorizontalAlignment', 'center');

%% Area Perivascular x Non-Perivascular - BAR GRAPH

figure;
areaGraph = bar([meanArea_perivascular, meanArea_nonPerivascular]); hold on;
xticks([1, 2]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
ylabel('Area (um2)');
ylim([0, 500]);
box off;

% Define colors for each bar
areaGraph.FaceColor = 'flat';
areaGraph.CData(1,:) = [0.6350 0.0780 0.1840];

% Calculate SEM
semArea_perivascular = std(area_perivascular) / sqrt(length(area_perivascular));
semArea_nonPerivascular = std(area_nonPerivascular) / sqrt(length(area_nonPerivascular));

% Add error bars representing SEM
errorbar([1, 2], [meanArea_perivascular, meanArea_nonPerivascular], ...
    [semArea_perivascular, semArea_nonPerivascular], ...
    'k.', 'LineWidth', 1.5);

% Set aspect ratio
pbaspect([1 1 2]); % Adjust the aspect ratio for a more rectangular shape

% Add p-value to the graph
if area_p_value < 0.001
    text(1.5, 400, 'p-value < 0.001', 'HorizontalAlignment', 'center');
else
    text(1.5, 400, ['p-value = ', num2str(area_p_value)], 'HorizontalAlignment', 'center');
end

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(area_p_value)]);

%% Event-based max_dFF Perivascular x Non-Perivascular    TO FIX VARIABLES

max_dFF = combinedTable{:,5};
max_dFF_perivascular = max_dFF(perivascular_indices); % Data points belonging to group 0
max_dFF_nonPerivascular = max_dFF(nonPerivascular_indices); % Data points belonging to group 2

% Plot scatterplot with jitter
figure;
scatter(repmat(0.05, sum(perivascular_indices), 1) + jitter_perivascular, max_dFF_perivascular, 'ro'); hold on;
scatter(repmat(0.35 + x_spacing_factor, sum(nonPerivascular_indices), 1) + jitter_nonPerivascular, max_dFF_nonPerivascular, 'bo');

% Calculate mean of each group
mean_maxDFF_perivascular = mean(max_dFF_perivascular);
mean_maxDFF_nonPerivascular = mean(max_dFF_nonPerivascular);

% Plot means
plot(0.05, mean_maxDFF_perivascular, 'rx', 'MarkerSize', 20, 'LineWidth', 2);
plot(0.35 + x_spacing_factor, mean_maxDFF_nonPerivascular, 'bx', 'MarkerSize', 20, 'LineWidth', 2);

% Customize plot
ylabel('Max dFF');
xticks([0.05, 0.4]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('Max dFF Perivascular x NonPerivascular');
% Increase y-axis range
max(max_dFF(:));
min(max_dFF(:));
ylim([0, 7]);

% Perform t-test
[h, maxDFF_p_value] = ttest2(max_dFF_perivascular, max_dFF_nonPerivascular);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(maxDFF_p_value)]);

% Add p-value to the graph
text(0.5, 6, ['p-value = ', num2str(maxDFF_p_value)], 'HorizontalAlignment', 'center');

%% max Dff Perivascular x Non-Perivascular - BAR GRAPH

figure;
max_dFF_Graph = bar([mean_maxDFF_perivascular, mean_maxDFF_nonPerivascular]); hold on;
xticks([1, 2]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
ylabel('Max dFF');
ylim([0, 1.5]);
box off;

% Define colors for each bar
max_dFF_Graph.FaceColor = 'flat';
max_dFF_Graph.CData(1,:) = [0.6350 0.0780 0.1840];

% Calculate SEM
sem_maxDFF_perivascular = std(max_dFF_perivascular) / sqrt(length(max_dFF_perivascular));
sem_maxDFF_nonPerivascular = std(max_dFF_nonPerivascular) / sqrt(length(max_dFF_nonPerivascular));

% Add error bars representing SEM
errorbar([1, 2], [mean_maxDFF_perivascular, mean_maxDFF_nonPerivascular], ...
    [sem_maxDFF_perivascular, sem_maxDFF_nonPerivascular], ...
    'k.', 'LineWidth', 1.5);

% Set aspect ratio
pbaspect([1 1 2]); % Adjust the aspect ratio for a more rectangular shape

% Add p-value to the graph
if area_p_value < 0.001
    text(1.5, 400, 'p-value < 0.001', 'HorizontalAlignment', 'center');
else
    text(1.5, 400, ['p-value = ', num2str(area_p_value)], 'HorizontalAlignment', 'center');
end

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(area_p_value)]);


%% CFU-based maxdFF    

% In the event-related feature, we use the average curve of all spatial pixels in the event as the input to calculate dFF.
% In the CFU-related feature, CFU is a weighted map, 
% and the duration of each spatial pixel is considered as a weight. 
% So the input is a weighted average. Then the dFF is calculated.
% So, usually the center of CFU will gain more weight, thus maximum value of CFU dff would be larger than the dffMax feature of event.

dFFmax_values_all = max(dFF_data, [], 2);
dFFmax_values_perivascular = max(dFF_data_Perivascular, [], 2);
dFFmax_values_NonPerivascular = max(dFF_data_NonPerivascular, [], 2);

% Extract data from the table
cellLocation = combinedTable{:, 13};
correctedmax_dFF = dFFmax_values_all;

data_group_0 = correctedmax_dFF(group_0_indices); % Data points belonging to group 0
data_group_2 = correctedmax_dFF(group_2_indices); % Data points belonging to group 2

% Plot scatterplot with jitter
figure;
scatter(repmat(0 - x_spacing_factor, sum(group_0_indices), 1) + jitter_0, data_group_0, 'bo'); hold on;
scatter(repmat(1 + x_spacing_factor, sum(group_2_indices), 1) + jitter_2, data_group_2, 'ro');

% Calculate mean of each group
mean_perivascular = mean(data_group_0);
mean_nonPerivascular = mean(data_group_2);

% Plot means
plot(0 - x_spacing_factor, mean_perivascular, 'bx', 'MarkerSize', 20, 'LineWidth', 2);
plot(1 + x_spacing_factor, mean_nonPerivascular, 'rx', 'MarkerSize', 20, 'LineWidth', 2);

% Customize plot
ylabel('Max dFF');
xticks([-0.05, 1.05]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('Max dFF Perivascular x NonPerivascular');
% Increase y-axis range
max(correctedmax_dFF(:));
min(correctedmax_dFF(:));
ylim([0, 8]);

% Perform t-test
[h, p_value] = ttest2(data_group_0, data_group_2);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(p_value)]);

% Add p-value to the graph
text(0.5, 7, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');

%% Duration10to10 Perivascular x Non-Perivascular FIX VARIABLES

% Extract data from the table
duration10to10 = combinedTable{:,7};
duration10to10_perivascular = duration10to10(perivascular_indices); % Data points belonging to group 0
duration10to10_nonPerivascular = duration10to10(nonPerivascular_indices); % Data points belonging to group 2

% Plot scatterplot with jitter
figure;
scatter(repmat(0 - x_spacing_factor, sum(Perivascular_indices), 1) + jitter_0, duration10to10_Perivascular, 'bo'); hold on;
scatter(repmat(1 + x_spacing_factor, sum(NonPerivascular_indices), 1) + jitter_2, duration10to10_NonPerivascular, 'ro');

% Calculate mean of each group
mean_perivascular = mean(data_group_0);
mean_nonPerivascular = mean(data_group_2);

% Plot means
plot(0 - x_spacing_factor, mean_perivascular, 'bx', 'MarkerSize', 20, 'LineWidth', 2);
plot(1 + x_spacing_factor, mean_nonPerivascular, 'rx', 'MarkerSize', 20, 'LineWidth', 2);

% Customize plot
ylabel('duration10to10');
xticks([-0.05, 1.05]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('duration10to10 Perivascular x NonPerivascular');
% Increase y-axis range
max(duration10to10(:));
min(duration10to10(:));
ylim([6, 240]);

% Perform t-test
[h, p_value] = ttest2(data_group_0, data_group_2);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(p_value)]);

% Add p-value to the graph
text(0.5, 230, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');

%% Duration50to50 Perivascular x Non-Perivascular FIX VARIABLES

% Extract data from the table
duration50to50byLocation = combinedTable{:, [6,13]};
cellLocation = duration50to50byLocation(:,2);
duration50to50 = duration50to50byLocation(:,1);

data_group_0 = duration50to50(group_0_indices); % Data points belonging to group 0
data_group_2 = duration50to50(group_2_indices); % Data points belonging to group 2

% Plot scatterplot with jitter
figure;
scatter(repmat(0 - x_spacing_factor, sum(group_0_indices), 1) + jitter_0, data_group_0, 'bo'); hold on;
scatter(repmat(1 + x_spacing_factor, sum(group_2_indices), 1) + jitter_2, data_group_2, 'ro');

% Calculate mean of each group
mean_perivascular = mean(data_group_0);
mean_nonPerivascular = mean(data_group_2);

% Plot means
plot(0 - x_spacing_factor, mean_perivascular, 'bx', 'MarkerSize', 20, 'LineWidth', 2);
plot(1 + x_spacing_factor, mean_nonPerivascular, 'rx', 'MarkerSize', 20, 'LineWidth', 2);

% Customize plot
ylabel('duration50to50');
xticks([-0.05, 1.05]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('duration50to50 Perivascular x NonPerivascular');
% Increase y-axis range
max(duration50to50(:));
min(duration50to50(:));
ylim([0, 160]);

% Perform t-test
[h, p_value] = ttest2(data_group_0, data_group_2);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(p_value)]);

% Add p-value to the graph
text(0.5, 150, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');

%% dFF_AUC Perivascular x Non-Perivascular FIX VARIABLES

% Extract data from the table
dFF_AUCbyLocation = combinedTable{:, [11,13]};
cellLocation = dFF_AUCbyLocation(:,2);
dFF_AUC = dFF_AUCbyLocation(:,1);

data_group_0 = dFF_AUC(group_0_indices); % Data points belonging to group 0
data_group_2 = dFF_AUC(group_2_indices); % Data points belonging to group 2

% Plot scatterplot with jitter
figure;
scatter(repmat(0 - x_spacing_factor, sum(group_0_indices), 1) + jitter_0, data_group_0, 'bo'); hold on;
scatter(repmat(1 + x_spacing_factor, sum(group_2_indices), 1) + jitter_2, data_group_2, 'ro');

% Calculate mean of each group
mean_perivascular = mean(data_group_0);
mean_nonPerivascular = mean(data_group_2);

% Plot means
plot(0 - x_spacing_factor, mean_perivascular, 'bx', 'MarkerSize', 20, 'LineWidth', 2);
plot(1 + x_spacing_factor, mean_nonPerivascular, 'rx', 'MarkerSize', 20, 'LineWidth', 2);

% Customize plot
ylabel('AUCdFF');
xticks([-0.05, 1.05]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('AUCdFF Perivascular x NonPerivascular');
% Increase y-axis range
max(dFF_AUC(:));
min(dFF_AUC(:));
ylim([0, 200]);

% Perform t-test
[h, p_value] = ttest2(data_group_0, data_group_2);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(p_value)]);

% Add p-value to the graph
text(0.5, 190, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');


%% dat_AUC Perivascular x Non-Perivascular

% Extract data from the table
dat_AUCbyLocation = combinedTable{:, [10,13]};
dat_AUC = dat_AUCbyLocation(:,1);

data_group_0 = dat_AUC(group_0_indices); % Data points belonging to group 0
data_group_2 = dat_AUC(group_2_indices); % Data points belonging to group 2

% Plot scatterplot with jitter
figure;
scatter(repmat(0 - x_spacing_factor, sum(group_0_indices), 1) + jitter_0, data_group_0, 'bo'); hold on;
scatter(repmat(1 + x_spacing_factor, sum(group_2_indices), 1) + jitter_2, data_group_2, 'ro');

% Calculate mean of each group
mean_perivascular = mean(data_group_0);
mean_nonPerivascular = mean(data_group_2);

% Plot means
plot(0 - x_spacing_factor, mean_perivascular, 'bx', 'MarkerSize', 20, 'LineWidth', 2);
plot(1 + x_spacing_factor, mean_nonPerivascular, 'rx', 'MarkerSize', 20, 'LineWidth', 2);

% Customize plot
ylabel('AUCdat');
xticks([-0.05, 1.05]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('AUCdat Perivascular x NonPerivascular');
% Increase y-axis range
max(dat_AUC(:));
min(dat_AUC(:));
ylim([2e+04, 1.5e+06]);

% Perform t-test
[h, p_value] = ttest2(data_group_0, data_group_2);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(p_value)]);

% Add p-value to the graph
text(0.5, 1.3e+06, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');

%% INCOMPLETE - Assuming your data is stored in a table named 'data'
% And assuming your variables are stored in columns 'Var1', 'Var2', etc.

logicalIndex0 = cellLocation == 0; %perivascular
rowsWithValue0 = combinedTable(logicalIndex0, :);
dataPerivascular = rowsWithValue0{:, 2:14};

logicalIndex2 = cellLocation == 2; %non-perivascular
rowsWithValue2 = combinedTable(logicalIndex2, :);
dataNonPerivascular = rowsWithValue2{:, 2:14};

% Get the names of variables (columns) in your data table
variable_namesPlot = combinedTable.Properties.VariableNames(2:12);

% Remove the 'Label' column from variable_names
variable_namesPlot = variable_namesPlot(~strcmp(variable_namesPlot, 'Label'));

% Set the number of variables and the width of each bar
num_variables = numel(variable_namesPlot);
bar_width = 0.35;

% Initialize the figure
figure;
hold on;

% Plot bar graphs for each variable
for i = 1:num_variables
    % Calculate x positions for bars
    x0 = i - bar_width/2;
    x2 = i + bar_width/2;
    
    % Plot bars for cells labeled 0
    bar(x0, mean(dataPerivascular(:,i)), bar_width, 'FaceColor', 'b');
    errorbar(x0, mean(dataPerivascular(:,i)), std(dataPerivascular(:,i)), '.', 'Color', 'k');

    % Plot bars for cells labeled 2
    bar(x2, mean(dataNonPerivascular(:,i)), bar_width, 'FaceColor', 'r');
    errorbar(x2, mean(dataNonPerivascular(:,i)), std(dataNonPerivascular(:,i)), '.', 'Color', 'k');
end

% Customize the plot
title('Mean of Variables for Cells labeled 0 and 2');
xlabel('Variables');
ylabel('Mean Value');
xticks(1:num_variables);
xticklabels(variable_names);
xtickangle(45); % Rotate x-axis labels for better visibility
legend('Perivascular', 'NonPerivascular');
grid on;

hold off;

%% Correlation between max_dFF and duration10to10

% Calculate correlation coefficients
corr_perivascular = corrcoef(max_dFF_perivascular, duration10to10_perivascular);
corr_nonPerivascular = corrcoef(max_dFF_nonPerivascular, duration10to10_nonPerivascular);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(duration10to10_perivascular, max_dFF_perivascular, 50, 'r', 'filled'); % Group 1 in blue
scatter(duration10to10_nonPerivascular, max_dFF_nonPerivascular, 50, 'b', 'filled'); % Group 2 in red

% Customize the plot
xlabel('duration 10to10');
ylabel('Max dFF');
%title('Correlation between Max dFF and Rising Time');
legend({['Perivascular (corr: ', num2str(corr_perivascular(1,2)), ')'], ['NonPerivascular (corr: ', num2str(corr_nonPerivascular(1,2)), ')']});
grid on;
hold off;

%% Correlation between max_dFF and numberOfEvents

% Calculate correlation coefficients
corr_perivascular = corrcoef(numberOfEvents_perivascular, max_dFF_perivascular);
corr_nonPerivascular = corrcoef(numberOfEvents_nonPerivascular, max_dFF_nonPerivascular);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(numberOfEvents_perivascular, max_dFF_perivascular, 50, 'r', 'filled'); % Group 1 in blue
scatter(numberOfEvents_nonPerivascular, max_dFF_nonPerivascular, 50, 'b', 'filled'); % Group 2 in red

% Customize the plot
xlabel('Number of Events');
ylabel('Max dFF');
%title('Correlation between Max dFF and Rising Time');
legend({['Perivascular (corr: ', num2str(corr_perivascular(1,2)), ')'], ['NonPerivascular (corr: ', num2str(corr_nonPerivascular(1,2)), ')']});
grid on;
hold off;

%% Correlation between max_dFF and area

% Calculate correlation coefficients
corr_perivascular = corrcoef(area_perivascular, max_dFF_perivascular);
corr_nonPerivascular = corrcoef(area_nonPerivascular, max_dFF_nonPerivascular);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(area_perivascular, max_dFF_perivascular, 50, 'r', 'filled'); % Group 1 in blue
scatter(area_nonPerivascular, max_dFF_nonPerivascular, 50, 'b', 'filled'); % Group 2 in red

% Customize the plot
xlabel('Area');
ylabel('Max dFF');
%title('Correlation between Max dFF and Rising Time');
legend({['Perivascular (corr: ', num2str(corr_perivascular(1,2)), ')'], ['NonPerivascular (corr: ', num2str(corr_nonPerivascular(1,2)), ')']});
grid on;
hold off;

%% Correlation between max_dFF and circularity

% Calculate correlation coefficients
corr_perivascular = corrcoef(circularity_perivascular, max_dFF_perivascular);
corr_nonPerivascular = corrcoef(circularity_nonPerivascular, max_dFF_nonPerivascular);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(circularity_perivascular, max_dFF_perivascular, 50, 'r', 'filled'); % Group 1 in blue
scatter(circularity_nonPerivascular, max_dFF_nonPerivascular, 50, 'b', 'filled'); % Group 2 in red

% Customize the plot
xlabel('Circularity');
ylabel('Max dFF');
%title('Correlation between Max dFF and Rising Time');
legend({['Perivascular (corr: ', num2str(corr_perivascular(1,2)), ')'], ['NonPerivascular (corr: ', num2str(corr_nonPerivascular(1,2)), ')']});
grid on;
hold off;

%% Correlation between perimeter and area

% Extract data from the table
perimeter = combinedTable{:,3};
perimeter_perivascular = perimeter(perivascular_indices); % Data points belonging to group 0
perimeter_nonPerivascular = perimeter(nonPerivascular_indices); % Data points belonging to group 2

% Calculate correlation coefficients
corr_perivascular = corrcoef(perimeter_perivascular, area_perivascular);
corr_nonPerivascular = corrcoef(perimeter_nonPerivascular, area_nonPerivascular);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(perimeter_perivascular, area_perivascular, 50, 'r', 'filled'); % Group 1 in blue
scatter(perimeter_nonPerivascular, area_nonPerivascular, 50, 'b', 'filled'); % Group 2 in red

% Customize the plot
xlabel('Perimeter');
ylabel('Area');
%title('Correlation between Max dFF and Rising Time');
legend({['Perivascular (corr: ', num2str(corr_perivascular(1,2)), ')'], ['NonPerivascular (corr: ', num2str(corr_nonPerivascular(1,2)), ')']});
grid on;
hold off;

%% Correlation between area and number of events

% Calculate correlation coefficients
corr_perivascular = corrcoef(area_perivascular, numberOfEvents_perivascular);
corr_nonPerivascular = corrcoef(area_nonPerivascular, numberOfEvents_nonPerivascular);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(area_perivascular, numberOfEvents_perivascular, 50, 'r', 'filled'); % Group 1 in blue
scatter(area_nonPerivascular, numberOfEvents_nonPerivascular, 50, 'b', 'filled'); % Group 2 in red

% Customize the plot
xlabel('Area');
ylabel('Number of Events');
%title('Correlation between Max dFF and Rising Time');
legend({['Perivascular (corr: ', num2str(corr_perivascular(1,2)), ')'], ['NonPerivascular (corr: ', num2str(corr_nonPerivascular(1,2)), ')']});
grid on;
hold off;

%% dFF waves

for perivascularCell = 1:size(rowsWithValue0,1)
    figure;
    dFF_graph = rowsWithValue0.dFF{perivascularCell,1};
    plot(dFF_graph);
    title(rowsWithValue0.fileNameColumn(perivascularCell), 'Interpreter','none');
    ylabel(rowsWithValue0.('Cell ID')(perivascularCell));
end
