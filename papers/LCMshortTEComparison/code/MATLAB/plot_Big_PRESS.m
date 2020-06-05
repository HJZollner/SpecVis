function [figures] = plot_Big_PRESS(MRSCont1,MRSCont2,MRSCont3, which)
%% [figures] = plot_Big_PRESS(MRSCont1,MRSCont2,MRSCont3, which)
%   Creates a number figures used in the Big PRESS software comparison paper (REF)
%   and is currently only working for PRESS data and three containers
%   (GE,Philips,Siemens) and three LCM (Osprey (overview),LCModel,
%   Tarquin). The functions to create and import the fit outputs are part
%   of Osprey. Descriptions can be found in the begin of each figure
%   section and in the correpsonding figure. A more generalized function is
%   planned to be implemented into Osprey.
%
%   USAGE:
%       figures = plot_Big_PRESS(MRSCont1,MRSCont2,MRSCont3, which)
%
%   OUTPUTS:
%       figures     = Figure handles of several comparing figures
%
%   OUTPUTS:
%       MRSCont1-3  = Osprey data container (e.g. GE, Philips, Siemens).
%       which    = String for the spectrum to plot (optional)
%                   OPTIONS:    'A' 
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2019-10-02)
%       hzoelln2@jhmi.edu
%
%   HISTORY:
%       2020-05-07: First version of the code.
%% 1. Mean site overview plot with spectra, fit, residual, baseline and MM + baseline specified by name
close all
Tools = {'overview','LCModel','Tarquin'}; % THIS POSSIBLY DIFFERS FOR OTHER DATASETS
Vendor = {'GE','Philips','Siemens'}; % THIS POSSIBLY DIFFERS FOR OTHER DATASETS IT NEDS TO BE IN THE ORDER OF THE MRSCONTAINER
shift = 0;
MRSCont = MRSCont1;
% Check that OspreyOverview has been run before
if ~MRSCont.flags.didOverview
    error('Trying to create overview plots, but no overview data has been created. Run OspreyOverview first.')
end


cb = cbrewer('qual', 'Dark2', 12, 'pchip');
temp = cb(3,:);
cb(3,:) = cb(4,:);
cb(4,:) = temp;

cb2 = cbrewer('qual', 'Paired', 8, 'pchip');
fit_color = cb2(2,:);
fit = 'off';

for c = 1 : 3 % Loop over all MRSCont to normalize spectra to 3 ppm creatine
    eval(['MRSCont = MRSCont', num2str(c)]);
    for t = 1 : 3    
        for g = 1 : (length(fields(MRSCont.(Tools{t}).sort_fit))-1)
            data_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_data_' fit '_' which]);
            Cr_height = max(data_mean(MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).ppm_fit_off_A>2.9 & MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).ppm_fit_off_A<3.1));
            MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_' fit '_' which])/Cr_height;
            MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_' fit '_' which])/Cr_height; 
            MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_data_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_data_' fit '_' which])/Cr_height;
            MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_data_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_data_' fit '_' which])/Cr_height;
            MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_baseline_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_baseline_' fit '_' which])/Cr_height;
            MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_baseline_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_baseline_' fit '_' which])/Cr_height;
            MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_res_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_res_' fit '_' which])/Cr_height;
            MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_res_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_res_' fit '_' which])/Cr_height;
            if MRSCont.opts.fit.fitMM
                MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_fittMM_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_fittMM_' fit '_' which])/Cr_height;
                MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_fittCr_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_fittCr_' fit '_' which])/Cr_height;
                MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_fittMM_' fit '_' which]) = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_fittMM_' fit '_' which])/Cr_height;
            end             
        end
    end
    eval(['MRSCont', num2str(c), '= MRSCont']);
end

