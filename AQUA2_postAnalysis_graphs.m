
%% Separate data points belonging to each group

cellLocation = combinedTable{:,13};
perivascular_indices = (cellLocation == 0); % Indices of cells belonging to group 0
nonPerivascular_indices = (cellLocation == 2); % Indices of cells belonging to group 2

% Convert numeric group labels to strings
group_str = cell(size(cellLocation));
group_str(cellLocation == 0) = {'Perivascular'};
group_str(cellLocation == 2) = {'NonPerivascular'};

% Add jitter to y-values
jitter_amount = 0.3; % Adjust the amount of jitter as needed
jitter_perivascular = (rand(sum(perivascular_indices), 1) - 0.5) * jitter_amount;
jitter_nonPerivascular = (rand(sum(nonPerivascular_indices), 1) - 0.5) * jitter_amount;

% Define spacing factor for x-axis data points
x_spacing_factor = 0.05; % Adjust as needed

%% Circularity Perivascular x Non-Perivascular

% Extract data from the table
circularity = combinedTable{:,4};
circularity_perivascular = circularity(perivascular_indices); % Data points belonging to group 0
circularity_nonPerivascular = circularity(nonPerivascular_indices); % Data points belonging to group 2

% Plot scatterplot with jitter
figure;
scatter(repmat(0, sum(perivascular_indices), 1) + jitter_perivascular, circularity_perivascular, 'bo'); hold on;
scatter(repmat(1, sum(nonPerivascular_indices), 1) + jitter_nonPerivascular, circularity_nonPerivascular, 'ro'); 

% Calculate mean of each group
mean_perivascular = mean(circularity_perivascular);
mean_nonPerivascular = mean(circularity_nonPerivascular);

% Plot means
plot(0, mean_perivascular, 'bx', 'MarkerSize', 20, 'LineWidth', 2);
plot(1, mean_nonPerivascular, 'rx', 'MarkerSize', 20, 'LineWidth', 2);

% Customize plot
ylabel('Circularity');
xticks([0 1]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('Circularity Perivascular x NonPerivascular');
% Increase y-axis range
ylim([0, 0.6]);

% Perform t-test
[h, p_value] = ttest2(circularity_perivascular, circularity_nonPerivascular);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(p_value)]);

% Add p-value to the graph
text(0.5, 0.5, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');


%% RedLabel Perivascular x NonPerivascular

redLabel = combinedTable{:,14};

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

%% Number of Events Perivascular x Non-Perivascular

numberOfEvents = combinedTable{:,12};
numberOfEvents_perivascular = numberOfEvents(perivascular_indices); % Data points belonging to group 0
numberOfEvents_nonPerivascular = numberOfEvents(nonPerivascular_indices); % Data points belonging to group 2

% % Identify outliers
% lower_threshold = mean_perivascular - 2 * std(numberOfEvents_perivascular); % Lower threshold
% upper_threshold = mean_perivascular + 2 * std(numberOfEvents_perivascular); % Upper threshold
% outliers_perivascular = numberOfEvents_perivascular < lower_threshold | numberOfEvents_perivascular > upper_threshold; % Outliers for group 0
% 
% lower_threshold = mean_nonPerivascular - 2 * std(numberOfEvents_nonPerivascular); % Lower threshold
% upper_threshold = mean_nonPerivascular + 2 * std(numberOfEvents_NonPerivascular); % Upper threshold
% outliers_nonPerivascular = numberOfEvents_nonPerivascular < lower_threshold | numberOfEvents_nonPerivascular > upper_threshold; % Outliers for group 2
% 
% % Plot outliers
% scatter(repmat(0, sum(outliers_perivascular), 1) + jitter_amount, numberOfEvents_perivascular(outliers_perivascular), 'g*', 'LineWidth', 2);
% scatter(repmat(1, sum(outliers_nonPerivascular), 1) + jitter_amount, numberOfEvents_nonPerivascular(outliers_nonPerivascular), 'g*', 'LineWidth', 2);

% Customize plot
legend('Perivascular', 'NonPerivascular', 'Mean Perivascular', 'Mean NonPerivascular', 'Outliers');

% Plot scatterplot with jitter
figure;
scatter(repmat(0, sum(Perivascular_indices), 1) + jitter_perivascular, numberOfEvents_Perivascular, 'bo'); hold on;
scatter(repmat(1, sum(NonPerivascular_indices), 1) + jitter_nonPerivascular, numberOfEvents_NonPerivascular, 'ro'); 

% Calculate mean of each group
mean_perivascular = mean(numberOfEvents_perivascular);
mean_nonPerivascular = mean(numberOfEvents_nonPerivascular);

% Plot means
plot(0, mean_perivascular, 'bx', 'MarkerSize', 20, 'LineWidth', 2);
plot(1, mean_nonPerivascular, 'rx', 'MarkerSize', 20, 'LineWidth', 2);

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
[h, p_value] = ttest2(numberOfEvents_perivascular, numberOfEvents_nonPerivascular);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(p_value)]);

