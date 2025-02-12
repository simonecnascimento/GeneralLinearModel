clear all;

% load GLM_diamFluor
diamFluorDir = 'D:\2photon\Simone\Simone_Macrophages\GLMs\diamFluor';
cd(diamFluorDir);

%% expt name
diamFluorExpt = 'Pf4Ai162-13_230719_FOV5_run1_reg_Z01_green_Substack(1-927)_GLM_diamFluor_baseline_vessel2_results';
diamFluorData = load(diamFluorExpt);

tokens = regexp(diamFluorExpt, 'vessel(\d+)', 'tokens'); % Find 'vessel' followed by a number
if ~isempty(tokens)
    vesselNumber = str2double(tokens{1}{1}); % Convert extracted number to double
else
    vesselNumber = NaN; % Handle case where no number is found
end

% load GLM_locoDiam
locoDiamDir = 'D:\2photon\Simone\Simone_Macrophages\GLMs\locoDiam';
cd(locoDiamDir);
FOV = extractBefore(diamFluorExpt, '_run1_reg_Z01_green_Substack(1-927)_GLM_diamFluor_baseline');
locoDiamExpt = strcat(FOV, '_GLM_locoDiam_baseline_results');
locoDiamData = load(locoDiamExpt);

%plot
GLMresultFig = figure('WindowState','maximized', 'color','w');
leftOpt = {[0.02,0.04], [0.08,0.03], [0.04,0.02]};  % {[vert, horz], [bottom, top], [left, right] }
rightOpt = {[0.04,0.04], [0.08,0.01], [0.04,0.01]}; 
xAngle = 25;
Nrow = locoDiamData.Pred.N+2; %locomotion, vasculature, macrophage
Ncol = 8;  %8
spGrid = reshape( 1:Nrow*Ncol, Ncol, Nrow )';
T = (1/locoDiamData.Opts.frameRate)*(0:size(locoDiamData.Pred.data,1)-1)'/60;
xLabelStr = 'Time (min)';

% Plot locomotion state (zero-shift only)
sp(1) = subtightplot(Nrow, Ncol, spGrid(3,1:Ncol-1), leftOpt{:});
plot( T, locoDiamData.Pred.data(:,1) ); 
hold on;    
ylabel(locoDiamData.Pred.name{1}, 'Interpreter','none');
xlim([-Inf,Inf]);
set(gca,'TickDir','out', 'TickLength',[0.003,0], 'box','off'); 
xlabel(xLabelStr);

% Plot vascular response data and models' predictions
sp(2) = subtightplot(Nrow, Ncol, spGrid(2,1:Ncol-1), leftOpt{:}); cla;
h1 = plot( T, locoDiamData.Resp.data(:,vesselNumber), 'k', 'LineWidth',1  ); 
hold on;
h2 = plot( T, locoDiamData.Result(vesselNumber).prediction, 'b', 'LineWidth',2 );
legend([h1, h2], {'Full data', 'Model prediction'}, 'Location','best');
set(gca, 'XtickLabel', [], 'TickDir', 'out', 'TickLength', [0.003,0]);
box off;
ylabel(strcat('Vessel #', num2str(vesselNumber)), 'Interpreter','none'); %locoDiamData.Resp.name{r}
xlim([-Inf,Inf]);

% Plot coeff
sp(3) = subtightplot(Nrow, Ncol, spGrid(3,Ncol), rightOpt{:}); cla;
plot( locoDiamData.Opts.lags, locoDiamData.Result(vesselNumber).coeff(:), 'k' ); hold on; 
plot( locoDiamData.Opts.lags, locoDiamData.Result(vesselNumber).coeff(:), 'k.', 'MarkerSize',10 ); 
ylabel('Coeff'); % ylabel( sprintf('%s coeff', Pred.name{v}), 'Interpreter','none');
axis square; 
xLim = get(gca,'Xlim');
line(xLim, [0,0], 'color','k');

