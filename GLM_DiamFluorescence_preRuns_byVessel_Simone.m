%% SCN - Use GLM to assess contribution of different variables

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

GLMname = 'diamFluor_preRuns';
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

    % define number of frames preCSD and postCSD
    totalRuns = expt{x}.Nruns;
    totalFrames = numel(vesselROI{x}{1,1}(1).diameter.um_lp);
    if numel(expt{x}.preRuns) == 1
        preRunsFrames = 1800; % 1800 frames at 1Hz = 30min (baseline)
    end
    postRunsFrames = totalFrames - preRunsFrames;

    bigVesselInd = find(strcmpi({vesselROI{x}{1,1}.vesselType}, {'A'}) | strcmpi({vesselROI{x}{1,1}.vesselType}, {'D'}));
    diamPool = [vesselROI{x}{1,1}(bigVesselInd).diameter];
    allDiam = cat(1, diamPool.um_lp)';
    allDiamZ = zscore(allDiam, [], 1);

    if ~isnan(expt{x}.csd)
        %preRuns
        allDiam_preRuns = allDiam(1:preRunsFrames,:);
        allDiamZ_preRuns = zscore(allDiam_preRuns, [], 1);
        %postRuns
        allDiam_postRuns = allDiam(preRunsFrames+1:totalFrames,:);
        allDiamZ_postRuns = zscore(allDiam_postRuns, [], 1);
    end

    diamFluor_pred{x} = struct('data',[], 'name',[], 'N',NaN, 'TB',[], 'lopo',[], 'fam',[]); 

    % allDiam
    diamFluor_summary_deviances = [];
    diamFluor_summary_peakCoefficients = [];
    diamFluor_summary_peakLags = [];

    % allDiamZ (Z-score)
    diamZFluor_summary_deviances = [];
    diamZFluor_summary_peakCoefficients = [];
    diamZFluor_summary_peakLags = [];

    for vessel = 1:numel(diamPool)
        diamFluor_pred{x}.data = allDiamZ_preRuns(:,vessel); % accelData, stateData, allDiam
        diamFluor_pred{x}.name = sprintfc('Diam %i', 1:size(allDiam,2)); % 1:size(allDiam,2); '|Accel|', 'State'
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
    
        if ~isnan(expt{x}.csd)
            fluorResp_preRuns = fluorResp(1:preRunsFrames,:);
            fluorRespZ_preRuns = zscore(fluorResp_preRuns, [], 1);
            fluorResp_postRuns = fluorResp(preRunsFrames+1:totalFrames,:);
            fluorRespZ_postRuns = zscore(fluorResp_postRuns, [], 1);
        end
    
        diamFluor_resp{x}.data = fluorRespZ_preRuns;
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
        GLMname_vessel = sprintf('GLM_diamFluor_preRuns_vessel_%i', vessel);
        diamFluor_opts{x}.name = sprintf('%s_%s', fileTemp, GLMname_vessel); %expt{x}.name
        
        % Run the GLM by single predictor
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
    diamFluor_summary_deviances.Properties.RowNames = cellstr(diamFluor_pred{x}.name(1,:)');
    diamFluor_summary_deviancesBinary = diamFluor_summary_deviances{:,:} > 0.1; %applies the logical operation and creates matrix
    diamFluor_summary_deviancesBinary = array2table(diamFluor_summary_deviancesBinary, 'VariableNames', diamFluor_summary_deviances.Properties.VariableNames);

    % diamFluor_summary_peakCoefficients 
    diamFluor_summary_peakCoefficients = array2table(diamFluor_summary_peakCoefficients);
    cellHeadings = cellstr(diamFluor_resp{x}.name(1,:));
    diamFluor_summary_peakCoefficients.Properties.VariableNames = cellHeadings;
    diamFluor_summary_peakCoefficients.Properties.RowNames = cellstr(diamFluor_pred{x}.name(1,:)');
 
    % diamFluor_summary_peakLags
    diamFluor_summary_peakLags = array2table(diamFluor_summary_peakLags);
    cellHeadings = cellstr(diamFluor_resp{x}.name(1,:));
    diamFluor_summary_peakLags.Properties.VariableNames = cellHeadings;
    diamFluor_summary_peakLags.Properties.RowNames = cellstr(diamFluor_pred{x}.name(1,:)');

    % Save metadata inside FOV folder
    if diamFluor_pred{x}.data == allDiamZ_preRuns(:,vessel)
        save(fullfile(diamFluor_opts{x}.saveRoot, strcat(fileTemp,'_GLM_diamZFluor'))); % save metadata inside FOV folder       
    else
        save(fullfile(diamFluor_opts{x}.saveRoot, strcat(fileTemp,'_GLM_diamFluor_preRuns')))
    end
 
    % Access the vessel map based on the current iteration
    %imshow(vesselROI{1, 22}{1, 1}(7).boxIm)  

%%
for x = xPresent
    diamFluor_opts{x}.rShow = 1:diamFluor_resp{x}.N; %1:locoDiamDeform_resp{x}.N; % 1:LocoDeform_resp{x}.N; %NaN;
    diamFluor_opts{x}.xVar = 'Time';
    ViewGLM(diamFluor_pred{x}, diamFluor_resp{x}, diamFluor_opts{x}, diamFluor_result{x}, diamFluor_summary{x}); %GLMresultFig = 
end

%% Compare GLM to data for each experiment
close all; clearvars sp SP;
PreGLMresults = figure('WindowState','maximized', 'color','w');
opt = {[0.02,0.07], [0.08,0.03], [0.04,0.02]};  % {[vert, horz], [bottom, top], [left, right] }\
rightOpt = {[0.1,0.07], [0.1,0.03], [0.04,0.02]};  % {[vert, horz], [bottom, top], [left, right] }\
jitterWidth = 0.45;
xAngle = 30;
Nrow = diamFluor_pred{xPresent(1)}.N+1;   
Ncol = 3;
spGrid = reshape( 1:Nrow*Ncol, Ncol, Nrow )';
for x = find(~cellfun(@isempty, diamFluor_result)) % xPresent xPresent
    sp(Nrow) = subtightplot(Nrow, 3, 1:2, opt{:});
    [~,sortInd] = sort( diamFluor_summary{x}.dev, 'descend');
    imagesc( diamFluor_resp{x}.data(:,sortInd)' ); hold on;
    %max = max(diamFluor_resp{x}.data(:));
    %min = min(diamFluor_resp{x}.data(:));
    caxis([-0.2,3]); %[-5,5]
    colormap(bluewhitered);
    ylabel('Fluor', 'Interpreter','none');
    title( sprintf('%s', expt{x}.name), 'Interpreter','none');
    set(gca,'TickDir','out', 'TickLength',[0.003,0], 'box','on', 'Xtick',[]); % , 'Ytick',onStruct(x).fluor.responder
    line( size(diamFluor_resp{x}.data,1)*[0,1], (diamFluor_summary{x}.Ngood+0.5)*[1,1], 'color','k');
    %text( repmat(size(preCSD_2D_resp{x}(r).data,1)+1, preCSD_2D_summary{x}.Ngood, 1), preCSD_2D_summary{x}.rGood+0.5, '*', 'VerticalAlignment','middle', 'FontSize',8);
    impixelinfo;
    
    for v = 1:diamFluor_pred{x}.N
        sp(v) = subtightplot(Nrow, Ncol, spGrid(v+1,1:2), opt{:});
        plot( diamFluor_pred{x}.data(:,v) ); hold on;
        ylabel(diamFluor_pred{x}.name{v}, 'Interpreter','none');
        clear xlim; %remove xlim variable from Aqua analysis variable
        xlim([-Inf,Inf]);
        if v < diamFluor_pred{x}.N
            set(gca,'TickDir','out', 'TickLength',[0.003,0], 'box','off', 'XtickLabel',[]);
        else
            set(gca,'TickDir','out', 'TickLength',[0.003,0], 'box','off');
        end
    end
    xlabel('Scan');
    linkaxes(sp,'x');
    xlim([-Inf,Inf]);
    
    subtightplot(2, 3, 3, rightOpt{:}); %(2,3,3, rightOpt{:});
    bar([diamFluor_summary{x}.Ngood]/numCells); % numel(onStruct(x).fluor.responder),   , numel(rLocoPreFit{x})
    set(gca,'Xtick',1, 'XtickLabel',{'Fit'}, 'box','off'); % 'Loco','Fit','Both'  :3
    ylabel('Fraction of ROI');
    ylim([0,1]);
    
    subtightplot(2,3,6, rightOpt{:}); 
    %JitterPlot( vertcat(diamFluor_summary{x}.lopo.devFrac(:,diamFluor_summary{x}.rGood), diamFluor_summary{x}.lofo.devFrac(:,diamFluor_summary{x}.rGood))', jitterWidth ); hold on;
    JitterPlot(diamFluor_summary{x}.lopo.devFrac(:,diamFluor_summary{x}.rGood)', jitterWidth ); hold on;
    set(gca, 'Xtick',1:diamFluor_pred{x}.N+diamFluor_pred{x}.fam.N,  'XtickLabel', [diamFluor_summary{x}.lopo.name, diamFluor_summary{x}.lofo.name], 'TickDir','out', 'TickLength',[0.003,0], 'TickLabelInterpreter','none', 'box','off' ); 
    line([0,diamFluor_pred{x}.N+diamFluor_pred{x}.fam.N+1], [1,1], 'color','k', 'lineStyle','--');
    xlim([0,diamFluor_pred{x}.N+diamFluor_pred{x}.fam.N+1]); 
    ylim([0,Inf]); 
    ylabel('Fraction of total deviance'); title('Leave One Predictor Out (well-fit units only)');
    xtickangle(xAngle);
    
    %{
    figPath = sprintf('%s%s_Deviance.tif', figDir, GLMname);
    if exist(figPath,'file'), delete(figPath); end
    fprintf('\nSaving %s', figPath);
    export_fig( figPath, '-pdf', '-painters','-q101', '-append', LocoSensitivePrePost ); pause(1);
    print(PreGLMresults, figPath, '-dtiff' ); 
    pause%(1);   
    clf;
    %}
    pause; clf;
end

%% INCOMPLETE
devSummMat = cell(1,Nexpt);
GLMresultFig = figure('WindowState','maximized', 'color','w');
for x = xPresent
    cla;
    devSummMat{x} = [diamFluor_summary{x}.dev; diamFluor_summary{x}.lopo.dev; diamFluor_summary{x}.lofo.dev];
    % {
    imagesc( devSummMat{x}' );
    set(gca,'XtickLabel',  [{'All'}; diamFluor_summary{xPresent(1)}.lopo.name(:); diamFluor_summary{xPresent(1)}.lofo.name(:)], ...
        'Ytick',1:diamFluor_resp{xPresent(1)}.N , 'YtickLabel',diamFluor_resp{xPresent(1)}.name, 'TickDir','out', 'TickLength',[0.003,0]);
    title(sprintf('%s: GLM Fit Summary', diamFluor_opts{x}.name), 'Interpreter','none');
    xtickangle(30);
    axis image;
    CB = colorbar; 
    CB.Label.String = 'Deviance Explained';
    caxis([0,0.2]);
    impixelinfo;
    pause;
    %}
end

devSummCat = cat(3, devSummMat{:});
devSummMed = median(devSummCat, 3, 'omitnan' );

diamFluor_GLMdevFig = figure('WindowState','maximized', 'color','w');
imagesc( devSummMed' );
set(gca,'XtickLabel',  [{'All'}; diamFluor_summary{x}.lopo.name(:); diamFluor_summary{x}.lofo.name(:)], ...
    'YtickLabel',diamFluor_resp{x}.name, 'TickDir','out', 'TickLength',[0.003,0]);
title('GLM Fit Summary (All 3D Data)', 'Interpreter','none');
xtickangle(30);
axis image;
CB = colorbar; 
CB.Label.String = 'Median Deviance Explained';
figPath = sprintf('%s%s_DevSummary.tif', figDir, GLMname );
fprintf('\nSaving %s\n', figPath);
%print( locoDeform_pre_GLMdevFig, figPath, '-dtiff');
impixelinfo;

%% Show relative explanatory value from submodels
exptColor = distinguishable_colors(Npresent);
locoDeform_pre_relExpFig = figure('WindowState','maximized', 'color','w');
Ncol = locoDeform_pre_resp{xPresent(1)}.N;  
%tiledlayout(1, Ncol);
opt = {[0.05,0.04], [0.06,0.02], [0.04,0.02]};
Ndrops = locoDeform_pre_pred{xPresent(1)}.N+locoDeform_pre_pred{xPresent(1)}.fam.N;
for col = 1:Ncol
    tempDevFracMat = nan( Npresent, Ndrops );
    k = 0;
    for x = xPresent
        k = k + 1;
        if locoDeform_pre_result{x}(col).dev > locoDeform_pre_opts{x}.minDev
            tempDevFracMat(k,:) = [locoDeform_pre_result{x}(col).lopo.devFrac, locoDeform_pre_result{x}(col).lofo.devFrac];
        end
    end
    subtightplot(1,Ncol,col,opt{:}); %nexttile
    JitterPlot( 1-tempDevFracMat, 0.45 ); hold on;
    line(0.5+[0,Ndrops], [0,0], 'color','k'); 
    set(gca, 'Xtick',1:Ndrops); %, 'Xticklabel'
    ylim([-0.4, 1.1]); xlim(0.5+[0,Ndrops])
    %colororder(exptColor)
    axis square;
    if col == 1, ylabel('Relative Explanatory Value'); end
    title( locoDeform_pre_resp{xPresent(1)}.name{col} );
    set(gca, 'XtickLabel', [locoDeform_pre_pred{xPresent(1)}.name, locoDeform_pre_pred{xPresent(1)}.fam.name])  % [locoDeform_pre_summary{x}.lopo.name(:); locoDeform_pre_summary{x}.lofo.name(:)]
    xtickangle(45)
end
figPath = sprintf('%s%s_ExpValSummary.tif', figDir, GLMname );
fprintf('\nSaving %s\n', figPath);
print( locoDeform_pre_relExpFig, figPath, '-dtiff');

%% Show time filters per response
exptColor = distinguishable_colors(Npresent);
locoDeform_pre_GLMcoeffFig = figure('WindowState','maximized', 'color','w');
Ncol = locoDeform_pre_resp{xPresent(1)}.N;   Nrow = locoDeform_pre_pred{xPresent(1)}.N;
tiledlayout(Nrow, Ncol);
k = 0;
for row = 1:Nrow
    for col = 1:Ncol
        nexttile
        tempCoeffMat = zeros( numel(locoDeform_pre_opts{xPresent(1)}.lags), Npresent );
        k = 0;
        for x = xPresent
            k = k + 1;
            if locoDeform_pre_result{x}(col).dev > locoDeform_pre_opts{x}.minDev
                tempCoeffMat(:,k) = locoDeform_pre_result{x}(col).coeff(:,row);
            end
        end
        plot( locoDeform_pre_opts{x}.lags, tempCoeffMat ); hold on;
        colororder(exptColor)
        axis square;
        if col == 1, ylabel(sprintf('%s Coefficient', locoDeform_pre_pred{xPresent(1)}.name{row} )); end
        if row == 1, title( locoDeform_pre_resp{xPresent(1)}.name{col} ); end
        if row == Nrow, xlabel('Response Lag (s)'); end
        %pause;
    end
end

figPath = sprintf('%s%s_CoeffSummary.tif', figDir, GLMname );
fprintf('\nSaving %s\n', figPath);
print( locoDeform_pre_GLMcoeffFig, figPath, '-dtiff');
