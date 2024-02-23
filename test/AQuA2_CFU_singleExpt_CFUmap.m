

for cell = 1:size(cfuInfo1, 1) 
% Assuming your cell array is named 'cfuInfo1' and the map is in cell {7,3}
    cellMap = cfuInfo1{cell, 3};

% Create a logical mask for non-zero values
    nonZeroMask = cellMap > 0;

% Display the cell map with only non-zero values
    imshow(nonZeroMask);

% Add a title to the figure
    title('Non-Zero Values in Cell Map');
end


% You can customize the figure further if needed



%% Show cell figure 1-by-1
for cellIndex = 1:size(cfuInfo1, 1)
    % Access the cell map based on the current iteration
    cellMap = cfuInfo1{cellIndex, 3};

    % Create a logical mask for non-zero values
    nonZeroMask = cellMap > 0;

    % Create a new figure for each iteration
    figure;

    % Display the cell map with only non-zero values
    imshow(nonZeroMask);

    % Add a title to the figure
    title(['Non-Zero Values in Cell Map - Cell ', num2str(cellIndex)]);

    % Add a pause to allow time for the figure to be displayed
    pause(1); % You can adjust the pause duration as needed
end


%% Show all cells in a grid figure
% Assuming your cell array is named 'cfuInfo1'

% Determine the number of cells in the array
numCells = size(cfuInfo1, 1);

% Determine the number of rows and columns for the subplot arrangement
numRows = ceil(sqrt(numCells));
numColumns = ceil(numCells / numRows);

% Create a new figure for all subplots
figure;

for cellIndex = 1:numCells
    % Access the cell map based on the current iteration
    cellMap = cfuInfo1{cellIndex, 3};

    % Create a logical mask for non-zero values
    nonZeroMask = cellMap > 0;

    % Create subplots in a grid
    subplot(numRows, numColumns, cellIndex);

    % Display the cell map with only non-zero values
    imshow(nonZeroMask);

    % Add a title to each subplot
    title(['Cell ', num2str(cellIndex)]);
end



%% Show all cells in a combined figure
% Assuming your cell array is named 'cfuInfo1'

% Determine the number of cells in the array
numCells = size(cfuInfo1, 1);

% Initialize an empty matrix to accumulate non-zero values
combinedMap = zeros(size(cfuInfo1{1, 3}));

% Combine non-zero values from all cells
for cellIndex = 1:numCells
    % Access the cell map based on the current iteration
    cellMap = cfuInfo1{cellIndex, 3};

    % Create a logical mask for non-zero values
    nonZeroMask = cellMap > 0;

    % Accumulate non-zero values into the combined map
    combinedMap = combinedMap + nonZeroMask;
end

% Create a new figure for the combined map
figure;

% Display the combined map with only non-zero values
imshow(combinedMap);

% Add a title to the figure
title('Combined Non-Zero Values from All Cells');


%% Show all cells in a grid figure
%BEST CODE

% Assuming your cell array is named 'cfuInfo1'

% Determine the number of cells in the array
numCells = size(cfuInfo1, 1);

% Determine the number of rows and columns for the subplot arrangement
numRows = ceil(sqrt(numCells));
numColumns = ceil(numCells / numRows);

% Create a new figure for all subplots
figure;

for cellIndex = 1:numCells
    % Access the cell map based on the current iteration
    cellMap = cfuInfo1{cellIndex, 3};

    % Create a logical mask for non-zero values
    nonZeroMask = cellMap > 0;

    % Create subplots in a grid
    subplot(numRows, numColumns, cellIndex);

    % Display the cell map with only non-zero values
    imshow(nonZeroMask);

    % Add a title to each subplot
    title(['Cell ', num2str(cellIndex)]);
end

% Save the figure
saveas(gcf, 'combined_cells_figure.png');




%% Show all cells in a grid figure

clear all


% Determine the number of cells in the array
numCells = size(cfuInfo1, 1);

% Determine the number of rows and columns for the subplot arrangement
numRows = ceil(sqrt(numCells));
numColumns = ceil(numCells / numRows);

% Create a new figure for all subplots
figure;

for cellIndex = 1:numCells
    % Access the cell map based on the current iteration
    cellMap = cfuInfo1{cellIndex, 3};

    % Create a logical mask for non-zero values
    nonZeroMask = cellMap > 0;

    % Create subplots in a grid
    subplot(numRows, numColumns, cellIndex);

    % Display the cell map with only non-zero values
    imshow(nonZeroMask);

    % Add a title to each subplot
    title(['Cell ', num2str(cellIndex)]);
end

% Prompt the user to choose a directory

selectedDir = uigetdir('', 'Select a directory to save the figure');

if selectedDir ~= 0
    % Save the figure in the selected directory
    saveas(gcf, fullfile(selectedDir, 'combined_cells_figure.png'));
    disp(['Figure saved in: ', selectedDir]);
else
    disp('Figure not saved. User canceled directory selection.');
end


%%
