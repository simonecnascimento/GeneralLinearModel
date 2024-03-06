%% Use GLM to assess contribution of different variables

% Clear any previous variables in the Workspace and Command Window to start fresh
clear; clc; close all;

% TODO -- Set the directory of where animal folders are located
dataDir =  'D:\2photon\Simone\Simone_Macrophages\'; % 'D:\2photon\Simone\Simone_Vasculature\'; 'D:\2photon\Simone\Simone_Macrophages\'; %  

% PARSE DATA TABLE 

% TODO --- Set excel sheet
dataSet = 'MacrophageBaseline'; %'Macrophage'; 'AffCSD'; 'Pollen'; 'Vasculature'; %  'Astrocyte'; %  'Anatomy'; %  'Neutrophil_Simone'; % 'Afferents'
[regParam, projParam] = DefaultProcessingParams(dataSet); % get default parameters for processing various types of data

regParam.method = 'translation'; %rigid 
regParam.name = 'translation'; %rigid  

% TODO --- Set data spreadsheet directory
dataTablePath = 'R:\Levy Lab\2photon\ImagingDatasets_Simone.xlsx'; % 'R:\Levy Lab\2photon\ImagingDatasetsSimone2.xlsx';
dataTable = readcell(dataTablePath, 'sheet',dataSet);  % 'NGC', ''
colNames = dataTable(1,:); dataTable(1,:) = [];
dataCol = struct('mouse',find(contains(colNames, 'Mouse')), 'date',find(contains(colNames, 'Date')), 'FOV',find(contains(colNames, 'FOV')), 'vascChan',find(contains(colNames, 'VascChan')),...
    'volume',find(contains(colNames, 'Volume')), 'run',find(contains(colNames, 'Runs')), 'Ztop',find(contains(colNames, 'Zbot')), 'Zbot',find(contains(colNames, 'Ztop')), 'csd',find(contains(colNames, 'CSD')), ...
    'ref',find(contains(colNames, 'Ref')), 'edges',find(contains(colNames, 'Edge')), 'Zproj',find(contains(colNames, 'Zproj')), 'done',find(contains(colNames, 'Done')));
Nexpt = size(dataTable, 1);
dataTable(:,dataCol.date) = cellfun(@num2str, dataTable(:,dataCol.date), 'UniformOutput',false);

% Use GLM to assess contribution of different variables
% Initialize variables
diamFluor_pred = cell(1,Nexpt); 
diamFluor_resp = cell(1,Nexpt); 
diamFluor_opts = cell(1,Nexpt); 
diamFluor_result = cell(1,Nexpt); 
diamFluor_summary = cell(1,Nexpt);

% Specify row number(X) within excel sheet
xPresent = 2;
Npresent = numel(xPresent);
overwrite = false;

GLMname = 'diamFluor_baseline';
figDir = 'D:\MATLAB\Figures\GLM_DiameterFluorescence\';  % CSD figures\
mkdir( figDir );

