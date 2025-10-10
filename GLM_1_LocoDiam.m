%% Use GLM to assess contribution of different variables

% Clear any previous variables in the Workspace and Command Window to start fresh
clear; clc; close all;

% TODO -- Set the directory of where animal folders are located
dataDir =  'D:\2photon\Simone\Simone_Macrophages\'; % 'D:\2photon\Simone\Simone_Vasculature\'; 'D:\2photon\Simone\Simone_Macrophages\'; %  

% PARSE DATA TABLE 

% TODO --- Set excel sheet
dataSet = 'MacrophageBaseline_craniotomy'; %'Macrophage'; 'AffCSD'; 'Pollen'; 'Vasculature'; %  'Astrocyte'; %  'Anatomy'; %  'Neutrophil_Simone'; % 'Afferents'
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

% Initialize variables
expt = cell(1,Nexpt); 
runInfo = cell(1,Nexpt); 
Tscan = cell(1,Nexpt); 
loco = cell(1,Nexpt); 
Tcat = cell(1,Nexpt);
vesselROI = cell(1,Nexpt); 
NvesselROI = cell(1,Nexpt); 
tifStackMax = cell(1,Nexpt); 

% Use GLM to assess contribution of different variables
locoDiam_pred = cell(1,Nexpt); %predictors
locoDiam_resp = cell(1,Nexpt); %response
locoDiam_opts = cell(1,Nexpt); %options
locoDiam_result = cell(1,Nexpt); 
locoDiam_summary = cell(1,Nexpt);

% TODO --- Specify xPresent - row number(X) within excel sheet
xPresent = 38; %[18,22,24,30:32]; % flip(100:102); %45:47; % [66:69];
Npresent = numel(xPresent);
overwrite = false;

GLMname = 'GLM_velocityDiam_baseline'; %'GLM_locoDiam_baseline' loco - all lomotion predictors
figDir = 'D:\2photon\Simone\Simone_Macrophages\GLMs\stateDiam\';  % CSD figures\
mkdir( figDir );

% Set GLM rate
GLMrate = 1; %15.49/16 for 3D data %projParam.rate_target = 1 for 2D data

