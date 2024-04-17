% Assuming your data is stored in a table named 'data'
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