% Set GLM rate
GLMrate = 1; %15.49/16 for 3D data %projParam.rate_target = 1 for 2D data
%% 
for x = xPresent % x3D % 

    % Parse data table
    [expt{x}, runInfo{x}, regParam, projParam] = ParseDataTable(dataTable, x, dataCol, dataDir, regParam, projParam);
    [Tscan{x}, runInfo{x}] = GetTime(runInfo{x});  % , Tcat{x}

    % Load vascular data
    [vesselROI{x}, NvesselROI{x}, tifStackMax{x}] = SegmentVasculature(expt{x}, projParam, 'overwrite',false, 'review',false );

    % GLMparallel options
    %housekeeping
    diamFluor_opts{x}.name = sprintf('%s_%s', expt{x}.name, GLMname); %strcat(expt{x}.name, , '_preCSDglm');
    diamFluor_opts{x}.rShow = NaN;
    diamFluor_opts{x}.figDir = ''; % figDir;

    % Signal processing parameters
    diamFluor_opts{x}.trainFrac = 0.75; % 1; %
    diamFluor_opts{x}.Ncycle = 20;
    diamFluor_opts{x}.minDev = 0.1; %0.05
    diamFluor_opts{x}.minDevFrac = 0.1;
    diamFluor_opts{x}.maxP = 0.05;
    diamFluor_opts{x}.Nshuff = 0;  
    diamFluor_opts{x}.minShuff = 15; %??
    diamFluor_opts{x}.window = [-60,60]; % [0,0]; % [-0.5, 0.5]; %consider temporal shifts this many seconds after/before response
    diamFluor_opts{x}.lopo = true; %false;

    % Downsample data to GLMrate target 
    diamFluor_opts{x}.frameRate = GLMrate;  % GLMrate; %expt{x}.scanRate
    diamFluor_opts{x}.binSize = max([1,round(expt{x}.scanRate/GLMrate)]); 
    diamFluor_opts{x}.minShuffFrame = round( diamFluor_opts{x}.frameRate*diamFluor_opts{x}.minShuff );
    windowFrame = [ceil(diamFluor_opts{x}.window(1)*diamFluor_opts{x}.frameRate), floor(diamFluor_opts{x}.window(2)*diamFluor_opts{x}.frameRate)];
    %windowFrame = round(locoDiam_opts{x}.window*locoDiam_opts{x}.frameRate); %window(sec)*frameRate
    diamFluor_opts{x}.shiftFrame = windowFrame(1):windowFrame(2);
    diamFluor_opts{x}.maxShift = max( abs(windowFrame) );
    diamFluor_opts{x}.Nshift = numel( diamFluor_opts{x}.shiftFrame );  %Nshift = preCSDOpts(x).Nshift;
    diamFluor_opts{x}.lags = diamFluor_opts{x}.shiftFrame/diamFluor_opts{x}.frameRate; %[-sec,+sec]
    diamFluor_opts{x}.xVar = 'Time';

    % GLMnet parameters - don't change without a good reason
    diamFluor_opts{x}.distribution = 'gaussian'; % 'poisson'; %  
    diamFluor_opts{x}.CVfold = 10;
    diamFluor_opts{x}.nlamda = 1000;
    diamFluor_opts{x}.maxit = 5*10^5;
    diamFluor_opts{x}.alpha = 0.01;  % The regularization parameter, default is 0.01
    diamFluor_opts{x}.standardize = true; 

    % PREDICTORS
    % Define vascular diameter data 
 
    bigVesselInd = find(strcmpi({vesselROI{x}{1,1}.vesselType}, {'A'}) | strcmpi({vesselROI{x}{1,1}.vesselType}, {'D'}));
    diamPool = [vesselROI{x}{1,1}(bigVesselInd).diameter];
    allDiam = cat(1, diamPool.um_lp)';
    allDiamZ = zscore(allDiam, [], 1);

    diamFluor_pred{x} = struct('data',[], 'name',[], 'N',NaN, 'TB',[], 'lopo',[], 'fam',[]); 

    % allDiam
    diamFluor_summary_deviances = [];
    diamFluor_summary_peakCoefficients = [];
    diamFluor_summary_peakLags = [];

