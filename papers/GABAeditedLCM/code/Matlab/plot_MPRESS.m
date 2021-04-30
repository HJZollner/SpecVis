function [figures] = plot_MPRESS(containerList, nameList,range,comb,bSp)
%% plot_MPRESS(containerList, nameList,range,comb,bSp)
%   Generate overview plots for all spectra
%
%   USAGE:
%       plot_MPRESS(containerList, nameList,range,comb,bSp)
%
%   OUTPUTS:
%       generates figure handels
%
%   OUTPUTS:
%       containerList  = List of container names (path)
%       nameList = List of the model names
%       range = indicator for the fit range (string)
%       comb = indicator for the HCar inclusion (string)
%       bSp = indicator for the knot spacing (string)
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2019-10-02)
%       hzoelln2@jhmi.edu
%
%   HISTORY:
%       2020-01-07: First version of the code.
%% Load the overview mat file with all results
% If a global container is stored load this, otherwise load each individual
% container and create a global copy for the future
 outDir = ['/Volumes/Samsung/paper/editedLCM/Figures/02_Overview/Figures' bSp '/SpectraOverview/' range comb];
 mkdir(outDir);
 if ~exist([outDir '/AllCont.mat'],'file')
    for cc = 1 : length(containerList)
        load(containerList{cc});       
        AllCont.(nameList{cc}) = MRSCont.overview.Osprey;
    end
 else
     load([outDir '/AllCont.mat']);
 end
close all
colorDark = cbrewer('qual', 'Dark2', 8, 'pchip');
colorPaired = cbrewer('qual', 'Paired', 10, 'pchip');

if ~exist([outDir '/AllCont.mat'],'file')
    save([outDir '/AllCont.mat'],'AllCont','MRSCont','-v7.3')
end
if length(containerList) == 7
    cb= [colorDark(8,:);colorPaired(2,:);colorPaired(1,:);colorPaired(4,:);colorPaired(3,:);colorPaired(6,:);colorPaired(5,:)];
else
    cb= [colorDark(8,:);colorPaired(2,:);colorPaired(1,:);colorPaired(6,:);colorPaired(5,:)];
end


