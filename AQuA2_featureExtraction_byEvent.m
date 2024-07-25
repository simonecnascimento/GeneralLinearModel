%% Load .mat files  (FULL CRANIOTOMY)

clear all

% Change you Current Folder - fullCraniotomy
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\_analysisByEvent.mat

% Initialize an empty table
table = table();

% fullCraniotomy
FilesAll = {
'Pf4Ai162-2_221130_FOV6_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-10_230628_FOV1_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-10_230628_FOV2_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-10_230628_FOV3_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',... 
'Pf4Ai162-10_230628_FOV4_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-10_230628_FOV5_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',... 
'Pf4Ai162-10_230628_FOV7_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-10_230628_FOV8_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-11_230630_FOV1_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-11_230630_FOV2_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-11_230630_FOV3_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-11_230630_FOV4_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-11_230630_FOV5_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-11_230630_FOV6_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-11_230630_FOV8_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-11_230630_FOV9_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV1_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV2_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV3_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV4_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV5_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV7_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV8_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV9_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV10_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV1_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV2_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV4_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV5_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV6_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV7_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV8_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-18_240221_FOV1_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-20_240229_FOV1_reg_green_Substack(1-927)_analysisByEvent.mat'};

%% Load .mat files  (THIN BONE)

% Change you Current Folder - thinBone
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\thinBone\_analysisByEvent.mat

% Initialize an empty table
table = table();

% thinBone
FilesAll = {
'Pf4Ai162-5_230502_FOV2_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-6_230502_FOV2_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-6_230502_FOV4_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-8_230614_FOV1_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-8_230614_FOV2_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-8_230614_FOV3_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-8_230614_FOV4_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-8_230614_FOV5_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-8_230614_FOV7_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-9_230614_FOV4_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-9_230614_FOV5_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat'};

%% extract propagation
for i = 1:length(FilesAll)
    
    % Load the .mat file
    data = load(FilesAll{i});
    features = data.resultsRaw.Row;
    
    % Extract feature from the structure (assuming variable names are consistent across files)
    resultData = rows2vars(data.resultsExpanded);

    % Convert the table to an array
    resultArray = table2array(data.resultsExpanded);
    resultData = resultArray';
    
    propagationDistance = data.propagationDistance;
    duration = data.duration50to50;
    propagationSpeed = data.speedEvent;

    % Create a column with the filename
    fileNameColumn = repelem(FilesAll(i), size(propagationSpeed, 1), 1); % Repeat filename for each row
       
    % Append resultData to combinedTable
    table = [table; propagationSpeed, propagationDistance, duration, table(fileNameColumn)];
end

%% Outliers
% Calculate the Z-score for the data
zScores = zscore(propagationTable.Speed);

% Identify outliers (e.g., Z-score > 3 or < -3)
outliersZscore = abs(zScores) > 2; %score within 2 standard deviations

numOutliers = sum(outliersZscore);

% Display the number of outliers
outliers_Speed = isoutlier(propagationTable.Speed);


%% Propagation compare fullCraniotomy vs thinBone

notOutliers_thinBone = outliersZscore==0;
propagation_thinBone = propagationTable.Speed(notOutliers_thinBone);

% Perform t-test
[h, propagation_p_value] = ttest2(propagation_fullCraniotomy, propagation_thinBone);

