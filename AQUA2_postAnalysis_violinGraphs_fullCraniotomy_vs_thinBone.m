%% Data analysis fullCraniotomy(NP+NM) vs thinBone(all)

%for fullCraniotomy data - load spreadsheet and add Var3
load('D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\AQuA2_data_fullCraniotomy.mat')
load('D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\multinucleatedCells.mat');
combinedTable_fullCraniotomy = addvars(combinedTable, multinucleatedCells.Var3, 'NewVariableNames', 'Multinucleated');
multinucleated = combinedTable_fullCraniotomy{:,17};
notBigCell_fullCraniotomy_indices = (multinucleated == 0);

%for thinBone data - create a new table 'multinucleatedCells' and add Var1
load('D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\thinBone\AQuA2_data_thinBone.mat')
multinucleatedCells = array2table(zeros(94,1));
combinedTable_thinBone = addvars(combinedTable, multinucleatedCells.Var1, 'NewVariableNames', 'Multinucleated');
cellLocation_thinBone = combinedTable_thinBone{:,13};
NP_indices = (cellLocation_thinBone == 2);
numOnes = sum(NP_indices);

%% Circularity 

%fullCraniotomy
circularity_fullCraniotomy = combinedTable_fullCraniotomy{:,4};
circularity_fullCraniotomy_NP_NM = circularity_fullCraniotomy(notBigCell_fullCraniotomy_indices);
%thinBone
circularity_thinBone = combinedTable_thinBone{:,4};
circularity_thinBone_NP = circularity_thinBone(NP_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({circularity_fullCraniotomy_NP_NM, circularity_thinBone_NP}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Circularity', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 0.6]);
xticks([1, 2]);
xticklabels({'fullCraniotomy', 'thinBone'});

% Remove top and right lines
box off;

% Perform t-test
[h, circularity_p_value] = ttest2(circularity_fullCraniotomy_NP_NM, circularity_thinBone_NP);

%% Area 

%fullCraniotomy
area_fullCraniotomy = combinedTable_fullCraniotomy{:,2};
area_fullCraniotomy_NP_NM = area_fullCraniotomy(notBigCell_fullCraniotomy_indices);
%thinBone
area_thinBone = combinedTable_thinBone{:,2};
area_thinBone_NP = area_thinBone(NP_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({area_fullCraniotomy_NP_NM, area_thinBone_NP}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Area', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 1000]);
xticks([1, 2]);
xticklabels({'fullCraniotomy', 'thinBone'});

% Remove top and right lines
box off;

% Perform t-test
[h, area_p_value] = ttest2(area_fullCraniotomy_NP_NM, area_thinBone_NP);

%% Perimeter 

%fullCraniotomy
perimeter_fullCraniotomy = combinedTable_fullCraniotomy{:,3};
perimeter_fullCraniotomy_NP_NM = perimeter_fullCraniotomy(notBigCell_fullCraniotomy_indices);

%thinBone
perimeter_thinBone = combinedTable_thinBone{:,3};
perimeter_thinBone_NP = perimeter_thinBone(NP_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({perimeter_fullCraniotomy_NP_NM, perimeter_thinBone_NP}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Perimeter', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 700]);
xticks([1, 2]);
xticklabels({'fullCraniotomy', 'thinBone'});

% Remove top and right lines
box off;

% Perform t-test
[h, perimeter_p_value] = ttest2(perimeter_fullCraniotomy_NP_NM, perimeter_thinBone_NP);