%% Filter cells (NP, NM = NOT PERIVASCULAR, NOT MULTINUCLEATED)

combinedTable_fullCraniotomy = addvars(combinedTable, multinucleatedCells.Var3, 'NewVariableNames', 'Multinucleated');

cellLocation = combinedTable_fullCraniotomy{:,13};
redLabel = combinedTable_fullCraniotomy{:,14};
multinucleated = combinedTable_fullCraniotomy{:,17};

%%
% NP_NM_indices = cellLocation == 2 & multinucleated == 0; numOnes = sum(NP_NM_indices); disp(numOnes);
% NP_NM_red_indices = cellLocation == 2 & multinucleated == 0 & redLabel == 1;
% NP_NM_not_red_indices = cellLocation == 2 & multinucleated == 0 & redLabel == 0;

allCells_NM_indices = multinucleated == 0;

%% Variables

area = combinedTable_fullCraniotomy{:,2};
area_allCells_NM = area(allCells_NM_indices);

circularity = combinedTable_fullCraniotomy{:,4};
circularity_allCells_NM = circularity(allCells_NM_indices);

maxDFF = combinedTable_fullCraniotomy{:,5};
maxDFF_allCells_NM = maxDFF(allCells_NM_indices);

dFFAUC = combinedTable_fullCraniotomy{:,11};
dFFAUC_allCells_NM = dFFAUC(allCells_NM_indices);

numberOfEvents = combinedTable_fullCraniotomy{:,12};
numberOfEvents_allCells_NM = numberOfEvents(allCells_NM_indices);

%% Correlation - numberOfEvents vs max_dFF

% Calculate correlation coefficients
corr_maxDFF_numberOfEvents = corrcoef(numberOfEvents_allCells_NM, maxDFF_allCells_NM);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(numberOfEvents_allCells_NM, maxDFF_allCells_NM, 50, 'r', 'filled'); % Group 1 in blue

% Customize the plot
xlabel('Number of Events');
ylabel('Max dFF');
legend(['Corr: ', num2str(corr_maxDFF_numberOfEvents(1,2))]);
grid on;
hold off;

%% Correlation - area vs max_dFF

% Calculate correlation coefficients
corr_area_maxDFF = corrcoef(area_allCells_NM, maxDFF_allCells_NM);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(area_allCells_NM, maxDFF_allCells_NM, 50, 'r', 'filled'); % Group 1 in blue

% Customize the plot
xlabel('Area');
ylabel('Max dFF');
legend(['Corr: ', num2str(corr_area_maxDFF(1,2))]);
grid on;
hold off;

%% Correlation - circularity vs max_dFF

% Calculate correlation coefficients
corr_circularity_maxDFF = corrcoef(circularity_allCells_NM, maxDFF_allCells_NM);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(circularity_allCells_NM, maxDFF_allCells_NM, 50, 'r', 'filled'); % Group 1 in blue

% Customize the plot
xlabel('Circularity');
ylabel('Max dFF');
legend(['Corr: ', num2str(corr_circularity_maxDFF(1,2))]);
grid on;
hold off;

%% Correlation - area vs number of events

% Calculate correlation coefficients
corr_area_numberOfEvents = corrcoef(area_allCells_NM, numberOfEvents_allCells_NM);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(area_allCells_NM, numberOfEvents_allCells_NM, 50, 'r', 'filled'); % Group 1 in blue

% Customize the plot
xlabel('Area');
ylabel('Number of Events');
legend(['Corr: ', num2str(corr_area_numberOfEvents(1,2))]);
grid on;
hold off;

%% Correlation - circularity vs number of events

% Calculate correlation coefficients
corr_circularity_numberOfEvents = corrcoef(circularity_allCells_NM, numberOfEvents_allCells_NM);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(circularity_allCells_NM, numberOfEvents_allCells_NM, 50, 'r', 'filled'); % Group 1 in blue

% Customize the plot
xlabel('Circularity');
ylabel('Number of Events');
legend(['Corr: ', num2str(corr_circularity_numberOfEvents(1,2))]);
grid on;
hold off;