for t = 1 : 3 %Loop over tools
    for c = 1 : 3 % Loop to calculate shift between sites to vertivally align the spectra by their means
        eval(['MRSCont = MRSCont', num2str(c)]);
        for g = 1 : (length(fields(MRSCont.(Tools{t}).sort_fit))-1)
            data_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_data_' fit '_' which]);
            data_sd = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['sd_data_' fit '_' which]);
            data_yu = data_mean + data_sd;
            data_yu = data_yu(MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).ppm_fit_off_A>0.5 & MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).ppm_fit_off_A<4);
            mean_cont(c,g) = mean(data_mean(MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).ppm_fit_off_A>1.85 & MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).ppm_fit_off_A<4));
            maxshift_abs = max(abs(data_yu));         
        end
    end
    max_mean = max(max(mean_cont));
    diff_mean = max_mean - mean_cont(:,:);
    maxshift = 1.9652; % THIS might be different for other datasets!
    out = figure('Visible','on');
    hold on

    for c = 1 : 3 %Loop over MRS container
        eval(['MRSCont = MRSCont', num2str(c)]);
        for g = 1 : (length(fields(MRSCont.(Tools{t}).sort_fit))-1) % Loop over sites
            fit = 'off'; % Vertically shift data here
            fit_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_' fit '_' which])+ diff_mean(c,g); 
            data_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_data_' fit '_' which])+ diff_mean(c,g);
            baseline_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_baseline_' fit '_' which])+ diff_mean(c,g);
            residual_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_res_' fit '_' which]);
            ppm = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['ppm_fit_' fit '_' which]);
            if MRSCont.opts.fit.fitMM
            MM_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_fittMM_' fit '_' which]);
            tCr_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_fittCr_' fit '_' which]);
            end

            % Plotting of site means starts here
            plot(ppm,baseline_mean- max(maxshift)*2.6 ,'color', cb(c,:), 'LineWidth', 0.5); %Baseline
            plot(ppm,MM_mean+baseline_mean- max(maxshift)*2.3 ,'color', cb(c,:), 'LineWidth', 0.5); %MM + Baseliine        
            plot(ppm,data_mean -max(maxshift) ,'color',cb(c,:), 'LineWidth', 0.5); % Data 
            plot(ppm,fit_mean- 2*max(maxshift),'color', cb(c,:), 'LineWidth', 0.5); %Fit
            plot(ppm,residual_mean ,'color', cb(c,:), 'LineWidth', 0.5);  %Residual

        end
    end

    [out] = design_finetuning(out,MRSCont);
    set(out,'Name',['Site means stack ' Tools{t}]);
    figures{t} = out;
