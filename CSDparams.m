
function paramTables = CSDparams(eventsByCell_experiment, data, variablesNames)
% processParameterTables: Generate tables for each parameter, calculating averages.
%
% INPUTS:
%   eventsByCell_experiment - Table with cells and event indices.
%   data - Struct containing resultsRaw (parameters) table.
%   variablesNames - Cell array of parameter names.
%
% OUTPUT:
%   paramTables - Structure containing tables for each parameter.

    % Rows to iterate through (cell numbers)
    rowsToProcess = [eventsByCell_experiment{:,1}];

    % Convert resultsRaw to array and clean it
    tableResultsRaw = table2array(data.resultsRaw);
    tableResultsRaw([1,2,3,7,15:24],:) = []; % Remove unwanted rows

    % Initialize a structure to hold tables for each parameter
    paramTables = struct();

    % Iterate through parameters
    for p = 1:length(variablesNames)
        paramName = string(variablesNames{p});

        % Preallocate a table for the current parameter
        medianTable = cell2table(cell(length(rowsToProcess), 5), ...
            'VariableNames', {'CellNumber', 'preCSD', 'duringCSD', 'postCSD', 'cellType'});

        % Copy the cell numbers into the first column
        medianTable.CellNumber = eventsByCell_experiment(:,1);

        % Iterate through each row (cell)
        for rIdx = 1:length(rowsToProcess)

            rowIdx = rowsToProcess(rIdx); % Current row

            for colIdx = 2:4 % Columns: preCSD=2, duringCSD=3, postCSD=4
                evts = eventsByCell_experiment{rIdx, colIdx};

                % Check if indices are valid
                if ~isempty(evts)
                    % Retrieve parameter values from tableResultsRaw
                    evtsParam = cell2mat(tableResultsRaw(p, evts));

                    % Calculate and store the median in the respective column
                    medianTable{rIdx, colIdx} = {median(evtsParam(1,:))};%mean
                end
            end

            if ismember(rowIdx, data.perivascularCells)
                medianTable{rIdx,5} = {0}; %perivascular
            else
                medianTable{rIdx,5} = {2};
            end
        end

        % Assign the current table to the struct
        paramTables.(paramName) = medianTable;
    end
end
