clear all;

% load GLM_diamFluor
diamFluorDir = 'D:\2photon\Simone\Simone_Macrophages\GLMs\diamFluor';
cd(diamFluorDir);

% expt name
diamFluorExpt = 'Pf4Ai162-2_221130_FOV2_run1_reg_Z01_green_Substack(1-927)_GLM_diamFluor_baseline_vessel1_results';
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
FOV = extractBefore(diamFluorExpt, '_run1_reg_Z01_green_Substack(1-927)_GLM_diamFluor_baseline_vessel1_results');
locoDiamExpt = strcat(FOV, '_GLM_locoDiam_baseline_results');
locoDiamData = load(locoDiamExpt);



% Determine which responses to plot
if sum(isnan(locoDiamData.Opts.rShow))
    locoDiamData.Opts.rShow = locoDiamData.Summ.rGood;
end

if ~isempty(locoDiamData.Opts.rShow)
    GLMresultFig = figure('WindowState','maximized', 'color','w');
    leftOpt = {[0.02,0.04], [0.08,0.03], [0.04,0.02]};  % {[vert, horz], [bottom, top], [left, right] }
    rightOpt = {[0.04,0.04], [0.08,0.01], [0.04,0.01]}; 
    xAngle = 25;
    Nrow = locoDiamData.Pred.N+2; %locomotion, vasculature, macrophage
    Ncol = 8;  %8
    spGrid = reshape( 1:Nrow*Ncol, Ncol, Nrow )';
    if ~isempty(locoDiamData.Opts.figDir)
        figPath = sprintf('%s%s', locoDiamData.Opts.figDir, locoDiamData.Opts.name ); %figPath = sprintf('%s%s_glmFits.pdf', Opts.figDir, Opts.name );
        if exist(figPath,'file') 
            delete(figPath); 
        end
    else
        figPath = '';
    end
    if strcmpi(locoDiamData.Opts.xVar, 'Time')
        T = (1/locoDiamData.Opts.frameRate)*(0:size(locoDiamData.Pred.data,1)-1)'/60;
        xLabelStr = 'Time (min)';
    else
        T = (1:size(Pred.data,1))';
        xLabelStr = 'Scan';
    end
    
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
    sp(3) = subtightplot(Nrow, Ncol, spGrid(v+1,Ncol), rightOpt{:}); cla;
    plot( Opts.lags, Result(r).coeff(:,v), 'k' ); hold on; 
    plot( Opts.lags, Result(r).coeff(:,v), 'k.', 'MarkerSize',10 ); 
    ylabel('Coeff'); % ylabel( sprintf('%s coeff', Pred.name{v}), 'Interpreter','none');
    title( sprintf('LOPO: %2.1f', 100*(1-Result(r).lopo.devFrac(v))) ); % locoDiamDeform_result{x}(1).lopo.devFrac()
    axis square; 
    xLim = get(gca,'Xlim');
    line(xLim, [0,0], 'color','k');
    %if v == 1, title('Predictor leads response >', 'FontSize',8, 'HorizontalAlignment','left'); end

    

    % Plot fluorescence signal
    sp(4) = subtightplot(Nrow, Ncol, spGrid(1,1:Ncol-1), leftOpt{:}); cla;
    h1 = plot( T, diamFluorData.Resp.data(:,r), 'k', 'LineWidth',1 ); 
    xlim([-Inf,Inf]);
    hold on;
    box off;
    h2 = plot( T, diamFluorData.Result.prediction, 'b', 'LineWidth',2 );
    ylabel(diamFluorData.Resp.name{r}, 'Interpreter','none');
    summaryString = sprintf('%s: dev exp locoDiam(%2.2f), diamFluor(%2.2f)', FOV, locoDiamData.Result(r).dev, diamFluorData.Result(r).dev);
    title(summaryString, 'Interpreter','none');
    legend([h1, h2], {'Full data', 'Model prediction'}, 'Location','best');

     

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