% Add p-value to the graph
text(0.5, 35, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');

%% Area (um2) Perivascular x Non-Perivascular  

% Extract data from the table
area = combinedTable{:,2};
area_perivascular = area(perivascular_indices); 
area_nonPerivascular = area(nonPerivascular_indices);

% Customize plot
legend('Perivascular', 'NonPerivascular', 'Mean Perivascular', 'Mean NonPerivascular', 'Outliers');

% Plot scatterplot with jitter
figure;
scatter(repmat(0 - x_spacing_factor, sum(perivascular_indices), 1) + jitter_perivascular, area_perivascular, 'bo'); hold on;
scatter(repmat(1 + x_spacing_factor, sum(nonPerivascular_indices), 1) + jitter_nonPerivascular, area_nonPerivascular, 'ro');

% Calculate mean of each group
mean_perivascular = mean(area_perivascular);
mean_nonPerivascular = mean(area_nonPerivascular);

% Plot means
plot(0 - x_spacing_factor, mean_perivascular, 'bx', 'MarkerSize', 20, 'LineWidth', 2);
plot(1 + x_spacing_factor, mean_nonPerivascular, 'rx', 'MarkerSize', 20, 'LineWidth', 2);

% Customize plot
ylabel('Area (um2)');
xticks([-0.05, 1.05]); % Set x-axis ticks
xticklabels({'Perivascular', 'NonPerivascular'}); % Set x-axis tick labels
title('Area Perivascular x NonPerivascular');
% Increase y-axis range
max(area(:));
min(area(:));
ylim([100, 800]);

% Perform t-test
[h, p_value] = ttest2(area_perivascular, area_nonPerivascular);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(p_value)]);

% Add p-value to the graph
text(0.5, 750, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');

%% Event-based max_dFF Perivascular x Non-Perivascular    TO FIX VARIABLES

max_dFF = combinedTable{:,5};
max_dFF_perivascular = max_dFF(Perivascular_indices); % Data points belonging to group 0
max_dFF_nonPerivascular = max_dFF(NonPerivascular_indices); % Data points belonging to group 2

% Plot scatterplot with jitter
figure;
scatter(repmat(0 - x_spacing_factor, sum(perivascular_indices), 1) + jitter_0, data_group_0, 'bo'); hold on;
scatter(repmat(1 + x_spacing_factor, sum(nonPerivascular_indices), 1) + jitter_2, data_group_2, 'ro');

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
max(max_dFF(:));
min(max_dFF(:));
ylim([0, 7]);

% Perform t-test
[h, p_value] = ttest2(data_group_0, data_group_2);

% Display p-value
disp(['The p-value between Group 0 and Group 2 is: ', num2str(p_value)]);

% Add p-value to the graph
text(0.5, 6, ['p-value = ', num2str(p_value)], 'HorizontalAlignment', 'center');

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
scatter(duration10to10_perivascular, max_dFF_perivascular, 50, 'b', 'filled'); % Group 1 in blue
scatter(duration10to10_nonPerivascular, max_dFF_nonPerivascular, 50, 'r', 'filled'); % Group 2 in red

% Customize the plot
xlabel('duration 10to10');
ylabel('Max dFF');
title('Correlation between Max dFF and Rising Time');
legend({['Perivascular (corr: ', num2str(corr_perivascular(1,2)), ')'], ['NonPerivascular (corr: ', num2str(corr_nonPerivascular(1,2)), ')']});
grid on;
hold off;

%% Correlation between max_dFF and numberOfEvents

% Calculate correlation coefficients
corr_perivascular = corrcoef(max_dFF_perivascular, numberOfEvents_perivascular);
corr_nonPerivascular = corrcoef(max_dFF_nonPerivascular, numberOfEvents_nonPerivascular);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(numberOfEvents_perivascular, max_dFF_perivascular, 50, 'r', 'filled'); % Group 1 in blue
scatter(numberOfEvents_nonPerivascular, max_dFF_nonPerivascular, 50, 'b', 'filled'); % Group 2 in red

% Customize the plot
xlabel('Number of Events');
ylabel('Max dFF');
title('Correlation between Max dFF and Rising Time');
legend({['Perivascular (corr: ', num2str(corr_perivascular(1,2)), ')'], ['NonPerivascular (corr: ', num2str(corr_nonPerivascular(1,2)), ')']});
grid on;
hold off;