figure;
barColors = [1 0 0; 0 0 1];
violin({propagation_fullCraniotomy, propagation_thinBone}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Propagation speed (um/s)', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([-5, 20]);
xticks([1, 2]);
xticklabels({'fullCraniotomy', 'thinBone'});

min(propagation_thinBone)


%% extract network spatial density

for experiment = 1:length(FilesAll)
    
    % Load analysis .mat file
    data_analysis = load(FilesAll{experiment});
    features = data_analysis.resultsRaw.Row;
    results_complete = data_analysis.resultsRaw.Variables;

    % AQuA2 directory 
    fileTemp_parts = strsplit(data_analysis.filename, '_');
    aqua_directory = fullfile('D:\2photon\Simone\Simone_Macrophages\', ...
        fileTemp_parts{1,1}, '\', ...
        [fileTemp_parts{1,2} '_' fileTemp_parts{1,3}], '\AQuA2\', ...
        [fileTemp_parts{1,1} '_' fileTemp_parts{1,2} '_' fileTemp_parts{1,3} '_run1_reg_Z01_green_Substack(1-927)']);
    AquA_fileName = [data_analysis.filename '_AQuA2.mat'];

%         fileTemp_parts = strsplit(data_analysis.filename, '_');
%     aqua_directory = fullfile('D:\2photon\Simone\Simone_Macrophages\', ...
%         fileTemp_parts{1,1}, '\', ...
%         [fileTemp_parts{1,2} '_' fileTemp_parts{1,3}], '\AQuA2\', ...
%         [fileTemp_parts{1,1} '_' fileTemp_parts{1,2} '_' fileTemp_parts{1,3} '_reg_green_Substack(1-927)']);
%     AquA_fileName = [data_analysis.filename '_AQuA2.mat'];

    % Load AQuA2.mat file 
    fullFilePath = fullfile(aqua_directory, AquA_fileName);
    data_aqua = load(fullFilePath);

    % get network data from aqua
    numberOfSimultanousEvents = num2cell(data_aqua.res.fts1.networkAll.nOccurSameTime);
    simultaneousEvents_all = data_aqua.res.fts1.networkAll.occurSameTimeList;
    % add column for cell number of that specific event
    cellNumber = cell(height(simultaneousEvents_all),1);
    % add column for cell number of that specific event
    cellMap = cell(height(simultaneousEvents_all),1);
    % duplicate occurSameTimeList to later on remove events that belong to current cell
    simultaneousEvents_fromDifferentCell = simultaneousEvents_all;
    % add column for cell number of that specific event
    cellNumber_network = cell(height(simultaneousEvents_all),1);
    % add column for maps of cells with simultaneous events
    cellMap_network = cell(height(simultaneousEvents_all),1);
    % add column for cell number of that specific event
    cellNumber_all = cell(height(simultaneousEvents_all),1);
    % add column for maps of cells with simultaneous events
    cellMap_all = cell(height(simultaneousEvents_all),1);
    % add column for propagation map of event
    propagationMap_event = cell(height(simultaneousEvents_all),1);
    % add column for propagation map of simultaneous events
    propagationMap_eventNetwork = cell(height(simultaneousEvents_all),1);
    % add column for cellMap and network of simultaneous events
    propagationMap_eventNetwork = cell(height(simultaneousEvents_all),1);


    % create a table with network results
    networkData = [propagationMap_event, cellNumber, cellMap, numberOfSimultanousEvents, simultaneousEvents_all, cellNumber_all, cellMap_all, simultaneousEvents_fromDifferentCell, propagationMap_eventNetwork, cellNumber_network, cellMap_network];
    networkData = cell2table(networkData);
    networkData.Properties.VariableNames = {'propagationMap_event','cellNumber', 'cellMap', 'numberOfSimultanousEvents', 'simultaneousEvents_all', 'cellNumber_all', 'cellMap_all', 'simultaneousEvents_fromDifferentCell', 'propagationMap_eventNetwork', 'cellNumber_network', 'cellMap_network'};
      
    % CFU directory
    CFU_directory = fullfile('D:\2photon\Simone\Simone_Macrophages\', ...
        fileTemp_parts{1,1}, '\', ...
        [fileTemp_parts{1,2} '_' fileTemp_parts{1,3}], '\AQuA2\');
    CFU_fileName = [data_analysis.filename '_AQuA_res_cfu.mat'];
    
    % Load CFU.mat file 
    CFU_FilePath = fullfile(CFU_directory, CFU_fileName);
    data_CFU = load(CFU_FilePath);

    for currentEvent = 1:size(networkData,1)

        % find the propagation matrix related to the current event
        propagationMatrix = data_aqua.res.riseLst1{1, currentEvent}.dlyMap50;
        networkData.propagationMap_event{currentEvent}{end+1} = propagationMatrix;
    
        % find the cell related to the current event
        cellIndex = find(cellfun(@(c) any(c == currentEvent), data_CFU.cfuInfo1(:, 2)));
        networkData.cellNumber{currentEvent} = cellIndex;

%         if ~isempty(cellIndex)
%             if isempty(networkData.cellNumber{currentEvent})
%                 networkData.cellNumber{currentEvent} = cellIndex;
%             else
%                 networkData.cellNumber{currentEvent} = [networkData.cellNumberList{currentEvent}, cellIndex];
%             end
%         end
% 
        % Get map of the cell of current event
        cellMap = data_CFU.cfuInfo1{cellIndex, 3};
        networkData.cellMap{currentEvent}{end+1} = cellMap;

        % Find list of simultaneous events related to that event
        simultaneousEvents = networkData.simultaneousEvents_all{currentEvent};

        % Remove the current event from simultaneous events
        simultaneousEvents(simultaneousEvents == currentEvent) = [];
        % Update the networkData table with the modified list
        networkData.simultaneousEvents_fromDifferentCell{currentEvent} = simultaneousEvents;
        
%         % Loop through each row in data_CFU.cfuInfo1
%         for cellRow = 1:size(data_CFU.cfuInfo1, 1)
% 
%             % Extract the cell number and the list of cell events
%             cellNumber = data_CFU.cfuInfo1{cellRow, 1};
%             cellEvents = data_CFU.cfuInfo1{cellRow, 2};
% 
%             % Check if the currentEvent is in the list of cellEvents
%             if ismember(currentEvent, cellEvents)
%                 networkData.cellNumberList_network{currentEvent,1} = cellNumber;
%                 break;  % Exit the loop once we find the corresponding first column value
%             end
%         end
       
        % Initialize an array to store indices of simultaneousEvents to remove
        indicesToRemove = [];

        for x = 1:length(simultaneousEvents)
            simultaneousEvent = simultaneousEvents(x);
    
            % Check if the simultaneous event is in the list of cellEvents
            if ismember(simultaneousEvent, data_CFU.cfuInfo1{cellIndex, 2})
                % Add the index to the list of indices to remove
                indicesToRemove = [indicesToRemove, x];
            end
    
            % Find the cell of the specific event
            cellIndex_network = find(cellfun(@(c) any(c == simultaneousEvent), data_CFU.cfuInfo1(:, 2)));

            if ~isempty(cellIndex_network)
                if isempty(networkData.cellNumber_network{currentEvent})
                    networkData.cellNumber_network{currentEvent} = cellIndex_network;
                else
                    networkData.cellNumber_network{currentEvent} = [networkData.cellNumber_network{currentEvent}, cellIndex_network];
                end
            end

            % Check if the cellMap entry for simultaneousEvent is empty and initialize if needed
            if isempty(networkData.cellMap_network{currentEvent})
                % Initialize networkData.cellMap{currentEvent} as a cell array of size 1x1
                networkData.cellMap_network{currentEvent} = {};
            end

            % find the propagation matrix related to the current event
            propagationMatrix_network = data_aqua.res.riseLst1{1, simultaneousEvent}.dlyMap50;
            networkData.propagationMap_eventNetwork{currentEvent}{end+1} = propagationMatrix_network;

            % Find the map of the simultaneousEvent to the cell array
            cellMap_network = data_CFU.cfuInfo1{cellIndex_network, 3};
            networkData.cellMap_network{currentEvent}{end+1} = cellMap_network;
        end
        
        % Remove the indices in reverse order to avoid out of range errors
        for i = length(indicesToRemove):-1:1
            networkData.simultaneousEvents_fromDifferentCell{currentEvent}(indicesToRemove(i)) = [];
        end
 
    end
end

    % save
    fileTemp = extractBefore(AquA_fileName, "_AQuA2"); 
    networkFilename = strcat(fileTemp, '_network.mat');
    save(networkFilename);




   