%% Use GLM to assess contribution of different variables

% Clear any previous variables in the Workspace and Command Window to start fresh
clear; clc; close all;

% TODO -- Set the directory of where animal folders are located
dataDir =  'D:\2photon\Simone\Simone_Macrophages\'; % 'D:\2photon\Simone\Simone_Vasculature\'; 'D:\2photon\Simone\Simone_Macrophages\'; %  

% PARSE DATA TABLE 

% TODO --- Set excel sheet
dataSet = 'Macrophage'; %'Macrophage'; 'AffCSD'; 'Pollen'; 'Vasculature'; %  'Astrocyte'; %  'Anatomy'; %  'Neutrophil_Simone'; % 'Afferents'
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
xPresent = 22;
Npresent = numel(xPresent);
overwrite = false;

GLMname = 'diamFluor';
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
    diamFluor_opts{x}.minDev = 0.05; 
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

    %define number of frames preCSD and postCSD
    totalRuns = expt{x}.Nruns;
    totalFrames = numel(vesselROI{x}{1,1}(1).diameter.um_lp);
    if numel(expt{x}.preRuns) == 1
        preRunsFrames = 1800; % 1800 frames at 1Hz = 30min (baseline)
    end
    postRunsFrames = totalFrames - preRunsFrames;

    %vesselROIpool = [vesselROI{x}{~cellfun(@isempty, vesselROI{x})}];
    bigVesselInd = find(strcmpi({vesselROI{x}{1,1}.vesselType}, {'A'}) | strcmpi({vesselROI{x}{1,1}.vesselType}, {'D'}));
    diamPool = [vesselROI{x}{1,1}(bigVesselInd).diameter];
    allDiam = cat(1, diamPool.um_lp)';
    allDiamZ = zscore(allDiam, [], 1);

    if ~isnan(expt{x}.csd)
        allDiam_preRuns = allDiam(1:preRunsFrames,:);
        allDiamZ_preRuns = zscore(allDiam_preRuns, [], 1);
        allDiam_postRuns = allDiam(preRunsFrames+1:totalFrames,:);
        allDiamZ_postRuns = zscore(allDiam_postRuns, [], 1);
    end

    diamData = BinDownMean( allDiam_preRuns, diamFluor_opts{x}.binSize ); % allDiamZ; 

    diamFluor_pred{x} = struct('data',[], 'name',[], 'N',NaN, 'TB',[], 'lopo',[], 'fam',[]); 
    diamFluor_pred{x}.data = allDiam_preRuns; % accelData, stateData, allDiam
    diamFluor_pred{x}.name = sprintfc('Diam %i', 1:size(allDiam,2)); %  '|Accel|', 'State'
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
    %double-check if x value is still what you set (AQuA analysis code also
    %had x value that is sometimes overwriting here)

    cellFluorPool = [resultsFinal.dFF];
    fluorResp = cat(1, cellFluorPool{:})';
    fluorRespZ = zscore(fluorResp, [], 1);

    diamFluor_resp{x}.data = fluorResp; % tempScaleMag; %
    diamFluor_resp{x}.N = size(diamFluor_resp{x}.data, 2); 
    diamFluor_resp{x}.name = sprintfc('Fluor %i', 1:diamFluor_resp{x}.N);

    % Remove scans with missing data 
    nanFrame = find(any(isnan([diamFluor_pred{x}.data, diamFluor_resp{x}.data]),2)); % find( isnan(sum(pred(x).data,2)) ); 
    fprintf('\nRemoving %i NaN-containing frames', numel(nanFrame));
    diamFluor_pred{x}.data(nanFrame,:) = []; 
    diamFluor_resp{x}.data(nanFrame,:) = [];

    % Run the GLM
    diamFluor_opts{x}.load = true; % false; % 
    diamFluor_opts{x}.saveRoot = expt{x}.dir; %''; %expt{x}.dir
    [diamFluor_result{x}, diamFluor_summary{x}, ~, diamFluor_pred{x}, diamFluor_resp{x}] = GLMparallel(diamFluor_pred{x}, diamFluor_resp{x}, diamFluor_opts{x}); 
end
%%
for x = xPresent
    diamFluor_opts{x}.rShow = 1:diamFluor_resp{x}.N; %1:locoDiamDeform_resp{x}.N; % 1:LocoDeform_resp{x}.N; %NaN;
    diamFluor_opts{x}.xVar = 'Time';
    ViewGLM(diamFluor_pred{x}, diamFluor_resp{x}, diamFluor_opts{x}, diamFluor_result{x}, diamFluor_summary{x}); %GLMresultFig = 
end