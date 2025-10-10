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
locoFluor_pred = cell(1,Nexpt); 
locoFluor_resp = cell(1,Nexpt); 
locoFluor_opts = cell(1,Nexpt); 
locoFluor_result = cell(1,Nexpt); 
locoFluor_summary = cell(1,Nexpt);

% Specify row number(X) within excel sheet
xPresent = 19;
Npresent = numel(xPresent);
overwrite = false;

GLMname = 'locoFluor';
figDir = 'D:\MATLAB\Figures\GLM_LocomotionFluorescence\';  % CSD figures\
mkdir( figDir );

% Set GLM rate
GLMrate = 1; %15.49/16 for 3D data %projParam.rate_target = 1 for 2D data
%% 
for x = xPresent % x3D % 

    % Parse data table
    [expt{x}, runInfo{x}, regParam, projParam] = ParseDataTable(dataTable, x, dataCol, dataDir, regParam, projParam);
    [Tscan{x}, runInfo{x}] = GetTime(runInfo{x});  % , Tcat{x}

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

    % GLMparallel options
    %housekeeping
    locoFluor_opts{x}.name = sprintf('%s_%s', expt{x}.name, GLMname); %strcat(expt{x}.name, , '_preCSDglm');
    locoFluor_opts{x}.rShow = NaN;
    locoFluor_opts{x}.figDir = ''; % figDir;

    % Signal processing parameters
    locoFluor_opts{x}.trainFrac = 0.75; % 1; %
    locoFluor_opts{x}.Ncycle = 20;
    locoFluor_opts{x}.minDev = 0.05; 
    locoFluor_opts{x}.minDevFrac = 0.1;
    locoFluor_opts{x}.maxP = 0.05;
    locoFluor_opts{x}.Nshuff = 0;  
    locoFluor_opts{x}.minShuff = 15; %??
    locoFluor_opts{x}.window = [-60,60]; % [0,0]; % [-0.5, 0.5]; %consider temporal shifts this many seconds after/before response
    locoFluor_opts{x}.lopo = true; %false;

    % Downsample data to GLMrate target 
    locoFluor_opts{x}.frameRate = GLMrate;  % GLMrate; %expt{x}.scanRate
    locoFluor_opts{x}.binSize = max([1,round(expt{x}.scanRate/GLMrate)]); 
    locoFluor_opts{x}.minShuffFrame = round( locoFluor_opts{x}.frameRate*locoFluor_opts{x}.minShuff );
    windowFrame = [ceil(locoFluor_opts{x}.window(1)*locoFluor_opts{x}.frameRate), floor(locoFluor_opts{x}.window(2)*locoFluor_opts{x}.frameRate)];
    %windowFrame = round(locoDiam_opts{x}.window*locoDiam_opts{x}.frameRate); %window(sec)*frameRate
    locoFluor_opts{x}.shiftFrame = windowFrame(1):windowFrame(2);
    locoFluor_opts{x}.maxShift = max( abs(windowFrame) );
    locoFluor_opts{x}.Nshift = numel( locoFluor_opts{x}.shiftFrame );  %Nshift = preCSDOpts(x).Nshift;
    locoFluor_opts{x}.lags = locoFluor_opts{x}.shiftFrame/locoFluor_opts{x}.frameRate; %[-sec,+sec]
    locoFluor_opts{x}.xVar = 'Time';

    % GLMnet parameters - don't change without a good reason
    locoFluor_opts{x}.distribution = 'gaussian'; % 'poisson'; %  
    locoFluor_opts{x}.CVfold = 10;
    locoFluor_opts{x}.nlamda = 1000;
    locoFluor_opts{x}.maxit = 5*10^5;
    locoFluor_opts{x}.alpha = 0.01;  % The regularization parameter, default is 0.01
    locoFluor_opts{x}.standardize = true; 

    % PREDICTORS

    if expt{x}.Nruns > 1 %for multiple runs ONLY - adjust frame number of kinetics to match projection
        for preRun = 1:expt{x}.Nruns
            loco{x}(preRun).Vdown(1:15) = [];
            loco{x}(preRun).Adown(1:15) = [];
            loco{x}(preRun).stateDown(1:15) = [];
        end
    end

    % Define locomotion predictors
    tempVelocityCat = BinDownMean( vertcat(loco{x}(expt{x}.preRuns).Vdown), locoFluor_opts{x}.binSize );
    tempAccelCat = BinDownMean( abs(vertcat(loco{x}(expt{x}.preRuns).Adown)), locoFluor_opts{x}.binSize ); 
    tempStateCat = BinDownMean( vertcat(loco{x}(expt{x}.preRuns).stateDown), locoFluor_opts{x}.binSize );

    % remove 1st and last frame to match projection 
    tempVelocityCat = tempVelocityCat(2:end-1); 
    tempAccelCat = tempAccelCat(2:end-1);
    tempStateCat = tempStateCat(2:end-1);

    %adjust frames based on Substack used
    substack = input('Enter substack frames (e.g., 200:5599): ');
    %adjust frames based on Substack used
    tempVelocityCat = tempVelocityCat(substack); 
    tempAccelCat = tempAccelCat(substack);
    tempStateCat = tempStateCat(substack);


    locoFluor_pred{x} = struct('data',[], 'name',[], 'N',NaN, 'TB',[], 'lopo',[], 'fam',[]); 
    locoFluor_pred{x}.data = [tempVelocityCat, tempAccelCat,  tempStateCat]; %  tempStateCat
    locoFluor_pred{x}.name = {'Velocity', '|Accel|', 'State'}; %'State'
    locoFluor_pred{x}.N = size(locoFluor_pred{x}.data,2);
    for p = flip(1:locoFluor_pred{x}.N) 
        locoFluor_pred{x}.lopo.name{p} = ['No ',locoFluor_pred{x}.name{p}]; 
    end
    
    % Set up leave-one-family-out
    locoFluor_pred{x}.fam.col = {1:2, 3}; %{1:4, 5:7}; %{1:2, 3:4, 5:6, 7:8, 9:10, 11:12};  % {1:12};%{1, 2:3, 4:5, 6:7, 8, 9}; 
    locoFluor_pred{x}.fam.N = numel(locoFluor_pred{x}.fam.col); 
    locoFluor_pred{x}.fam.name = {'Kinematics','Loco'}; 

    % Define response
    % Get/Load fluorescence data
    %double-check if x value is still what you set (AQuA analysis code also
    %had x value that is sometimes overwriting here)

    cellFluorPool = [resultsFinal.dFF];
    fluorResp = cat(1, cellFluorPool{:})';
    fluorRespZ = zscore(fluorResp, [], 1);

    locoFluor_resp{x}.data = fluorResp; % tempScaleMag; %
    locoFluor_resp{x}.N = size(locoFluor_resp{x}.data, 2); 
    locoFluor_resp{x}.name = sprintfc('Fluor %i', 1:locoFluor_resp{x}.N);

    % Remove scans with missing data 
    nanFrame = find(any(isnan([locoFluor_pred{x}.data, locoFluor_resp{x}.data]),2)); % find( isnan(sum(pred(x).data,2)) ); 
    fprintf('\nRemoving %i NaN-containing frames', numel(nanFrame));
    locoFluor_pred{x}.data(nanFrame,:) = []; 
    locoFluor_resp{x}.data(nanFrame,:) = [];

    % Run the GLM
    locoFluor_opts{x}.load = false; % false; % 
    locoFluor_opts{x}.saveRoot = sprintf('%s', expt{x}.dir, 'GLMs\GLM_locoFluor\'); 
    mkdir (diamFluor_opts{x}.saveRoot);
    [locoFluor_result{x}, locoFluor_summary{x}, ~, locoFluor_pred{x}, locoFluor_resp{x}] = GLMparallel(locoFluor_pred{x}, locoFluor_resp{x}, locoFluor_opts{x}); 
end
%%
for x = xPresent
    locoFluor_opts{x}.rShow = 1:locoFluor_resp{x}.N; %1:locoDiamDeform_resp{x}.N; % 1:LocoDeform_resp{x}.N; %NaN;
    locoFluor_opts{x}.xVar = 'Time';
    ViewGLM(locoFluor_pred{x}, locoFluor_resp{x}, locoFluor_opts{x}, locoFluor_result{x}, locoFluor_summary{x}); %GLMresultFig = 
end

 % Save metadata inside FOV folder
 save(fullfile(locoFluor_opts{x}.saveRoot, strcat(fileTemp,'_GLM_locoFluor'))); % save metadata inside FOV folder


%% Pool results across experiments
LKFdevPool = []; goodDevPool = [];
LKFdevFracPool = []; %lofoDevFracPool = [];
LKF_Nsubtype = []; k = 0;
for x = xPresent
    k = k+1;
    if ~isempty( LKF_summary{x}.rGood )
        LKFdevPool = [LKFdevPool, LKF_summary{x}.dev]; 
        goodDevPool = [goodDevPool, LKF_summary{x}.dev( LKF_summary{x}.rGood )];
        LKFdevFracPool = [LKFdevFracPool, vertcat(LKF_summary{x}.lopo.devFrac(:,LKF_summary{x}.rGood) , LKF_summary{x}.lofo.devFrac(:,LKF_summary{x}.rGood) )]; %
    end
end

% Summarize deviance explained
opt = {[0.02,0.07], [0.1,0.07], [0.09,0.09]};  % {[vert, horz], [bottom, top], [left, right] }
DevianceFig = figure('WindowState','maximized', 'color','w');
k = 1; clearvars h;
subtightplot(1,2,1,opt{:});
for x = xPresent
    [Ftemp, Xtemp] = ecdf( LKF_summary{x}.dev ); hold on;
    h(k) = plot(Xtemp, Ftemp, 'color',0.7*[1,1,1] ); % exptColor(k,:)
    k = k + 1;
end
[Fdev, Xdev] = ecdf( LKFdevPool );
h(k) = plot( Xdev, Fdev, 'color','k', 'LineWidth',2 ); 
axis square;
legend(h, {expt(xPresent).name, 'Pooled', 'Threshold'}, 'Location','southEast', 'Interpreter','none', 'AutoUpdate',false );
xlim([0, 0.2]);
line(LKF_opts{xPresent(1)}.minDev*[1,1], [0,1], 'Color','r', 'LineStyle','--'); % h(k+1) = 
xlabel('Deviance Explained'); ylabel('Fraction of Units');
title( sprintf('%s Fit Results', GLMname), 'Interpreter','none' );

subtightplot(1,2,2,opt{:});
JitterPlot( 1 - LKFdevFracPool', 0.45, 'ErrorCap',10, 'monochrome',0.6); hold on;
line([0,size(LKFdevFracPool,1)+1], [0,0], 'color','k');
axis square;
ylabel('Relative Explanatory Value'); %ylabel('Cumulative Distribution');
ylim([-1,1]);
set(gca,'Xtick', 1:size(LKFdevFracPool,1), 'XtickLabel',[LKF_pred{xPresent(1)}.name, LKF_pred{xPresent(1)}.fam.name]);
xtickangle(30);
title('Well-Fit Units');




%% Show time filters per response
exptColor = distinguishable_colors(Npresent);
LKF_GLMcoeffFig = figure('WindowState','maximized', 'color','w');
Ncol = locoFluor_resp{xPresent(1)}.N;   Nrow = LKF_pred{xPresent(1)}.N;
tiledlayout(Nrow, Ncol);
k = 0;
for row = 1:Nrow
    for col = 1:Ncol
        nexttile
        try
            tempCoeffMat = zeros( numel(LKF_opts{xPresent(1)}.lags), Npresent );
            k = 0;
            for x = xPresent
                k = k + 1;
                if LKF_result{x}(col).dev > LKF_opts{x}.minDev
                    tempCoeffMat(:,k) = LKF_result{x}(col).coeff(:,row);
                end
            end
            plot( LKF_opts{x}.lags, tempCoeffMat ); hold on;
            colororder(exptColor)
            axis square;
            if col == 1, ylabel(sprintf('%s Coefficient', LKF_pred{xPresent(1)}.name{row} )); end
            if row == 1, title( locoFluor_resp{xPresent(1)}.name{col} ); end
            if row == Nrow, xlabel('Response Lag (s)'); end
        end
        %pause;
    end
end

figPath = sprintf('%s%s_CoeffSummary.tif', figDir, GLMname );
fprintf('\nSaving %s\n', figPath);
%print( LKF_GLMcoeffFig, figPath, '-dtiff');

%% Break out coefficients by bout response subtype

for x = x2D
    excCoeffCat = cat(3, LKF_result{x}( boutResponse(x).pre.exc ).coeff);
    neutCoeffCat = cat(3, LKF_result{x}( boutResponse(x).pre.neut ).coeff);
    inhCoeffCat = cat(3, LKF_result{x}( boutResponse(x).pre.inh ).coeff);
    
    LKF_lags = linspace(LKF_opts{x}.window(1), LKF_opts{x}.window(2), LKF_opts{x}.Nshift);
    
    subplot(1,3,1);
    plot( mean(excCoeffCat(:,1,:), 3), 'b' ); hold on;
    plot( mean(neutCoeffCat(:,1,:), 3), 'k' ); hold on;
    plot( mean(inhCoeffCat(:,1,:), 3), 'r' ); hold on;
    axis square;
    title('dF/F per velocity')
    
    subplot(1,3,2);
    plot( mean(excCoeffCat(:,2,:), 3), 'b' ); hold on;
    plot( mean(neutCoeffCat(:,2,:), 3), 'k' ); hold on;
    plot( mean(inhCoeffCat(:,2,:), 3), 'r' ); hold on;
    axis square;
    title('dF/F per accel')
    
    subplot(1,3,3);
    plot( mean(excCoeffCat(:,3,:), 3), 'b' ); hold on;
    plot( mean(neutCoeffCat(:,3,:), 3), 'k' ); hold on;
    plot( mean(inhCoeffCat(:,3,:), 3), 'r' ); hold on;
    axis square;
    title('dF/F per loco state')
    pause;
end

%% Breakout coefficients by bout response subtype - heatmaps
Nshift = LKF_opts{x2D(1)}.Nshift;
typeCoeff = {nan(Nshift, 3, 0), nan(Nshift, 3, 0), nan(Nshift, 3, 0)};
typeVal = {nan(0,3), nan(0,3), nan(0,3)};
typeDev = cell(1,3);
for x = find(~cellfun(@isempty, LKF_summary))
    goodExc = intersect(LKF_summary{x}.rGood, boutResponse(x).pre.exc);
    goodNeut = intersect(LKF_summary{x}.rGood, boutResponse(x).pre.neut);
    goodInh = intersect(LKF_summary{x}.rGood, boutResponse(x).pre.inh);

    typeDev{1} = cat(2, typeDev{1}, [LKF_result{x}(goodExc).dev]);
    typeDev{2} = cat(2, typeDev{2}, [LKF_result{x}(goodNeut).dev]);
    typeDev{3} = cat(2, typeDev{3}, [LKF_result{x}(goodInh).dev]);
    
    typeCoeff{1} = cat(3, typeCoeff{1}, LKF_result{x}(goodExc).coeff);
    typeCoeff{2} = cat(3, typeCoeff{2}, LKF_result{x}(goodNeut).coeff);
    typeCoeff{3} = cat(3, typeCoeff{3}, LKF_result{x}(goodInh).coeff);
    
    typeVal{1} = vertcat(typeVal{1}, 1-LKF_summary{x}.lopo.devFrac(:,goodExc)');
    typeVal{2} = vertcat(typeVal{2}, 1-LKF_summary{x}.lopo.devFrac(:,goodNeut)');
    typeVal{3} = vertcat(typeVal{3}, 1-LKF_summary{x}.lopo.devFrac(:,goodInh)');
end
typeName = ["Bout-Activated","Bout-Neutral","Bout-Suppressed"];


Tshift = linspace(-60,60, LKF_opts{x}.Nshift);
Ttick = linspace(-60,60, 5);
coeffSubtypeFig_shaded = figure('WindowState','maximized', 'color','w');
opt = {[0.05,0.05], [0.1,0.07], [0.09,0.09]};  % {[vert, horz], [bottom, top], [left, right] }
for p = 1:3 % bout response type
    for t = 1:3 %  predictor
        subtightplot(3,3, sub2ind([3,3], t,p), opt{:});
        tempCoeff = squeeze(typeCoeff{t}(:,p,:));
        meanCoeff = mean(tempCoeff, 2);
        semCoeff = std(tempCoeff,0,2); % SEM(tempCoeff, 2);
        coeffShadeMat = [meanCoeff-semCoeff, meanCoeff, meanCoeff+semCoeff]';
        line([-60, 60], [0,0], 'color','k');  hold on;
        plotshaded(Tshift, coeffShadeMat, '-');
        axis tight; axis square; 
        set(gca,'Xtick',Ttick);
        
        if t == 1, ylabel([LKF_pred{x}.name{p},' coeff']); end
        if p == 3; xlabel('Delay (s)'); end
        if p == 1, title(typeName(t)); end
        
        %text(0.9, 0.9, sprintf('Val = %2.2f +/ %2.2f', mean(typeVal{t}(:,p)), SEM(typeVal{t}(:,p))  ), 'Units','normalized' )
        %pause;
    end
end
figPath = sprintf('%scoeffSubtypeFig_shaded.pdf', figDir);
exportgraphics(coeffSubtypeFig_shaded, figPath, 'Resolution',300); fprintf('\nSaved %s', figPath);


devSubtypeFig = figure('WindowState','maximized', 'color','w');
subplot(1,4,1);
JitterPlot(cell2padmat(typeDev), 'ErrorBar',3, 'ErrorCap',20, 'new',false);
axis square;
ylabel('Deviance explained');
set(gca,'Xtick',1:3, 'XtickLabel',typeName);
xtickangle(30);

for t = 1:3
    subplot(1,4,t+1);
    bar(mean(typeVal{t})); hold on;
    errorbar(1:3, mean(typeVal{t}), SEM(typeVal{t}), 'linestyle','none', 'color','k');
    title(typeName{t})
    if t == 1, ylabel('Rel. exp. value'); end
    %JitterPlot(typeVal{t}, 0.2, 'paired',true, 'new',false);
    %axis tight; 
    xlim([0.5,3.5]);
    axis square;
    set(gca,'Xtick',[1,2,3], 'XtickLabel',{'Velocity','|Accel|','State'});
end
figPath = sprintf('%sdevSubtypeFig.pdf', figDir);
exportgraphics(devSubtypeFig, figPath, 'Resolution',300); fprintf('\nSaved %s', figPath);

valMean = cellfun(@mean, typeVal, 'UniformOutput',false);
valMean = vertcat(valMean{[1,3]}); % exclude bout-neutral ROI
valSEM = cellfun(@SEM, typeVal, 'UniformOutput',false);
valSEM = vertcat(valSEM{[1,3]}); % % exclude bout-neutral ROI
GroupedBarError(valMean', valSEM', 'ErrorBar',1.5, 'ErrorCap',3)


%{
coeffSubtypeFig_heatmaps = figure('WindowState','maximized', 'color','w');
for t = 1:3 % bout response type
    for p = 1:3 %  predictor
        subtightplot(3,3, sub2ind([3,3], t,p));
        tempCoeff = squeeze(typeCoeff{t}(:,p,:))';
        imagesc(tempCoeff); 
        colormap(bluewhitered);
        caxis(max(tempCoeff(:))*[-1,1]);
        colormap(bluewhitered)
        colorbar();
        pause;
    end
end
%}
