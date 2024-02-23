%% Figures

clear all
%load AQuA_res_cfu.mat
load('Pf4Ai162-1_221122_FOV2_run1_reg_Z01_green_Substack(1-900)_AQuA_res_cfu.mat');

%% CFU map
%Show all cells in a grid figure - Assuming your cell array is named 'cfuInfo1'

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


%% dFF curves
cellList = cfuInfo1(:,1);
dFF = cfuInfo1(:,6);
dataTable = table(cellList);
dataTable = [dataTable, array2table(dFF)];

% Get the number of rows in the table
numCells = size(resultsFinal,1);

% Create a figure
dFF_curve = figure('Visible', 'on');

% Plot each row
for i = 1:numCells
    % Extract the i-th row of the column
    rowData = resultsFinal.dFF{i};
    
    % Plot the curve for the i-th row
    plot(rowData);
    
    % Add labels and legend if needed
    xlabel('Frames');
    ylabel('dFF');
    xlim=900;
    title('Curve Plot', resultsFinal.OriginalVariableNames{i});
    
    % If you want to plot all curves in the same figure, use "hold on"
    hold on;
end


[filepath,name,ext] = fileparts(data);
fileTemp = extractBefore(name, "_AQuA_res_cfu");
save(fullfile(outputDirFOV, strcat(fileTemp,'_analysis'))); % save metadata inside FOV folder       
writetable(resultsFinal,fullfile(outputDirFOV,strcat(fileTemp,"_resultsFinal")),"WriteRowNames",true,"WriteVariableNames", true, "FileType","spreadsheet"); %save resultsFinal inside FOV folder
writetable(resultsFinal,fullfile(outputDirAnimal,strcat(fileTemp,"_resultsFinal")),"WriteRowNames",true,"WriteVariableNames", true, "FileType","spreadsheet"); %save resultsFinal to animal folder

saveas(dFF_curve, )