% adjust code for multiple cells
for cell = 1:size(diamFluorData.Resp.name,2)
    % Plot fluorescence signal
    sp(4) = subtightplot(Nrow, Ncol, spGrid(1,1:Ncol-1), leftOpt{:}); cla;
    h1 = plot( T, diamFluorData.Resp.data(:,cell), 'k', 'LineWidth',1 ); 
    xlim([-Inf,Inf]);
    hold on;
    box off;
    h2 = plot( T, diamFluorData.Result(cell).prediction, 'b', 'LineWidth',2 );
    ylabel(diamFluorData.Resp.name{cell}, 'Interpreter','none');
    %summaryString = sprintf('%s: dev exp locoDiam(%2.2f), diamFluor(%2.2f)', FOV, locoDiamData.Result(r).dev, diamFluorData.Result(r).dev);
    summaryString = sprintf('%s', FOV);
    title(summaryString, 'Interpreter','none');
    legend([h1, h2], {'Full data', 'Model prediction'}, 'Location','best');
    
    % Plot coeff
    sp(5) = subtightplot(Nrow, Ncol, spGrid(2,Ncol), rightOpt{:}); cla;
    plot( diamFluorData.Opts.lags, diamFluorData.Result(cell).coeff(:), 'k' ); hold on; 
    plot( diamFluorData.Opts.lags, diamFluorData.Result(cell).coeff(:), 'k.', 'MarkerSize',10 ); 
    ylabel('Coeff'); % ylabel( sprintf('%s coeff', Pred.name{v}), 'Interpreter','none');
    axis square; 
    xLim = get(gca,'Xlim');
    line(xLim, [0,0], 'color','k');
    
    % compare full-model deviance explained to that of the LOPO and LOFO models
    sp(6) = subtightplot(Nrow, Ncol, spGrid(1,Ncol), rightOpt{:});  % [0.01,0.01], [0.00,0.00], [0.00,0.00]
    cla; %to clear the axis
    line([0,0], [0, 2]+0.5, 'color','k' ); hold on;
    line(diamFluorData.Opts.minDev*[1,1], [0, 2]+0.5, 'color','r', 'LineStyle','--' );
    plot([locoDiamData.Result(vesselNumber).dev, diamFluorData.Result(cell).dev], 1:2,  '*' );
    % Add numbers on top of the stars
    text(locoDiamData.Result(vesselNumber).dev, 1.1, sprintf('%.2f', locoDiamData.Result(vesselNumber).dev), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10); %num2str(locoDiamData.Result(vesselNumber).dev), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
    text(diamFluorData.Result(cell).dev, 2.1, sprintf('%.2f', diamFluorData.Result(cell).dev), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
    axis square;
    set(gca, 'Ytick',1:2, 'YtickLabel',{'locoDiam', 'diamFluor'}, 'TickLabelInterpreter','none', 'FontSize',10, 'TickDir','out'); % 
    xlim([-0.02, Inf]); ylim([0, 2]+0.5); 
    ylabel('Dev Expl');
    pause;
end

     

%         %save figure
%         if ~isempty(figPath)
%           nameTemp = extractBefore(summaryString, ':');
%           name = strcat(FOV, '_vessel', num2str(vesselNumber), '_cell', num2str(r));
%           path = 'D:\2photon\Simone\Simone_Macrophages\GLMs\locoDiam\Figures';
%           filename = fullfile(path, [name, '.fig']); % Combine path, name, and extension
%           saveas(GLMresultFig, filename);
%         end
% 
%          if ~isempty(figPath)
% %             fprintf('\nSaving %s', figPath);
% %             export_fig(figPath, '-pdf', '-painters','-q101', '-append', GLMresultFig); 
% %             pause(1);
%          else
% %             nameTemp = extractBefore(summaryString, ':');
% %             name = strcat(nameTemp, '_vessel_', num2str(r));
% %             path = 'D:\2photon\Simone\Simone_Macrophages\GLMs\locoDiam\Figures';
% %             filename = fullfile(path, [name, '.fig']); % Combine path, name, and extension
% %             saveas(GLMresultFig, filename);
%              pause;
%          end
%     end

%% plot DELAY

clear all;
diamFluorDir = "D:\2photon\Simone\Simone_Macrophages\GLMs\diamFluor";
cd(diamFluorDir);

FilesAll = dir(fullfile(diamFluorDir, '*_results.mat')); 

% Extract file names
fileNames = {FilesAll.name};

% Initialize an array to store the extracted parts for sorting
sortKey = [];

% Loop through all filenames to extract the parts for sorting
for file = 1:length(fileNames)
    filename = fileNames{file};
    
    % Extract the number after "Pf4Ai162-" (e.g., '2' from 'Pf4Ai162-2')
    numberAfterPrefix = sscanf(filename, 'Pf4Ai162-%d', 1);
    
    % Extract the date (e.g., '221130' from 'Pf4Ai162-2_221130_FOV6')
    dateStr = regexp(filename, '\d{6}', 'match', 'once');
    
    % Extract the FOV number (e.g., 'FOV6' from 'Pf4Ai162-2_221130_FOV6')
    fovNumber = sscanf(filename, 'Pf4Ai162-%*d_%*d_FOV%d', 1);
    
    % Store the extracted values in a matrix for sorting
    sortKey = [sortKey; numberAfterPrefix, str2double(dateStr), fovNumber];
end

% Sort by the three columns: numberAfterPrefix, date, fovNumber
[~, idx] = sortrows(sortKey);
sortedFileNames = fileNames(idx);

% Initialize arrays
coeff_positive = [];
coeff_negative = [];
delay_positive = [];
delay_negative = [];
cells_all = [];

% for x = 3:length(sortedFileNames)
%     data = load(sortedFileNames{x});
%     file = sortedFileNames{x};
%     disp(file)
%     for cell = 1:length(data.Result)
%         perivascularToVessel = input(strcat('Is cell_', num2str(cell), ' perivascular to this vessel? '));
%         if perivascularToVessel == 1
%             if data.Result(cell).dev >= 0.1
%                coeff_values = data.Result(cell).coeff;  
%                 if data.Result(cell).peakCoeff > 0
%                     coeff_positive = [coeff_positive, coeff_values]; 
%                 elseif data.Result(cell).peakCoeff < 0
%                     coeff_negative = [coeff_negative, coeff_values];
%                 end
%             end
%         end
%     end
% end


% INFO of cellIndexes
%Pf4Ai162-2_221130_FOV2_vessel1 
%Pf4Ai162-10_230628_FOV1_vessel1
%Pf4Ai162-10_230628_FOV1_vessel2
%Pf4Ai162-10_230628_FOV2_vessel1
%Pf4Ai162-10_230628_FOV3_vessel1
%Pf4Ai162-10_230628_FOV8_vessel1
%Pf4Ai162-11_230628_FOV3_vessel1
%Pf4Ai162-12_230717_FOV2_vessel1
%Pf4Ai162-12_230717_FOV3_vessel2
%Pf4Ai162-12_230717_FOV4_vessel2
%Pf4Ai162-12_230717_FOV5_vessel1
%Pf4Ai162-12_230717_FOV6_vessel1
%Pf4Ai162-12_230717_FOV7_vessel3
%Pf4Ai162-13_230717_FOV2_vessel2
%Pf4Ai162-13_230717_FOV3_vessel1
%Pf4Ai162-13_230717_FOV3_vessel3
%Pf4Ai162-13_230717_FOV4_vessel1
%Pf4Ai162-13_230717_FOV4_vessel3
%Pf4Ai162-13_230717_FOV5_vessel1
%Pf4Ai162-13_230717_FOV5_vessel2
%Pf4Ai162-13_230717_FOV5_vessel5
%Pf4Ai162-13_230717_FOV7_vessel3

for x = 1:length(sortedFileNames)
    data = load(sortedFileNames{x});
    file = sortedFileNames{x};
    disp(file)
    for cellIdx = 1:length(data.Result)
        if data.Result(cellIdx).dev >= 0.1
           perivascularToVessel = input(strcat('Is cell_', num2str(cellIdx), ' perivascular to this vessel? '));
           if perivascularToVessel == 1
               % get expt and cell info
               cell = table(string(file), cellIdx, 'VariableNames', {'File', 'CellIndex'});
               cells_all = [cells_all; cell];
               % get coeff and delay
               coeff_values = data.Result(cellIdx).coeff;
               delay = data.Result(cellIdx).peakShift;
               %separate cells by positive/negative coefficient
               if data.Result(cellIdx).peakCoeff > 0
                   coeff_positive = [coeff_positive, coeff_values]; 
                   delay_positive = [delay_positive, delay];
               elseif data.Result(cellIdx).peakCoeff < 0
                   coeff_negative = [coeff_negative, coeff_values];
               end
           end
        end
    end
end

%% PLOT coeff_positive

x = (-60:60)'; % Column vector for x-axis

% Individual + Mean
figure; % Create a new figure
hold on; % Keep all plots on the same figure

% Plot each column
for col = 1:size(coeff_positive,2)
    h1 = plot(x, coeff_positive(:, col), 'Color', [0.9 0.9 0.9]); % Light gray for individual curves
end

% Compute the mean across columns
meanCurve = mean(coeff_positive, 2, 'omitnan'); % Excludes NaNs if present

% Plot the mean curve in a distinct color (e.g., red, thicker line)
h2 = plot(x, meanCurve, 'r', 'LineWidth', 2);

% Create legend and store handle
lgd = legend([h1(1), h2], {'Individual Curves', 'Mean Curve'});

% Formatting
xlim([-60 60]);
xlabel('Delay (sec)');
ylabel('Coefficient value');
title('Macrophage fluorescence response to dural diameter changes');
grid off;
% legend({'Individual Curves', 'Mean Curve'});

hold off; % Release the figure

%% PLOT coeff_negative

%remove cells that have doubt
removeCols = [1,8];  %1 = Pf4Ai162-2 FOV2 cell 1  %8 = Pf4Ai16212 FOV5 cell14
coeff_negative(:, removeCols) = [];

x = (-60:60)'; % Column vector for x-axis

% Individual + Mean
figure; % Create a new figure
hold on; % Keep all plots on the same figure

% Plot each column
for col = 1:size(coeff_negative,2)
    h1 = plot(x, coeff_negative(:, col), 'Color', [0.7 0.7 0.7]); % Light gray for individual curves
end

% Compute the mean across columns
meanCurve = mean(coeff_negative, 2, 'omitnan'); % Excludes NaNs if present

% Plot the mean curve in a distinct color (e.g., red, thicker line)
h2 = plot(x, meanCurve, 'r', 'LineWidth', 2);

% Create legend and store handle
lgd = legend([h1(1), h2], {'Individual Curves', 'Mean Curve'});

% Formatting
xlim([-60 60]);
xlabel('Delay (sec)');
ylabel('Coefficient value');
title('Macrophage fluorescence response to dural diameter changes');
grid off;
% legend({'Individual Curves', 'Mean Curve'});

hold off; % Release the figure


%%
% Plot positive peakCoeff
figure;
scatter(positive_peak_x, positive_peak_y, 'b', 'filled');
hold on;
scatter(negative_peak_x, negative_peak_y, 'r', 'filled');
xlabel('Peak Coefficient');
ylabel('Delay');
legend('Positive peakCoeff', 'Negative peakCoeff');
title('Peak Coeff vs Delay');
grid on;