end
%% Grand mean overview plot with spectra + SD, fit, residual, baseline and MM + baseline and models specified by name
for t = 1 : 3 %Loop over tools
    out = figure;
    hold on
    for c = 1 : 3 %Loop over container
        eval(['MRSCont = MRSCont', num2str(c)]);
         %Normalize grand mean spectra to creatine and initalize the plot variables
        fit = 'off';
        data_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_data_' fit '_' which]);
        Cr_height = max(data_mean(MRSCont.(Tools{t}).sort_fit.GMean.ppm_fit_off_A>2.9 & MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).ppm_fit_off_A<3.1));
        fit_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_' fit '_' which])/Cr_height;
        data_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_data_' fit '_' which])/Cr_height;
        data_sd = MRSCont.(Tools{t}).sort_fit.GMean.(['sd_data_' fit '_' which])/Cr_height;
        baseline_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_baseline_' fit '_' which])/Cr_height;
        residual_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_res_' fit '_' which])/Cr_height;
        residual_sd = MRSCont.(Tools{t}).sort_fit.GMean.(['sd_res_' fit '_' which])/Cr_height;
        ppm = MRSCont.(Tools{t}).sort_fit.GMean.(['ppm_fit_' fit '_' which]);
        if MRSCont.opts.fit.fitMM
            MM_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fittMM_' fit '_' which])/Cr_height;
            tNAA_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fittNAA_' fit '_' which])/Cr_height;
            tCho_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fittCho_' fit '_' which])/Cr_height;
            Glx_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fitGlx_' fit '_' which])/Cr_height;
            Ins_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fitIns_' fit '_' which])/Cr_height;
        end

        %Calculate SD shadows
        data_yu = data_mean + data_sd;
        data_yl = data_mean - data_sd;
        residual_yu = residual_mean + residual_sd;
        residual_yl = residual_mean - residual_sd;


        try
            fill([ppm fliplr(ppm)], [(residual_yu-max(maxshift)*(0.05*(c-1))) (fliplr(residual_yl-max(maxshift)*(0.05*(c-1))))], cb(c,:),'FaceAlpha',0.15, 'linestyle', 'none'); %SD Shadow res
        catch
           fill([ppm' fliplr(ppm')], [(residual_yu-max(maxshift)*(0.05*(c-1))) (fliplr(residual_yl-max(maxshift)*(0.05*(c-1))))], cb(c,:),'FaceAlpha',0.15, 'linestyle', 'none'); %SD Shadow res
        end

        try
            fill([ppm fliplr(ppm)], [data_yu-max(maxshift)*0.5*c-max(maxshift)*0.6 fliplr(data_yl)-max(maxshift)*0.5*c-max(maxshift)*0.6], cb(c,:),'FaceAlpha',0.15, 'linestyle', 'none'); %SD Shadow data
        catch
            fill([ppm' fliplr(ppm')], [data_yu-max(maxshift)*0.5*c-max(maxshift)*0.6 fliplr(data_yl)-max(maxshift)*0.5*c-max(maxshift)*0.6], cb(c,:),'FaceAlpha',0.15, 'linestyle', 'none'); %SD Shadow data
        end


        plot(ppm,baseline_mean- max(maxshift)*0.5*c- max(maxshift)*0.6 ,'color', cb(c,:), 'LineWidth', 0.5); %Baseline
        plot(ppm,MM_mean+baseline_mean- max(maxshift)*0.5*c-max(maxshift)*0.6 ,'color', fit_color, 'LineWidth', 0.75); %MM Baseline
        plot(ppm,data_mean - max(maxshift)*0.5*c-max(maxshift)*0.6 ,'color',cb(c,:), 'LineWidth', 0.5); % Data 

        plot(ppm,tNAA_mean -max(maxshift)*1.5-max(maxshift)*0.6-max(maxshift)*0.7  ,'color',cb(c,:), 'LineWidth', 0.5); % Model tNAA
        plot(ppm,tCho_mean -max(maxshift)*1.5-max(maxshift)*0.6-max(maxshift)*1  ,'color',cb(c,:), 'LineWidth', 0.5); % Model tCho 
        plot(ppm,Ins_mean -max(maxshift)*1.5-max(maxshift)*0.6-max(maxshift)*1.18  ,'color',cb(c,:), 'LineWidth', 0.5); % Model Ins 
        plot(ppm,Glx_mean -max(maxshift)*1.5-max(maxshift)*0.6-max(maxshift)*1.38  ,'color',cb(c,:), 'LineWidth', 0.5); % Model Glx 
        plot(ppm,fit_mean- max(maxshift)*0.5*c-max(maxshift)*0.6,'color', fit_color, 'LineWidth', 0.75); %Fit
        plot(ppm,residual_mean -max(maxshift)*(0.05*(c-1)) ,'color', cb(c,:), 'LineWidth', 0.5);  %Residual
    end


    [out] = design_finetuning(out,MRSCont);
     set(out,'Name',['Grand mean +- SD stack ' Tools{t}]);
    figures{t+3} = out;
