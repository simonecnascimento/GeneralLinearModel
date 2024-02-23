%% Combine results for each animal

clear all;
mouse = 'Pf4Ai162-1';
folder_path = fullfile('D:\2photon\Simone\Simone_Macrophages\', mouse, '\', 'AQuA2_Results');
files = dir(fullfile(folder_path, '*_resultsFinal.xls'));

all_data = table();

for i = 1:length(files)
    file_path = fullfile(folder_path, files(i).name);
    resultsFinal = readtable(file_path); %use the original column headers as table variable names.  

    % Add an empty column to all_data
    all_data = [all_data, table(nan(size(all_data, 1), 1), 'VariableNames', {'EmptyColumn'})];
    
    % Append new columns to all_data
    all_data = [all_data, resultsFinal];
  
end


%% Combine results for each animal

clear all;
mouse = 'Pf4Ai162-1';
folder_path = fullfile('D:\2photon\Simone\Simone_Macrophages\', mouse, '\', 'AQuA2_Results');
files = dir(fullfile(folder_path, '*_resultsFinal.xls'));

all_data = table()[];

for i = 1:length(files)
    file_path = fullfile(folder_path, files(i).name);
    resultsFinal = xlsread(file_path); %use the original column headers as table variable names.  

     % Add an empty column to all_data
    all_data = [all_data, nan(size(all_data, 1), 1)];
    
    % Append new columns to all_data
    all_data = [all_data, resultsFinal];
  
end
%% Save results file for combined experiments 

% Set the output directory to save files
AQuA2_results_outputDir = fullfile('D:\2photon\Simone\Simone_Macrophages\', mouse, '\', 'AQuA2_results\');
AQuA2_CFUinfo = load(AQuA2_CFUinfo_filePath);


cd(outputDir); %change directory of current folder

D:\2photon\Simone\Simone_Macrophages\Pf4Ai162-1\AQuA2_Results
