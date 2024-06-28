%% Circularity 

circularity = combinedTable{:,4};
circularity_perivascular = circularity(perivascular_indices); % Data points belonging to group 0
circularity_nonPerivascular = circularity(nonPerivascular_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({circularity_perivascular, circularity_nonPerivascular}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Circularity', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 0.7]);
xticks([1, 2]);
xticklabels({'Perivascular', 'Non-Perivascular'});

% Remove top and right lines
box off;

% Perform t-test
[h, circularity_p_value] = ttest2(circularity_perivascular, circularity_nonPerivascular);

%% Area

area = combinedTable{:,2};
area_perivascular = area(perivascular_indices); % Data points belonging to group 0
area_nonPerivascular = area(nonPerivascular_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({area_perivascular, area_nonPerivascular}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Area (um2)', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 1000]);
xticks([1, 2]);
xticklabels({'Perivascular', 'Non-Perivascular'});

% Remove top and right lines
box off;

% Perform t-test
[h, area_p_value] = ttest2(area_perivascular, area_nonPerivascular);

%% Perimeter

perimeter = combinedTable{:,3};
perimeter_perivascular = perimeter(perivascular_indices); % Data points belonging to group 0
perimeter_nonPerivascular = perimeter(nonPerivascular_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({perimeter_perivascular, perimeter_nonPerivascular}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Perimeter', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 500]);
xticks([1, 2]);
xticklabels({'Perivascular', 'Non-Perivascular'});

% Remove top and right lines
box off;

% Perform t-test
[h, perimeter_p_value] = ttest2(perimeter_perivascular, perimeter_nonPerivascular);

%% Number of Events

numberOfEvents = combinedTable{:,12};
numberOfEvents_perivascular = numberOfEvents(perivascular_indices); % Data points belonging to group 0
numberOfEvents_nonPerivascular = numberOfEvents(nonPerivascular_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({numberOfEvents_perivascular, numberOfEvents_nonPerivascular}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Number of Events', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 50]);
xticks([1, 2]);
xticklabels({'Perivascular', 'Non-Perivascular'});

% Remove top and right lines
box off;

% Perform t-test
[h, numberOfEvents_p_value] = ttest2(numberOfEvents_perivascular, numberOfEvents_nonPerivascular);

%% Max DFF

maxDFF = combinedTable{:,5};
maxDFF_perivascular = maxDFF(perivascular_indices); % Data points belonging to group 0
maxDFF_nonPerivascular = maxDFF(nonPerivascular_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({maxDFF_perivascular, maxDFF_nonPerivascular}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Max dFF', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 5]);
xticks([1, 2]);
xticklabels({'Perivascular', 'Non-Perivascular'});

% Remove top and right lines
box off;

% Perform t-test
[h, maxDFF_p_value] = ttest2(maxDFF_perivascular, maxDFF_nonPerivascular);


%% dFF AUC

dFF_AUC = combinedTable{:,11};
dFF_AUC_perivascular = dFF_AUC(perivascular_indices); % Data points belonging to group 0
dFF_AUC_nonPerivascular = dFF_AUC(nonPerivascular_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({dFF_AUC_perivascular, dFF_AUC_nonPerivascular}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('dFF AUC', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 250]);
xticks([1, 2]);
xticklabels({'Perivascular', 'Non-Perivascular'});

% Remove top and right lines
box off;

% Perform t-test
[h, dFF_AUC_p_value] = ttest2(dFF_AUC_perivascular, dFF_AUC_nonPerivascular);