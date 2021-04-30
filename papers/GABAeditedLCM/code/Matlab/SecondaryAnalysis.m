%% MATLAB analysis for 'Comparison of linear-combination modeling strategies for GABA-edited MRS at 3T'
%   This script performs the analysis for the different modeling strategies
%   for GABA-edited data with LCM. The data was analyzed with Osprey. The
%   script is devided into parts 5 parts.
%
%   1. Call analysis
%   2. Do secondary analysis (plots, residuals, and individual AICs)
%   3. Calculate mean AICs
%   4. Calculate mean deltaAICs and weights
%   5. Export results
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2019-10-02)
%       hzoelln2@jhmi.edu
%
%   HISTORY:
%       2021-01-07: First version of the code.

%% 1. Here the function for the main analysis is called
% This script runs the LCM for all different modeling strategies

MEGA_PRESS_Model;
%% 2. Do secondary calculations
% Here each Osprey container is loaded and the secondary analysis scripts
% are called. This includes the calculations of the normalized residuals
% for the whole fit range and the 3-ppm GABA peak. Next the AICs are
% calcualted and the Grand Mean spectra are plotted.


range = {'full','inter','red'};
comb = {'','Comb'};
kSp = {'055','04','025'};
for r = 1 : length(range)
    for cb = 1 :  length(comb)
        for  sp = 1 : length(kSp)
            if strcmp(range{r},'full')
                contList = {['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivativesnone/jobPhilipsMP.mat'],...
                    ['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivatives1to1GABA/jobPhilipsMP.mat'],...
                    ['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivatives1to1GABAsoft/jobPhilipsMP.mat'],...
                    ['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivatives3to2MM/jobPhilipsMP.mat'],...
                    ['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivatives3to2MMsoft/jobPhilipsMP.mat'],...
                    ['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivativesfreeGauss14/jobPhilipsMP.mat'],...
                    ['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivativesfreeGauss/jobPhilipsMP.mat']};
                 nameList = {'NoMM','fixedGABA','softGABA','fixedMM','softMM','fixedGauss','freeGauss'};
            else
                contList = {['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivativesnone/jobPhilipsMP.mat'],...
                    ['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivatives1to1GABA/jobPhilipsMP.mat'],...
                    ['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivatives1to1GABAsoft/jobPhilipsMP.mat'],...
                    ['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivativesfreeGauss14/jobPhilipsMP.mat'],...
                    ['/Volumes/Samsung/working/ISMRM/Philips/' range{r} comb{cb} kSp{sp} '/derivativesfreeGauss/jobPhilipsMP.mat']};
                nameList = {'NoMM','fixedGABA','softGABA','fixedGauss','freeGauss'};  
            end
            for cont= 1 : length(contList)
                load(contList{cont});
                extract_GABAtoCrArea_Big_GABA(MRSCont,comb{cb}); %Calculate the residuals
                out.([nameList{cont} range{r} comb{cb} kSp{sp}]) = calc_Model_Scores(MRSCont); % Calculate AICs
            end          
            figures = plot_MPRESS(contList, nameList,range{r}, comb{cb}, kSp{sp}); % Create plots
            close all
        end
    end
end
%% 3. Calculate mean AIC values
% Here the mean AICs are calculated for further analysis.

which_meas = 4; % This refers to SSE AIC calculations
mean_values = [];
name = cell(1);
range = {'full','inter','red'};
comb = {''};
kSp = {'055','04','025'};
for r = 1 : length(range)
    for cb = 1 :  length(comb)
        for  sp = 1 : length(kSp)
            if strcmp(range{r},'full')                
                         mean_values = horzcat(mean_values ,  out.(['NoMM' range{r} comb{cb} kSp{sp}]).means(which_meas),... 
                        out.(['fixedGABA' range{r} comb{cb} kSp{sp}]).means(which_meas),... 
                        out.(['softGABA' range{r} comb{cb} kSp{sp}]).means(which_meas),... 
                        out.(['fixedGauss' range{r} comb{cb} kSp{sp}]).means(which_meas),... 
                        out.(['freeGauss' range{r} comb{cb} kSp{sp}]).means(which_meas),... 
                        out.(['fixedMM' range{r} comb{cb} kSp{sp}]).means(which_meas),... 
                        out.(['softMM' range{r} comb{cb} kSp{sp}]).means(which_meas));
                    name{end+1} = ['NoMM' range{r} comb{cb} kSp{sp}];
                    name{end+1} = ['fixedGABA' range{r} comb{cb} kSp{sp}];
                    name{end+1} = ['softGABA' range{r} comb{cb} kSp{sp}];
                    name{end+1} = ['fixedGauss' range{r} comb{cb} kSp{sp}];
                    name{end+1} = ['freeGauss' range{r} comb{cb} kSp{sp}];
                    name{end+1} = ['fixedMM' range{r} comb{cb} kSp{sp}];
                    name{end+1} = ['softMM' range{r} comb{cb} kSp{sp}];
            else
                mean_values = horzcat(mean_values ,  out.(['NoMM' range{r} comb{cb} kSp{sp}]).means(which_meas),... 
                        out.(['fixedGABA' range{r} comb{cb} kSp{sp}]).means(which_meas),... 
                        out.(['softGABA' range{r} comb{cb} kSp{sp}]).means(which_meas),... 
                        out.(['fixedGauss' range{r} comb{cb} kSp{sp}]).means(which_meas),... 
                        out.(['freeGauss' range{r} comb{cb} kSp{sp}]).means(which_meas));
                    name{end+1} = ['NoMM' range{r} comb{cb} kSp{sp}];
                    name{end+1} = ['fixedGABA' range{r} comb{cb} kSp{sp}];
                    name{end+1} = ['softGABA' range{r} comb{cb} kSp{sp}];
                    name{end+1} = ['fixedGauss' range{r} comb{cb} kSp{sp}];
                    name{end+1} = ['freeGauss' range{r} comb{cb} kSp{sp}];
            end

        end
    end
end
name(1) =[];
%% 4. Calcualte deltaAICs
% Here the minimal AIC is found. Subsequently, the delat AICs and Akaike
% weights are calculated

[min_val, ind] = min(mean_values);

delta_values = mean_values-min_val;

exp_values = exp(-0.5 .* delta_values);

exp_sum = sum(exp_values);

weight_values = exp_values./exp_sum;

%% 5. Create csv output for AICs
% delta AICs are exported for each model here
s = [1,8,15,22,27,32,37,42,47];
e = [7,14,21,26,31,36,41,46,51];
spline = {'055','04','025','055','04','025','055','04','025'};
range = {'full','full','full','inter','inter','inter','red','red','red'};
comb = '';
for ll = 1 : length(s)
    matrix = horzcat(delta_values(s(ll):e(ll))');
end
IntTab = array2table(matrix,'VariableNames',{'dAIC_ll'});
writetable(IntTab,['/Volumes/Samsung/working/ISMRM/Philips/' range{ll} comb spline{ll}   '/dICsq.csv']);