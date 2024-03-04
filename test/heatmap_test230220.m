clc;
clear 
close all;

cd('R:\Levy Lab\Simone\Matlab_toplot\')
data_filename = 'ongoing_activity_230217.csv';
data = readmatrix(data_filename, 'NumHeaderLines', 0); % don't read variable names

% Default Parameters
cmap = redbluecmap; %original color map contain just 11 colors
newCmap = imresize(cmap, [128, 3]); %increase number of colors
newCmap = min(max(newCmap, 0), 1);
colorBar = [-2 5];
missingData = [.7 .7 .7];

h1 = heatmap(data(2:5, 2:end), ...
    'Colormap', newCmap, ...
    'GridVisible','off', ...
    'ColorLimits', colorBar, ...
    'MissingDataColor', missingData, ...
    height=nrow(h1)*unit(5,"mm")); 
h1 = draw(h1);

h1.XDisplayLabels = string(data(1, 2:end)); 
h1.YDisplayLabels = string(data(2:5, 1));
xlabel("Time (min)"); 
ylabel("Fiber ID");
title("Ongoing Activity"); 
saveas(h1, 'Heatmap1.jpg')
