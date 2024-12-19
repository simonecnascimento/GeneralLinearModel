%% Load .mat files 

clear all;

fullCraniotomyCSDDir = 'D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\CSD\corrected_for_pinprick\3._analysisByEvent.mat';
cd (fullCraniotomyCSDDir);

% Get all .mat files in the directory
FilesAll = dir(fullfile(fullCraniotomyCSDDir, '*_analysisByEvent.mat')); 

% Extract file names
fileNames = {FilesAll.name};

% Initialize an array to store the extracted parts for sorting
sortKey = [];

% Loop through all filenames to extract the parts for sorting
for file = 1:length(fileNames)
    filename = fileNames{file};
    
    % Extract the number after "Pf4Ai162-" (e.g., '2' from 'Pf4Ai162-2')
    numberAfterPrefix = sscanf(filename, 'Pf4Ai162-%d', 1);
    
    % Extract the date (e.g., '221130' from 'Pf4Ai162-2_221130_FOV6')
    dateStr = regexp(filename, '\d{6}', 'match', 'once');
    
    % Extract the FOV number (e.g., 'FOV6' from 'Pf4Ai162-2_221130_FOV6')
    fovNumber = sscanf(filename, 'Pf4Ai162-%*d_%*d_FOV%d', 1);
    
    % Store the extracted values in a matrix for sorting
    sortKey = [sortKey; numberAfterPrefix, str2double(dateStr), fovNumber];
end

% Sort by the three columns: numberAfterPrefix, date, fovNumber
[~, idx] = sortrows(sortKey);
sortedFileNames = fileNames(idx);

%% Extract and combine resultData from each experiment

variablesNames = {'Area', ...
            'Perimeter', ...
            'Circularity', ...
            'Max_dFF', ...
            'Duration50to50', ...
            'Duration10to10', ...
            'RisingDuration10to90', ...
            'DecayingDuration90to10',...
            'datAUC', ...
        	'dFFAUC'};

paramTables_all = [];

% Loop through each file
for file = 1:length(fileNames)

    % Load the .mat file
    data = load(fileNames{file});

    preCSD_frames = 1854;
    duringCSD_frames = [1855, 1917]; %60sec (ca. 62 frames)
    postCSD_frames = [1918, 3772];
    
    % separate events in pre, during and postCSD
    eventsByCell_experiment = eventsCSDphases(data, preCSD_frames, duringCSD_frames, postCSD_frames);

    % get median of parameters by CSD phase
    paramTables = CSDparams(eventsByCell_experiment, data, variablesNames);
    paramTables_all = [paramTables_all; paramTables];
end

%get name of columns/parameters
columnName = fieldnames(paramTables_all);

% Initialize the output structures
paramTables_allData = struct();
paramTables_allCleanedData = struct();

for param = 1:length(columnName)
    parameter = columnName{param};

    % Initialize an empty table to store concatenated data
    combinedTable = table(); % Initialize an empty table to store concatenated data

    for expt = 1:length(paramTables_all)
        currentTable = paramTables_all(expt).(parameter);
        combinedTable = [combinedTable; currentTable];
    end

    % Store the concatenated table in the output struct
    paramTables_allData.(parameter) = combinedTable;

    myTable = (paramTables_allData.(parameter)(:,2:5));
   
    % Replace empty cells with NaN for each column
    for i = 1:width(myTable)
    % Check if the column is a cell array
        if iscell(myTable{:, i})
            emptyRows = cellfun(@(x) isempty(x) || isequal(size(x), [0 0]), myTable{:, i});
            myTable{emptyRows, i} = {NaN};
        end
    end

    %Analyze only cells that are present on all 3 phases.    
    myTable = table2cell(myTable); % Convert table to cell array
    myTable = cellfun(@double, myTable);
    %myTable = cell2mat(myTable); % Convert cell array to matrix for processing
    allPhases_validRows = all(~isnan(myTable), 2); % Logical indexing to find rows without NaN
    allPhases_cleanedData = myTable(allPhases_validRows, :); % Keep only valid rows
    % Store the concatenated table in the output struct
    paramTables_allCleanedData.(parameter) = allPhases_cleanedData;

%     savePath = extractBefore(fullCraniotomyCSDDir, '\3.');
%     plotCSDBoxplots(myTable, parameter, savePath);
end
