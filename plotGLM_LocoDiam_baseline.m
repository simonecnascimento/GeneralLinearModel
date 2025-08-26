clear all;
directory = "D:\2photon\Simone\Simone_Macrophages\GLMs";
cd(directory);

filename = 'GLMs.xlsx'; % Your Excel file
sheetname = 'GLM_locoDiam_coeffSubset';   % Specify the sheet name or index
dataTable = readtable(filename, 'Sheet', sheetname);
GLM_locoDiamMatrix = readmatrix(filename, 'Sheet', sheetname);
GLM_locoDiamMatrix = GLM_locoDiamMatrix(2:end, :);

% % vessel type based on manual visualization
% piaVessels = [4,7,13,19,22]; 
% duraVessels = [1,2,3,5,8,9,10,11,15,16,20,21]; 
% %not sure [6, 12,14,17,18]

% vessel type based on loco coefficient (total = 22 vessels)
piaVessels = [4,7,13,19,22]; %14
duraVessels = [1,2,3,5,6,8,9,10,11,12,15,17,18,20]; %duplicate #16,21

x = (-60:60)'; % Column vector for x-axis

%% All vessels
% for columns = 1:22 %columns = 1:22
%     figure;
%     plot(x, GLM_locoDiamMatrix(:,columns));
%     xlim([-60 60]); % Set x-axis limits
%     xlabel('Delay (sec)');
%     ylabel('Coefficient value');
%     title(['Plot of Column ', num2str(columns)]);
%     grid on;
% end

%% PIA
% % All
% plot(x, GLM_locoDiamMatrix(:,piaVessels));
% xlim([-60 60]); % Set x-axis limits
% xlabel('Delay (sec)');
% ylabel('Coefficient value');
% title(['Plot of Column ', num2str(columns)]);
% grid on;
% 
% % Individual
% for columns = 1:length(piaVessels)
%     column = piaVessels(columns);
%     figure;
%     plot(x, GLM_locoDiamMatrix(:,column));
%     xlim([-60 60]); % Set x-axis limits
%     xlabel('Delay (sec)');
%     ylabel('Coefficient value');
%     title(['Plot of Column ', num2str(column)]);
%     grid on;
% end
% 
% % Individual + Mean
% figure; % Create a new figure
% hold on; % Keep all plots on the same figure
% 
% % Plot each column
% for columns = 1:length(piaVessels)
%     column = piaVessels(columns);
%     h1 = plot(x, GLM_locoDiamMatrix(:, column), 'Color', [0.7 0.7 0.7]); % Light gray for individual curves
% end
% 
% % Compute the mean across columns
% meanCurve = mean(GLM_locoDiamMatrix(:, piaVessels), 2, 'omitnan'); % Excludes NaNs if present
% 
% % Plot the mean curve in a distinct color (e.g., red, thicker line)
% h2 = plot(x, meanCurve, 'r', 'LineWidth', 2);
% 
% % Create legend and store handle
% lgd = legend([h1(1), h2], {'Individual Curves', 'Mean Curve'});
% 
% % Formatting
% xlim([-60 60]);
% xlabel('Delay (sec)');
% ylabel('Coefficient value');
% title('Pia Vessel Response to Locomotion State');
% grid on;
% % legend({'Individual Curves', 'Mean Curve'});
% 
% hold off; % Release the figure

%% PAPER PIA
% Create a new figure

blue = [80, 160, 255] / 255; 
useMedian = true;  % set to false if you want mean ± SEM instead

figure;
hold on;

if useMedian
    % ----- Median + IQR -----
    medianCurve = median(GLM_locoDiamMatrix(:, piaVessels), 2, 'omitnan');
    q25 = prctile(GLM_locoDiamMatrix(:, piaVessels), 25, 2);
    q75 = prctile(GLM_locoDiamMatrix(:, piaVessels), 75, 2);

    y_lower = q25;
    y_upper = q75;

    % Plot shaded region for IQR
    fill([x; flipud(x)], [y_upper; flipud(y_lower)], blue, ...
        'FaceAlpha', 0.3, 'EdgeColor', 'none');
    % Plot the median curve
    plot(x, medianCurve, 'k', 'LineWidth', 1);

else
    % ----- Mean + SEM -----
    meanCurve = mean(GLM_locoDiamMatrix(:, piaVessels), 2, 'omitnan');
    stdCurve = std(GLM_locoDiamMatrix(:, piaVessels), 0, 2, 'omitnan');
    n = sum(~isnan(GLM_locoDiamMatrix(:, piaVessels)), 2);
    semCurve = stdCurve ./ sqrt(n);

    y_upper = meanCurve + semCurve;
    y_lower = meanCurve - semCurve;

    % Plot shaded region for SEM
    fill([x; flipud(x)], [y_upper; flipud(y_lower)], blue, ...
        'FaceAlpha', 0.3, 'EdgeColor', 'none');
    % Plot the mean curve
    plot(x, meanCurve, 'k', 'LineWidth', 1);
