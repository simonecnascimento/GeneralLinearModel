%% Simultanous matrices by event and cell

% Matrix by event
numEvents = simultaneousEvents_all;
simultaneousMatrix = zeros(numEvents, numEvents);
[numRows, numCols] = size(simultaneousMatrix);
simultaneousMatrixDelay = zeros(numEvents, numEvents);
startingFrame = data_analysis.resultsRaw.ftsTb(3,:); %starting frame of event to compute delay

% Matrix by cell
numCells = length(data_CFU.cfuInfo1);
simultaneousMatrixbyCell = zeros(numCells, numCells);
simultaneousMatrixDelaybyCell = zeros(numCells, numCells);

% Fill the matrix based on simultaneous events
for row = 1:numRows
    events = networkData.simultaneousEvents_all{row};
    for j = 1:length(events)
        for k = 1:length(events)
            simultaneousMatrix(events(j), events(k)) = 1;
        end
    end
    simultaneousMatrix(row, row) = 1; % Ensure the diagonal is set to 1 (an event is always simultaneous with itself)

end

% % Ensure the diagonal is set to 1 (an event is always simultaneous with itself)
% for i = 1:numEvents
%     simultaneousMatrix(d, d) = 1;
% end

% Compute delay between events
startingFrame = data_analysis.resultsRaw.ftsTb(3,:);

[numRows, numCols] = size(simultaneousMatrix);
for row = 1:numRows
    for col = 1:numCols
        element = simultaneousMatrix(row, col); % Access the current element
        % Perform operations on 'element'
        fprintf('Element at (%d, %d): %d\n', row, col, element);
        if element == 1
            startingFrameRow = startingFrame{row};
            startingFrameColumn = startingFrame{col};
            delay = startingFrameRow-startingFrameColumn;
            if delay < 0
                delay = 0;
            end
            simultaneousMatrixDelay(row,col) = delay;
        end
    end
end

%% Simultanous matrix by cell

numCells = length(data_CFU.cfuInfo1);

% Initialize the adjacency matrix
simultaneousMatrixbyCell = zeros(numCells, numCells);
% Compute delay between events
simultaneousMatrixDelaybyCell = zeros(numCells, numCells);

[numRowsCell, numColsCell] = size(simultaneousMatrixbyCell);

for 
for rowCell = 1:numRowsCell
    for colCell = 1:numColsCell
        elementCell = simultaneousMatrix(rowCell, colCell); % Access the current element
        % Perform operations on 'element'
        fprintf('Element at (%d, %d): %d\n', rowCell, colCell, elementCell);
        if rowCell == colCell
            simultaneousMatrixDelaybyCell(rowCell,colCell) = 0;
        else
            rowCellEvents = data_CFU.cfuInfo1{rowCell,2};
            colCellEvents = data_CFU.cfuInfo1{colCell,2};
            for f = 1:length(rowCellEvents)
                rowCellEvent = rowCellEvents(f);
                networkData.



        end

        if element == 1
            startingFrameRow = startingFrame{rowCell};
            startingFrameColumn = startingFrame{colCell};
            delay = startingFrameRow-startingFrameColumn;
            if delay < 0
                delay = 0;
            end
            simultaneousMatrixDelay(rowCell,colCell) = delayCell;
        end
    end
end





