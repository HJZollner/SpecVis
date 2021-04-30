function extract_GABAtoCrArea_Big_GABA(MRSCont,comb)
%% extract_GABAtoCrArea_Big_GABA(MRSCont1)
%   Creates csv files with the residuals accross the whole fit range and
%   the 3-ppm range.
%
%   USAGE:
%       extract_GABAtoCrArea_Big_GABA(MRSCont1)
%
%   OUTPUTS:
%       generates .csv files with GABAtoCrAreas
%
%   OUTPUTS:
%       MRSCont1-3  = Osprey data container (e.g. GE, Philips, Siemens).
%       comb    = String for the analysis with HCar string type 'Comb'
%                   OPTIONS:    '', 'Comb' 
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2019-10-02)
%       hzoelln2@jhmi.edu
%
%   HISTORY:
%       2020-01-07: First version of the code.
    
%%
FitNames = fieldnames(MRSCont.fit.results);
NoFit = length(fieldnames(MRSCont.fit.results));
dataPlotNames = FitNames;
shift = 0;
for sf = 1 : NoFit
    switch MRSCont.opts.fit.method
        case 'Osprey'
            switch FitNames{sf}
                case 'off'
                    dataPlotNames{sf} = 'A';
                case 'conc'
                    if MRSCont.flags.isMEGA
                        dataPlotNames{sf} = 'diff1';
                        dataPlotNames{sf+1} = 'sum';
                        tempFitNames{sf} = 'conc';
                        tempFitNames{sf+1} = 'conc';
                        shift = 1;
                    end
                    if (MRSCont.flags.isHERMES || MRSCont.flags.isHERCULES)
                        dataPlotNames{sf} = 'diff1';
                        dataPlotNames{sf+1} = 'diff2';
                        dataPlotNames{sf+2} = 'sum';
                        tempFitNames{sf} = 'conc';
                        tempFitNames{sf+1} = 'conc';
                        tempFitNames{sf+2} = 'conc';
                        shift = 2;
                    end
                otherwise
                    dataPlotNames{sf + shift} = FitNames{sf};
                    tempFitNames{sf + shift} = FitNames{sf};
            end
        case 'LCModel'
            switch FitNames{sf}
                case 'off'
                    dataPlotNames{sf} = 'A';
                otherwise
                    dataPlotNames{sf} = FitNames{sf};
            end
    end
end
for sf = 1 : NoFit %Loop over all fits
    if ~strcmp(FitNames{sf},'ref') && ~strcmp(FitNames{sf},'w')
        for kk = 1 : MRSCont.nDatasets % Loop over datasets
            fitRangePPM = MRSCont.opts.fit.range;
            basisSet    = MRSCont.fit.resBasisSet.(FitNames{sf}){kk};
            dataToPlot  = MRSCont.processed.(dataPlotNames{sf}){kk};
            % Get the fit parameters
            fitParams   = MRSCont.fit.results.(FitNames{sf}).fitParams{kk};
            % Pack up into structs to feed into the reconstruction functions
            inputData.dataToFit                 = dataToPlot;
            inputData.basisSet                  = basisSet;
            inputSettings.scale                 = MRSCont.fit.scale{kk};
            inputSettings.fitRangePPM           = fitRangePPM;
            inputSettings.minKnotSpacingPPM     = MRSCont.opts.fit.bLineKnotSpace;
            inputSettings.fitStyle              = MRSCont.opts.fit.style;
            inputSettings.flags.isMEGA          = MRSCont.flags.isMEGA;
            inputSettings.flags.isHERMES        = MRSCont.flags.isHERMES;
            inputSettings.flags.isHERCULES      = MRSCont.flags.isHERCULES;
            inputSettings.flags.isPRIAM         = MRSCont.flags.isPRIAM;
            inputSettings.concatenated.Subspec  = dataPlotNames{sf};
            if strcmp(inputSettings.fitStyle,'Concatenated')
                [ModelOutput] = fit_OspreyParamsToConcModel(inputData, inputSettings, fitParams);
            else
                [ModelOutput] = fit_OspreyParamsToModel(inputData, inputSettings, fitParams);
            end

            if strcmp(FitNames{sf},'off') || strcmp(FitNames{sf},'conc')
                idx_Cr  = find(strcmp(basisSet.name,'Cr'));
                idx_PCr  = find(strcmp(basisSet.name,'PCr'));
                Cr_model = 0;
                if ~isempty(idx_Cr) && ~isempty(idx_PCr)
                    Cr_model  = ModelOutput.indivMets(:,idx_Cr) + ModelOutput.indivMets(:,idx_PCr);
                else if ~isempty(idx_1)
                     Cr_model  = ModelOutput.indivMets(:,idx_Cr);
                    else if ~isempty(idx_2)
                        Cr_model  = ModelOutput.indivMets(:,idx_PCr);
                        end
                    end
                end
%                 Cr_model = Cr_model + ModelOutput.baseline;
                ppm = ModelOutput.ppm(1,:);
                ppmmin = 3.027 - 0.15;
                ppmmax = 3.027 + 0.15;
                CrPeak = Cr_model(ppm>ppmmin & ppm<ppmmax, 1); 
                output.CrArea(kk) = sum(CrPeak);
            end
            
             if strcmp(FitNames{sf},'diff1') || strcmp(FitNames{sf},'conc')
                idx_GABA  = find(strcmp(basisSet.name,'GABA'));
                idx_HCar  = find(strcmp(basisSet.name,'HCar'));
                idx_MM3co  = find(strcmp(basisSet.name,'MM3co'));
