%% Filter cells (NOT PERIVASCULAR)

cellLocation = combinedTable{:,13};
redLabel = combinedTable{:,14};

nonPerivascular_red_indices = cellLocation == 2 & redLabel == 1;
nonPerivascular_not_red_indices = cellLocation == 2 & redLabel == 0;

%% Circularity 

circularity = combinedTable{:,4};
circularity_nonPerivascular_red = circularity(nonPerivascular_red_indices);
circularity_nonPerivascular_not_red = circularity(nonPerivascular_not_red_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({circularity_nonPerivascular_red, circularity_nonPerivascular_not_red}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Circularity', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 0.7]);
xticks([1, 2]);
xticklabels({'circularity_nonPerivascular_red', 'circularity_nonPerivascular_not_red'});

% Remove top and right lines
box off;

% Perform t-test
[h, circularity_p_value] = ttest2(circularity_nonPerivascular_red, circularity_nonPerivascular_not_red);

%% Area

area = combinedTable{:,2};
area_nonPerivascular_red = area(nonPerivascular_red_indices); % Data points belonging to group 0
area_nonPerivascular_not_red = area(nonPerivascular_not_red_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({area_nonPerivascular_red, area_nonPerivascular_not_red}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Area (um2)', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 1000]);
xticks([1, 2]);
xticklabels({'Perivascular', 'Non-Perivascular'});

% Remove top and right lines
box off;

% Perform t-test
[h, area_p_value] = ttest2(area_nonPerivascular_red, area_nonPerivascular_not_red);

%% Number of Events

numberOfEvents = combinedTable{:,12};
numberOfEvents_nonPerivascular_red = numberOfEvents(nonPerivascular_red_indices); % Data points belonging to group 0
numberOfEvents_nonPerivascular_not_red = numberOfEvents(nonPerivascular_not_red_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({numberOfEvents_nonPerivascular_red, numberOfEvents_nonPerivascular_not_red}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Number of Events', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 50]);
xticks([1, 2]);
xticklabels({'numberOfEvents_nonPerivascular_red', 'numberOfEvents_nonPerivascular_not_red'});

% Remove top and right lines
box off;

% Perform t-test
[h, numberOfEvents_p_value] = ttest2(numberOfEvents_nonPerivascular_red, numberOfEvents_nonPerivascular_not_red);

%% Max DFF

maxDFF = combinedTable{:,5};
maxDFF_nonPerivascular_red = maxDFF(nonPerivascular_red_indices); % Data points belonging to group 0
maxDFF_nonPerivascular_not_red = maxDFF(nonPerivascular_not_red_indices); % Data points belonging to group 2

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({maxDFF_nonPerivascular_red, maxDFF_nonPerivascular_not_red}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Max dFF', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 5]);
xticks([1, 2]);
xticklabels({'maxDFF nonPerivascular red', 'maxDFF nonPerivascular not red'});

% Remove top and right lines
box off;

% Perform t-test
[h, maxDFF_p_value] = ttest2(maxDFF_nonPerivascular_red, maxDFF_nonPerivascular_not_red);