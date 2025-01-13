function [cleanedData, classifiedData, classifiedTable] = processAndClassify(inputTable)
    % Extract relevant columns
    myTable_all = inputTable(:, 2:6);

    % Replace empty cells with NaN
    for i = 1:width(myTable_all)
        if iscell(myTable_all{:, i})
            emptyRows = cellfun(@(x) isempty(x) || isequal(size(x), [0 0]), myTable_all{:, i});
            myTable_all{emptyRows, i} = {NaN};
        end
    end

    % Create phase-specific tables
    myTable_allPhases = myTable_all(:, [1,2,3,5]); %
    myTable_pre_duringCSD = myTable_all(:, [1, 2, 5]);
    myTable_pre_postCSD = myTable_all(:, [1, 3, 5]);
    myTable_during_postCSD = myTable_all(:, [2, 3, 5]);
    myTable_baseline_preCSD = myTable_all(:, [4, 5]);

%    myTable_allPhases2 = myTable_allPhases(:, 1:3); % duplicate to remove baseline_preCSD which is for a different analysis

    % Convert tables to numeric matrices
    myTable_allPhases = cellfun(@double, table2cell(myTable_allPhases));
    myTable_pre_duringCSD = cellfun(@double, table2cell(myTable_pre_duringCSD));
    myTable_pre_postCSD = cellfun(@double, table2cell(myTable_pre_postCSD));
    myTable_during_postCSD = cellfun(@double, table2cell(myTable_during_postCSD));
    myTable_baseline_preCSD = cellfun(@double, table2cell(myTable_baseline_preCSD));

    % Filter rows with valid data in all columns
    allPhases_cleanedData = myTable_allPhases(all(~isnan(myTable_allPhases), 2), :);
    pre_during_cleanedData = myTable_pre_duringCSD(all(~isnan(myTable_pre_duringCSD), 2), :);
    pre_post_cleanedData = myTable_pre_postCSD(all(~isnan(myTable_pre_postCSD), 2), :);
    during_post_cleanedData = myTable_during_postCSD(all(~isnan(myTable_during_postCSD), 2), :);
    baseline_preCSD_cleanedData = myTable_baseline_preCSD(all(~isnan(myTable_baseline_preCSD), 2), :);

    % Store cleaned data
    cleanedData.allPhases = allPhases_cleanedData;
    cleanedData.pre_duringCSD = pre_during_cleanedData;
    cleanedData.pre_postCSD = pre_post_cleanedData;
    cleanedData.during_postCSD = during_post_cleanedData;
    cleanedData.baseline_preCSD = baseline_preCSD_cleanedData;

    % Classify rows
    [classifiedData.allPhases, classifiedTable.allPhases] = classifyAllCategories(allPhases_cleanedData);
    [classifiedData.pre_duringCSD, classifiedTable.pre_duringCSD] = classifyAllCategories(pre_during_cleanedData);
    [classifiedData.pre_postCSD, classifiedTable.pre_postCSD] = classifyAllCategories(pre_post_cleanedData);
    [classifiedData.during_postCSD, classifiedTable.during_postCSD] = classifyAllCategories(during_post_cleanedData);
end
