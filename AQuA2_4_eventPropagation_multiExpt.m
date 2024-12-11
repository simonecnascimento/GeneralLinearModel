%% Load .mat files  (FULL CRANIOTOMY BASELINE)

clear all;

% Change you Current Folder - fullCraniotomy
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\baseline\3._analysisByEvent.mat;

% Initialize an empty table
propagationTable = table();

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

%% Load .mat files  (THIN BONE BASELINE) - TO CORRECT FILES

% Change you Current Folder - thinBone
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\thinBone\_analysisByEvent.mat

% Initialize an empty table
propagationTable = table();

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

%% Load .mat files  (FULL CRANIOTOMY CSD) - TO CORRECT FILES

% Change you Current Folder - thinBone
cd D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\CSD\corrected_for_pinprick\1._analysis.mat;

% Initialize an empty table
propagationTable = table();

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

%% extract propagation (separately for full craniotomy and thin bone baseline, and full craniotomy CSD)

for i = 1:length(FilesAll)
    % Load the .mat file
    data = load(FilesAll{i});
    
    % Extract variables
    propagationSpeed = data.speedEvent;        
    propagationDistance = data.propagationDistance;
    propagationDuration = data.duration50to50;         
    fileNameColumn = repmat(FilesAll(i), size(propagationSpeed, 1), 1); 

    % Combine into a temporary table
    tempTable = table(propagationSpeed, propagationDistance, propagationDuration, fileNameColumn, ...
                      'VariableNames', {'Speed', 'Distance', 'Duration', 'FileName'});

    % Append to the main table
    propagationTable = [propagationTable; tempTable];
 end

%% Load propagation files

propagation_fullCraniotomy = load( ...
    'D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\baseline\AQuA2_data_fullCraniotomy_propagation_baseline.mat');

%propagation_thinBone =
%load('D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\baseline\AQuA2_data_thinBone_propagation'); (REDO _propagation.mat files to include perivascular cells)

%% zScores and Outliers (%score within 2 standard deviations)

%Speed
zScoresSpeed = zscore(cell2mat(propagation_fullCraniotomy.propagationTable_all.Speed));
outliers_zScoresSpeed = abs(zScoresSpeed) > 2;
numOutliersSpeed = sum(outliers_zScoresSpeed);
%outliersSpeed = isoutlier(cell2mat(propagation_fullCraniotomy.propagationTable_all.Speed));

%Distance
zScoresDistance = zscore(cell2mat(propagation_fullCraniotomy.propagationTable_all.Distance));
outliers_zScoresDistance = abs(zScoresDistance) > 2; 
numOutliersDistance = sum(outliers_zScoresDistance);
%outliersDistance = isoutlier(cell2mat(propagationTable.Speed));

%Duration
zScoresDuration = zscore(cell2mat(propagation_fullCraniotomy.propagationTable_all.Duration));
outliers_zScoresDuration = abs(zScoresDuration) > 2; 
numOutliersDuration = sum(outliers_zScoresDuration);
%outliers_Speed = isoutlier(cell2mat(propagationTable.Speed));


%% Speed

%fullCraniotomy
notOutliersSpeed_fullCraniotomy = outliers_zScoresSpeed==0;
propagationSpeed_fullCraniotomy = propagation_fullCraniotomy.propagationTable_all.Speed(notOutliersSpeed_fullCraniotomy);


%thinBone
%notOutliers_thinBone = outliersZscore==0;
%propagation_thinBone = propagationTable.Speed(notOutliers_thinBone);

% Perform t-test
[h, propagation_p_value] = ttest2(propagation_fullCraniotomy, propagation_thinBone);

figure;
barColors = [1 0 0; 0 0 1];
violin(propagation_fullCraniotomy, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
%ylabel('Propagation speed (um/s)', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([-5, 20]);
xticks([1, 2]);
%xticklabels({'fullCraniotomy', 'thinBone'});
title('Propagation speed (um/s)', FontSize=30);

% Adjust y-axis tick font size and remove x-axis ticks
ax = gca;
ax.YAxis.FontSize = 30;  % Set y-axis number font size to 30
set(gca, 'xtick', []);   % Remove x-axis ticks

% Remove top and right lines
box off;

min(propagation_thinBone)

%% Full craniotomy vs thinBone

% Identify outliers (e.g., Z-score > 3 or < -3)
outliersZscore = abs(zScores) > 2; %score within 2 standard deviations
numOutliers = sum(outliersZscore);

% Display the number of outliers
outliers_Speed = isoutlier(cell2mat(propagationTable.Speed));

%notOutliers_thinBone = outliersZscore==0;
%propagation_thinBone = propagationTable.Speed(notOutliers_thinBone);

notOutliers_fullCraniotomy = outliersZscore==0;
propagation_fullCraniotomy_notOutliers = propagation_fullCraniotomy(notOutliers_fullCraniotomy);

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
