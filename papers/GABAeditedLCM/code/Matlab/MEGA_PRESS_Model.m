%% MATLAB analysis for 'Comparison of linear-combination modeling strategies for GABA-edited MRS at 3T'
%   This script runs all LCM analysis for the differnt modelings
%   strategies. It varies between all MM3co models, fit ranges, baseline
%   knot spcaings, and basis set combinations.
%
%   6 MM3co models (GABAhard, GABAsoft, Gaussfree, Gaussfixed, MM09hard,
%   MM09soft) with different degrees of freedom are tested. Additionllay,
%   the conventional approach of not modeling the co-edited MM is tested
%
%   3 fit ranges are tested:
%    - 0.5 to 4 pppm standard wide fit range (typically used for shortTE)
%    - 1.85 to 4.1 ppm intermediate range described to be the best approach
%    for GABA-edited MRS in LCModel manual
%   - 2.79 to 4.2 ppm narrow fit range also used in Gannet
%
%   3 spline knot spacings are tested:
%   - sparser (0.55 ppm), Osprey default (0.4 ppm), denser (0.25 ppm)
%
%   - inclusion of homocarnosine in the basis set is tested
%
%
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2019-10-02)
%       hzoelln2@jhmi.edu
%
%   HISTORY:
%       2021-01-07: First version of the code.
%% Change the path here
% Loads a dummy container were the processing is finshed and backs it up
% for the looping process
cont_file = '/Volumes/Samsung/working/ISMRM/Philips/full04/jobPhilipsMP.mat';
load(cont_file); 
MRSCont_backup = MRSCont;
vendor = 'Philips';

% Set up differnt model names
coMM3models = {'none','1to1GABAsoft','1to1GABA','freeGauss14','freeGauss','3to2MMsoft','3to2MM'};
% Set up output name for HCar included analysis
includeMetabs = {'','Comb'};
% Set up fit ranges and the output names
range = {[0.5, 4], [1.85, 4.1], [2.79, 4.2]};
names = {'full','inter','red'};
% Set up knot spacing
knotSpace = [0.25 0.4 0.55];

%% Loop over all strategies
%Here begins the loop over all strategies
for iM = 1 : 1 
    for kS = 1 : 3
        for r = 1 : 2     
            for m = 1 : length(coMM3models)
                if r > 1
                    if m  < 6
                        if ~exist(['/Volumes/Samsung/working/ISMRM/' vendor '/' names{r} includeMetabs{iM} strrep(num2str(knotSpace(kS)),'.','') '/derivatives' coMM3models{m} '/'])
                           MRSCont = MRSCont_backup;
                            MRSCont.flags.isMRSI = 0;
                            MRSCont.flags.isPRIAM = 0;
                            MRSCont.flags.didFit = 0;
%                             MRSCont.opts.fit = rmfield(MRSCont.opts.fit,'basisSetFile');
                            MRSCont.flags.didQuantify = 0;
                            MRSCont.flags.didOverview = 0;
                            MRSCont.flags.speedUp = 0;
                            MRSCont.file_stat = ['/Volumes/Samsung/working/ISMRM/' vendor '/statMPred.csv'];

                            if iM == 1
                                MRSCont.opts.fit.includeMetabs      = {'Asc', 'Asp', 'Cr', 'CrCH2', 'GABA', 'GPC', 'GSH', 'Gln',...
                                               'Glu', 'H2O', 'Ins', 'Lac', 'NAA', 'NAAG', 'PCh', 'PCr', 'PE', 'Scyllo',... 
                                               'Tau', 'MM09', 'MM12', 'MM14', 'MM17', 'MM20', 'Lip09', 'Lip13', 'Lip20'}; 
                            else
                                MRSCont.opts.fit.includeMetabs      = {'Asc', 'Asp', 'Cr', 'CrCH2', 'GABA', 'GPC', 'GSH', 'Gln',...
                                               'Glu', 'HCar', 'H2O', 'Ins', 'Lac', 'NAA', 'NAAG', 'PCh', 'PCr', 'PE', 'Scyllo',... 
                                               'Tau', 'MM09', 'MM12', 'MM14', 'MM17', 'MM20', 'Lip09', 'Lip13', 'Lip20'}; 
                            end
                            MRSCont.opts.fit.coMM3 = coMM3models{m};
                            MRSCont.opts.fit.range = range{r};
                            MRSCont.opts.fit.bLineKnotSpace     = knotSpace(kS);
                            MRSCont.outputFolder = ['/Volumes/Samsung/working/ISMRM/' vendor '/' names{r} includeMetabs{iM} strrep(num2str(knotSpace(kS)),'.','') '/derivatives' coMM3models{m} '/'];
 
                            mkdir(MRSCont.outputFolder)
                            MRSCont = OspreyFit(MRSCont);
                            MRSCont = OspreyQuantify(MRSCont);
                            MRSCont = OspreyOverview(MRSCont);
                        end
                    end
                else
                    if ~exist(['/Volumes/Samsung/working/ISMRM/' vendor '/' names{r} includeMetabs{iM} strrep(num2str(knotSpace(kS)),'.','') '/derivatives' coMM3models{m} '/'])
                        MRSCont = MRSCont_backup;
                        MRSCont.flags.isMRSI = 0;
                        MRSCont.flags.isPRIAM = 0;
                        MRSCont.flags.didFit = 0;
%                         MRSCont.opts.fit = rmfield(MRSCont.opts.fit,'basisSetFile');
                        MRSCont.flags.didQuantify = 0;
                        MRSCont.flags.didOverview = 0;
                        MRSCont.flags.speedUp = 0;
                        MRSCont.file_stat = ['/Volumes/Samsung/working/ISMRM/' vendor '/statMPred.csv'];

                        if iM == 1
                            MRSCont.opts.fit.includeMetabs      = {'Asc', 'Asp', 'Cr', 'CrCH2', 'GABA', 'GPC', 'GSH', 'Gln',...
                                               'Glu', 'H2O', 'Ins', 'Lac', 'NAA', 'NAAG', 'PCh', 'PCr', 'PE', 'Scyllo',... 
                                               'Tau', 'MM09', 'MM12', 'MM14', 'MM17', 'MM20', 'Lip09', 'Lip13', 'Lip20'}; 
                        else
                            MRSCont.opts.fit.includeMetabs      = {'Asc', 'Asp', 'Cr', 'CrCH2', 'GABA', 'GPC', 'GSH', 'Gln',...
                                           'Glu', 'HCar', 'H2O', 'Ins', 'Lac', 'NAA', 'NAAG', 'PCh', 'PCr', 'PE', 'Scyllo',... 
                                           'Tau', 'MM09', 'MM12', 'MM14', 'MM17', 'MM20', 'Lip09', 'Lip13', 'Lip20'}; 
                        end
                        MRSCont.opts.fit.coMM3 = coMM3models{m};
                        MRSCont.opts.fit.range = range{r};
                        MRSCont.opts.fit.bLineKnotSpace    = knotSpace(kS);
                        MRSCont.outputFolder = ['/Volumes/Samsung/working/ISMRM/' vendor '/' names{r} includeMetabs{iM} strrep(num2str(knotSpace(kS)),'.','') '/derivatives' coMM3models{m} '/'];
                    
                        mkdir(MRSCont.outputFolder)
                        MRSCont = OspreyFit(MRSCont);
                        MRSCont = OspreyQuantify(MRSCont);
                        MRSCont = OspreyOverview(MRSCont);
                    end

                end

            end

        end
    end
end