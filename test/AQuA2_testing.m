% Sample data table
yourDataTable = table(rand(10, 15), 'VariableNames', cellstr(num2str((1:15).', 'Var_%d')));

% List of event column numbers
eventColumnNumbersList = [6; 40; 44; 48; 60; 67; 84; 87; 88; 91; 95; 99; 106];

% Initialize an array to store median values
medianValuesArray = zeros(size(yourDataTable, 1), numel(eventColumnNumbersList));

% Iterate over each event column number
for i = 1:numel(eventColumnNumbersList)
    % Extract the current event column
    currentEventColumn = eventColumnNumbersList(i);
    
    % Calculate the median for each row in the selected column
    medianValuesArray(:, i) = median(yourDataTable{:, currentEventColumn}, 2);
end



TEST

% Set the directory of AQuA2 folder
dataDir =  'D:\2photon\Simone\Simone_Macrophages\'; %  'D:\2photon\Simone\Simone_Macrophages\'; %  'D:\2photon\Simone\Simone_Vasculature\', D:\2photon\Anna
animal = 'Pf4Ai162-1';
fileToFind = '*_AQuA_res_cfu.mat';
AquaDir = dir(fullfile(strcat(dataDir,animal, fileToFind)));
fileToFind = '*_AQuA_res_cfu.mat'
_AQuA2.mat

dir([strcat(dataDir,animal])

FileList = dir(fullfile(Folder, '**', '*.csv'))

% Load files
load()
