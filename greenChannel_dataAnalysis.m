
greenChannel_data = [aqua; manual];
greenChannel_data = array2table(greenChannel_data);
greenChannel_data.Properties.VariableNames = {'Area_um2','Area_px','Perimeter','Circularity','Red','Mode'};

area_px_Thrd_indices = greenChannel_data.Area_px > 523;
greenChannel_data_filtered = greenChannel_data(area_px_Thrd_indices,:);

aqua_indices = greenChannel_data_filtered.Mode == 1;
manual_indices = greenChannel_data_filtered.Mode == 2;

%% Circularity
circularity = greenChannel_data_filtered.Circularity;
circularity_aqua = circularity(aqua_indices);
circularity_manual = circularity(manual_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({circularity_aqua, circularity_manual}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Circularity', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 2]);
xticks([1, 2]);
xticklabels({'AQuA', 'Manual'});

% Remove top and right lines
box off;

% Perform t-test
[h, circularity_p_value] = ttest2(circularity_aqua, circularity_manual);


%% Area(um2)
area_um2 = greenChannel_data_filtered.Area_um2;
area_um2_aqua = area_um2(aqua_indices);
area_um2_manual = area_um2(manual_indices);

% Create a combined violin plot for both groups
figure;
barColors = [1 0 0; 0 0 1];
violin({area_um2_aqua, area_um2_manual}, ...
    'facecolor', barColors, 'edgecolor', [], 'mc', 'k');
ylabel('Area(um2)', 'FontName', 'Helvetica', 'FontSize', 18);
ylim([0, 1000]);
xticks([1, 2]);
xticklabels({'AQuA', 'Manual'});

% Remove top and right lines
box off;

% Perform t-test
[h, area_um2_p_value] = ttest2(area_um2_aqua, area_um2_manual);

%% Red Label

redLabel = greenChannel_data_filtered.Red == 1;
Aqua_mode = greenChannel_data_filtered.Mode == 1;

% Count cells labeled with red and those not labeled with red
aqua_red = sum(Aqua_mode == 1 & redLabel == 1);
aqua_not_red = sum(Aqua_mode == 1 & redLabel == 0);
manual_red = sum(Aqua_mode == 0 & redLabel == 1);
manual_not_red = sum(Aqua_mode == 0 & redLabel == 0);

% Create grouped bar chart with custom colors
figure;
bar_data = [aqua_red, aqua_not_red; manual_red, manual_not_red];
bar_handle = bar(bar_data, 'grouped');

% Set custom colors
set(bar_handle(1), 'FaceColor', 'red');
set(bar_handle(2), 'FaceColor', 'green');

% Customize plot
ylabel('Number of Cells');
xticklabels({'Aqua', 'Manual'}); % Adjusted position for clarity
legend({'Red Label', 'No Red Label'}, 'Location', 'best');
title('Presence of red dextran');
ylim([0, 350]);
