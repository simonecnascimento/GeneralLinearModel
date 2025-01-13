function createParameterCSV(cleanedData, classifiedData, parameter, outputDir)
    % Add classifications to the cleaned data and create tables
    allPhasesTable = array2table(cleanedData.allPhases, ...
        'VariableNames', {'preCSD', 'duringCSD', 'postCSD', 'cellType'});
    allPhasesTable.Classification = classifiedData.allPhases;

    preDuringTable = array2table(cleanedData.pre_duringCSD, ...
        'VariableNames', {'preCSD', 'duringCSD', 'cellType'});
    preDuringTable.Classification = classifiedData.pre_duringCSD;

    prePostTable = array2table(cleanedData.pre_postCSD, ...
        'VariableNames', {'preCSD', 'postCSD', 'cellType'});
    prePostTable.Classification = classifiedData.pre_postCSD;

    % Save CSV files
    writetable(allPhasesTable, fullfile(outputDir, [parameter '_allPhases.csv']));
    writetable(preDuringTable, fullfile(outputDir, [parameter '_preDuringCSD.csv']));
    writetable(prePostTable, fullfile(outputDir, [parameter '_prePostCSD.csv']));
end
