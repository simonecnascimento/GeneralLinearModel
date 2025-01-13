function correlationBetweenCellPairsAndEdge = correlationBetweenCellPairsAndEdge(cellPairs_edges_distanceMicron_all)
    % Extract columns 3 and 4 from the data
    col3 = cellPairs_edges_distanceMicron_all(:, 3);
    col4 = cellPairs_edges_distanceMicron_all(:, 4);
    
    % Compute the Pearson correlation between columns 3 and 4
    correlationBetweenCellPairsAndEdge = corr(col3, col4);
    r_squared = correlationBetweenCellPairsAndEdge^2;

    % Create scatter plot of the data points
    figure;
    scatter(col3, col4, 'b', 'DisplayName', 'Data points');
    hold on;
    
    % Label the axes and title
    xlabel('Average delay between cell events (sec)');
    ylabel('Distance between cell pairs (um)');
    title(sprintf('Regression Line (Correlation: %.4f)', correlationBetweenCellPairsAndEdge));

    % Display the correlation result
    fprintf('The correlation between column 3 and column 4 is: %.4f\n', correlationBetweenCellPairsAndEdge);
    fprintf('The coefficient of determination between column 3 and column 4 is: %.4f\n', r_squared);

end


% mean_allDelays = mean(cellPairs_edges_distanceMicron_all(:,3));
% figure;
% histogram(cellPairs_edges_distanceMicron_all(:,3), 'BinWidth', 5); % Adjust BinWidth as needed
% xlabel('Delay (sec)');
% ylabel('Frequency');
% title('Histogram of Delays');