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
locoDiam_pred = cell(1,Nexpt); 
locoDiam_resp = cell(1,Nexpt); 
locoDiam_opts = cell(1,Nexpt); 
locoDiam_result = cell(1,Nexpt); 
locoDiam_summary = cell(1,Nexpt);

% Specify row number(X) within excel sheet
xPresent = 23;
Npresent = numel(xPresent);
overwrite = false;

GLMname = 'locoDiam_baseline';
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
    locoDiam_opts{x}.name = sprintf('%s_%s', expt{x}.name, GLMname); %strcat(expt{x}.name, , '_preCSDglm');
    locoDiam_opts{x}.rShow = NaN;
    locoDiam_opts{x}.figDir = ''; % figDir;

    % Signal processing parameters
    locoDiam_opts{x}.trainFrac = 0.75; % 1; %
    locoDiam_opts{x}.Ncycle = 20;
    locoDiam_opts{x}.minDev = 0.1; %0.05
    locoDiam_opts{x}.minDevFrac = 0.1;
    locoDiam_opts{x}.maxP = 0.05;
    locoDiam_opts{x}.Nshuff = 0;  
    locoDiam_opts{x}.minShuff = 15; %??
    locoDiam_opts{x}.window = [-60,60]; % [0,0]; % [-0.5, 0.5]; %consider temporal shifts this many seconds after/before response
    locoDiam_opts{x}.lopo = true; %false;

    % Downsample data to GLMrate target 
    locoDiam_opts{x}.frameRate = GLMrate;  % GLMrate; %expt{x}.scanRate
    locoDiam_opts{x}.binSize = max([1,round(expt{x}.scanRate/GLMrate)]); 
    locoDiam_opts{x}.minShuffFrame = round( locoDiam_opts{x}.frameRate*locoDiam_opts{x}.minShuff );
    windowFrame = [ceil(locoDiam_opts{x}.window(1)*locoDiam_opts{x}.frameRate), floor(locoDiam_opts{x}.window(2)*locoDiam_opts{x}.frameRate)];
    %windowFrame = round(locoDiam_opts{x}.window*locoDiam_opts{x}.frameRate); %window(sec)*frameRate
    locoDiam_opts{x}.shiftFrame = windowFrame(1):windowFrame(2);
    locoDiam_opts{x}.maxShift = max( abs(windowFrame) );
    locoDiam_opts{x}.Nshift = numel( locoDiam_opts{x}.shiftFrame );  %Nshift = preCSDOpts(x).Nshift;
    locoDiam_opts{x}.lags = locoDiam_opts{x}.shiftFrame/locoDiam_opts{x}.frameRate; %[-sec,+sec]
    locoDiam_opts{x}.xVar = 'Time';

    % GLMnet parameters - don't change without a good reason
    locoDiam_opts{x}.distribution = 'gaussian'; % 'poisson'; %  
    locoDiam_opts{x}.CVfold = 10;
    locoDiam_opts{x}.nlamda = 1000;
    locoDiam_opts{x}.maxit = 5*10^5;
    locoDiam_opts{x}.alpha = 0.01;  % The regularization parameter, default is 0.01
    locoDiam_opts{x}.standardize = true; 

    % PREDICTORS
    % Locomotion
    %adjust frames based on Substack used for fluorescence
    substack = input('Enter substack frames (e.g., 200:5599): ');
    subtackDiam = substack';

    % Get locomotion data
    for runs = expt{x}.runs % flip(expt{x}.runs) % 
        loco{x}(runs) = GetLocoData( runInfo{x}(runs), 'show',false ); 
    end

    %Get locomotion state
    if any(cellfun(@isempty, {loco{x}.stateDown})) %isempty(loco{x}.stateDown)
            try
                loco{x} = GetLocoState(expt{x}, loco{x}, 'dir',strcat(dataDir, expt{x}.mouse,'\'), 'name',expt{x}.mouse, 'var','velocity', 'show',true); %
            catch
                fprintf('\nGetLocoState failed for %s', expt{x}.name)
            end
    end

    if expt{x}.Nruns == 1  %for single runs ONLY - adjust frame number of kinetics to match vascular projection
        tempVelocityCat = BinDownMean( vertcat(loco{x}(expt{x}.preRuns).Vdown), locoDiam_opts{x}.binSize );
        tempAccelCat = BinDownMean( abs(vertcat(loco{x}(expt{x}.preRuns).Adown)), locoDiam_opts{x}.binSize ); 
        tempStateCat = BinDownMean( vertcat(loco{x}(expt{x}.preRuns).stateDown), locoDiam_opts{x}.binSize );

        %adjust frames based on Substack used
        tempVelocityCat = tempVelocityCat(substack); 
        tempAccelCat = tempAccelCat(substack);
        tempStateCat = tempStateCat(substack);

    else %for multiple runs ONLY - adjust frame number of kinetics to match vascular projection
        for preRun = 1:expt{x}.Nruns
            loco{x}(preRun).Vdown(1:15) = [];
            loco{x}(preRun).Adown(1:15) = [];
            %loco{x}(preRun).stateDown(1:15) = [];
        end
        % Define locomotion predictors
        tempVelocityCat = BinDownMean( vertcat(loco{x}(expt{x}.preRuns).Vdown), locoDiam_opts{x}.binSize );
        tempAccelCat = BinDownMean( abs(vertcat(loco{x}(expt{x}.preRuns).Adown)), locoDiam_opts{x}.binSize ); 
        tempStateCat = BinDownMean( vertcat(loco{x}(expt{x}.preRuns).stateDown), locoDiam_opts{x}.binSize );

        %adjust frames based on Substack used
        tempVelocityCat = tempVelocityCat(200:5599); 
        tempAccelCat = tempAccelCat(200:5599);
        tempStateCat = tempStateCat(200:5599);
    end

%     tempVelocityCat = BinDownMean( vertcat(loco{x}(expt{x}.preRuns).Vdown), locoDiam_opts{x}.binSize );
%     tempAccelCat = BinDownMean( abs(vertcat(loco{x}(expt{x}.preRuns).Adown)), locoDiam_opts{x}.binSize ); 
%     tempStateCat = BinDownMean( vertcat(loco{x}(expt{x}.preRuns).stateDown), locoDiam_opts{x}.binSize );

    locoFluor_pred{x} = struct('data',[], 'name',[], 'N',NaN, 'TB',[], 'lopo',[], 'fam',[]); 
    locoFluor_pred{x}.data = [tempVelocityCat, tempAccelCat,  tempStateCat]; %  tempStateCat
    locoFluor_pred{x}.name = {'Velocity', '|Accel|', 'State'}; %'State'
    locoFluor_pred{x}.N = size(locoFluor_pred{x}.data,2);
    for p = flip(1:locoFluor_pred{x}.N) 
        locoFluor_pred{x}.lopo.name{p} = ['No ',locoFluor_pred{x}.name{p}]; 
    end

    % Set up leave-one-family-out
    firstDiamInd = find(contains(locoDiam_pred{x}.name, 'Diam'), 1);
    locoDiam_pred{x}.fam.col = {}; %1:firstDiamInd-1, firstDiamInd:diamFluor_pred{x}.N}; %{1:4, 5:7}; %{1:2, 3:4, 5:6, 7:8, 9:10, 11:12};  % {1:12};%{1, 2:3, 4:5, 6:7, 8, 9}; 
    locoDiam_pred{x}.fam.N = numel(locoDiam_pred{x}.fam.col); 
    locoDiam_pred{x}.fam.name = {}; 

    % RESPONSE
    % Load vascular data
    [vesselROI{x}, NvesselROI{x}, tifStackMax{x}] = SegmentVasculature(expt{x}, projParam, 'overwrite',false, 'review',false );

    % Define vascular diameter data 
    bigVesselInd = find(strcmpi({vesselROI{x}{1,1}.vesselType}, {'A'}) | strcmpi({vesselROI{x}{1,1}.vesselType}, {'V'}) | strcmpi({vesselROI{x}{1,1}.vesselType}, {'D'}));
    diamPool = [vesselROI{x}{1,1}(bigVesselInd).diameter];
    allDiam = cat(1, diamPool.um_lp)'; %lp - low pass filter?
    allDiamZ = zscore(allDiam, [], 1);

    locoDiam_pred{x} = struct('data',[], 'name',[], 'N',NaN, 'TB',[], 'lopo',[], 'fam',[]); 

    % allDiam
    locoDiam_summary_deviances = [];
    locoDiam_summary_peakCoefficients = [];
    locoDiam_summary_peakLags = [];

%     % allDiamZ (Z-score)
%     diamZFluor_summary_deviances = [];
%     diamZFluor_summary_peakCoefficients = [];
%     diamZFluor_summary_peakLags = [];

    for vessel = 1:numel(diamPool)


        locoDiam_pred{x}.data = allDiamZ(1:927, vessel); % 901:1800 Zscore %change range according to Substack
        locoDiam_pred{x}.name = sprintfc('Diam %i', vessel); % 1:size(allDiam,2);  '|Accel|', 'State'
        locoDiam_pred{x}.N = size(locoDiam_pred{x}.data,2);
        for p = flip(1:locoDiam_pred{x}.N)
            locoDiam_pred{x}.lopo.name{p} = ['No ',locoDiam_pred{x}.name{p}]; 
        end
    
        % Set up leave-one-family-out
        firstDiamInd = find(contains(locoDiam_pred{x}.name, 'Diam'), 1);
        locoDiam_pred{x}.fam.col = {}; %1:firstDiamInd-1, firstDiamInd:diamFluor_pred{x}.N}; %{1:4, 5:7}; %{1:2, 3:4, 5:6, 7:8, 9:10, 11:12};  % {1:12};%{1, 2:3, 4:5, 6:7, 8, 9}; 
        locoDiam_pred{x}.fam.N = numel(locoDiam_pred{x}.fam.col); 
        locoDiam_pred{x}.fam.name = {}; 
    
        % Define response

        
        cellFluorPool = [resultsFinal.dFF];
        fluorResp = cat(1, cellFluorPool{:})';
        fluorRespZ = zscore(fluorResp, [], 1);
    
        locoDiam_resp{x}.data = fluorResp; 
        locoDiam_resp{x}.N = size(locoDiam_resp{x}.data, 2); 
    
        %extract Cell ID from resultsFinal
        fluorIDs = table2cell(resultsFinal(:,1))';
        locoDiam_resp{x}.name = fluorIDs; 
    
        % Remove scans with missing data 
        nanFrame = find(any(isnan([locoDiam_pred{x}.data, locoDiam_resp{x}.data]),2)); % find( isnan(sum(pred(x).data,2)) ); 
        fprintf('\nRemoving %i NaN-containing frames', numel(nanFrame));
        locoDiam_pred{x}.data(nanFrame,:) = []; 
        locoDiam_resp{x}.data(nanFrame,:) = [];

        % GLM name update by vessel
        GLMname_vessel = sprintf('GLM_locoDiam_baseline_vessel%i', vessel);
        locoDiam_opts{x}.name = sprintf('%s_%s', fileTemp, GLMname_vessel); 
    
        % Run the GLM
        locoDiam_opts{x}.load = false; % false; % 
        locoDiam_opts{x}.saveRoot = sprintf('%s', expt{x}.dir, 'GLMs\GLM_locoDiam\'); %''; %expt{x}.dir
        mkdir (locoDiam_opts{x}.saveRoot);
        [locoDiam_result{x}, locoDiam_summary{x}, ~, locoDiam_pred{x}, locoDiam_resp{x}] = GLMparallel(locoDiam_pred{x}, locoDiam_resp{x}, locoDiam_opts{x}); 

        % create results table and add locoDiam summary by vessel
        locoDiam_summary_deviances = [locoDiam_summary_deviances; locoDiam_summary{x}.dev];
        locoDiam_summary_peakCoefficients = [locoDiam_summary_peakCoefficients; locoDiam_summary{x}.peakCoeff'];
        locoDiam_summary_peakLags = [locoDiam_summary_peakLags; locoDiam_summary{x}.peakLag'];

        %Show results
        locoDiam_opts{x}.rShow = 1:locoDiam_resp{x}.N; %1:locoDiamDeform_resp{x}.N; % 1:LocoDeform_resp{x}.N; %NaN;
        locoDiam_opts{x}.xVar = 'Time';
        ViewGLM(locoDiam_pred{x}, locoDiam_resp{x}, locoDiam_opts{x}, locoDiam_result{x}, locoDiam_summary{x}); %GLMresultFig = 

    end
end
%% Gather all summary data (deviances, peakCoefficients and peakLags of each cell against each vessel) - SCN
    
    % locoDiam_summary_deviances 
    locoDiam_summary_deviances = array2table(locoDiam_summary_deviances);
    cellHeadings = cellstr(locoDiam_resp{x}.name(1,:));
    locoDiam_summary_deviances.Properties.VariableNames = cellHeadings;
    locoDiam_summary_deviances.Properties.RowNames = sprintfc('Diam %i', 1:size(allDiam,2)); %cellstr(diamFluor_pred{x}.name(1,:)');
    locoDiam_summary_deviancesBinary = locoDiam_summary_deviances{:,:} > 0.1; %applies the logical operation and creates matrix
    locoDiam_summary_deviancesBinary = array2table(locoDiam_summary_deviancesBinary, 'VariableNames', locoDiam_summary_deviances.Properties.VariableNames);

    % locoDiam_summary_peakCoefficients 
    locoDiam_summary_peakCoefficients = array2table(locoDiam_summary_peakCoefficients);
    cellHeadings = cellstr(locoDiam_resp{x}.name(1,:));
    locoDiam_summary_peakCoefficients.Properties.VariableNames = cellHeadings;
    locoDiam_summary_peakCoefficients.Properties.RowNames = sprintfc('Diam %i', 1:size(allDiam,2)); %cellstr(diamFluor_pred{x}.name(1,:)');
 
    % locoDiam_summary_peakLags
    locoDiam_summary_peakLags = array2table(locoDiam_summary_peakLags);
    cellHeadings = cellstr(locoDiam_resp{x}.name(1,:));
    locoDiam_summary_peakLags.Properties.VariableNames = cellHeadings;
    locoDiam_summary_peakLags.Properties.RowNames = sprintfc('Diam %i', 1:size(allDiam,2)); %cellstr(locoDiam_pred{x}.name(1,:)');

    % Save metadata inside FOV folder
    save(fullfile(locoDiam_opts{x}.saveRoot, strcat(fileTemp,'_GLM_diamFluor'))); % save metadata inside FOV folder

    % Access the vessel map based on the current iteration
    %imshow(vesselROI{1, 22}{1, 1}(7).boxIm)  
    
%%
for x = xPresent
    locoDiam_opts{x}.rShow = 1:locoDiam_resp{x}.N; %1:locoDiamDeform_resp{x}.N; % 1:LocoDeform_resp{x}.N; %NaN;
    locoDiam_opts{x}.xVar = 'Time';
    ViewGLM(locoDiam_pred{x}, locoDiam_resp{x}, locoDiam_opts{x}, locoDiam_result{x}, locoDiam_summary{x}); %GLMresultFig = 
end