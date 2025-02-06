clear all;
directory = "D:\2photon\Simone\Simone_Macrophages\GLMs";
cd(directory);

filename = 'GLMs.xlsx'; 
sheetname = 'GLM_diamFluor_coeff';
dataTableDura = readtable(filename, 'Sheet', sheetname);
GLM_diamFluor_Matrix = readmatrix(filename, 'Sheet', sheetname);

%% Vessel type
% Based on observation
Pia_P_Positive = [49,50]; 
Pia_P_Negative = [48,86];
Pia_NP_Positive = [13:16,22:24,26,28,32,85,88:98,115];
Pia_NP_Negative = [25,27,29:31,51:53,87];
Dura_P_Positive = [17,33,35,37,38,56:59,61,63,65,66,71:73,75,77:80,82,84,99,108];
Dura_P_Negative = [34,36,39:41,44,46,47,76,83,100,101,104:107,109:111,113,114]; %1
Dura_NP_Positive = [2:4,7:10,42,45,54,55,62,67:70,74,81];
Dura_NP_Negative = [5,6,11,12,18:21,43,60,64,102,103,112];

% Based on coefficient with locomotion state
%Pia_P_Positive = [56,57,58,59,61,63,65,66];  
Pia_P_Negative = [];
Dura_P_Positive = [17,33,35,37,38,49,50,7,72,73,75,77,99];% duplicate 78,79,80,82,84,108
Dura_P_Negative = [34,36,39:41,44,46:48,76,83,86,100,101,104,106,107]; %1 % duplicate 109:111,113,114

%%
% figure;
% x = (-60:60)'; 
% %plot all curves (pia or dura)
% plot(x, GLM_diamFluor_Matrix(:,[Pia_P_Positive, Dura_P_Positive])); %Pia_P_Positive, Dura_P_Positive, Pia_P_Negative, Dura_P_Negative
% xlim([-60 60]); % Set x-axis limits
% xlabel('Delay (sec)');
% ylabel('Coefficient value');
% %title(['Plot of Column ', num2str(columns)]);
% grid on;

% Count number of columns in each category
%num_Pia_P_Positive = numel(Pia_P_Positive);
%num_Pia_P_Negative = numel(Pia_P_Negative);
%num_Pia_NP_Positive = numel(Pia_NP_Positive);
%num_Pia_NP_Negative = numel(Pia_NP_Negative);
num_Dura_P_Positive = numel(Dura_P_Positive);
num_Dura_P_Negative = numel(Dura_P_Negative);
%num_Dura_NP_Positive = numel(Dura_NP_Positive);
%num_Dura_NP_Negative = numel(Dura_NP_Negative);

% Compute total number of classified columns
%total_classified_columns = num_Pia_P_Positive + num_Pia_P_Negative + num_Pia_NP_Positive + num_Pia_NP_Negative + num_Dura_P_Positive + num_Dura_P_Negative + num_Dura_NP_Positive + num_Dura_NP_Negative;

% Store in structured format
%classifiedData.Pia_P_Positive = GLM_diamFluor_Matrix(:, Pia_P_Positive);
%classifiedData.Pia_P_Negative = GLM_diamFluor_Matrix(:, Pia_P_Negative);
%classifiedData.Pia_NP_Positive = GLM_diamFluor_Matrix(:, Pia_NP_Positive);
%classifiedData.Pia_NP_Negative = GLM_diamFluor_Matrix(:, Pia_NP_Negative);
classifiedData.Dura_P_Positive = GLM_diamFluor_Matrix(:, Dura_P_Positive);
classifiedData.Dura_P_Negative = GLM_diamFluor_Matrix(:, Dura_P_Negative);
%classifiedData.Dura_NP_Positive = GLM_diamFluor_Matrix(:, Dura_NP_Positive);
%classifiedData.Dura_NP_Negative = GLM_diamFluor_Matrix(:, Dura_NP_Negative);

%% DURA PERIVASCULAR POSITIVE

% All
figure;
x = (-60:60)';
plot(x, classifiedData.Dura_P_Positive(:,:));
xlim([-60 60]); % Set x-axis limits
xlabel('Delay (sec)');
ylabel('Coefficient value');
%title(['Plot of Column ', num2str(columns)]);
grid on;

% Individual positive coefficients
for columns = 1:size(classifiedData.Dura_P_Positive,2)
    %column = classifiedData.Dura_P_Positive(:,columns);
    figure;
    plot(x, classifiedData.Dura_P_Positive(:,columns));
    xlim([-60 60]); % Set x-axis limits
    xlabel('Delay (sec)');
    ylabel('Coefficient value');
    title(['Plot of Column ', num2str(columns)]);
    grid on;
