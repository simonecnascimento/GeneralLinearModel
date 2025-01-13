function plotCSDBoxplots(paramTables_allPhases_cleanedData, parameter, savePath)
  
    preCSD = paramTables_allPhases_cleanedData.(parameter)(:,1);
    duringCSD = paramTables_allPhases_cleanedData.(parameter)(:,2);
    postCSD = paramTables_allPhases_cleanedData.(parameter)(:,3);


    % Find the global min and max to align the y-axes
    ymin = min([preCSD; duringCSD; postCSD]);
    yMin = ymin - 0.2 * ymin;
    ymax = max([preCSD; duringCSD; postCSD]);
    yMax = ymax + 0.1 * ymax;

    % Create the boxplots for each condition
    CSDplot = figure;
    
    subplot(1,3,1); 
    boxplot(preCSD);
    title('Pre CSD');
    ylabel(parameter, 'FontSize', 15);
    ylim([yMin yMax]);
    
    subplot(1,3,2);  
    boxplot(duringCSD);
    title('During CSD');
    ylim([yMin yMax]);
    
    subplot(1,3,3);  
    boxplot(postCSD);
    title('Post CSD');
    ylim([yMin yMax]);

    % Save the figure
    if nargin > 2
        fileName = strcat('Boxplots_',  parameter);
        saveas(CSDplot, fullfile(savePath, fileName), 'png');
    end

end
