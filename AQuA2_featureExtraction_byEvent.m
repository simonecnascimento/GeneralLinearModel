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

for i = 25:length(FilesAll)
    
    % Load analysis .mat file
    data_analysis = load(FilesAll{i});
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

    % get network results
    nOccurSameTimeCell = num2cell(data_aqua.res.fts1.networkAll.nOccurSameTime);
    networkData = [nOccurSameTimeCell, data_aqua.res.fts1.networkAll.occurSameTimeList];
    networkData = cell2table(networkData);
    networkData.Properties.VariableNames = {'nOccurSameTime', 'occurSameTimeList'};
      
    % CFU directory
    CFU_directory = fullfile('D:\2photon\Simone\Simone_Macrophages\', ...
        fileTemp_parts{1,1}, '\', ...
        [fileTemp_parts{1,2} '_' fileTemp_parts{1,3}], '\AQuA2\');
    CFU_fileName = [data_analysis.filename '_AQuA_res_cfu.mat'];
    
    % Load CFU.mat file 
    CFU_FilePath = fullfile(CFU_directory, CFU_fileName);
    data_CFU = load(CFU_FilePath);

    % save
    fileTemp = extractBefore(AquA_fileName, "_AQuA2"); 
    networkFilename = strcat(fileTemp, '_network.mat');
    save(networkFilename);
end
