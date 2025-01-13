function [categories, classifiedTable] = classifyAllCategories(dataTable)
    % Classify rows into rising, decreasing, and noChange categories
    % Ensure there are at least two columns
    if size(dataTable, 2) < 2
        error('Table does not have enough columns for classification.');
    end

    % Logical conditions for classification
    isRising = dataTable(:, 2) > 1.25 * dataTable(:, 1);
    isDecreasing = dataTable(:, 2) < 0.75 * dataTable(:, 1);
    isNoChange = ~(isRising | isDecreasing);

    % Extract rows based on classification
    categories.increase = dataTable(isRising, :);
    categories.decrease = dataTable(isDecreasing, :);
    categories.noChange = dataTable(isNoChange, :);

     % Ensure that each category is a table (if not already)
    categories.increase = array2table(categories.increase);
    categories.decrease = array2table(categories.decrease);
    categories.noChange = array2table(categories.noChange);

    % Add the classification label in the 5th column for each category
    categories.increase.Classification = repmat({'increase'}, size(categories.increase, 1), 1);
    categories.decrease.Classification = repmat({'decrease'}, size(categories.decrease, 1), 1);
    categories.noChange.Classification = repmat({'noChange'}, size(categories.noChange, 1), 1);

%     % Define the variable names (you can adjust these based on your data)
%     variableNames = {'preCSD', 'duringCSD', 'postCSD', 'cellType', 'Classification'};
%     
%     % Set the variable names for each category
%     categories.rising.Properties.VariableNames = variableNames;
%     categories.decreasing.Properties.VariableNames = variableNames;
%     categories.noChange.Properties.VariableNames = variableNames;

    % Combine the categories back into a single table
    classifiedTable = [categories.increase; categories.decrease; categories.noChange];

end
