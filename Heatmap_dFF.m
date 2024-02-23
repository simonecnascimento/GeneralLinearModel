% function createHeatmap(data, xLabels, yLabels, titleText)
%     % data: 2D matrix of values for the heatmap
%     % xLabels: cell array of labels for the x-axis
%     % yLabels: cell array of labels for the y-axis
%     % titleText: title for the heatmap
%     
%     % Create a heatmap
%     heatmap(data, 'XLabel', 'X-axis', 'YLabel', 'Y-axis', 'XDisplayLabels', xLabels, 'YDisplayLabels', yLabels);
%     
%     % Add title
%     title(titleText);
%     
%     % Add colorbar
%     colorbar;
% end

% Default Parameters
cmap = redbluecmap; %original color map contain just 11 colors
newCmap = imresize(cmap, [128, 3]); %increase number of colors
newCmap = min(max(newCmap, 0), 1);
colorLimits = [-0.5 6];
missingData = [.7 .7 .7];

% Transpose tables
% fluorescence of fiber
fluorFiber = fluor{1,x}.dFF.axon(:,:);
fluorFiberTranspose = fluorFiber';
% fluorescence of ROI
fluorROI = fluor{1,x}.dFF.ROI(:,:);
fluorROITranspose = fluorROI';

%examples of fiber and their respective [ROIs]
fiber1 = [11,10,9,15,20,14];
fiber2 = [17,23,25];
fiber5 = [7,12];
fiber7 = 25;
fiber8 = 22;
fiber11 = 21;


%transpose data
dF_ROI = (fluor{1,x}.F.ROI(:,:))';
dFF_ROI = (fluor{1,62}.dFF.ROI)';

%segregate fluorescence based on ROIs of specific fiber
dF_ROI_fiber5 = sum(dF_ROI(fiber5,:));
dFF_ROI_fiber5 = median(dFF_ROI(fiber5,:));
dFF_ROI_fiber8 = dFF_ROI(fiber8,:);
dFF_ROI_fiber11 = dFF_ROI(fiber11,:);
dFF_ROI_fiber7 = dFF_ROI(fiber7,:);

%Heatmaps by fiber
%subplot(3,1,1);
a = fluorROITranspose(fiber5, :);
h1 = heatmap(fluorROITranspose(fiber5, :), ...
    'Colormap', newCmap, ...
    'GridVisible','off', ...
    'ColorLimits', colorLimits, ...
    'MissingDataColor', missingData, ...
    FontSize=8);
maxDffFiber5 = max(a(:));
minDffFiber5 = min(a(:));

fluorROITransposeFiber5 = sum(fluorROITranspose(fiber5,:));
h1 = heatmap(fluorROITransposeFiber5(:, :), ...
    'Colormap', newCmap, ...
    'GridVisible','off', ...
    'ColorLimits', colorLimits, ...
    'MissingDataColor', missingData, ...
    FontSize=8);
maxDffFiber5 = max(fluorROITransposeFiber5(:));
minDffFiber5 = min(fluorROITransposeFiber5(:));




b = fluorROITranspose(fiber2, :);
h2 = heatmap(fluorROITranspose(fiber2, :), ...
    'Colormap', newCmap, ...
    'GridVisible','off', ...
    'ColorLimits', colorLimits, ...
    'MissingDataColor', missingData, ...
    FontSize=8);
maxDffFiber2 = max(b(:));
minDffFiber2 = min(b(:));

, ...
    XDisplayLabels=string(data(1, 2:end)), ...
    YDisplayLabels=string(data(2:5, 1)), ...
    FontSize=8); 
%xlabel("Time (min)"); 
%ylabel("Fiber ID");
%title("Ongoing Activity"); 
saveas(h1, 'Heatmap1_230516.pdf')
maxDff1 = max(fluorROITranspose(:));
minDff1 = min(fluorROITranspose(:));

maxDff = max(fluorFiber(:));
minDff = min(fluorFiber(:));