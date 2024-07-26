%% Extract features of each experiment

% load aqua files (cfuInfo1 and res.featuresTable1)

% define experiment name
filename = 'Pf4Ai162-18_240221_FOV1_run1_reg_Z01_green_Substack(1-927)';

% transform struct to table
resultsRaw = res.featureTable1;
resultsExpanded = cell2table(resultsRaw.ftsTb); %expanded events without features column
       
% Delete columns = perivascular and multinucleated cells and their respective events
cols_to_delete = input('Enter columns to delete (e.g., [1,2] ): ');

totalCells = input('Enter total number of remaining cells: ');

% Delete specified columns
resultsExpanded(:, cols_to_delete) = [];

%% propagation speed

% extract propagationDistance and duration of events
propagationDistance = (table2cell(resultsExpanded(16,:)))';
duration50to50 = (table2cell(resultsExpanded(9,:)))';

% Initialize the result cell array
speedEvent = cell(size(propagationDistance));

% Perform element-wise division
for i = 1:length(propagationDistance)
    speedEvent{i} = propagationDistance{i} / duration50to50{i};
end

% save
newFilename = strcat(filename, '_propagationSpeed.mat');
save(newFilename);