end

% 
% % Compute the mean
% meanCurve = mean(GLM_locoDiamMatrix(:, piaVessels), 2, 'omitnan'); % Mean curve
% % STD or SEM
% % Standard deviation across vessels
% stdCurve = std(GLM_locoDiamMatrix(:, piaVessels), 0, 2, 'omitnan'); % Standard deviation
% % Standard Error of the Mean
% n = sum(~isnan(GLM_locoDiamMatrix(:, piaVessels)), 2); % handle NaNs per timepoint
% semCurve = std(GLM_locoDiamMatrix(:, piaVessels), 0, 2, 'omitnan') ./ sqrt(n);
% % Define upper and lower bounds for shading
% y_upper = meanCurve + semCurve; %+ stdCurve
% y_lower = meanCurve - semCurve;
% % Plot shaded region for individual variation
% fill([x; flipud(x)], [y_upper; flipud(y_lower)], orangeC4, 'FaceAlpha', 0.3, 'EdgeColor', 'none'); %[0.8 0.8 0.8]
% % Plot the mean curve in a distinct color (e.g., red, thicker line)
% h2 = plot(x, meanCurve, 'k', 'LineWidth', 1);
% 
% 
% % Compute the median across vessels
% medianCurve = median(GLM_locoDiamMatrix(:, piaVessels), 2, 'omitnan');
% % Compute IQR (25th and 75th percentiles)
% q25 = prctile(GLM_locoDiamMatrix(:, piaVessels), 25, 2);
% q75 = prctile(GLM_locoDiamMatrix(:, piaVessels), 75, 2);
% % Define bounds for shading (IQR)
% y_lower = q25;
% y_upper = q75;
% % Plot shaded region for IQR
% fill([x; flipud(x)], [y_upper; flipud(y_lower)], orangeC4, ...
%     'FaceAlpha', 0.3, 'EdgeColor', 'none');
% % Plot the median curve
% plot(x, medianCurve, 'k', 'LineWidth', 1);

% Formatting
xlim([-60 60]);
xlabel('Delay (sec)');
ylabel('Coefficient value');
%title('Pia Vessel Response to Locomotion State');
grid off;

% Create legend
%legend({'Mean ± SD', 'Mean Curve'}, 'Location', 'Best');
ax = gca;
ax.FontSize = 16; 
set(gca, 'Color', 'w'); % Ensure the background is white
set(findall(gca, 'Type', 'patch'), 'FaceAlpha', 1); % Make patches fully opaque
set(gca, 'TickDir', 'out'); % Make tick marks point outward
%set(findall(gca, 'Type', 'line'), 'Color', [0 0 0]); % Ensure line colors are solid

hold off;

%% DURA
% % All
% plot(x, GLM_locoDiamMatrix(:,duraVessels));
% xlim([-60 60]); % Set x-axis limits
% xlabel('Delay (sec)');
% ylabel('Coefficient value');
% title(['Plot of Column ', num2str(columns)]);
% grid on;
% 
% % Individual
% for columns = 1:length(piaVessels)
%     column = piaVessels(columns);
%     figure;
%     plot(x, GLM_locoDiamMatrix(:,column));
%     xlim([-60 60]); % Set x-axis limits
%     xlabel('Delay (sec)');
%     ylabel('Coefficient value');
%     title(['Plot of Column ', num2str(column)]);
%     grid on;
% end
% 
% % Individual + Mean
% figure; % Create a new figure
% hold on; % Keep all plots on the same figure
% 
% % Plot each column
% for columns = 1:length(duraVessels)
%     column = duraVessels(columns);
%     h1 = plot(x, GLM_locoDiamMatrix(:, column), 'Color', [0.7 0.7 0.7]); % Light gray for individual curves
% end
% 
% % Compute the mean across columns
% meanCurve = mean(GLM_locoDiamMatrix(:, duraVessels), 2, 'omitnan'); % Excludes NaNs if present
% 
% % Plot the mean curve in a distinct color (e.g., red, thicker line)
% h2 = plot(x, meanCurve, 'r', 'LineWidth', 2);
% 
% % Create legend and store handle
% lgd = legend([h1(1), h2], {'Individual Curves', 'Mean Curve'});
% 
% % Formatting
% xlim([-60 60]);
% xlabel('Delay (sec)');
% ylabel('Coefficient value');
% title('Dura Vessel Response to Locomotion State');
% grid on;
% % legend({'Individual Curves', 'Mean Curve'});
% 
% hold off; % Release the figure


