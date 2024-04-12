%Create heatmap of dFF data by cell

%Perivascular cells
for perivascular = resultsFinal.("Cell location (0,perivascular;1,adjacent;2,none)") == 0
    dFF_perivascular = resultsFinal{perivascular,"dFF"};
end

%Convert cell array to 2D matrix
dFF_perivascular = cell2mat(dFF_perivascular);


% Define the colormap
cmap = redbluecmap; % Or any other colormap you prefer
newCmap = imresize(cmap, [128, 3]); % Increase number of colors
newCmap = min(max(newCmap, 0), 1);

% Define the color limits based on your data range
maxDff = max(dFF_perivascular(:));
minDff = min(dFF_perivascular(:));
colorLimits = [minDff maxDff]; % Using the actual minimum and maximum values of the data

% Create the heatmap with the custom colormap and color limits using imagesc
imagesc(dFF_perivascular, colorLimits);

% Apply the custom colormap
colormap(newCmap);

% Add color bar
colorbar;

% Set titles and labels
title('dFF');
xlabel('Seconds');
ylabel('Cell ID');


%% 


%Non-perivascular cells
for non_perivascular = resultsFinal.("Cell location (0,perivascular;1,adjacent;2,none)") == 2
    dFF_Nperivascular = resultsFinal{non_perivascular,"dFF"};
end

%Convert cell array to 2D matrix
dFF_Nperivascular = cell2mat(dFF_Nperivascular);


% Define the colormap
cmap = redbluecmap; % Or any other colormap you prefer
newCmap = imresize(cmap, [128, 3]); % Increase number of colors
newCmap = min(max(newCmap, 0), 1);

% Define the color limits based on your data range
maxDff = max(dFF_Nperivascular(:));
minDff = min(dFF_Nperivascular(:));
colorLimits = [minDff maxDff]; % Using the actual minimum and maximum values of the data

% Create the heatmap with the custom colormap and color limits using imagesc
imagesc(dFF_Nperivascular, colorLimits);

% Apply the custom colormap
colormap(newCmap);

% Add color bar
colorbar;

% Set titles and labels
title('dFF');
xlabel('Seconds');
ylabel('Cell ID');
