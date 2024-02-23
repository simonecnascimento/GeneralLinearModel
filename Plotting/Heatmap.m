clc;
clear 
close all;

cd('R:\Levy Lab\Simone\Matlab_toplot\')
data_filename = 'ongoing_activity_230516_new_DL89.xlsx';
data = readmatrix(data_filename, 'NumHeaderLines', 0); % don't read variable names

% Default Parameters
cmap = redbluecmap; %original color map contain just 11 colors
newCmap = imresize(cmap, [128, 3]); %increase number of colors
newCmap = min(max(newCmap, 0), 1);
colorBar = [-2 5];
missingData = [.7 .7 .7];

%Create 1 heatmap
h = heatmap(data(2:end, 2:end), 'Colormap', redbluecmap, 'GridVisible','off', MissingDataColor='w'); 
h.XDisplayLabels = string(data(1, 2:end)); 
h.YDisplayLabels = string(data(2:end, 1))
xlabel("Time (min)"); 
ylabel("Fiber ID (-)");
title("Ongoing Activity"); 
saveas(h, 'Heatmap1_230516.jpg')

%Create multiple heatmaps by fiber
h1 = heatmap(data(2:5, 2:end), 'Colormap', newCmap, 'GridVisible','off', 'ColorLimits', colorBar, 'MissingDataColor', missingData); 
h1.XDisplayLabels = string(data(1, 2:end)); 
h1.YDisplayLabels = string(data(2:5, 1));
xlabel("Time (min)"); 
ylabel("Fiber ID");
title("Ongoing Activity"); 
saveas(h1, 'Heatmap1_230516.jpg')

h2 = heatmap(data(7:12, 2:end), 'Colormap', newCmap, 'GridVisible','off', 'ColorLimits', colorBar, 'MissingDataColor', missingData); 
h2.XDisplayLabels = string(data(1, 2:end)); 
h2.YDisplayLabels = string(data(7:12, 1));
xlabel("Time (min)"); 
ylabel("Fiber ID");
title("Ongoing Activity"); 
saveas(h2, 'Heatmap2.jpg')

h3 = heatmap(data(14:31, 2:end), 'Colormap', newCmap, 'GridVisible','off', 'ColorLimits', colorBar, 'MissingDataColor', missingData); 
h3.XDisplayLabels = string(data(1, 2:end)); 
h3.YDisplayLabels = string(data(14:31, 1));
xlabel("Time (min)"); 
ylabel("Fiber ID");
title("Ongoing Activity"); 
saveas(h3, 'Heatmap3.jpg')