end

% Individual + Mean
figure; % Create a new figure
hold on; % Keep all plots on the same figure
% Plot each column
for columns = 1:size(classifiedData.Dura_P_Positive,2)
    h1 = plot(x, classifiedData.Dura_P_Positive(:, columns), 'Color', [0.7 0.7 0.7]); % Light gray for individual curves
end
% Compute the mean across columns
meanCurve = mean(classifiedData.Dura_P_Positive(:,columns), 2, 'omitnan'); % Excludes NaNs if present
% Plot the mean curve in a distinct color (e.g., red, thicker line)
h2 = plot(x, meanCurve, 'r', 'LineWidth', 2);
% Create legend and store handle
lgd = legend([h1(1), h2], {'Individual Curves', 'Mean Curve'});
% Formatting
xlim([-60 60]);
xlabel('Delay (sec)');
ylabel('Coefficient value');
title('Activated Macrophages');
% legend({'Individual Curves', 'Mean Curve'});
hold off; % Release the figure

%% DURA PERIVASCULAR NEGATIVE

% All
figure;
x = (-60:60)';
plot(x, classifiedData.Dura_P_Negative(:,:));
xlim([-60 60]); % Set x-axis limits
xlabel('Delay (sec)');
ylabel('Coefficient value');
%title(['Plot of Column ', num2str(columns)]);
grid on;

% Individual positive coefficients
for columns = 1:size(classifiedData.Dura_P_Negative,2)
    figure;
    plot(x, classifiedData.Dura_P_Negative(:,columns));
    xlim([-60 60]); % Set x-axis limits
    xlabel('Delay (sec)');
    ylabel('Coefficient value');
    title(['Plot of Column ', num2str(columns)]);
    grid on;
end

% Individual + Mean
figure; % Create a new figure
hold on; % Keep all plots on the same figure
% Plot each column
for columns = 1:size(classifiedData.Dura_P_Negative,2)
    h1 = plot(x, classifiedData.Dura_P_Negative(:, columns), 'Color', [0.7 0.7 0.7]); % Light gray for individual curves
end
% Compute the mean across columns
meanCurve = mean(classifiedData.Dura_P_Negative(:,columns), 2, 'omitnan'); % Excludes NaNs if present
% Plot the mean curve in a distinct color (e.g., red, thicker line)
h2 = plot(x, meanCurve, 'r', 'LineWidth', 2);
% Create legend and store handle
lgd = legend([h1(1), h2], {'Individual Curves', 'Mean Curve'});
% Formatting
xlim([-60 60]);
xlabel('Delay (sec)');
ylabel('Coefficient value');
title('Activated Macrophages');
% legend({'Individual Curves', 'Mean Curve'});
hold off; % Release the figure

%%
% Define the number of columns in your matrix
numCols = 115;  % Assuming 115 columns

% Initialize new rows with NaNs (for clarity)
VesselType = repmat({''}, 1, numCols);
CellType = repmat({''}, 1, numCols);
Coeff = repmat({''}, 1, numCols);

% Assign values based on classification
VesselType([Pia_P_Positive, Pia_P_Negative, Pia_NP_Positive, Pia_NP_Negative]) = {"Pia"};
VesselType([Dura_P_Positive, Dura_P_Negative, Dura_NP_Positive, Dura_NP_Negative]) = {"Dura"};

CellType([Pia_P_Positive, Pia_P_Negative, Dura_P_Positive, Dura_P_Negative]) = {"P"};
CellType([Pia_NP_Positive, Pia_NP_Negative, Dura_NP_Positive, Dura_NP_Negative]) = {"NP"};

Coeff([Pia_P_Positive, Pia_NP_Positive, Dura_P_Positive, Dura_NP_Positive]) = {"positive"};
Coeff([Pia_P_Negative, Pia_NP_Negative, Dura_P_Negative, Dura_NP_Negative]) =  {"negative"};

% Convert numerical matrix to a cell array
dataCell = num2cell(GLM_diamFluor_Matrix);

% Combine the labels with the numerical data
extendedCellMatrix = [VesselType; CellType; Coeff; dataCell];
extendedCellMatrix = extendedCellMatrix';

% Display size
disp(size(extendedCellMatrix)); % Should be (124, 115)

