function createClassificationTable(cleanedData, classifiedData, outputFileName)
    % This function takes cleaned data and classified data, classifies the rows,
    % and creates a table with a classification column. It also saves the table as a CSV.
    %
    % Inputs:
    %   cleanedData - Struct containing the cleaned data (e.g., allPhases).
    %   classifiedData - Struct containing classification results (rising, decreasing, no change).
    %   outputFileName - The name of the CSV file to save the table (e.g., 'classifiedData.csv').
    
    % Create subsets for each classification (rising, decreasing, no change)
    risingData = cleanedData.allPhases(classifiedData.allPhases.rising, :);
    decreasingData = cleanedData.allPhases(classifiedData.allPhases.decreasing, :);
    nochangeData = cleanedData.allPhases(classifiedData.allPhases.nochange, :);

    % Create the classification column for each subset
    risingClassification = repmat({'rising'}, size(risingData, 1), 1);
    decreasingClassification = repmat({'decreasing'}, size(decreasingData, 1), 1);
    nochangeClassification = repmat({'no change'}, size(nochangeData, 1), 1);

    % Combine all the data into one table
    combinedData = [risingData; decreasingData; nochangeData];
    combinedClassification = [risingClassification; decreasingClassification; nochangeClassification];

    % Create the final table with classification column
    finalTable = array2table(combinedData, 'VariableNames', {'preCSD', 'duringCSD', 'postCSD', 'cellType'});
    finalTable.Classification = combinedClassification;

    % Save the final table to a CSV file
    writetable(finalTable, outputFileName);
    
    disp(['Table saved to: ', outputFileName]);
end
