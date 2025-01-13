function correlationBetweenEventDurationAndNumberSimultaneousEvents = computeEventDurationCorrelation(eventDuration_simultaneousEvents_all)
    % Function to compute the correlation between event duration and the number 
    % of simultaneous events across experiments.
    %
    % Inputs:
    %   eventDuration_simultaneousEvents_all - Cell array containing data
    %     from all experiments. Each cell corresponds to an experiment, where 
    %     column 1 contains event durations, and column 2 contains arrays of 
    %     simultaneous events.
    %
    % Outputs:
    %   correlation - Correlation value between event duration and the number
    %     of simultaneous events.
    
    % Remove the first experiment (assumes it only has 1 cell)
    eventDuration_simultaneousEvents_allExperiments = eventDuration_simultaneousEvents_all(2:end);
    
    % Concatenate data from all experiments
    eventDuration_simultaneousEvents_allExperiments2 = [];
    for expt = 1:size(eventDuration_simultaneousEvents_allExperiments, 1)
        data = eventDuration_simultaneousEvents_allExperiments{expt};
        eventDuration_simultaneousEvents_allExperiments2 = [eventDuration_simultaneousEvents_allExperiments2; data];
    end
    
    % Convert the first column (event durations) to a numeric array
    durationEvent = cell2mat(eventDuration_simultaneousEvents_allExperiments2(:, 1));
    
    % Compute the number of elements in column 2 for each row
    numSimultaneousEvents = cellfun(@numel, eventDuration_simultaneousEvents_allExperiments2(:, 2));
    
    % Compute correlation
    correlationValue = corr(durationEvent, numSimultaneousEvents, 'Rows', 'complete');
    
    % Display the correlation
    disp(['Correlation between event duration and number of simultaneous events: ' num2str(correlationValue)]);
    
    % Plot the results
    figure;
    scatter(durationEvent, numSimultaneousEvents, 'filled');
    xlabel('Event Duration');
    ylabel('Number of Simultaneous Events');
    title(['Correlation: ' num2str(correlationValue)]);
    
    % Return the correlation
    correlationBetweenEventDurationAndNumberSimultaneousEvents = correlationValue;
end
