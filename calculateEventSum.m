function [columnsToSum, eventSums] = calculateEventSum(paramTables)
    % calculateEventSum - Calculate sum of events by FOV and classify event trends
    %
    % Syntax: [columnsToSum, eventSums] = calculateEventSum(paramTables)
    %
    % Inputs:
    %   paramTables - A table with a column 'NumberOfEvents', containing cell arrays of event data.
    %
    % Outputs:
    %   columnsToSum - Numeric matrix of event sums for each FOV.
    %   eventSums - A table with the total sum for each column and classified event trends.

    % Replace `[]` with NaN to handle missing values
    events_byFOV = table2cell(paramTables.NumberOfEvents);
    emptyCells = cellfun(@isempty, events_byFOV);
    events_byFOV(emptyCells) = {NaN};

    % Convert the relevant columns to a numeric matrix, ignoring NaN values
    columnsToSum = cell2mat(events_byFOV(:, 2:5));

    % Compute the sum for each column, ignoring NaN values
    eventSums = sum(columnsToSum, 1, 'omitnan');

    % Logical conditions for classification of events
    risingEvents = eventSums(3) > 1.25 * eventSums(1);
    decreasingEvents = eventSums(3) < 0.75 * eventSums(1);
    noChangeEvents = ~(risingEvents || decreasingEvents);

    % Determine the classification as a string
    if risingEvents
        trend = "rising";
    elseif decreasingEvents
        trend = "decreasing";
    else
        trend = "no change";
    end

    % Create a table for the output
    eventSums = array2table(eventSums, 'VariableNames', {'PreCSD', 'DuringCSD', 'PostCSD', 'Trend'});
    eventSums.Trend = trend;
end
