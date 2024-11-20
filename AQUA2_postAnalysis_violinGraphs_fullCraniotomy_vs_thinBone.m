%% Data analysis fullCraniotomy(NP+NM) vs thinBone(all)

%for fullCraniotomy data - load spreadsheet and add Var3
load('D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\baseline\AQuA2_data_fullCraniotomy_baseline.mat')
load('D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\baseline\multinucleated cells\multinucleatedCells.mat');
fullCraniotomy_combinedTable = addvars(combinedTable, multinucleatedCells.Var3, 'NewVariableNames', 'Multinucleated');
fullCraniotomy_multinucleated = fullCraniotomy_combinedTable{:,17};
fullCraniotomy_cellLocation = fullCraniotomy_combinedTable{:,13};
fullCraniotomy_all_NM_indices = fullCraniotomy_multinucleated == 0;
fullCraniotomy_numOnes = sum(fullCraniotomy_all_NM_indices);

%fullCraniotomy_multinucleated_indices = fullCraniotomy_multinucleated == 1;
%sum(fullCraniotomy_multinucleated_indices);

%for thinBone data - create a new table 'multinucleatedCells' and add Var1
load('V:\2photon\Simone\Simone_Macrophages\AQuA2_Results\thinBone\AQuA2_data_thinBone.mat')
thinBone_multinucleated = zeros(94,1);
thinBone_combinedTable = addvars(combinedTable, thinBone_multinucleated.Var1, 'NewVariableNames', 'Multinucleated');
thinBone_cellLocation = thinBone_combinedTable{:,13};
thinBone_all_NM_indices = thinBone_multinucleated == 0;
thinBone_numOnes = sum(thinBone_all_NM_indices);
combinedTable_thinBone = combinedTable(thinBone_all_NM_indices,:);


%% Circularity 

%fullCraniotomy
circularity_fullCraniotomy = fullCraniotomy_combinedTable{:,4};
circularity_fullCraniotomy_all_NM = circularity_fullCraniotomy(fullCraniotomy_all_NM_indices);
%thinBone
circularity_thinBone = thinBone_combinedTable{:,4};
circularity_thinBone_all_NM = circularity_thinBone(thinBone_all_NM_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({circularity_fullCraniotomy_all_NM, circularity_thinBone_all_NM}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Circularity', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 0.6]);
xticks([1, 2]);
xticklabels({'fullCraniotomy', 'thinBone'});

% Remove top and right lines
box off;

% Perform t-test
[h, circularity_p_value] = ttest2(circularity_fullCraniotomy_all_NM, circularity_thinBone_all_NM);

% Perform the Mann-Whitney U test
[p, h, stats] = ranksum(circularity_fullCraniotomy_all_NM, circularity_thinBone_all_NM);

% Display the results
fprintf('p-value: %f\n', p);
fprintf('Test decision (h): %d\n', h);
disp('Test statistics:');
disp(stats);
%% Area 

%fullCraniotomy
area_fullCraniotomy = fullCraniotomy_combinedTable{:,2};
area_fullCraniotomy_all_NM = area_fullCraniotomy(fullCraniotomy_all_NM_indices);
%thinBone
area_thinBone = thinBone_combinedTable{:,2};
area_thinBone_all_NM = area_thinBone(thinBone_all_NM_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({area_fullCraniotomy_all_NM, area_thinBone_all_NM}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Area', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 1000]);
xticks([1, 2]);
xticklabels({'fullCraniotomy', 'thinBone'});

% Remove top and right lines
box off;

% Perform t-test
[h, area_p_value] = ttest2(area_fullCraniotomy_all_NM, area_thinBone_all_NM);

%% Perimeter 

%fullCraniotomy
perimeter_fullCraniotomy = fullCraniotomy_combinedTable{:,3};
perimeter_fullCraniotomy_all_NM = perimeter_fullCraniotomy(fullCraniotomy_all_NM_indices);

%thinBone
perimeter_thinBone = thinBone_combinedTable{:,3};
perimeter_thinBone_all_NM = perimeter_thinBone(thinBone_all_NM_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({perimeter_fullCraniotomy_all_NM, perimeter_thinBone_all_NM}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Perimeter', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 700]);
xticks([1, 2]);
xticklabels({'fullCraniotomy', 'thinBone'});

% Remove top and right lines
box off;

% Perform t-test
[h, perimeter_p_value] = ttest2(perimeter_fullCraniotomy_all_NM, perimeter_thinBone_all_NM);

%% Number of Events 

%fullCraniotomy
numberOfEvents_fullCraniotomy = fullCraniotomy_combinedTable{:,12};
numberOfEvents_fullCraniotomy_all_NM = numberOfEvents_fullCraniotomy(fullCraniotomy_all_NM_indices);

%thinBone
numberOfEvents_thinBone = thinBone_combinedTable{:,12};
numberOfEvents_thinBone_all_NM = numberOfEvents_thinBone(thinBone_all_NM_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({numberOfEvents_fullCraniotomy_all_NM, numberOfEvents_thinBone_all_NM}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('numberOfEvents', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 25]);
xticks([1, 2]);
xticklabels({'fullCraniotomy', 'thinBone'});

% Remove top and right lines
box off;

% Perform t-test
[h, numberOfEvents_p_value] = ttest2(numberOfEvents_fullCraniotomy_all_NM, numberOfEvents_thinBone_all_NM);

%% maxDFF

%fullCraniotomy
maxDFF_fullCraniotomy = fullCraniotomy_combinedTable{:,5};
maxDFF_fullCraniotomy_all_NM = maxDFF_fullCraniotomy(fullCraniotomy_all_NM_indices);

%thinBone
maxDFF_thinBone = thinBone_combinedTable{:,5};
maxDFF_thinBone_all_NM = maxDFF_thinBone(thinBone_all_NM_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({maxDFF_fullCraniotomy_all_NM, maxDFF_thinBone_all_NM}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('maxDFF', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 4]);
xticks([1, 2]);
xticklabels({'fullCraniotomy', 'thinBone'});

% Remove top and right lines
box off;

% Perform t-test
[h, maxDFF_p_value] = ttest2(maxDFF_fullCraniotomy_all_NM, maxDFF_thinBone_all_NM);