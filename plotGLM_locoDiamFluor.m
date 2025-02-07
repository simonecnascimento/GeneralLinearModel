clear all;

% load GLM_diamFluor
diamFluorDir = 'D:\2photon\Simone\Simone_Macrophages\GLMs\diamFluor';
cd(diamFluorDir);

% expt name
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
end

     

        %save figure
        if ~isempty(figPath)
          nameTemp = extractBefore(summaryString, ':');
          name = strcat(FOV, '_vessel', num2str(vesselNumber), '_cell', num2str(r));
          path = 'D:\2photon\Simone\Simone_Macrophages\GLMs\locoDiam\Figures';
          filename = fullfile(path, [name, '.fig']); % Combine path, name, and extension
          saveas(GLMresultFig, filename);
        end

         if ~isempty(figPath)
%             fprintf('\nSaving %s', figPath);
%             export_fig(figPath, '-pdf', '-painters','-q101', '-append', GLMresultFig); 
%             pause(1);
         else
%             nameTemp = extractBefore(summaryString, ':');
%             name = strcat(nameTemp, '_vessel_', num2str(r));
%             path = 'D:\2photon\Simone\Simone_Macrophages\GLMs\locoDiam\Figures';
%             filename = fullfile(path, [name, '.fig']); % Combine path, name, and extension
%             saveas(GLMresultFig, filename);
             pause;
         end
    end