%     % allDiamZ (Z-score)
%     diamZFluor_summary_deviances = [];
%     diamZFluor_summary_peakCoefficients = [];
%     diamZFluor_summary_peakLags = [];

    for vessel = 1:numel(diamPool)
        diamFluor_pred{x}.data = allDiamZ(1:900, vessel); %Zscore
        diamFluor_pred{x}.name = sprintfc('Diam %i', vessel); % 1:size(allDiam,2);  '|Accel|', 'State'
        diamFluor_pred{x}.N = size(diamFluor_pred{x}.data,2);
        for p = flip(1:diamFluor_pred{x}.N)
            diamFluor_pred{x}.lopo.name{p} = ['No ',diamFluor_pred{x}.name{p}]; 
        end
    
        % Set up leave-one-family-out
        firstDiamInd = find(contains(diamFluor_pred{x}.name, 'Diam'), 1);
        diamFluor_pred{x}.fam.col = {}; %1:firstDiamInd-1, firstDiamInd:diamFluor_pred{x}.N}; %{1:4, 5:7}; %{1:2, 3:4, 5:6, 7:8, 9:10, 11:12};  % {1:12};%{1, 2:3, 4:5, 6:7, 8, 9}; 
        diamFluor_pred{x}.fam.N = numel(diamFluor_pred{x}.fam.col); 
        diamFluor_pred{x}.fam.name = {}; 
    
        % Define response

        % Get/Load fluorescence data
        aquaPath = sprintf('%sAQuA2\\1Hz', expt{x}.dir);
        files_aqua = dir(aquaPath);

        % Exclude '.', '..', and 'Thumbs.db' entries, so 'contents' contains only the actual files and folders in the directory
        excludeList = {'.', '..', 'Thumbs.db'};
        files_aqua = files_aqua(~ismember({files_aqua.name}, excludeList));
        for f = 1:numel(files_aqua)
            if contains(files_aqua(f).name, 'analysis') 
                fileName = files_aqua(f).name;
                load(sprintf('%s\\%s', aquaPath, fileName));
            end
        end
       
        x=xPresent;  %reset experiment row value because AQuA analysis code also had x as variable
        
        cellFluorPool = [resultsFinal.dFF];
        fluorResp = cat(1, cellFluorPool{:})';
        fluorRespZ = zscore(fluorResp, [], 1);
    
        diamFluor_resp{x}.data = fluorResp; 
        diamFluor_resp{x}.N = size(diamFluor_resp{x}.data, 2); 
    
        %extract Cell ID from resultsFinal
        fluorIDs = table2cell(resultsFinal(:,1))';
        diamFluor_resp{x}.name = fluorIDs; 
    
        % Remove scans with missing data 
        nanFrame = find(any(isnan([diamFluor_pred{x}.data, diamFluor_resp{x}.data]),2)); % find( isnan(sum(pred(x).data,2)) ); 
        fprintf('\nRemoving %i NaN-containing frames', numel(nanFrame));
        diamFluor_pred{x}.data(nanFrame,:) = []; 
        diamFluor_resp{x}.data(nanFrame,:) = [];

        % GLM name update by vessel
        GLMname_vessel = sprintf('GLM_diamFluor_baseline_vessel%i', vessel);
        diamFluor_opts{x}.name = sprintf('%s_%s', fileTemp, GLMname_vessel); 
    
        % Run the GLM
        diamFluor_opts{x}.load = false; % false; % 
        diamFluor_opts{x}.saveRoot = sprintf('%s', expt{x}.dir, 'GLMs\GLM_diamFluor\'); %''; %expt{x}.dir
        [diamFluor_result{x}, diamFluor_summary{x}, ~, diamFluor_pred{x}, diamFluor_resp{x}] = GLMparallel(diamFluor_pred{x}, diamFluor_resp{x}, diamFluor_opts{x}); 

        % create results table and add diamFluor summary by vessel
        diamFluor_summary_deviances = [diamFluor_summary_deviances; diamFluor_summary{x}.dev];
        diamFluor_summary_peakCoefficients = [diamFluor_summary_peakCoefficients; diamFluor_summary{x}.peakCoeff'];
        diamFluor_summary_peakLags = [diamFluor_summary_peakLags; diamFluor_summary{x}.peakLag'];

        % Show results
%       diamFluor_opts{x}.rShow = 1:diamFluor_resp{x}.N; %1:locoDiamDeform_resp{x}.N; % 1:LocoDeform_resp{x}.N; %NaN;
%       diamFluor_opts{x}.xVar = 'Time';
%       ViewGLM(diamFluor_pred{x}, diamFluor_resp{x}, diamFluor_opts{x}, diamFluor_result{x}, diamFluor_summary{x}); %GLMresultFig = 

    end
end
%% Gather all summary data (deviances, peakCoefficients and peakLags of each cell against each vessel) - SCN
    
    % diamFluor_summary_deviances 
    diamFluor_summary_deviances = array2table(diamFluor_summary_deviances);
    cellHeadings = cellstr(diamFluor_resp{x}.name(1,:));
    diamFluor_summary_deviances.Properties.VariableNames = cellHeadings;
    diamFluor_summary_deviances.Properties.RowNames = sprintfc('Diam %i', 1:size(allDiam,2)); %cellstr(diamFluor_pred{x}.name(1,:)');
    diamFluor_summary_deviancesBinary = diamFluor_summary_deviances{:,:} > 0.1; %applies the logical operation and creates matrix
    diamFluor_summary_deviancesBinary = array2table(diamFluor_summary_deviancesBinary, 'VariableNames', diamFluor_summary_deviances.Properties.VariableNames);

    % diamFluor_summary_peakCoefficients 
    diamFluor_summary_peakCoefficients = array2table(diamFluor_summary_peakCoefficients);
    cellHeadings = cellstr(diamFluor_resp{x}.name(1,:));
    diamFluor_summary_peakCoefficients.Properties.VariableNames = cellHeadings;
    diamFluor_summary_peakCoefficients.Properties.RowNames = sprintfc('Diam %i', 1:size(allDiam,2)); %cellstr(diamFluor_pred{x}.name(1,:)');
 
    % diamFluor_summary_peakLags
    diamFluor_summary_peakLags = array2table(diamFluor_summary_peakLags);
    cellHeadings = cellstr(diamFluor_resp{x}.name(1,:));
    diamFluor_summary_peakLags.Properties.VariableNames = cellHeadings;
    diamFluor_summary_peakLags.Properties.RowNames = sprintfc('Diam %i', 1:size(allDiam,2)); %cellstr(diamFluor_pred{x}.name(1,:)');

    % Save metadata inside FOV folder
    save(fullfile(diamFluor_opts{x}.saveRoot, strcat(fileTemp,'_GLM_diamFluor'))); % save metadata inside FOV folder
    

    % Access the vessel map based on the current iteration
    %imshow(vesselROI{1, 22}{1, 1}(7).boxIm)  
    
%%
for x = xPresent
    diamFluor_opts{x}.rShow = 1:diamFluor_resp{x}.N; %1:locoDiamDeform_resp{x}.N; % 1:LocoDeform_resp{x}.N; %NaN;
    diamFluor_opts{x}.xVar = 'Time';
    ViewGLM(diamFluor_pred{x}, diamFluor_resp{x}, diamFluor_opts{x}, diamFluor_result{x}, diamFluor_summary{x}); %GLMresultFig = 
end