fit = 'diff1';
which = 'diff1';
%% Site level models
% Create site level plots of data and fits
for cc = 1 : length(containerList)

    for g = 1 : (length(fields(AllCont.(nameList{cc}).sort_fit_voxel_1))-1)
        data_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_data_' fit '_' which]);
        data_sd = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['sd_data_' fit '_' which]);
        data_yu = data_mean + data_sd;
        data_yu = data_yu(AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).ppm_fit_diff1_diff1>1.95 & AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).ppm_fit_diff1_diff1<4);
        mean_cont(g) = mean(data_mean(AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).ppm_fit_diff1_diff1>1.95 & AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).ppm_fit_diff1_diff1<4));   
    end
    data_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_data_' fit '_' which]);
    data_sd = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['sd_data_' fit '_' which]);
    data_yu = data_mean + data_sd;
    data_yu = data_yu(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1>0.5 & AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1<4);
    mean_cont(g+1) = mean(data_mean(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1>1.85 & AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1<4)); 
    
    max_mean = max(max(mean_cont));
    diff_mean = max_mean - mean_cont(:);
    maxshift = 0.2; % THIS might be different for other datasets!
    out = figure('Visible','on');
    hold on

    for g = 1 : (length(fields(AllCont.(nameList{cc}).sort_fit_voxel_1))-1) % Loop over sites
        fit = 'diff1'; % Vertically shift data here
        fit_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_' fit '_' which])+ diff_mean(g); 
        data_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_data_' fit '_' which])+ diff_mean(g);
        baseline_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_baseline_' fit '_' which])+ diff_mean(g);
        residual_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_res_' fit '_' which]);
        ppm = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['ppm_fit_' fit '_' which]);
        GABA_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitGABA_' fit '_' which])+ diff_mean(g);
        GABAp_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitGABA_' fit '_' which]);
        if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]),'mean_fitMM3co_diff1_diff1')
            MMco_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitMM3co_' fit '_' which])+ diff_mean(g);
            GABAp_mean = GABAp_mean + AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitMM3co_' fit '_' which])+ diff_mean(g);
            if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]),'mean_fitHCar_diff1_diff1')
                HCar_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitHCar_' fit '_' which]) + diff_mean(g);
                GABAp_mean = GABAp_mean+ AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitHCar_' fit '_' which]);
            end
        else if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]),'mean_fitHCar_diff1_diff1')
                HCar_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitHCar_' fit '_' which])+ diff_mean(g);
                GABAp_mean = GABAp_mean+ AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitHCar_' fit '_' which])+ diff_mean(g);
                if strcmp(nameList{cc},'fixedMM') || strcmp(nameList{cc},'fixedMM09')
                    MMco_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitMM09_' fit '_' which]);
                    GABAp_mean = GABAp_mean + AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitMM09_' fit '_' which]);
                end
            else
                if strcmp(nameList{cc},'fixedMM') || strcmp(nameList{cc},'fixedMM09')
                    MMco_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitMM09_' fit '_' which])+ diff_mean(g);
                    GABAp_mean = GABAp_mean + AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]).(['mean_fitMM09_' fit '_' which]) +diff_mean(g);
                else
                    MMco_mean = zeros(1,length(ppm));
                    GABAp_mean = GABAp_mean + diff_mean(g);
                end
            end
        end

        % Plotting of site means starts here   
        try
            if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]),'mean_fitHCar_diff1_diff1')
                plot(ppm,baseline_mean- max(maxshift)*3.5 ,'color', cb(cc,:), 'LineWidth', 1.5); %Baseline
                plot(ppm,HCar_mean- max(maxshift)*3 ,'color', cb(cc,:), 'LineWidth', 1.5); %HCar
            else
                plot(ppm,baseline_mean- max(maxshift)*3 ,'color', cb(cc,:), 'LineWidth', 1.5); %Baseline
            end
            if exist('MMco_mean','var')
                plot(ppm,MMco_mean- max(maxshift)*2.5 ,'color', cb(cc,:), 'LineWidth', 0.5); %MMco 
            end
            plot(ppm,GABA_mean- max(maxshift)*2 ,'color', cb(cc,:), 'LineWidth', 0.5); %GABA  
            plot(ppm,GABAp_mean- max(maxshift)*1.5 ,'color', cb(cc,:), 'LineWidth', 0.5); %GABA+ 
            plot(ppm,fit_mean- max(maxshift),'color', cb(cc,:), 'LineWidth', 0.5); %Fit
            plot(ppm,data_mean -0.5*max(maxshift) ,'color',cb(cc,:), 'LineWidth', 0.5); % Data
            plot(ppm,residual_mean ,'color', cb(cc,:), 'LineWidth', 0.5);  %Residual
        catch
        end
    end

    data_grandmean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_data_' fit '_' which])+ diff_mean(g+1);
    ppm = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['ppm_fit_' fit '_' which]);
    plot(ppm,data_grandmean- max(maxshift),'color', 'k', 'LineWidth', 1); %Grand mean data
    if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.(['g_' num2str(g)]),'mean_fitHCar_diff1_diff1')
        plot(ppm,zeros(1,length(ppm))- max(maxshift)*3.5 ,'color', 'k', 'LineWidth', 0.5); %Baseline 
    else
        plot(ppm,zeros(1,length(ppm))- max(maxshift)*3 ,'color', 'k', 'LineWidth', 0.5); %Baseline 
    end
    plot(ppm,zeros(1,length(ppm)) - max(maxshift)*2.5 ,'color', 'k', 'LineWidth', 0.5); %MMco 
    plot(ppm,zeros(1,length(ppm)) - max(maxshift)*2 ,'color', 'k', 'LineWidth', 0.5); %GABA
    plot(ppm,zeros(1,length(ppm)) - max(maxshift)*1.5 ,'color', 'k', 'LineWidth', 0.5); %GABAp
    plot(ppm,zeros(1,length(ppm))- 1*max(maxshift),'color', 'k', 'LineWidth', 0.5); %Fit
    plot(ppm,zeros(1,length(ppm)) -0.5*max(maxshift),'color','k', 'LineWidth', 0.5); % Data
    plot(ppm,zeros(1,length(ppm)) ,'color', 'k', 'LineWidth', 0.5);  %Residual 
            
    [out] = design_finetuning_model(out,MRSCont);
    set(out,'Name',['Model means stack ' nameList{cc}]);
    figures{cc} = out;
    saveas(gcf,[outDir '/' nameList{cc}],'pdf');
end
figNum = cc;    
%% Grand mean models
% Create grand mean plots of data and model