end
%% Site mean stack plot with spectra, fit, residual, baseline and MM + baseline specified by name
count = 1;
for t = 1 : 3 %Loop over tools
    for c = 1 : 3 %Loop over container
        eval(['MRSCont = MRSCont', num2str(c)]);
        out = figure;
        hold on

        for g = 1 : (length(fields(MRSCont.(Tools{t}).sort_fit))-1) %Initalize the plot variables
            shift = max(maxshift) * (g-1);
            fit = 'off';
            fit_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_' fit '_' which]);
            data_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_data_' fit '_' which]);
            baseline_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_baseline_' fit '_' which]);
            residual_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_res_' fit '_' which]);
            ppm = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['ppm_fit_' fit '_' which]);
            if MRSCont.opts.fit.fitMM
            MM_mean = MRSCont.(Tools{t}).sort_fit.(['g_' num2str(g)]).(['mean_fittMM_' fit '_' which]);
            end

            plot(ppm,baseline_mean-shift- max(maxshift) ,'color', cb(c,:), 'LineWidth', 0.5); %Baseline
            plot(ppm,MM_mean+baseline_mean-shift- max(maxshift) ,'color', cb(c,:), 'LineWidth', 0.5); %MM Baseline
            plot(ppm,data_mean-shift -max(maxshift) ,'color',cb(c,:), 'LineWidth', 0.5); % Data 
            plot(ppm,fit_mean-shift- max(maxshift),'color', MRSCont.colormap.Accent, 'LineWidth', 0.5); %Fit
            plot(ppm,residual_mean-shift - max(maxshift)*0.1 ,'color', cb(c,:), 'LineWidth', 0.5);  %Residual
        end

        [out] = design_finetuning(out,MRSCont);
        set(out,'Name',['Site mean stack ' Vendor{c} ' ' Tools{t}]);
        figures{(count+6)} = out;
        count = count + 1;
    end
end

%% Grand mean overview plot with spectra, fit, residual, baseline and MM + baseline and models for all Tools and Vendors

for c = 1 : 3 %Loop over container
    eval(['MRSCont = MRSCont', num2str(c)]);
    out = figure;
    hold on

    for t = 1 : 3 %Loop over tools

        if strcmp(Tools{t},'overview')
            cb2 = cbrewer('qual', 'Paired', 8, 'pchip');
            fit_color = cb2(2,:);
        end
        if strcmp(Tools{t},'Tarquin')
            cb2 = cbrewer('qual', 'Paired', 8, 'pchip');
            fit_color = cb2(4,:);
        end
        if strcmp(Tools{t},'LCModel')
            cb2 = cbrewer('qual', 'Paired', 8, 'pchip');
            fit_color = cb2(6,:);
        end

        %Normalize grand mean spectra to creatine and initalize the plot variables
        fit = 'off';
        data_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_data_' fit '_' which]);
        Cr_height = max(data_mean(MRSCont.(Tools{t}).sort_fit.GMean.ppm_fit_off_A>2.9 & MRSCont.(Tools{t}).sort_fit.GMean.ppm_fit_off_A<3.1));
        fit_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_' fit '_' which])/Cr_height;
        data_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_data_' fit '_' which])/Cr_height;
        baseline_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_baseline_' fit '_' which])/Cr_height;
        residual_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_res_' fit '_' which])/Cr_height;
        ppm = MRSCont.(Tools{t}).sort_fit.GMean.(['ppm_fit_' fit '_' which]);
        if MRSCont.opts.fit.fitMM
        tNAA_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fittNAA_' fit '_' which])/Cr_height;
        tCho_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fittCho_' fit '_' which])/Cr_height;
        Glx_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fitGlx_' fit '_' which])/Cr_height;
        Ins_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fitIns_' fit '_' which])/Cr_height;
        tCr_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fittCr_' fit '_' which])/Cr_height;
        tCr_sd = MRSCont.(Tools{t}).sort_fit.GMean.(['sd_fittCr_' fit '_' which])/Cr_height;
        end

        %Plot data
        plot(ppm,baseline_mean- max(maxshift)*0.9 ,'color', fit_color, 'LineWidth', 0.5); %Baseline
        plot(ppm,data_mean -max(maxshift)*0.9 ,'color',fit_color, 'LineWidth', 0.5); % Data 
        plot(ppm,fit_mean- max(maxshift)*0.9,'color', fit_color, 'LineWidth', 0.75); %Fit
        plot(ppm,residual_mean ,'color', fit_color, 'LineWidth', 0.5);  %Residual
        %Plot models
        plot(ppm,tNAA_mean -max(maxshift)*0.9-max(maxshift)*0.7  ,'color',fit_color, 'LineWidth', 0.75); % Model tNAA
        plot(ppm,tCho_mean -max(maxshift)*0.9-max(maxshift)*1  ,'color',fit_color, 'LineWidth', 0.75); % Model tCho 
        plot(ppm,Ins_mean -max(maxshift)*0.9-max(maxshift)*1.18  ,'color',fit_color, 'LineWidth', 0.75); % Model Ins 
        plot(ppm,Glx_mean -max(maxshift)*0.9-max(maxshift)*1.38  ,'color',fit_color, 'LineWidth', 0.75); % Model Glx 
        plot(ppm,tCr_mean -max(maxshift)*0.9-max(maxshift)*1.68  ,'color',fit_color, 'LineWidth', 0.75); % Model tCr 
    end


    [out] = design_finetuning(out,MRSCont);
    set(out,'Name',['Grand mean stack ' Vendor{c} ' ' Tools{t}]);
    figures{(c+15)} = out;
