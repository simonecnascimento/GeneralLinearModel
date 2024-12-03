%% Load .mat files  (FULL CRANIOTOMY BASELINE)

clear all;

% Change you Current Folder - fullCraniotomy
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\baseline\3._analysisByEvent.mat;

% Initialize an empty table
networkTable_all = table();

% fullCraniotomy
FilesAll = {
'Pf4Ai162-2_221130_FOV2_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
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
'Pf4Ai162-12_230717_FOV6_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV7_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV8_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV9_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-12_230717_FOV10_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV1_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV2_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV3_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV4_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV5_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV6_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV7_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-13_230719_FOV8_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-18_240221_FOV1_run1_reg_Z01_green_Substack(1-927)_analysisByEvent.mat',...
'Pf4Ai162-20_240229_FOV1_reg_green_Substack(1-927)_analysisByEvent.mat'};

%% Load .mat files  (THIN BONE BASELINE)

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

%% Load .mat files  (FULL CRANIOTOMY CSD)

% Change you Current Folder - thinBone
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\CSD\corrected_for_pinprick\1._analysis.mat;

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


%% extract network spatial density

% Initialize a cell array to store the upperTriAverages for each experiment, for distance between cells

allUpperTriValues = cell(length(FilesAll), 1); %distance between pair of cells
eventDuration_simultanenousEvents_all = cell(length(FilesAll), 1);

for experiment = 2:length(FilesAll)
    
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

%     fileTemp_parts = strsplit(data_analysis.filename, '_');
%     aqua_directory = fullfile('D:\2photon\Simone\Simone_Macrophages\', ...
%         fileTemp_parts{1,1}, '\', ...
%         [fileTemp_parts{1,2} '_' fileTemp_parts{1,3}], '\AQuA2\', ...
%         [fileTemp_parts{1,1} '_' fileTemp_parts{1,2} '_' fileTemp_parts{1,3} '_reg_green_Substack(1-927)']);
%     AquA_fileName = [data_analysis.filename '_AQuA2.mat'];

    % Load AQuA2.mat file 
    fullFilePath = fullfile(aqua_directory, AquA_fileName);
    data_aqua = load(fullFilePath);

    % FILL TABLE WITH CELL NUMBERS, MAPS, AND EVENTS PROPAGATIONS

    % get network data from aqua
    nSimultanousEvents = num2cell(data_aqua.res.fts1.networkAll.nOccurSameTime);
    simultaneousEvents_all = data_aqua.res.fts1.networkAll.occurSameTimeList;

    % Define the number of events
    numEvents = height(simultaneousEvents_all);

    % for current event
    propagationMap_event = cell(numEvents,1);
    % for cell corresponding the current event
    cellNumber_event = cell(numEvents,1);
    cellType_event = cell(numEvents,1);
    cellMap_event = cell(numEvents,1);
    
    % for all simultaneous events
    propagationMap_all = cell(numEvents,1);
    % for cells corresponding the all simultaneous events
    cellNumber_all = cell(numEvents,1);
    cellType_all = cell(numEvents,1);
    cellMap_all = cell(numEvents,1);
    % for cells corresponding the all simultaneous events, but without repeating cell numbers
    cellNumber_all_unique = cell(numEvents,1);
    cellMap_all_unique = cell(numEvents,1);

    % for events removing current Event
    simultaneousEvents_network = simultaneousEvents_all; %duplicate 
    simultaneousEvents_network_corrected = simultaneousEvents_all; %duplicate and remove any eventToDelete
    propagationMap_network = cell(numEvents,1);
    % for cell corresponding to events in the network
    cellNumber_network = cell(numEvents,1);
    cellType_network = cell(numEvents,1);
    cellMap_network = cell(numEvents,1);

    % combine propagation map of event to map of cell
    eventNetwork_cellMap_all = cell(numEvents,1);
    % calculate shortest distance between centers
    shortestDistanceBetweenCenters = cell(numEvents,1);

    % create a table with network results
    networkData = [propagationMap_event, cellNumber_event, cellType_event, cellMap_event, nSimultanousEvents, ...
        simultaneousEvents_all, propagationMap_all, cellNumber_all, cellType_all, cellMap_all, ...
        cellNumber_all_unique, cellMap_all_unique, eventNetwork_cellMap_all, shortestDistanceBetweenCenters, ...
        simultaneousEvents_network, simultaneousEvents_network_corrected, propagationMap_network, cellNumber_network, cellType_network, cellMap_network];
    networkData = cell2table(networkData);
    networkData.Properties.VariableNames = {'propagationMap_event','cellNumber_event', 'cellType_event','cellMap_event', 'nSimultanousEvents', ...
        'simultaneousEvents_all', 'propagationMap_all', 'cellNumber_all', 'cellType_all', 'cellMap_all', 'cellNumber_all_unique', 'cellMap_all_unique', 'eventNetwork_cellMap_all', 'shortestDistanceBetweenCenters', ...
        'simultaneousEvents_network', 'simultaneousEvents_network_corrected', 'propagationMap_network', 'cellNumber_network', 'cellType_network', 'cellMap_network'};
      
