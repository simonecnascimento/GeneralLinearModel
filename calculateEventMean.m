function [columnsToMean, eventMeans] = calculateEventMean(paramTables)
    % calculateEventMean - Calculate mean of events by FOV and classify event trends
    %
    % Syntax: [columnsToMean, eventMeans] = calculateEventMean(paramTables)
    %
    % Inputs:
    %   paramTables - A table with a column 'NumberOfEvents', containing cell arrays of event data.
    %
    % Outputs:
    %   columnsToMean - Numeric matrix of event means for each FOV.
    %   eventMeans - A table with the mean for each column and classified event trends.

    % Replace `[]` with NaN to handle missing values
    events_byFOV = table2cell(paramTables.NumberOfEvents);
    emptyCells = cellfun(@isempty, events_byFOV);
    events_byFOV(emptyCells) = {NaN};

    % Convert the relevant columns to a numeric matrix, ignoring NaN values
    columnsToMean = cell2mat(events_byFOV(:, 2:5));

    % Compute the mean for each column, ignoring NaN values
    eventMeans = mean(columnsToMean, 1, 'omitnan');

    % Logical conditions for classification of events
    risingEvents = eventMeans(3) > 1.25 * eventMeans(1);
    decreasingEvents = eventMeans(3) < 0.75 * eventMeans(1);
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
    eventMeans = array2table(eventMeans, 'VariableNames', {'PreCSD', 'DuringCSD', 'PostCSD', 'Trend'});
    eventMeans.Trend = trend;
end