mean_cont = [];
for cc = 1 : length(containerList)
    data_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_data_' fit '_' which]);
    data_sd = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['sd_data_' fit '_' which]);
    data_yu = data_mean + data_sd;
    data_yu = data_yu(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1>0.5 & AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1<4);
    mean_cont(cc) = mean(data_mean(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1>1.85 & AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1<4));
    maxshift_abs = min(abs(data_yu));         
end
max_mean = max(max(mean_cont));
diff_mean = max_mean - mean_cont(:);
maxshift = 0.2; % THIS might be different for other datasets!
out = figure('Visible','on');
hold on

    for cc = 1 : length(containerList)
        fit = 'diff1'; % Vertically shift data here
        fit_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_' fit '_' which])+ diff_mean(cc); 
        data_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_data_' fit '_' which])+ diff_mean(cc);
        baseline_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_baseline_' fit '_' which])+ diff_mean(cc);
        residual_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_res_' fit '_' which]);
        ppm = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['ppm_fit_' fit '_' which]);
        GABA_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitGABA_' fit '_' which])+ diff_mean(cc); 
        GABAp_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitGABA_' fit '_' which]); 
        if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean,'mean_fitMM3co_diff1_diff1')
            MMco_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitMM3co_' fit '_' which])+ diff_mean(cc);
            GABAp_mean = GABAp_mean + AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitMM3co_' fit '_' which])+ diff_mean(cc);
            if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean,'mean_fitHCar_diff1_diff1')
%                 MMco_mean = MMco_mean + AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitHCar_' fit '_' which]);
                GABAp_mean = GABAp_mean+ AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitHCar_' fit '_' which]);
            end
        else if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean,'mean_fitHCar_diff1_diff1')
                HCar_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitHCar_' fit '_' which])+ diff_mean(cc);                
                GABAp_mean = GABAp_mean+ AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitHCar_' fit '_' which])+ diff_mean(cc);
                if strcmp(nameList{cc},'fixedMM') || strcmp(nameList{cc},'fixedMM09')
                    MMco_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitMM09_' fit '_' which]) + diff_mean(cc);
                    GABAp_mean = GABAp_mean + AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitMM09_' fit '_' which]);
                end
            else
                if strcmp(nameList{cc},'fixedMM') || strcmp(nameList{cc},'fixedMM09')
                    MMco_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitMM09_' fit '_' which])+ diff_mean(cc);
                    GABAp_mean = GABAp_mean + AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitMM09_' fit '_' which]) +diff_mean(cc);
                else
                    MMco_mean = zeros(1,length(ppm));
                    GABAp_mean = GABAp_mean + diff_mean(cc);
                end
            end
        end

        % Plotting of site means starts here      
        if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean,'mean_fitHCar_diff1_diff1')
            plot(ppm,baseline_mean- max(maxshift)*3 ,'color', cb(cc,:), 'LineWidth', 1.5); %Baseline
            plot(ppm,HCar_mean- max(maxshift)*2.5 ,'color', cb(cc,:), 'LineWidth', 1.5); %HCar
        else
            plot(ppm,baseline_mean- max(maxshift)*2.5 ,'color', cb(cc,:), 'LineWidth', 1.5); %Baseline
        end
        plot(ppm,MMco_mean- max(maxshift)*2 ,'color', cb(cc,:), 'LineWidth', 1.5); %MMco 
        plot(ppm,GABA_mean- max(maxshift)*1.5 ,'color', cb(cc,:), 'LineWidth', 1.5); %GABA  
        plot(ppm,GABAp_mean- max(maxshift)*1 ,'color', cb(cc,:), 'LineWidth', 1.5); %GABA+  
        plot(ppm,fit_mean- 0.5*max(maxshift),'color', cb(cc,:), 'LineWidth', 1.5); %Fit
        plot(ppm,residual_mean+ 0.5*max(maxshift) ,'color', cb(cc,:), 'LineWidth', 1.5);  %Residual
    end
    plot(ppm,data_mean -0.5*max(maxshift), 'color','k', 'LineWidth', 1); % Data
    if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean,'mean_fitHCar_diff1_diff1')
        plot(ppm,zeros(1,length(ppm))- max(maxshift)*3 ,'color', 'k', 'LineWidth', 0.5); %Baseline 
    else
        plot(ppm,zeros(1,length(ppm))- max(maxshift)*2.5 ,'color', 'k', 'LineWidth', 0.5); %Baseline 
    end
    plot(ppm,zeros(1,length(ppm))- max(maxshift)*1.5 ,'color', 'k', 'LineWidth', 0.5); %MMco 
    plot(ppm,zeros(1,length(ppm))- max(maxshift)*1 ,'color', 'k', 'LineWidth', 0.5); %GABA   
    plot(ppm,zeros(1,length(ppm))- 0.5*max(maxshift),'color', 'k', 'LineWidth', 0.5); %Fit
    plot(ppm,zeros(1,length(ppm))+ 0.5*max(maxshift),'color', 'k', 'LineWidth', 0.5);  %Residual 
            
    [out] = design_finetuning_range(out,MRSCont);
    set(out,'Name',['Grand means stack']);
    saveas(gcf,[outDir '/Grand means stack'],'pdf');
    figures{figNum + 1} = out;
 figNum = figNum + 1;   
