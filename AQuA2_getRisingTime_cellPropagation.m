% i = event number
for i = 1:numel(res.evtFavList1)
    imagesc(res.riseLst1{1, i}.dlyMap50)
    
    %propagation matrix
    matrix = res.riseLst1{1, i}.dlyMap50;

    % Find the maximum value
    maxValue = max(matrix(:));
    % Find all positions of the maximum value
    [maxRows, maxCols] = find(matrix == maxValue);
    
    % Find the minimum value
    minValue = min(matrix(:));
    % Find all positions of the minimum value
    [minRows, minCols] = find(matrix == minValue);
    
    % Display the results for maximum value
    disp(['Maximum value: ', num2str(maxValue)]);
    disp('Positions of max value:');
    for j = 1:length(maxRows)
        disp(['(', num2str(maxRows(j)), ', ', num2str(maxCols(j)), ')']);
    end
    
    % Display the results for minimum value
    disp(['Minimum value: ', num2str(minValue)]);
    disp('Positions of min value:');
    for j = 1:length(minRows)
        disp(['(', num2str(minRows(j)), ', ', num2str(minCols(j)), ')']);
    end

end


%% Calculating propagation distance (um) relative to area(um2) of event

% load metadata of Aqua as it is


%distribution of the starting point (histogram of images)


% Define the directory containing your images
imageDir = 'D:\2photon\Simone\Simone_Macrophages\Pf4Ai162-2\221130_FOV6\AQuA2\Pf4Ai162-2_221130_FOV6_run1_reg_Z01_green_Substack(1-927)\risingMaps_CH1';

% Get a list of image files in the directory
imageFiles = dir(fullfile(imageDir, '*.png')); % Adjust the extension as needed

% Initialize an array to store start point locations
startPoints = [];

% Loop through each image
for i = 1:length(imageFiles)
    % Read the image
    img = imread(fullfile(imageDir, imageFiles(i).name));
    
    % Convert the image to grayscale (if not already)
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    % Threshold the image to identify the start region (dark blue)
    % Adjust the threshold value as needed
    threshold = 50;
    startRegion = img < threshold;
    
    % Find the centroid of the start region
    stats = regionprops(startRegion, 'Centroid');
    if ~isempty(stats)
        startPoint = stats(1).Centroid;
        startPoints = [startPoints; startPoint];
    end
end
