function [columnsToMedian, eventMedians] = calculateEventMedian(paramTables)
    % calculateEventAverages - Calculate median number of events by FOV and classify event trends
    %
    % Syntax: paramTables_all_byFOV = calculateEventAverages(paramTables)
    %
    % Inputs:
    %   paramTables - A table with a column 'NumberOfEvents', containing cell arrays of event data.
    %
    % Outputs:
    %   paramTables_all_byFOV - A matrix with the medians for each column and classified event trends.

    % Initialize the output matrix
    eventMedians = [];

    % Replace `[]` with NaN to handle missing values
    events_byFOV = table2cell(paramTables.NumberOfEvents);
    emptyCells = cellfun(@isempty, events_byFOV);
    events_byFOV(emptyCells) = {NaN};

    % Convert the relevant columns to a numeric matrix, ignoring NaN values
    columnsToMedian = cell2mat(events_byFOV(:, 2:5));

    % Compute the average for each column, ignoring NaN values
    eventMedians = median(columnsToMedian, 1, 'omitnan');

    % Logical conditions for classification of events
    risingEvents = eventMedians(3) > 1.25 * eventMedians(1);
    decreasingEvents = eventMedians(3) < 0.75 * eventMedians(1);
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
    eventMedians = array2table(eventMedians, 'VariableNames', {'PreCSD', 'DuringCSD', 'PostCSD', 'Trend'});
    eventMedians.Trend = trend;
end