%% Grand mean models zoom
% Create grand mean models zoomed in to the 3-ppm region
mean_cont = [];
for cc = 1 : length(containerList)
    data_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_data_' fit '_' which]);
    data_sd = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['sd_data_' fit '_' which]);
    data_yu = data_mean + data_sd;
    data_yu = data_yu(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1>0.5 & AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1<4);
    mean_cont(cc) = mean(data_mean(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1>1.85 & AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.ppm_fit_diff1_diff1<4));
    maxshift_abs = min(abs(data_yu));         
end
max_mean = max(max(mean_cont));
diff_mean = max_mean - mean_cont(:);
maxshift = 0.2; % THIS might be different for other datasets!
out = figure('Visible','on');
hold on

    for cc = 1 : length(containerList)
        fit = 'diff1'; % Vertically shift data here
        fit_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_' fit '_' which])+ diff_mean(cc); 
        data_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_data_' fit '_' which])+ diff_mean(cc);
        baseline_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_baseline_' fit '_' which])+ diff_mean(cc);
        residual_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_res_' fit '_' which]);
        ppm = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['ppm_fit_' fit '_' which]);
        GABA_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitGABA_' fit '_' which])+ diff_mean(cc); 
        if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean,'mean_fitMM3co_diff1_diff1')
            MMco_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitMM3co_' fit '_' which])+ diff_mean(cc);
            if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean,'mean_fitHCar_diff1_diff1')
                MMco_mean = MMco_mean + AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitHCar_' fit '_' which]);
            end
            if strcmp(nameList{cc},'fixedMM') || strcmp(nameList{cc},'fixedMM09')
                    MMco_mean = MMco_mean+ AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitMM09_' fit '_' which]);
            end
        else if isfield(AllCont.(nameList{cc}).sort_fit_voxel_1.GMean,'mean_fitHCar_diff1_diff1')
                MMco_mean = AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitHCar_' fit '_' which])+ diff_mean(cc);
                if strcmp(nameList{cc},'fixedMM') || strcmp(nameList{cc},'fixedMM09')
                    MMco_mean = MMco_mean+ AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitMM09_' fit '_' which]);
                end
            else
                MMco_mean = zeros(1,length(ppm));
                if strcmp(nameList{cc},'fixedMM') || strcmp(nameList{cc},'fixedMM09')
                    MMco_mean = MMco_mean+ AllCont.(nameList{cc}).sort_fit_voxel_1.GMean.(['mean_fitMM09_' fit '_' which]);
                end
            end
        end

        % Plotting of site means starts here      
        plot(ppm,baseline_mean- max(maxshift)*2 ,'color', cb(cc,:), 'LineWidth', 1.5); %Baseline
        plot(ppm,MMco_mean- max(maxshift)*1.5 ,'color', cb(cc,:), 'LineWidth', 1.5); %MMco 
        plot(ppm,GABA_mean- max(maxshift)*1 ,'color', cb(cc,:), 'LineWidth', 1.5); %GABA  
         
        plot(ppm,fit_mean- 0.5*max(maxshift),'color', cb(cc,:), 'LineWidth', 1.5); %Fit
        plot(ppm,residual_mean ,'color', cb(cc,:), 'LineWidth', 1.5);  %Residual
    end
    plot(ppm,data_mean -0.5*max(maxshift) ,'color','k', 'LineWidth', 1); % Data
    plot(ppm,zeros(1,length(ppm)) - max(maxshift)*2 ,'color', 'k', 'LineWidth', 0.5); %Baseline 
    plot(ppm,zeros(1,length(ppm)) - max(maxshift)*1.5 ,'color', 'k', 'LineWidth', 0.5); %MMco 
    plot(ppm,zeros(1,length(ppm)) - max(maxshift)*1 ,'color', 'k', 'LineWidth', 0.5); %GABA   
    plot(ppm,zeros(1,length(ppm)) -0.5*max(maxshift),'color','k', 'LineWidth', 0.5); % Data
    plot(ppm,zeros(1,length(ppm))- 0.5*max(maxshift),'color', 'k', 'LineWidth', 0.5); %Fit
    plot(ppm,zeros(1,length(ppm)) ,'color', 'k', 'LineWidth', 0.5);  %Residual 
            
    [out] = design_finetuning_model_means(out,MRSCont);
    set(out,'Name',['Model grand means stack ']);
    saveas(gcf,[outDir '/Grand means stack zoom'],'pdf');
    figures{figNum + 1} = out;    
    figNum = figNum + 1;  