%                 idx_GSH  = find(strcmp(basisSet.name,'GSH'));
                if strcmp(MRSCont.opts.fit.coMM3, '3to2MM')
                   idx_MM09  = find(strcmp(basisSet.name,'MM09')); 
                else
                    idx_MM09 = [];
                end
                
                GABA_model = 0;
                pureGABA_model = 0;
                GABA_ampl = 0;
                if ~isempty(idx_GABA)
                    GABA_model  = GABA_model + ModelOutput.indivMets(:,idx_GABA);
                    GABA_ampl = GABA_ampl + fitParams.ampl(idx_GABA);
                end
                if ~isempty(idx_GABA)
                    pureGABA_model  = pureGABA_model + ModelOutput.indivMets(:,idx_GABA);
                end
                if ~isempty(idx_HCar)
                    GABA_model  = GABA_model + ModelOutput.indivMets(:,idx_HCar);
                    GABA_ampl = GABA_ampl + fitParams.ampl(idx_HCar);
                end
                if ~isempty(idx_MM3co)
                    GABA_model  = GABA_model + ModelOutput.indivMets(:,idx_MM3co);
                    GABA_ampl = GABA_ampl + fitParams.ampl(idx_MM3co);
                end
                if ~isempty(idx_MM09)
                    GABA_model  = GABA_model + ModelOutput.indivMets(:,idx_MM09);
                    GABA_ampl = GABA_ampl + fitParams.ampl(idx_MM09);
                end
%                 if ~isempty(idx_GSH)
%                     GABA_model  = GABA_model + ModelOutput.indivMets(:,idx_GSH);
%                     GABA_ampl = GABA_ampl + fitParams.ampl(idx_GSH);
%                 end
%                 GABA_model = GABA_model + ModelOutput.baseline;
                

                noisewindow=dataToPlot.specs(dataToPlot.ppm>-2 & dataToPlot.ppm<0)./MRSCont.fit.scale{kk};
                ppmwindow2=dataToPlot.ppm(dataToPlot.ppm>-2 & dataToPlot.ppm<0)';

                P=polyfit(ppmwindow2,noisewindow,2);
                noise=noisewindow-polyval(P,ppmwindow2); 

                range = [max(ModelOutput.residual) min(ModelOutput.residual)];
                output.RangeResRelAmpl(kk) = (range(1)-range(2))/std(real(noise));
                output.RangeResSD(kk) = std(real(ModelOutput.residual))/std(real(noise));

                ppm = ModelOutput.ppm(1,:);
                ppmmin = 3.027 - 0.15;
                ppmmax = 3.027 + 0.15;
                GABAPeak = GABA_model(ppm>ppmmin & ppm<ppmmax, 1); 
                pureGABAPeak = pureGABA_model(ppm>ppmmin & ppm<ppmmax, 1); 
                GABARes = ModelOutput.residual(ppm>ppmmin & ppm<ppmmax, 1);
                output.GABAArea(kk) = sum(GABAPeak);
                output.GABAFitEr(kk) = 100*std(GABARes)/max(GABAPeak);
                output.GABAtoCr(kk) = output.GABAArea(kk)/output.CrArea(kk);
                output.pureGABAArea(kk) = sum(pureGABAPeak);
                output.pureGABAtoCr(kk) = sum(pureGABAPeak)/output.CrArea(kk);
                GABArange = [max(GABARes) min(GABARes)];
                output.GABAResRelAmpl(kk) = (GABArange(1)-GABArange(2))/std(real(noise));
                output.GABAResSD(kk) = std(real(GABARes))/std(real(noise));
             end
        end
    end
end



%Identify range
switch MRSCont.opts.fit.range(1)
    case 0.5
        range = 'full';
    case 1.85
        range = 'int';
    case 2.79
        range = 'red';
end

%Identify range
switch MRSCont.opts.fit.bLineKnotSpace
    case 0.55
        spline = '055';
    case 0.4
        spline = '04';
    case 0.25
        spline = '025';
end
        

mkdir(['/Volumes/Samsung/working/ISMRM/Philips/GABAAreas' spline '/' range comb '/']); 
matrix = horzcat(output.GABAtoCr(1,:)',output.pureGABAtoCr(1,:)',output.GABAArea(1,:)',output.pureGABAArea(1,:)',output.CrArea(1,:)',output.GABAFitEr(1,:)',output.GABAResRelAmpl(1,:)',output.GABAResSD(1,:)',output.RangeResRelAmpl(1,:)',output.RangeResSD(1,:)');
IntTab = array2table(matrix,'VariableNames',{'GABAtoCr','pureGABAtoCr','GABAArea','pureGABAArea','CrArea','GABAFitEr','GABAResRelAmpl','GABAResSD','RangeResRelAmpl','RangeResSD'});
writetable(IntTab,['/Volumes/Samsung/working/ISMRM/Philips/GABAAreas' spline '/' range  comb '/Ph_Osp_GABAtoCr_' MRSCont.opts.fit.coMM3 '.csv']);
% IntTab = array2table(output.GABAFitEr(1,:)','VariableNames',{'GABAFitEr'});
% writetable(IntTab,['/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/' range  comb '/Ph_Osp_GABAFitEr_' MRSCont.opts.fit.coMM3 '.csv']);

end