%     % Duplicate table to remove repetitive cells in the future
%     networkData_cleaned = networkData;
% %     cellNumbers = num2cell(networkData_cleaned{currentEvent, 'cellNumber_all'}{1}); % Assuming cellNumber_all is a cell array
% %     cellMaps = networkData_cleaned{currentEvent, 'cellMap_all'}{1}; % cellMap_all might already be a cell array

    % CFU directory
    CFU_directory = fullfile('D:\2photon\Simone\Simone_Macrophages\', ...
        fileTemp_parts{1,1}, '\', ...
        [fileTemp_parts{1,2} '_' fileTemp_parts{1,3}], '\AQuA2\');
    CFU_fileName = [data_analysis.filename '_AQuA_res_cfu.mat'];
    
    % Load CFU.mat file 
    CFU_FilePath = fullfile(CFU_directory, CFU_fileName);
    data_CFU = load(CFU_FilePath);

    % Matrix by event
    simultaneousMatrix = zeros(numEvents, numEvents);
    [numRows, numCols] = size(simultaneousMatrix);
    simultaneousMatrixDelay = zeros(numEvents, numEvents);
    startingFrame = data_analysis.resultsRaw.ftsTb(3,:); %starting frame of event to compute delay
    
    % Matrix by cell
    numCells = size(data_CFU.cfuInfo1,1);
    simultaneousMatrixbyCell = zeros(numCells, numCells);
    simultaneousMatrixDelaybyCell = cell(numCells, numCells);
    simultaneousMatrixDelaybyCell_average = cell(numCells, numCells);

    for currentEvent = 1:size(networkData,1)

        % find the propagation matrix related to the current event
        propagationMap_event = data_aqua.res.riseLst1{1, currentEvent}.dlyMap50;
        networkData.propagationMap_event{currentEvent} = propagationMap_event;
    
        % find the cell related to the current event
        cellNumber_event = find(cellfun(@(c) any(c == currentEvent), data_CFU.cfuInfo1(:, 2)));
        networkData.cellNumber_event{currentEvent} = cellNumber_event;

        % find if cell is perivascular or nonPerivascular
        if ismember(cellNumber_event,data_analysis.perivascularCells)
            networkData.cellType_event{currentEvent} = 0;
        else
            networkData.cellType_event{currentEvent} = 2;
        end

        % Get map of the cell of current event
        cellMap_event = data_CFU.cfuInfo1{cellNumber_event, 3};
        networkData.cellMap_event{currentEvent} = cellMap_event;
     
        % Find list of all simultaneous events related to that event and fill up simultaneousMatrix
        simultaneousEvents_current = networkData.simultaneousEvents_all{currentEvent};
      
        for a = 1:length(simultaneousEvents_current)
            simultaneousEvent = simultaneousEvents_current(a);

            % find the propagation matrix map related to the simultaneous event
            propagationMap_all = data_aqua.res.riseLst1{1, simultaneousEvent}.dlyMap50;
            networkData.propagationMap_all{currentEvent}{end+1} = propagationMap_all;
            
            % Find the cell of the specific event
            cellNumber_all = find(cellfun(@(c) any(c == simultaneousEvent), data_CFU.cfuInfo1(:, 2)));

            if ~isempty(cellNumber_all)
                if isempty(networkData.cellNumber_all{currentEvent})
                    networkData.cellNumber_all{currentEvent} = cellNumber_all;
                else
                    networkData.cellNumber_all{currentEvent} = [networkData.cellNumber_all{currentEvent}, cellNumber_all];
                end
            end
            
            % find if cell is perivascular or nonPerivascular
            if ismember(cellNumber_all, data_analysis.perivascularCells)
                cellType_all = 0;
            else
                cellType_all = 2;
            end
            
            % populate networkData table
            if isempty(networkData.cellType_all{currentEvent})
               networkData.cellType_all{currentEvent} = cellType_all;
            else
                networkData.cellType_all{currentEvent} = [networkData.cellType_all{currentEvent}, cellType_all];
            end

            % Find the map of the simultaneousEvent to the cell array
            cellMap_all = data_CFU.cfuInfo1{cellNumber_all, 3};
            networkData.cellMap_all{currentEvent}{end+1} = cellMap_all;  

%             %eventNetwork_cellMap_all
%    
%             %Cell Map
%             tempMap = networkData.cellMap_all{currentEvent}{simultaneousEvent_all};
%             nonZeroMask = tempMap > 0;
%             countTempMap = nnz((tempMap));
%             imshow(nonZeroMask);
%             
%             %Event Propagation
%             tempPropagation = networkData.propagationMap_all{currentEvent}{simultaneousEvent_all};  
%             countTempPropagation = nnz(~isnan(tempPropagation));
%             
%             %Get the linear indices of non-zero elements in tempMap
%             nonZeroIndicesTempMap = find(tempMap ~= 0);
%             
%             %Get the linear indices of non-NaN elements in tempPropagation
%             nonNaNIndicesTempPropagation = find(~isnan(tempPropagation));
%             
%             %Ensure both have the same number of elements
%             if length(nonZeroIndicesTempMap) ~= length(nonNaNIndicesTempPropagation)
%                 error('The number of non-zero elements in temp must equal the number of non-NaN elements in matrix.');
%             end
%             
%             %Create a new variable to hold the result
%             newTempMap = tempMap;
%             
%             %Insert the values from matrix tempPropagation into the newTemp at the corresponding positions
%             newTempMap(nonZeroIndicesTempMap) = tempPropagation(nonNaNIndicesTempPropagation);
%             
%             %Replace all zeros with NaN in newTempMap
%             newTempMap(newTempMap == 0) = NaN;
% 
%             %Substitute networkData table
%             networkData.eventNetwork_cellMap_all{currentEvent}{end+1} = newTempMap; 
%             
%             %Plot image of eventNetwork_cellMap_all
%             imagesc(newTempMap)
%             matrixTemp = newTempMap;
%             
%             %Find the maximum value
%             maxValue = max(matrixTemp(:));
%             Find all positions of the maximum value
%             [maxRows, maxCols] = find(matrixTemp == maxValue);
%             
%             %Find the minimum value
%             minValue = min(matrixTemp(:));
%             Find all positions of the minimum value
%             [minRows, minCols] = find(matrixTemp == minValue);
%             
%             %Display the results for maximum value
%             disp(['Maximum value: ', num2str(maxValue)]);
%             disp('Positions of max value:');
%             for j = 1:length(maxRows)
%                 disp(['(', num2str(maxRows(j)), ', ', num2str(maxCols(j)), ')']);
%             end
%             
%             %Display the results for minimum value
%             disp(['Minimum value: ', num2str(minValue)]);
%             disp('Positions of min value:');
%             for j = 1:length(minRows)
%                 disp(['(', num2str(minRows(j)), ', ', num2str(minCols(j)), ')']);
%             end
        
            simultaneousMatrix(currentEvent, simultaneousEvent) = 1;
            simultaneousMatrix(currentEvent, currentEvent) = 1; % Ensure the diagonal is set to 1 (an event is always simultaneous with itself)
           
            % Calculate delay between current event and 1st simultanous event
            element = simultaneousMatrix(currentEvent, simultaneousEvent); % Access the current element
            % Perform operations on 'element'
            %fprintf('Element at (%d, %d): %d\n', currentEvent, simultaneousEvent, element);
            startingFrame_currentEvent = startingFrame{currentEvent};
            startingFrame_simultaneousEvent = startingFrame{simultaneousEvent};
            delay = startingFrame_currentEvent-startingFrame_simultaneousEvent;
              if delay < 0
                 delay = 0;
              end
            simultaneousMatrixDelay(currentEvent,simultaneousEvent) = delay;

            % Check if the cell already contains data
            if isempty(simultaneousMatrixDelaybyCell{cellNumber_event, cellNumber_all})
                % If empty, initialize it as an array with the current delay
                simultaneousMatrixDelaybyCell{cellNumber_event, cellNumber_all} = delay;
            else
                % Append the new delay to the existing data
                simultaneousMatrixDelaybyCell{cellNumber_event, cellNumber_all} = ...
                [simultaneousMatrixDelaybyCell{cellNumber_event, cellNumber_all}, delay];
            end            
        end

        % Duplicate all events and Remove the current event from all simultaneous events
        simultaneousEvents_network = simultaneousEvents_current; %duplicate 
        simultaneousEvents_network(simultaneousEvents_current == currentEvent) = [];
        % Update the networkData table with the modified list
        networkData.simultaneousEvents_network{currentEvent} = simultaneousEvents_network;

        % Duplicate events
        simultaneousEvents_network_corrected = simultaneousEvents_network;
        networkData.simultaneousEvents_network_corrected{currentEvent} = simultaneousEvents_network_corrected;
          
        % Check if any elements in simultaneousEvents_network_corrected needs to be deleted
        if any(ismember(simultaneousEvents_network_corrected, data_analysis.eventsToDelete))
            % Keep only elements that are not in eventsToDelete
            simultaneousEvents_network_corrected = simultaneousEvents_network_corrected(~ismember(simultaneousEvents_network_corrected, data_analysis.eventsToDelete));
            networkData.simultaneousEvents_network_corrected{currentEvent} = simultaneousEvents_network_corrected;
        end

        % Initialize an array to store indices of simultaneousEvents to remove
        indicesToRemove = [];

        %remove current event from network events
        for b = 1:length(simultaneousEvents_network_corrected)
            simultaneousEvent_network_corrected = simultaneousEvents_network_corrected(b);
    
            % Check if the simultaneous event is in the list of cellEvents
            if ismember(simultaneousEvent_network_corrected, data_CFU.cfuInfo1{cellNumber_event, 2})
                % Add the index to the list of indices to remove
                indicesToRemove = [indicesToRemove, b];
            end

            % find the propagation matrix related to the current event
            propagationMap_network = data_aqua.res.riseLst1{1, simultaneousEvent_network_corrected}.dlyMap50;
            networkData.propagationMap_network{currentEvent}{end+1} = propagationMap_network;

            % Find the cell of the specific event
            cellNumber_network = find(cellfun(@(c) any(c == simultaneousEvent_network_corrected), data_CFU.cfuInfo1(:, 2)));

            if ~isempty(cellNumber_network)
                if isempty(networkData.cellNumber_network{currentEvent})
                    networkData.cellNumber_network{currentEvent} = cellNumber_network;
                else
                    networkData.cellNumber_network{currentEvent} = [networkData.cellNumber_network{currentEvent}, cellNumber_network];
                end
            end

            % find if cell is perivascular or nonPerivascular
            if ismember(cellNumber_network, data_analysis.perivascularCells)
                cellType_network = 0;
            else
                cellType_network = 2;
            end

            % populate networkData table
            if isempty(networkData.cellType_network{currentEvent})
               networkData.cellType_network{currentEvent} = cellType_network;
            else
                networkData.cellType_network{currentEvent} = [networkData.cellType_network{currentEvent}, cellType_network];
            end
            
            % Check if the cellMap entry for simultaneousEvent is empty and initialize if needed
            if isempty(networkData.cellMap_network{currentEvent})
                % Initialize networkData.cellMap{currentEvent} as a cell array of size 1x1
                networkData.cellMap_network{currentEvent} = {};
            end

            % Find the map of the simultaneousEvent to the cell array
            cellMap_network = data_CFU.cfuInfo1{cellNumber_network, 3};
            networkData.cellMap_network{currentEvent}{end+1} = cellMap_network;
        end
        
        % Remove the indices in reverse order to avoid out of range errors
        for i = length(indicesToRemove):-1:1
            networkData.simultaneousEvents_network_corrected{currentEvent}(indicesToRemove(i)) = [];
        end

        % COMBINE CELL MAPS 
    
        cellNumbers = num2cell(networkData{currentEvent, 'cellNumber_all'}{1}); % Assuming cellNumber_all is a cell array
        cellMaps = networkData{currentEvent, 'cellMap_all'}{1}; % cellMap_all might already be a cell array
    
        if iscell(cellNumbers)
            % Flatten the cell array and find unique numbers
            cellNumbers = [cellNumbers{:}];
        end
        
        % Remove duplicates in cellNumbers
        [uniqueCellNumbers, ia] = unique(cellNumbers, 'stable');
        
        % Extract corresponding cellMaps for unique cellNumbers
        cleanedCellMaps = cellMaps(ia);
    
        % Update the cleaned table
        networkData{currentEvent, 'cellNumber_all_unique'} = {uniqueCellNumbers};
        networkData{currentEvent, 'cellMap_all_unique'}{:} = cleanedCellMaps;
    
        % Initialize the combined matrix with zeros
        combinedMatrix = zeros(size(cleanedCellMaps{1}));
    
        % Loop over each cellMap and combine non-zero values
        for k = 1:numel(cleanedCellMaps)
            currentCellMap = cleanedCellMaps{k};
            % Create binary mask for non-zero elements
            currentMask = currentCellMap ~= 0;
            
            % Combine non-zero values into the combinedMatrix
            combinedMatrix(currentMask) = currentCellMap(currentMask);
        end
%         figure;
%         imshow(combinedMatrix, []); % Display the combined matrix
%         title('Combined Non-Zero Values from All Cell Maps');
    
        networkData.eventNetwork_cellMap_all{currentEvent} = combinedMatrix;
    
        % Compute the shortest distance
        pairwiseDistances = computePairwiseCenterDistances(cleanedCellMaps);
        networkData.shortestDistanceBetweenCenters{currentEvent} = pairwiseDistances;
        % Create heatmap of the distance matrix
        %createHeatmap(pairwiseDistances);
    end

    % Get distribution of distances between pair of cells
    % Extract the relevant column
    shortestDistanceBetweenCenters = networkData.shortestDistanceBetweenCenters;
    
    % Initialize an array to store the averages of the upper triangular values
    upperTriAverages = [];
    upperTriValues = [];

    % Conversion factor from pixels to micrometers (spatial resolution = 0.49 um/pixel = 2.04pixel/um)
    conversionFactor = 0.49;
    
    % Process each matrix
    for i = 1:length(shortestDistanceBetweenCenters)
    currentMatrix = shortestDistanceBetweenCenters{i};
    
        if isnumeric(currentMatrix)
            % Convert each element from pixels to micrometers
            convertedMatrix = currentMatrix * conversionFactor;
            
            % Extract the upper triangular part, excluding the diagonal
            upperTriValue = convertedMatrix(triu(true(size(convertedMatrix)), 1));
            
%             % Compute the mean of the upper triangular values, ignoring NaNs
%             upperTriAvg = mean(upperTriValue, 'omitnan');
%             % Append the computed average to the array
%             upperTriAverages = [upperTriAverages; upperTriAvg];

            % Append values with no average
            upperTriValues = [upperTriValues; upperTriValue];
        end
    end   

    % Store the upperTriValues for this experiment
    allUpperTriValues{experiment} = upperTriValues;
        
%     % Plot the distribution of the averages
%     figure;
%     %histogram(upperTriAverages);
%     %histogram(upperTriAvg);
%     histogram(upperTriValues);
%     title('Distance between pair of cells of concurrent events (um)');
%     xlabel('Average Distance (µm)');
%     ylabel('Frequency');
% 
%     % Save figure
%     % Edit the filename to end with '_cellDistances'
%     currentFolder = pwd;
%     subfolderName = 'cellDistances'; % Define the subfolder name
%     subfolderPath = fullfile(currentFolder, subfolderName); % Create the full path for the subfolder
%     fileTemp = extractBefore(AquA_fileName, "_AQuA2"); 
%     distancesFileName = strcat(fileTemp, '_cellDistances', '.fig');
%     save_path = fullfile(subfolderPath, distancesFileName);
%     saveas(gcf, save_path);
% 
%     % Save data
%     networkFilename = strcat(fileTemp, '_network_propagation.mat');
%     save(networkFilename);

    % Get events duration and simultaneous events
    eventDuration = table2cell(data_analysis.resultsRaw("Curve - Duration 10% to 10%","ftsTb"));
    eventDuration = eventDuration{1,1}';
    eventDuration_simultaneousEvents = [eventDuration,simultaneousEvents_all]; 
    eventDuration_simultanenousEvents_all{experiment} = eventDuration_simultaneousEvents; % Store values for this experiment

    % MATRIX for all cells (distance and delay)
    pairwiseDistanceMatrix = nan(numCells, numCells); % Initialize with NaN

    % Calculate distance and average delay between events within cells
    for cell1 = 1:numCells
        for cell2 = 1:numCells

            % Distance
            % Retrieve the cell numbers
            cellNumber_matrix = [cell1,cell2];

            % Retrieve the cell maps for the two cells
            cellMap1 = data_CFU.cfuInfo1{cell1, 3};
            cellMap2 = data_CFU.cfuInfo1{cell2, 3};
            cellMap_matrix = {cellMap1,cellMap2};
 
            % Initialize the combined matrix with zeros
            combinedMatrix_allCells = zeros(size(cellMap1));
        
            % Loop over each cellMap and combine non-zero values
            for k = 1:numel(cellMap_matrix)
                currentCellMap = cellMap_matrix{k};
                % Create binary mask for non-zero elements
                currentMask = currentCellMap ~= 0;
                
                % Combine non-zero values into the combinedMatrix
                combinedMatrix_allCells(currentMask) = currentCellMap(currentMask);
            end
%             figure;
%             imshow(combinedMatrix_allCells, []); % Display the combined matrix
%             title('Combined Non-Zero Values from All Cell Maps');

            % Compute pairwise distance 
            distance = computePairwiseCenterDistances({cellMap1, cellMap2});
            % Logical indexing to exclude NaN values
            nonNaNValues = distance(~isnan(distance));
            firstValue = nonNaNValues(1); 
            convertedValue = firstValue * conversionFactor;
            
            % Fill the matrix symmetrically
            pairwiseDistanceMatrix(cell1, cell2) = convertedValue;
            pairwiseDistanceMatrix(cell2, cell1) = convertedValue; % Symmetric
 
            % Delay
            % Get the delay data for the current cell
            data = simultaneousMatrixDelaybyCell{cell1,cell2};
            % Exclude zeros and negative values using logical indexing
            validData = data(data > 0);
            % Calculate the mean of the valid data (non-zero and non-negative elements)
            if ~isempty(validData) % Check if there are valid elements
                meanValue = mean(validData);
            else
                meanValue = NaN; % Assign NaN if no valid data
            end    
            % Store the mean value in the output matrix
            simultaneousMatrixDelaybyCell_average{cell1, cell2} = meanValue;
        end
    end

%     % Plot digraph with cell correlation
%     simultaneousMatrixDelaybyCell_average2 = cell2mat(simultaneousMatrixDelaybyCell_average);
%     graphAverage = digraph(simultaneousMatrixDelaybyCell_average);
%     plot(graphAverage)
% 
%     % Check if the matrix is symmetric
%     isSymmetric = isequal(simultaneousMatrixDelaybyCell_average, simultaneousMatrixDelaybyCell_average');
%     if isSymmetric
%         disp('The matrix is symmetric.');
%     else
%         disp('The matrix is not symmetric.'); %likely means that the delay relationships between cells are directional 
%     end
% 
%     % Replace NaN with 0 for graph representation
%     adjMatrix = simultaneousMatrixDelaybyCell_average2;
%     adjMatrix(isnan(adjMatrix)) = 0;
%     
%     % Create a directed graph
%     G = digraph(adjMatrix);
%     
%     % Plot the directed graph
%     figure;
%     plot(G, 'EdgeLabel', G.Edges.Weight);
%     title('Directed Network of Cells Based on Average Delays');

end

%% Get all averages of distances and get distribution

% Initialize an empty array to store all values
allValuesDistances_um = [];

% Loop through each array
for k = 1:length(allUpperTriValues) %allUpperTriAverages
    currentVector = allUpperTriValues{k}; %allUpperTriAverages
    
    % Append the values to the allValues array
    allValuesDistances_um = [allValuesDistances_um; currentVector]; 
end

% Remove NaN values
cleanDataDistances_um = allValuesDistances_um(~isnan(allValuesDistances_um));

% Plot the histogram of the cleaned data
figure;
histogram(cleanDataDistances_um);
title('Distance Metrics for Cells with Concurrent Activity');
xlabel('Distance (um)');
ylabel('Number of cell pairs');

%% correlation between duration of events and number of simultaneous events

eventDuration = table2cell(data_analysis.resultsRaw("Curve - Duration 10% to 10%","ftsTb"));
eventDuration = eventDuration{1,1}';

eventDuration_simultaneousEvents = [eventDuration,simultaneousEvents_all];

% Calculate the number of elements in each cell array in column2
numElements = cellfun(@numel, eventDuration_simultaneousEvents(:,2));  % This gives the length of each array in column2

duration = cell2mat(eventDuration_simultaneousEvents(:,1));
% Compute the correlation between column1 and the number of elements in column2
correlation = corr(duration(:), numElements(:));  % Ensure both are column vectors

% Display the result
disp(['Correlation between column1 and the number of elements in column2: ' num2str(correlation)]);

%% Correlation between duration of events and number of simultaneous events
test = eventDuration_simultaneousEvents_all(2:37,1);

test2 = [];

for x = 1:size(test,1)
    data = test{x};
    test2 = [test2;data];
end

% Assuming `data` is your input where column 1 has values and column 2 has elements (e.g., arrays or cells)

% Extract column 1
durationEvent = cell2mat(test2(:, 1)); % Convert to numeric if it's not already

% Compute the number of elements in column 2 for each row
numSimultaneousEvents = cellfun(@numel, test2(:, 2)); % Use `numel` to count elements in each array/cell

% Calculate the correlation
correlation = corr(durationEvent, numSimultaneousEvents, 'Rows', 'complete');

% Display the result
disp(['Correlation between column 1 and number of elements in column 2: ' num2str(correlation)]);

correlation = [durationEvent, numSimultaneousEvents];

