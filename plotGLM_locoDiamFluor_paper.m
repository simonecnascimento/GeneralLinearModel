clear all;

% load GLM_diamFluor
diamFluorDir = 'D:\2photon\Simone\Simone_Macrophages\GLMs\diamFluor';
cd(diamFluorDir);

%% expt name
diamFluorExpt = 'Pf4Ai162-12_230717_FOV2_run1_reg_Z01_green_Substack(1-927)_GLM_diamFluor_baseline_vessel1_results';
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
locoDiamExpt = strcat(FOV, '_GLM_locoDiam_baseline_results_good');
locoDiamData = load(locoDiamExpt);

%plot
GLMresultFig = figure('WindowState', 'normal', 'color','w');
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
locoDiamData.Pred.data2 = locoDiamData.Pred.data(:,1);

for state = 1:807
    if locoDiamData.Pred.data2(state,1) > 1.5
        locoDiamData.Pred.data2(state,1) = 1; %2
    else
        locoDiamData.Pred.data2(state,1) = 0; %1
    end
end

plot( T, locoDiamData.Pred.data2(:,1) ); 
hold on;    
ylabel(locoDiamData.Pred.name{1}, 'Interpreter','none');
xlim([-Inf,Inf]);
set(gca,'TickDir','out', 'TickLength',[0.003,0], 'box','off'); 
xlabel(xLabelStr);

% % Find segments where value > 1.5
% aboveThreshold = locoDiamData.Pred.data(:,1) > 1.5;
% diffAbove = diff([0; aboveThreshold; 0]); % Find start/end points
% startIdx = find(diffAbove == 1); % Indices where shading starts
% endIdx = find(diffAbove == -1) - 1; % Indices where shading ends
% 
% % Loop through detected regions and shade them
% for i = 1:length(startIdx)
%     x1 = T(startIdx(i)); % Start time
%     x2 = T(endIdx(i));   % End time
%     fill([x1 x2 x2 x1], [1 1 2 2], [0.7, 0.7, 0.7], ...
%         'EdgeColor', 'none', 'FaceAlpha', 0.3); % Gray rectangle
% end

% Plot vascular response data and models' predictions
sp(2) = subtightplot(Nrow, Ncol, spGrid(2,1:Ncol-1), leftOpt{:}); cla;
h1 = plot( T, locoDiamData.Resp.data(:,vesselNumber), 'k', 'LineWidth',1  ); 
hold on;
h2 = plot( T, locoDiamData.Result(vesselNumber).prediction, 'b', 'LineWidth',2 );
legend([h1, h2], {'Diameter', 'Model'}, 'Location','best');
set(gca, 'XtickLabel', [], 'TickDir', 'out', 'TickLength', [0.003,0]);
box off;
ylabel(strcat('Diameter z-score'), 'Interpreter','none'); %locoDiamData.Resp.name{r}, 'Vessel #' %ylabel(strcat('Diameter z-score', num2str(vesselNumber)), 'Interpreter','none'); 
xlim([-Inf,Inf]);

% adjust code for multiple cells
for cell = 4:5
    % Plot fluorescence signal
    sp(4) = subtightplot(Nrow, Ncol, spGrid(1,1:Ncol-1), leftOpt{:}); cla;
    h1 = plot( T, diamFluorData.Resp.data(:,cell), 'k', 'LineWidth',1 ); 
    xlim([T(1), T(end)]); %xlim([-Inf,Inf]);
    hold on;
    box off;
    h2 = plot( T, diamFluorData.Result(cell).prediction, 'b', 'LineWidth',2 );
    ylabel(strcat('Fluorescence z-score'), 'Interpreter','none'); %diamFluorData.Resp.name{cell},
    %summaryString = sprintf('%s: dev exp locoDiam(%2.2f), diamFluor(%2.2f)', FOV, locoDiamData.Result(r).dev, diamFluorData.Result(r).dev);
    summaryString = sprintf('%s', FOV);
    set(gca, 'XtickLabel', [], 'TickDir', 'out','TickLength', [0.003,0]); % Make tick marks point outward
    title(summaryString, 'Interpreter','none');
    legend([h1, h2], {'Fluorescence', 'Model'}, 'Location','best');
    pause;
end