end

%% Grand mean stack plot with spectra + SD, fit, residual, baseline and MM + baseline and all models for all Tools and Vendors


for c = 1 : 3 %Loop over container
    eval(['MRSCont = MRSCont', num2str(c)]);
    out = figure;
    hold on

    for t = 1 : 3 %Loop over tools

        if strcmp(Tools{t},'overview')
            cb2 = cbrewer('qual', 'Paired', 8, 'pchip');
            fit_color = cb2(2,:);
        end
        if strcmp(Tools{t},'Tarquin')
            cb2 = cbrewer('qual', 'Paired', 8, 'pchip');
            fit_color = cb2(4,:);
        end
        if strcmp(Tools{t},'LCModel')
            cb2 = cbrewer('qual', 'Paired', 8, 'pchip');
            fit_color = cb2(6,:);
        end
        %Normalize grand mean spectra to creatine and initalize the plot variables

        fit = 'off';
        data_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_data_' fit '_' which]);
        Cr_height = max(data_mean(MRSCont.(Tools{t}).sort_fit.GMean.ppm_fit_off_A>2.9 & MRSCont.(Tools{t}).sort_fit.GMean.ppm_fit_off_A<3.1));
        fit_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_' fit '_' which])/Cr_height;
        data_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_data_' fit '_' which])/Cr_height;
        baseline_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_baseline_' fit '_' which])/Cr_height;
        residual_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_res_' fit '_' which])/Cr_height;
        ppm = MRSCont.(Tools{t}).sort_fit.GMean.(['ppm_fit_' fit '_' which]);
        modelNames = fields(MRSCont.(Tools{t}).sort_fit.GMean);
        if strcmp(Tools{t},'LCModel') || strcmp(Tools{t},'Tarquin')
            start = 10;
        else
            start = 11;
        end
        for n = start : length(fields(MRSCont.(Tools{t}).sort_fit.GMean))                
            MRSCont.(Tools{t}).sort_fit.GMean.(modelNames{n})  = MRSCont.(Tools{t}).sort_fit.GMean.(modelNames{n})/Cr_height;
        end
        %Plot data here
        plot(ppm,baseline_mean- max(maxshift)*0.9 ,'color', fit_color, 'LineWidth', 0.5); %Baseline
        plot(ppm,data_mean -max(maxshift)*0.9 ,'color',fit_color, 'LineWidth', 0.5); % Data 
        plot(ppm,fit_mean- max(maxshift)*0.9,'color', fit_color, 'LineWidth', 0.75); %Fit
        plot(ppm,residual_mean ,'color', fit_color, 'LineWidth', 0.5);  %Residual
        % Set up names of the struct
        dataModelNames = {'fitAsc','fitAsp','fitGABA',...
                       'fitGSH','fitGln','fitGlu',...
                       'fitNAA','fitNAAG',...
                       'fitCr','fitPCr','fitCrCH2','fitPCh','fitGPC',...
                       'fitIns','fitLac','fitPE','fitScyllo',...
                       'fitTau','fitMM09','fitMM12','fitMM14',...
                       'fitMM17','fitMM20','fitMM09','fitLip09',...
                       'fitLip13','fitLip20'};

        modelNames = {'mean_fitAsc_off_A','mean_fitAsp_off_A','mean_fitGABA_off_A',...
                       'mean_fitGSH_off_A','mean_fitGln_off_A','mean_fitGlu_off_A',...
                       'mean_fitNAA_off_A','mean_fitNAAG_off_A',...
                       'mean_fitCr_off_A','mean_fitPCr_off_A','mean_fitCrCH2_off_A','mean_fitPCh_off_A','mean_fitGPC_off_A',...
                       'mean_fitIns_off_A','mean_fitLac_off_A','mean_fitPE_off_A','mean_fitScyllo_off_A',...
                       'mean_fitTau_off_A','mean_fitMM09_off_A','mean_fitMM12_off_A','mean_fitMM14_off_A',...
                       'mean_fitMM17_off_A','mean_fitMM20_off_A','mean_fitMM09_off_A','mean_fitLip09_off_A',...
                       'mean_fitLip13_off_A','mean_fitLip20_off_A'};

        printNames = {'Asc','Asp','GABA','GSH','Gln','Glu','NAA','NAAG',...
                       'Cr','PCr','-CrCH2','PCh','GPC','Ins','Lac','PE','Scyllo',...
                       'Tau','MM09','MM12','MM14','MM17','MM20','MM09','Lip09',...
                       'Lip13','Lip20'};
        %Find zero models   
        for n = 1 : length(dataModelNames)
                nonZero = 0;
                for kk = 1 : length(MRSCont.(Tools{t}).sort_fit.GMean.off_A)
                    if isfield(MRSCont.(Tools{t}).sort_fit.GMean.off_A{1,kk},dataModelNames{n})
                        if abs(sum(MRSCont.(Tools{t}).sort_fit.GMean.off_A{1,kk}.(dataModelNames{n}))) > 0
                            nonZero = nonZero + 1;
                        end
                    end
                end
                MRSCont.(Tools{t}).sort_fit.succQuant.(modelNames{n}) = length(MRSCont.(Tools{t}).sort_fit.GMean.off_A) - nonZero;
        end                 
        stack = 1;
        % Add number of zero quantifications
        for n = 1 : length(modelNames)
                plot(ppm,MRSCont.(Tools{t}).sort_fit.GMean.(modelNames{n})  -max(maxshift)*1-max(maxshift)*0.075*stack  ,'color',fit_color, 'LineWidth', 0.75);
                if strcmp(printNames{n}(1), 'M') || strcmp(printNames{n}(1:2), 'Li')
                    if strcmp(Tools{t},'overview')
                        text(ppm(end)-0.2*(t-1)-0.12,  -max(maxshift)*1-max(maxshift)*0.075*stack+max(maxshift)*0.03, num2str(MRSCont.(Tools{t}).sort_fit.succQuant.(modelNames{n})), 'FontSize', 8,'Color',fit_color, 'HorizontalAlignment','right');
                    else
                       text(4-0.2*(t-1)-0.12,  -max(maxshift)*1-max(maxshift)*0.075*stack+max(maxshift)*0.03, num2str(MRSCont.(Tools{t}).sort_fit.succQuant.(modelNames{n})), 'FontSize', 8,'Color',fit_color, 'HorizontalAlignment','right'); 
                    end            
                else
                    if strcmp(Tools{t},'overview')
                        text(ppm(1)+0.2*(3-t),  -max(maxshift)*1-max(maxshift)*0.075*stack+max(maxshift)*0.03, num2str(MRSCont.(Tools{t}).sort_fit.succQuant.(modelNames{n})), 'FontSize', 8,'Color',fit_color, 'HorizontalAlignment','right');
                    else
                       text(0.5+0.2*(3-t),  -max(maxshift)*1-max(maxshift)*0.075*stack+max(maxshift)*0.03, num2str(MRSCont.(Tools{t}).sort_fit.succQuant.(modelNames{n})), 'FontSize', 8,'Color',fit_color, 'HorizontalAlignment','right'); 
                    end
                end

                if strcmp(Tools{t},'overview')
                    text(ppm(1)-0.05,  -max(maxshift)*1-max(maxshift)*0.075*stack, printNames{n}, 'FontSize', 9,'Color','k');
                end
                stack = stack + 1;
        end

    end

