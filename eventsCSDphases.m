function [eventsByCell_experiment, frameNumbers, indexes] = eventsCSDphases(data_analysis, preCSD_frames, duringCSD_frames, postCSD_frames, baseline_preCSD_frames)
% processCSDPhases: Filters and merges cell events across preCSD, duringCSD, and postCSD phases.
%
% INPUTS:
%   data - Struct containing:
%          - resultsRaw (parameters)
%          - cols_to_delete (invalid event indices)
%          - eventList (list of events per cell)
%          - cellList (list of cell numbers)
%          - cellsToMerge (indices of cells to combine)
%          - cellsToMergeCell (list of cells to remove after merging)
%   preCSD_frames - [lastFrame_preCSD]: Frame range for preCSD phase
%   duringCSD_frames - [firstFrame_duringCSD, lastFrame_duringCSD]: Frame range for duringCSD phase
%   postCSD_frames - [firstFrame_postCSD, lastFrame_postCSD]: Frame range for postCSD phase
%
% OUTPUT:
%   eventsByCell_experiment - Table with cells and filtered/merged events for each phase.

    % Extract frame numbers and indexes
    frameNumbers = cell2mat(data_analysis.resultsRaw{3, :});  % Row 3: Frame numbers
    indexes = cell2mat(data_analysis.resultsRaw{2, :});       % Row 2: Event indices

    % Baseline Pre-CSD Phase
    validIndexes_baseline_preCSD = indexes(frameNumbers >= baseline_preCSD_frames(1) & frameNumbers <= baseline_preCSD_frames(2)); %frameNumbers <= baseline_preCSD_frames
    if ~isempty(data_analysis.cols_to_delete)
        validIndexes_baseline_preCSD(ismember(validIndexes_baseline_preCSD, data_analysis.cols_to_delete)) = [];
    end
    filteredEventList_baseline_preCSD = filterEventList(data_analysis.eventList, validIndexes_baseline_preCSD);

    % Pre-CSD Phase
    validIndexes_preCSD = indexes(frameNumbers <= preCSD_frames);
    if ~isempty(data_analysis.cols_to_delete)
        validIndexes_preCSD(ismember(validIndexes_preCSD, data_analysis.cols_to_delete)) = [];
    end
    filteredEventList_preCSD = filterEventList(data_analysis.eventList, validIndexes_preCSD);

    % During-CSD Phase
    validIndexes_duringCSD = indexes(frameNumbers >= duringCSD_frames(1) & frameNumbers <= duringCSD_frames(2));
    if ~isempty(data_analysis.cols_to_delete)
        validIndexes_duringCSD(ismember(validIndexes_duringCSD, data_analysis.cols_to_delete)) = [];
    end
    filteredEventList_duringCSD = filterEventList(data_analysis.eventList, validIndexes_duringCSD);

    % Post-CSD Phase
    validIndexes_postCSD = indexes(frameNumbers >= postCSD_frames(1) & frameNumbers <= postCSD_frames(2));
    if ~isempty(data_analysis.cols_to_delete)
        validIndexes_postCSD(ismember(validIndexes_postCSD, data_analysis.cols_to_delete)) = [];
    end
    filteredEventList_postCSD = filterEventList(data_analysis.eventList, validIndexes_postCSD);

    % Combine Results into Table
    eventsByCell_experiment = [data_analysis.cellList, filteredEventList_preCSD, filteredEventList_duringCSD, filteredEventList_postCSD, filteredEventList_baseline_preCSD];

    % Merge Cells Based on `cellsToMerge`
    for m = 1:size(data_analysis.cellsToMerge, 1)
        % Extract cell indices to merge
        cellIndices = data_analysis.cellsToMerge(m, :);
        validIndices = ~isnan(cellIndices);
        validCellIndices = cellIndices(validIndices);

        % Combine events for preCSD, duringCSD, postCSD
        eventsByCell_experiment{validCellIndices(1), 2} = cat(1, eventsByCell_experiment{validCellIndices, 2}); % Pre-CSD
        eventsByCell_experiment{validCellIndices(1), 3} = cat(1, eventsByCell_experiment{validCellIndices, 3}); % During-CSD
        eventsByCell_experiment{validCellIndices(1), 4} = cat(1, eventsByCell_experiment{validCellIndices, 4}); % Post-CSD
        eventsByCell_experiment{validCellIndices(1), 5} = cat(1, eventsByCell_experiment{validCellIndices, 5}); % baseline_preCSD**
    end

    % Remove the extra CFUs
    cellsToMergeCell = cell(size(data_analysis.cellsToMerge));
    for i = 1:size(data_analysis.cellsToMerge, 1)
        for c = 1:size(data_analysis.cellsToMerge, 2)
            if isnan(data_analysis.cellsToMerge(i, c))
                cellsToMergeCell{i, c} = [];
            else
                cellsToMergeCell{i, c} = data_analysis.cellsToMerge(i, c);
            end
        end
    end
    valuesToRemove = cat(1,cellsToMergeCell{:, 2:end}); %valuesToRemove = cat(1,data_analysis.cellsToMergeCell{:, 2:end});
    eventsByCell_experiment(valuesToRemove, :) = [];
end

%% Helper Function to Filter Event List
function filteredEventList = filterEventList(eventList, validIndexes)
% Filters the event list to keep only valid indexes
    filteredEventList = cell(size(eventList));
    for a = 1:numel(eventList)
        if isnumeric(eventList{a}) % check if the entry is numeric
            filteredEventList{a} = eventList{a}(ismember(eventList{a}, validIndexes));
        end
    end
end