%% PAPER DURA
% Create a new figure

red = [220, 50, 47] / 255; % Normalize RGB to [0,1]
useMedian = true;  % set true for Median + IQR, false for Mean + SEM

figure;
hold on;

if useMedian
    % ----- Median + IQR -----
    medianCurve = median(GLM_locoDiamMatrix(:, duraVessels), 2, 'omitnan');
    q25 = prctile(GLM_locoDiamMatrix(:, duraVessels), 25, 2);
    q75 = prctile(GLM_locoDiamMatrix(:, duraVessels), 75, 2);

    y_lower = q25;
    y_upper = q75;

    % Plot shaded region for IQR
    fill([x; flipud(x)], [y_upper; flipud(y_lower)], red, ...
        'FaceAlpha', 0.3, 'EdgeColor', 'none');
    % Plot the median curve
    plot(x, medianCurve, 'k', 'LineWidth', 1);

else
    % ----- Mean + SEM -----
    meanCurve = mean(GLM_locoDiamMatrix(:, duraVessels), 2, 'omitnan');
    stdCurve  = std(GLM_locoDiamMatrix(:, duraVessels), 0, 2, 'omitnan');
    nVessels  = sum(~isnan(GLM_locoDiamMatrix(:, duraVessels)), 2);
    semCurve  = stdCurve ./ sqrt(nVessels);

    y_upper = meanCurve + semCurve;
    y_lower = meanCurve - semCurve;

    % Plot shaded region for SEM
    fill([x; flipud(x)], [y_upper; flipud(y_lower)], red, ...
        'FaceAlpha', 0.3, 'EdgeColor', 'none');
    % Plot the mean curve
    plot(x, meanCurve, 'k', 'LineWidth', 1);
end

% Optional horizontal line
% yline(0, '--', 'Color', [0.5,0.5,0.5], 'LineWidth', 1);
% 
% greenC7 = [65, 240, 174] / 255; % Normalize RGB to [0,1]
% 
% figure;
% hold on;
% 
% % Compute the mean and standard deviation across vessels
% meanCurve = mean(GLM_locoDiamMatrix(:, duraVessels), 2, 'omitnan'); % Mean curve
% stdCurve = std(GLM_locoDiamMatrix(:, duraVessels), 0, 2, 'omitnan'); % Standard deviation
% nVessels = sum(~isnan(GLM_locoDiamMatrix(:, duraVessels)), 2); % Counts non-NaN vessels at each time point
% semCurve = stdCurve ./ sqrt(nVessels); % Standard error of the mean
% 
% % Define upper and lower bounds for shading
% y_upper = meanCurve + semCurve;
% y_lower = meanCurve - semCurve;
% 
% % Plot shaded region for individual variation
% fill([x; flipud(x)], [y_upper; flipud(y_lower)], greenC7, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
% 
% % Plot the mean curve in a distinct color (e.g., red, thicker line)
% h2 = plot(x, meanCurve, 'k', 'LineWidth', 1);
% 
% %yline(0, '--', 'Color', [0.5,0.5,0.5], 'LineWidth', 1); % Dashed black line at y = 0

% Formatting
xlim([-60 60]);
xlabel('Delay (sec)');
ylabel('Coefficient value');
%title('Pia Vessel Response to Locomotion State');
grid off;

% Create legend
%legend({'Mean ± SD', 'Mean Curve'}, 'Location', 'Best');
ax = gca;
ax.FontSize = 16; 
set(gca, 'Color', 'w'); % Ensure the background is white
set(findall(gca, 'Type', 'patch'), 'FaceAlpha', 1); % Make patches fully opaque
set(gca, 'TickDir', 'out'); % Make tick marks point outward
%set(findall(gca, 'Type', 'line'), 'Color', [0 0 0]); % Ensure line colors are solid


hold off;
%% CENTER OF MASS PIA and DURA 

% Given time series data
T = (1:size(GLM_locoDiamMatrix, 1))'; % Time points

% Compute center of mass for each column
COM = sum(T .* abs(GLM_locoDiamMatrix), 1) ./ sum(abs(GLM_locoDiamMatrix), 1);
COM_relative = COM - 60;

COM_pia = COM_relative(piaVessels);
COM_pia_average = mean(COM_pia);

COM_dura = COM_relative(duraVessels);
COM_dura_average = mean(COM_dura);