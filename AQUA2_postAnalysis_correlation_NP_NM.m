%% Filter cells (NP, NM = NOT PERIVASCULAR, NOT MULTINUCLEATED)

combinedTableBigCells = addvars(combinedTable, multinucleatedCells.Var3, 'NewVariableNames', 'Multinucleated');
cellLocation = combinedTableBigCells{:,13};
redLabel = combinedTableBigCells{:,14};
multinucleated = combinedTableBigCells{:,17};

NP_NM_indices = cellLocation == 2 & multinucleated == 0; numOnes = sum(NP_NM_indices); disp(numOnes);
NP_NM_red_indices = cellLocation == 2 & multinucleated == 0 & redLabel == 1;
NP_NM_not_red_indices = cellLocation == 2 & multinucleated == 0 & redLabel == 0;


%% Variables

area = combinedTableBigCells{:,2};
area_NP_NM = area(NP_NM_indices);

circularity = combinedTableBigCells{:,4};
circularity_NP_NM = circularity(NP_NM_indices);

maxDFF = combinedTableBigCells{:,5};
maxDFF_NP_NM = maxDFF(NP_NM_indices);

dFFAUC = combinedTableBigCells{:,11};
dFFAUC_NP_NM = dFFAUC(NP_NM_indices);

numberOfEvents = combinedTableBigCells{:,12};
numberOfEvents_NP_NM = numberOfEvents(NP_NM_indices);

%% Correlation - numberOfEvents vs max_dFF

% Calculate correlation coefficients
corr_maxDFF_numberOfEvents = corrcoef(numberOfEvents_NP_NM, maxDFF_NP_NM);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(numberOfEvents_NP_NM, maxDFF_NP_NM, 50, 'r', 'filled'); % Group 1 in blue

% Customize the plot
xlabel('Number of Events');
ylabel('Max dFF');
legend(['Corr: ', num2str(corr_maxDFF_numberOfEvents(1,2))]);
grid on;
hold off;

%% Correlation - area vs max_dFF

% Calculate correlation coefficients
corr_area_maxDFF = corrcoef(area_NP_NM, maxDFF_NP_NM);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(area_NP_NM, maxDFF_NP_NM, 50, 'r', 'filled'); % Group 1 in blue

% Customize the plot
xlabel('Area');
ylabel('Max dFF');
legend(['Corr: ', num2str(corr_area_maxDFF(1,2))]);
grid on;
hold off;

%% Correlation - circularity vs max_dFF

% Calculate correlation coefficients
corr_circularity_maxDFF = corrcoef(circularity_NP_NM, maxDFF_NP_NM);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(circularity_NP_NM, maxDFF_NP_NM, 50, 'r', 'filled'); % Group 1 in blue

% Customize the plot
xlabel('Circularity');
ylabel('Max dFF');
legend(['Corr: ', num2str(corr_circularity_maxDFF(1,2))]);
grid on;
hold off;

%% Correlation - area vs number of events

% Calculate correlation coefficients
corr_area_numberOfEvents = corrcoef(area_NP_NM, numberOfEvents_NP_NM);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(area_NP_NM, numberOfEvents_NP_NM, 50, 'r', 'filled'); % Group 1 in blue

% Customize the plot
xlabel('Area');
ylabel('Number of Events');
legend(['Corr: ', num2str(corr_area_numberOfEvents(1,2))]);
grid on;
hold off;

%% Correlation - circularity vs number of events

% Calculate correlation coefficients
corr_circularity_numberOfEvents = corrcoef(circularity_NP_NM, numberOfEvents_NP_NM);

% Plot correlation with different colors for each group
figure;
hold on;
scatter(circularity_NP_NM, numberOfEvents_NP_NM, 50, 'r', 'filled'); % Group 1 in blue

% Customize the plot
xlabel('Circularity');
ylabel('Number of Events');
legend(['Corr: ', num2str(corr_circularity_numberOfEvents(1,2))]);
grid on;
hold off;