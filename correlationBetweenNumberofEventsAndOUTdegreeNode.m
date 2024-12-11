function correlationBetweenNumberofEventsAndOUTdegreeNode = correlationBetweenNumberofEventsAndOUTdegreeNode(listOfEvents_perCell_nodeOUTdegree_all)

    % Remove the first experiment (assumes it only has 1 cell)
    listOfEvents_perCell_nodeOUTdegree_allExperiments = listOfEvents_perCell_nodeOUTdegree_all(2:end);
    
    % Concatenate data from all experiments
    listOfEvents_perCell_nodeOUTdegree_allExperiments2 = [];
    for expt = 1:size(listOfEvents_perCell_nodeOUTdegree_allExperiments, 1)
        data = listOfEvents_perCell_nodeOUTdegree_allExperiments{expt};
        listOfEvents_perCell_nodeOUTdegree_allExperiments2 = [listOfEvents_perCell_nodeOUTdegree_allExperiments2; data];
    end
    
    % Convert the first column (numberOfEvents) to a numeric array
    numberOfEvents = listOfEvents_perCell_nodeOUTdegree_allExperiments2(:, 1);
    
    % Compute the number of elements in column 2 for each row
    nodeOUTdegree = listOfEvents_perCell_nodeOUTdegree_allExperiments2(:, 2);
    
    % Compute correlation
    correlationValue = corr(numberOfEvents, nodeOUTdegree, 'Rows', 'complete');
    
    % Display the correlation
    disp(['Correlation between number of events and node outdegree: ' num2str(correlationValue)]);
    
    % Plot the results
    figure;
    scatter(numberOfEvents, nodeOUTdegree, 'filled');
    xlabel('Number of Events');
    ylabel('Node outdegree');
    title(['Correlation: ' num2str(correlationValue)]);
    
    % Return the correlation
    correlationBetweenNumberofEventsAndOUTdegreeNode = correlationValue;
end