% Vessel
vessel = extendedCellMatrix(1, :);
dura = strcmp(vessel, "Dura");
pia = strcmp(vessel, "Pia");
% Cell
cell = extendedCellMatrix(2,:);
perivascular = strcmp(cell, "P");
nonPerivascular = strcmp(cell, "NP");
% Coefficient
coeff = extendedCellMatrix(3,:);
positive = strcmp(coeff, "positive");
negative = strcmp(coeff, "negative");



% Ensure non-empty cells for comparison
validVessel = ~cellfun(@isempty, vessel); % Logical index for non-empty entries

% Compare only where values are valid
dura = false(size(vessel)); 
dura(validVessel) = strcmp(vessel(validVessel), "Dura");

pia = false(size(vessel));
pia(validVessel) = strcmp(vessel(validVessel), "Pia");

% Debugging output
disp("Dura count: " + sum(dura)); % Should match the expected number of "Dura"
disp("Pia count: " + sum(pia));   % Should match the expected number of "Pia"


% Extract numerical data (from row 3 onwards) only for "P" columns
P_values = cell2mat(data(3:end, P_cols));

% Plot the extracted values
figure;
plot(P_values, 'o-', 'LineWidth', 1.5);
xlabel('Time (or Index)');
ylabel('Value');
title('Plot of P Values');
grid on;


%%

% % Plot each column (data is found in GLMs, GLM_locoDiam sheet)
% for columns = 1:numel(44 %columns = 1:22
%     figure;
%     plot(x, GLM_diamFluor_dura_Matrix(:,columns));
%     xlim([-60 60]); % Set x-axis limits
%     xlabel('Delay (sec)');
%     ylabel('Coefficient value');
%     title(['Plot of Column ', num2str(columns)]);
%     grid on;
% end

figure;
x = (-60:60)'; 
%plot all curves (pia or dura)
plot(x, GLM_diamFluor_Matrix(:,:));
xlim([-60 60]); % Set x-axis limits
xlabel('Delay (sec)');
ylabel('Coefficient value');
%title(['Plot of Column ', num2str(columns)]);
grid on;



% Plot each column (data is found in GLMs, GLM_locoDiam sheet)
for columns = 1:length(duraVessels)
    column = duraVessels(columns);
    figure;
    plot(x, GLM_locoDiamMatrix(:,column));
    xlim([-60 60]); % Set x-axis limits
    xlabel('Delay (sec)');
    ylabel('Coefficient value');
    title(['Plot of Column ', num2str(column)]);
    grid on;
end

%% Response By Vessel Type
% Pia
figure; % Create a new figure
hold on; % Keep all plots on the same figure

% Plot each column
for columns = 1:length(piaVessels)
    column = piaVessels(columns);
    h1 = plot(x, GLM_locoDiamMatrix(:, column), 'Color', [0.7 0.7 0.7]); % Light gray for individual curves
end

% Compute the mean across columns
meanCurve = mean(GLM_locoDiamMatrix(:, piaVessels), 2, 'omitnan'); % Excludes NaNs if present

% Plot the mean curve in a distinct color (e.g., red, thicker line)
h2 = plot(x, meanCurve, 'r', 'LineWidth', 2);

% Create legend and store handle
lgd = legend([h1(1), h2], {'Individual Curves', 'Mean Curve'});

% Formatting
xlim([-60 60]);
xlabel('Delay (sec)');
ylabel('Coefficient value');
title('Pia Vessel Response to Locomotion State');
grid on;
% legend({'Individual Curves', 'Mean Curve'});

hold off; % Release the figure

% Dura
figure; % Create a new figure
hold on; % Keep all plots on the same figure

% Plot each column
for columns = 1:length(duraVessels)
    column = duraVessels(columns);
    h1 = plot(x, GLM_locoDiamMatrix(:, column), 'Color', [0.7 0.7 0.7]); % Light gray for individual curves
end

% Compute the mean across columns
meanCurve = mean(GLM_locoDiamMatrix(:, duraVessels), 2, 'omitnan'); % Excludes NaNs if present

% Plot the mean curve in a distinct color (e.g., red, thicker line)
h2 = plot(x, meanCurve, 'r', 'LineWidth', 2);

% Create legend and store handle
lgd = legend([h1(1), h2], {'Individual Curves', 'Mean Curve'});

% Formatting
xlim([-60 60]);
xlabel('Delay (sec)');
ylabel('Coefficient value');
title('Dura Vessel Response to Locomotion State');
grid on;
% legend({'Individual Curves', 'Mean Curve'});

hold off; % Release the figure