for x = xPresent % x3D % 

    % Parse data table
    [expt{x}, runInfo{x}, regParam, projParam] = ParseDataTable(dataTable, x, dataCol, dataDir, regParam, projParam);
    [Tscan{x}, runInfo{x}] = GetTime(runInfo{x});  % , Tcat{x}

    % Load vascular data
    [vesselROI{x}, NvesselROI{x}, tifStackMax{x}] = SegmentVasculature(expt{x}, projParam, 'overwrite',false, 'review',false );

    % Set GLMparallel options
    % housekeeping
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
    locoDiam_opts{x}.lopo = true; %false; %LOPO = Leave One Predictor Out

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

    % PREDICTOR - LOCOMOTION
    % Get locomotion data
    for runs = expt{x}.runs % flip(expt{x}.runs) % 
        loco{x}(runs) = GetLocoData( runInfo{x}(runs), 'show',false ); 
        %plot(loco{x}(regParam.refRun).Vdown)
    end

    %Get locomotion state
    if any(cellfun(@isempty, {loco{x}.stateDown})) %isempty(loco{x}.stateDown)
            try
                loco{x} = GetLocoState(expt{x}, loco{x}, 'dir',strcat(dataDir, expt{x}.mouse,'\'), 'name',expt{x}.mouse, 'var','velocity', 'show',true); %
            catch
                fprintf('\nGetLocoState failed for %s', expt{x}.name)
            end
    end

    % Concatenate input variables pre-CSD
    % Define locomotion predictors
    if expt{x}.Nruns == 1  %for single runs ONLY - adjust frame number of kinetics to match vascular projection
        tempVelocityCat = BinDownMean( vertcat(loco{x}(expt{x}.preRuns).Vdown), locoDiam_opts{x}.binSize );
        tempAccelCat = BinDownMean( abs(vertcat(loco{x}(expt{x}.preRuns).Adown)), locoDiam_opts{x}.binSize ); 
        tempStateCat = BinDownMean( vertcat(loco{x}(expt{x}.preRuns).stateDown), locoDiam_opts{x}.binSize );

        vascFrames = numel(vesselROI{1, x}{1,1}(1).projection(:, 2));

        if numel(tempStateCat) == (vascFrames + 1)
            %ALWAYS remove first scan. ONLY remove last scan if there is a difference of 2 frames
            tempVelocityCat = tempVelocityCat(2:end);
            tempAccelCat = tempAccelCat(2:end); 
            tempStateCat = tempStateCat(2:end); 
        elseif numel(tempStateCat) == (vascFrames + 2)
            %ONLY remove last scan if there is a difference of 2 frames
            tempVelocityCat = tempVelocityCat(2:end-1);
            tempAccelCat = tempAccelCat(2:end-1); 
            tempStateCat = tempStateCat(2:end-1);
        else
            %error('Unexpected mismatch in the number of elements of tempVelocityCat.');
            %Adjust frames based on Substack baseline (1-927). 
            %By default, 1st frame is removed when generating projection for vasculature, so for locomotion you should set substack for 2-928
            tempVelocityCat = tempVelocityCat(2:928);
            tempAccelCat = tempAccelCat(2:928); 
            tempStateCat = tempStateCat(2:928);
        end

    else %for multiple runs ONLY - adjust frame number of kinetics to match vascular projection
        for preRun = 1:expt{x}.Nruns
            loco{x}(preRun).Vdown(1:15) = [];
            loco{x}(preRun).Adown(1:15) = [];
            loco{x}(preRun).stateDown(1:15) = [];
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

    locoDiam_pred{x} = struct('data',[], 'name',[], 'N',NaN, 'TB',[], 'lopo',[], 'fam',[]); 
    locoDiam_pred{x}.data = tempStateCat(1:927);  
    locoDiam_pred{x}.name = {'State'}; %{'Velocity', '|Accel|', 'State'};
    locoDiam_pred{x}.N = size(locoDiam_pred{x}.data,2);
    for p = flip(1:locoDiam_pred{x}.N) 
        locoDiam_pred{x}.lopo.name{p} = ['No ',locoDiam_pred{x}.name{p}]; 
    end
    
    % Set up leave-one-family-out
    locoDiam_pred{x}.fam.col = {}; %{1:4, 5:7}; %{1:2, 3:4, 5:6, 7:8, 9:10, 11:12};  % {1:12};%{1, 2:3, 4:5, 6:7, 8, 9}; 
    locoDiam_pred{x}.fam.N = numel(locoDiam_pred{x}.fam.col); 
    locoDiam_pred{x}.fam.name = {}; %{'All'};%  'Onset Time',

    % RESPONSE - VASCULATURE
    
%     Define Response
%     Vascular diamater data
%     vesselROIpool = [vesselROI{x}{~cellfun(@isempty, vesselROI{x})}];
%     bigVesselInd = find(strcmpi({vesselROI{x}{:}.vesselType}, {'A'}) | strcmpi({vesselROI{x}{:}.vesselType}, {'D'})); %Find index of cells containing string A(rtery) and D(ura)
%     diamPool = [vesselROI{x}(bigVesselInd).diameter]; 

    % Define Response
    vesselROIpool = [vesselROI{x}{:}];
    diamPool = [vesselROIpool.diameter];
    allDiam = cat(1, diamPool.um_lp)';
    allDiam = allDiam(1:927, :);
%     % calculate delta diameter
%     baseline = allDiam(1,:);
%     deltaDiam = abs(allDiam - baseline);
    allDiamZ = zscore(allDiam, [], 1); %the mean and standard deviation are calculated for each column
    diamResp = allDiamZ; %BinDownMean( allDiamZ, locoDiam_opts{x}.binSize ); % allDiam

    locoDiam_resp{x}.data = diamResp;  %diamResp SCN 240102
    locoDiam_resp{x}.N = size(locoDiam_resp{x}.data, 2); 
    locoDiam_resp{x}.name = sprintfc('Diameter %i', 1:locoDiam_resp{x}.N);
 
    % Remove scans with missing data 
    nanFrame = find(any(isnan([locoDiam_pred{x}.data, locoDiam_resp{x}.data]),2)); % find( isnan(sum(pred(x).data,2)) ); 
    fprintf('\nRemoving %i NaN-containing frames', numel(nanFrame));
    locoDiam_pred{x}.data(nanFrame,:) = []; 
    locoDiam_resp{x}.data(nanFrame,:) = [];

    % GLM name update by vessel
%     GLMname_vessel = sprintf('GLM_locoDiam_baseline_vessel%i', vessel);
%     locoDiam_opts{x}.name = sprintf('%s_%s', expt{x}.name, GLMname_vessel); 

    % Run the GLM
    locoDiam_opts{x}.load = false; % false; % 
    locoDiam_opts{x}.saveRoot = 'D:\2photon\Simone\Simone_Macrophages\GLMs\velocityDiam\'; %sprintf('%s', expt{x}.dir, 'GLMs\GLM_locoDiam\'); %''; %expt{x}.dir
    mkdir (locoDiam_opts{x}.saveRoot);
    [locoDiam_result{x}, locoDiam_summary{x}, ~, locoDiam_pred{x}, locoDiam_resp{x}] = GLMparallel(locoDiam_pred{x}, locoDiam_resp{x}, locoDiam_opts{x}); 
    %locoDiam_summary{x} = SummarizeGLM(locoDiam_result{x}, locoDiam_pred{x}, locoDiam_resp{x}, locoDiam_opts{x});
end

%save metadata
%save(fullfile(locoDiam_opts{x}.saveRoot, locoDiam_opts{x}.name)); % save metadata

% Show results
for x = xPresent
    locoDiam_opts{x}.rShow = 1:sum(NvesselROI{x}); %1:locoDiam_resp{x}.N; % 1:LocoDeform_resp{x}.N; %NaN;
    locoDiam_opts{x}.xVar = 'Time';
    ViewGLM(locoDiam_pred{x}, locoDiam_resp{x}, locoDiam_opts{x}, locoDiam_result{x}, locoDiam_summary{x});
    %ViewGLM(Pred, Resp, Opts, Result, Summ)%GLMresultFig = 
end

%% Compare GLM to data for each experiment
close all; clearvars sp SP;
PreGLMresults = figure('WindowState','maximized', 'color','w');
opt = {[0.02,0.07], [0.06,0.03], [0.04,0.02]};  % {[vert, horz], [bottom, top], [left, right] }\
rightOpt = {[0.1,0.07], [0.1,0.03], [0.04,0.02]};  % {[vert, horz], [bottom, top], [left, right] }\
jitterWidth = 0.45;
xAngle = 30;
Nrow = locoDiam_pred{xPresent(1)}(1).N+1; 
Ncol = 3;
spGrid = reshape( 1:Nrow*Ncol, Ncol, Nrow )';
for x = xPresent
    sp(locoDiam_pred{x}.N+1) = subtightplot(locoDiam_pred{x}.N+1, 3, 1:2, opt{:});
    imagesc( locoDiam_resp{x}.data' );
    ylabel('Diameter', 'Interpreter','none');
    title( sprintf('%s', expt{x}.name), 'Interpreter','none');
    set(gca,'TickDir','out', 'TickLength',[0.003,0], 'box','off', 'Xtick',[]); % , 'Ytick',onStruct(x).fluor.responder
    text( repmat(size(locoDiam_resp{x}.data,1)+1, locoDiam_summary{x}.Ngood, 1), locoDiam_summary{x}.rGood+0.5, '*', 'VerticalAlignment','middle', 'FontSize',8);
    impixelinfo;
    
    for v = 1:locoDiam_pred{x}.N
        sp(v) = subtightplot(Nrow, Ncol, spGrid(v+1,1:2), opt{:});
        plot( locoDiam_pred{x}.data(:,v) ); hold on;
        ylabel(locoDiam_pred{x}.name{v}, 'Interpreter','none');
        xlim([-Inf,Inf]);
        if v < locoDiam_pred{x}.N
            set(gca,'TickDir','out', 'TickLength',[0.003,0], 'box','off', 'XtickLabel',[]);
        else
            set(gca,'TickDir','out', 'TickLength',[0.003,0], 'box','off');
        end
    end
    xlabel('Scan');
    
    %expt{x}.Nroi = size(diamResp,2); %SCN 231020

    subtightplot(3,3,3, rightOpt{:});
    bar([locoDiam_summary{x}.Ngood]/expt{x}.Nroi ); % numel(onStruct(x).fluor.responder),   , numel(rLocoPreFit{x})
    set(gca,'Xtick',1, 'XtickLabel',{'Fit'}, 'box','off'); % 'Loco','Fit','Both'  :3
    ylabel('Fraction of ROI');
    ylim([0,1]);
    

    %lopo
    subtightplot(3,3,6, rightOpt{:});
    JitterPlot( locoDiam_summary{x}.lopo.devFrac(:,locoDiam_summary{x}.rGood)', jitterWidth ); hold on;
    line([0,locoDiam_pred{x}.N+1], [1,1], 'color','k', 'lineStyle','--');
    xlim([0,locoDiam_pred{x}.N+1]); 
    ylim([0,Inf]); 
    ylabel('Fraction of total deviance'); 
    title('Leave One Predictor Out (well-fit units only)');
    set(gca, 'Xtick',1:locoDiam_pred{x}.N,  'XtickLabel', locoDiam_summary{x}.lopo.name, 'TickDir','out', 'TickLength',[0.003,0], 'TickLabelInterpreter','none', 'box','off' ); 
    xtickangle(xAngle);
    
    %lofo - locoDiam_summary{x}.lofo - not determined yet
    subtightplot(3,3,9, rightOpt{:});
    JitterPlot( locoDiam_summary{x}.lofo.devFrac(:,locoDiam_summary{x}.rGood)', jitterWidth ); hold on;
    line([0,locoDiam_pred{x}.fam.N]+0.5, [1,1], 'color','k', 'lineStyle','--');
    xlim([0,locoDiam_pred{x}.fam.N]+0.5);
    ylabel('Fraction of total deviance'); 
    title('Leave One Family Out (well-fit units only)');
    set(gca, 'Xtick',1:locoDiam_pred{x}.fam.N,  'XtickLabel', locoDiam_summary{x}.lofo.name, 'TickDir','out', 'TickLength',[0.003,0], 'TickLabelInterpreter','none', 'box','off' ); 
    xtickangle(xAngle);
    ylim([0,Inf]);
    
    linkaxes(sp,'x');
    % {
    figPath = sprintf('%s%s_Deviance.tif', figDir, GLMname);
    if exist(figPath,'file') 
        delete(figPath); 
    end
    fprintf('\nSaving %s', figPath);
    %export_fig( figPath, '-pdf', '-painters','-q101', '-append', LocoSensitivePrePost ); pause(1);
    %print(PreGLMresults, figPath, '-dtiff' ); 
    pause%(1);   
    clf;
    %}
    %pause; clf;
end
%%
for x = find(~cellfun(@isempty, locoDiam_result)) %  xPresent
    locoDiam_opts{x}.rShow = locoDiam_summary{x}.rGood; % 2; %1:7; %1:LocoDeform_resp{x}.N; %NaN; % 1:LocoDeform_resp{x}.N; %NaN;
    locoDiam_opts{x}.xVar = 'Time';
    ViewGLM(locoDiam_pred{x}, locoDiam_resp{x}, locoDiam_opts{x}, locoDiam_result{x}, locoDiam_summary{x}); %GLMresultFig = 
end