[out] = design_finetuning(out,MRSCont);
    set(out,'Name',['Grand mean stack ' Vendor{c}]);
figures{(c+18)} = out;
end
%% Grand mean plot Cr models + SD for all Tools and Vendors

for c = 1 : 3 %Loop over container
    eval(['MRSCont = MRSCont', num2str(c)]);
    out = figure;
    hold on

    for t = 1 : 3 %Loop over tools

        if strcmp(Tools{t},'overview')
            cb2 = cbrewer('qual', 'Paired', 8, 'pchip');
            fit_color = cb2(2,:);
        end
        if strcmp(Tools{t},'Tarquin')
            cb2 = cbrewer('qual', 'Paired', 8, 'pchip');
            fit_color = cb2(4,:);
        end
        if strcmp(Tools{t},'LCModel')
            cb2 = cbrewer('qual', 'Paired', 8, 'pchip');
            fit_color = cb2(6,:);
        end

        %Normalize grand mean models to NAA and initalize the plot variables
        fit = 'off';
        data_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_data_' fit '_' which]);
        NAA_height = max(data_mean(MRSCont.(Tools{t}).sort_fit.GMean.ppm_fit_off_A>1.9 & MRSCont.(Tools{t}).sort_fit.GMean.ppm_fit_off_A<2.1));
        ppm = MRSCont.(Tools{t}).sort_fit.GMean.(['ppm_fit_' fit '_' which]);
        tCr_mean = MRSCont.(Tools{t}).sort_fit.GMean.(['mean_fittCr_' fit '_' which])/NAA_height;
        tCr_sd = MRSCont.(Tools{t}).sort_fit.GMean.(['sd_fittCr_' fit '_' which])/NAA_height;


        %Calculate SD shadows
        tCr_yu = tCr_mean + tCr_sd;
        tCr_yl = tCr_mean - tCr_sd;

        try
            fill([ppm fliplr(ppm)], [tCr_yu-max(maxshift)*0.5*(t-1) fliplr(tCr_yl)-max(maxshift)*0.5*(t-1)], fit_color,'FaceAlpha',0.15, 'linestyle', 'none'); %SD Shadow data
        catch
            fill([ppm' fliplr(ppm')], [tCr_yu-max(maxshift)*0.5*(t-1) fliplr(tCr_yl)-max(maxshift)*0.5*(t-1)], fit_color,'FaceAlpha',0.15, 'linestyle', 'none'); %SD Shadow data
        end
        plot(ppm,tCr_mean-max(maxshift)*0.5*(t-1)  ,'color',fit_color, 'LineWidth', 0.75); % Model tCr 

    end

    [out] = design_finetuning(out,MRSCont);
    set(out,'Name',['Cr model grand mean stack ' Vendor{c}]);
    figures{(c+21)} = out;
end

end
function [out] = design_finetuning(out,MRSCont)
    %%% DESIGN FINETUNING %%%
    % Adapt common style for all axes
    ppmRange = MRSCont.opts.fit.range;
    set(gca, 'XDir', 'reverse', 'XLim', [ppmRange(1), ppmRange(end)]);
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
   