end


function [out] = design_finetuning_range(out,MRSCont)
    %%% DESIGN FINETUNING %%%
    % Adapt common style for all axes
    ppmRange = MRSCont.opts.fit.range;
    yLims = get(gca, 'YLim');
    set(gca, 'XDir', 'reverse', 'XLim', [ppmRange(1), ppmRange(end)]);
    set(gca, 'YLim', [-0.7, yLims(end)]);
    set(gca, 'LineWidth', 1, 'TickDir', 'out');
    set(gca, 'FontSize', 16);

    set(gca, 'YColor', MRSCont.colormap.Background);
    set(gca,'YTickLabel',{});
    set(gca,'YTick',{});
    % Dirtywhite axes, light gray background
    set(gca, 'XColor', 'k');
    set(gca, 'Color', MRSCont.colormap.Background);
    set(gcf, 'Color', MRSCont.colormap.Background);
    
    xlab = 'Frequency (ppm)';
    ylab = '';

    box off;
    xlabel(xlab, 'FontSize', 16);
    ylabel(ylab, 'FontSize', 16);
    set(gcf,'Position',[100 100 700 700])
    set(out,'Renderer','painters','Menu','none','Toolbar','none');
end
function [out] = design_finetuning_model(out,MRSCont)
    %%% DESIGN FINETUNING %%%
    % Adapt common style for all axes
    ppmRange = [2.8 3.2];
    yLims = get(gca, 'YLim');
    set(gca, 'XDir', 'reverse', 'XLim', [ppmRange(1), ppmRange(end)]);
    set(gca, 'YLim', [-0.7, yLims(end)]);
    set(gca, 'LineWidth', 1, 'TickDir', 'out');
    set(gca, 'FontSize', 16);

    set(gca, 'YColor', MRSCont.colormap.Background);
    set(gca,'YTickLabel',{});
    set(gca,'YTick',{});
    % Dirtywhite axes, light gray background
    set(gca, 'XColor', 'k');
    set(gca, 'Color', MRSCont.colormap.Background);
    set(gcf, 'Color', MRSCont.colormap.Background);
    
    xlab = 'Frequency (ppm)';
    ylab = '';

    box off;
    xlabel(xlab, 'FontSize', 16);
    ylabel(ylab, 'FontSize', 16);
    set(gcf,'Position',[100 100 175 375])
    set(out,'Renderer','painters','Menu','none','Toolbar','none');
end
function [out] = design_finetuning_model_means(out,MRSCont)
    %%% DESIGN FINETUNING %%%
    % Adapt common style for all axes
    ppmRange = [2.8 3.2];
    yLims = get(gca, 'YLim');
    set(gca, 'XDir', 'reverse', 'XLim', [ppmRange(1), ppmRange(end)]);
    set(gca, 'YLim', [-0.7, yLims(end)]);
    set(gca, 'LineWidth', 1, 'TickDir', 'out');
    set(gca, 'FontSize', 16);

    set(gca, 'YColor', MRSCont.colormap.Background);
    set(gca,'YTickLabel',{});
    set(gca,'YTick',{});
    % Dirtywhite axes, light gray background
    set(gca, 'XColor', 'k');
    set(gca, 'Color', MRSCont.colormap.Background);
    set(gcf, 'Color', MRSCont.colormap.Background);
    
    xlab = 'Frequency (ppm)';
    ylab = '';

    box off;
    xlabel(xlab, 'FontSize', 16);
    ylabel(ylab, 'FontSize', 16);
    set(gcf,'Position',[100 100 350 700])
    set(out,'Renderer','painters','Menu','none','Toolbar','none');
end