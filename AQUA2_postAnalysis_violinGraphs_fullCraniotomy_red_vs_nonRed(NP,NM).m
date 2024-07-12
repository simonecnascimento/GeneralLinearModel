%% Filter cells (NP, NM = NOT PERIVASCULAR, NOT MULTINUCLEATED)

%for fullCraniotomy data - load spreadsheet and add Var3
load('D:\2photon\Simone\Simone_Macrophages\AQuA2_Results\fullCraniotomy\multinucleatedCells.mat');
combinedTable_fullCraniotomy = addvars(combinedTable, multinucleatedCells.Var3, 'NewVariableNames', 'Multinucleated');

%for thinBone data - create a new table 'multinucleatedCells' and add Var1
multinucleatedCells = array2table(zeros(94,1));
combinedTable_thinBone = addvars(combinedTable, multinucleatedCells.Var1, 'NewVariableNames', 'Multinucleated');

cellLocation = combinedTableBigCells{:,13};
redLabel = combinedTableBigCells{:,14};
multinucleated = combinedTableBigCells{:,17};

% bigCell_indices = (multinucleated == 1);
notBigCell_indices = (multinucleated == 0);
NP_NM_red_indices = cellLocation == 2 & multinucleated == 0 & redLabel == 1;
NP_NM_not_red_indices = cellLocation == 2 & multinucleated == 0 & redLabel == 0;
%nonPerivascular_notBigCell_red_indices = cellLocation == 2 & multinucleated == 0 & redLabel == 1;
%nonPerivascular_notBigCell_not_red_indices = cellLocation == 2 & multinucleated == 0 & redLabel == 0;

%% Circularity Red vs Not red

circularity = combinedTableBigCells{:,4};
circularity_NP_NM = circularity(notBigCell_indices);
circularity_NP_NM_red = circularity(NP_NM_red_indices);
circularity_NP_NM_not_red = circularity(NP_NM_not_red_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({circularity_NP_NM_red, circularity_NP_NM_not_red}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Circularity', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 0.7]);
xticks([1, 2]);
xticklabels({'NP/NM Red', 'NP/NM Not Red'});

% Remove top and right lines
box off;

% Perform t-test
[h, circularity_p_value] = ttest2(circularity_NP_NM_red, circularity_NP_NM_not_red);

%% Area  Red vs Not red

area = combinedTableBigCells{:,2};
area_NP_NM_red = area(NP_NM_red_indices); % Data points belonging to group 0
area_NP_NM_not_red = area(NP_NM_not_red_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({area_NP_NM_red, area_NP_NM_not_red}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Area (um2)', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 1000]);
xticks([1, 2]);
xticklabels({'NP/NM Red', 'NP/NM Not Red'});

% Remove top and right lines
box off;

% Perform t-test
[h, area_p_value] = ttest2(area_NP_NM_red, area_NP_NM_not_red);

%% Number of Events  Red vs Not red

numberOfEvents = combinedTableBigCells{:,12};
numberOfEvents_NP_NM_red = numberOfEvents(NP_NM_red_indices); % Data points belonging to group 0
numberOfEvents_NP_NM_not_red = numberOfEvents(NP_NM_not_red_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({numberOfEvents_NP_NM_red, numberOfEvents_NP_NM_not_red}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Number of Events', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 50]);
xticks([1, 2]);
xticklabels({'NP/NM Red', 'NP/NM Not Red'});

% Remove top and right lines
box off;

% Perform t-test
[h, numberOfEvents_p_value] = ttest2(numberOfEvents_NP_NM_red, numberOfEvents_NP_NM_not_red);

%% Max DFF  Red vs Not red

maxDFF = combinedTableBigCells{:,5};
maxDFF_NP_NM_red = maxDFF(NP_NM_red_indices); % Data points belonging to group 0
maxDFF_NP_NM_not_red = maxDFF(NP_NM_not_red_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({maxDFF_NP_NM_red, maxDFF_NP_NM_not_red}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Max dFF', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 5]);
xticks([1, 2]);
xticklabels({'Red', 'Not red'});

% Remove top and right lines
box off;

% Perform t-test
[h, maxDFF_p_value] = ttest2(maxDFF_NP_NM_red, maxDFF_NP_NM_not_red);