directory = "D:\2photon\Simone\Simone_Macrophages\GLMs";
cd(directory);

filename = 'GLMs.xlsx'; % Your Excel file
sheetname = 'GLM_locoDiam_coeff2';   % Specify the sheet name or index
dataTable = readtable(filename, 'Sheet', sheetname);
GLM_locoDiamMatrix = readmatrix(filename, 'Sheet', sheetname);
GLM_locoDiamMatrix = GLM_locoDiamMatrix(2:end, :);

x = (-60:60)'; % Column vector for x-axis

% Plot each column (data is found in GLMs, GLM_locoDiam sheet)
for columns = 1:22 %columns = 1:22
    figure;
    plot(x, GLM_locoDiamMatrix(:,columns));
    xlim([-60 60]); % Set x-axis limits
    xlabel('Delay (sec)');
    ylabel('Coefficient value');
    title(['Plot of Column ', num2str(columns)]);
    grid on;
end


% plot by vessel type
piaVessels = [4,7,13,19,22]; 
duraVessels = [1,2,3,5,8,9,10,11,15,16,20,21]; 
%not sure [6, 12,14,17,18]

%plot all curves (pia or dura)
plot(x, GLM_locoDiamMatrix(:,duraVessels));
xlim([-60 60]); % Set x-axis limits
xlabel('Delay (sec)');
ylabel('Coefficient value');
title(['Plot of Column ', num2str(columns)]);
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
