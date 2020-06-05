function extract_CrModelInt_and_phases_Big_PRESS(MRSCont1,MRSCont2,MRSCont3, which)
%% extract_CrModelInt_and_phases_Big_PRESS(MRSCont1,MRSCont2,MRSCont3, which)
%   Creates csv files with the area of the NAA normalized creatine models
%   as well as the ph0 and ph1 (at 3 ppm) of all inidvidual datasets and
%   MRS container. It is currently only working with the dataset of  the
%   Big PRESS software comparison paper (REF)
%
%   USAGE:
%       extract_CrModelInt_and_phases_Big_PRESS(MRSCont1,MRSCont2,MRSCont3, which)
%
%   OUTPUTS:
%       generates .csv files with Cr Model integrals and phases
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
    
%%
Tools = {'overview','LCModel','Tarquin'};

for c = 1 : 3 %Loop over container
    eval(['MRSCont = MRSCont', num2str(c)]);
    fit = 'off';
    for t = 1 : 3 %Loop over tools
        for kk = 1 : MRSCont.nDatasets % Loop over datasets
            data_mean = MRSCont.(Tools{t}).all_models.([fit '_' which]){1,kk}.data;
            NAA_height = max(data_mean(MRSCont.(Tools{t}).all_models.([fit '_' which]){1,kk}.ppm>1.9 & MRSCont.(Tools{t}).all_models.([fit '_' which]){1,kk}.ppm<2.1));
            data_mean = MRSCont.(Tools{t}).all_models.([fit '_' which]){1,kk}.fittCr/NAA_height;
            ppm = MRSCont.(Tools{t}).all_models.([fit '_' which]){1,kk}.ppm;
            output.(['Spec' num2str(c)]).Cr_height(t,kk) = trapz(ppm(ppm>0.5 & ppm<4.0),data_mean(ppm>0.5 & ppm<4.0));
            if issorted(ppm, 'descend')
                output.(['Spec' num2str(c)]).Cr_height(t,kk) = -output.(['Spec' num2str(c)]).Cr_height(t,kk);
            end

        end
    end
end

for c = 1 : 3 %Loop over container
    output.(['Spec' num2str(c)]).Cr_heightN(1,:) = output.(['Spec' num2str(c)]).Cr_height(1,:)./mean(output.(['Spec' num2str(c)]).Cr_height(1,:));
    output.(['Spec' num2str(c)]).Cr_heightN(2,:) = output.(['Spec' num2str(c)]).Cr_height(2,:)./mean(output.(['Spec' num2str(c)]).Cr_height(2,:));
    output.(['Spec' num2str(c)]).Cr_heightN(3,:) = output.(['Spec' num2str(c)]).Cr_height(3,:)./mean(output.(['Spec' num2str(c)]).Cr_height(3,:));
end

%Export creatine model area
mkdir('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/CrModel')
mkdir('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/CrModel')
mkdir('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/CrModel')
names = {'ModelCrInt'};
CrIntTab = array2table(output.Spec1.Cr_height(1,:)','VariableNames',names);
writetable(CrIntTab,['/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/CrModel/GE_Osp_CrModel.csv']);
CrIntTab = array2table(output.Spec1.Cr_height(2,:)','VariableNames',names);
writetable(CrIntTab,['/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/CrModel/GE_LCM_CrModel.csv']);
CrIntTab = array2table(output.Spec1.Cr_height(3,:)','VariableNames',names);
writetable(CrIntTab,['/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/CrModel/GE_Tar_CrModel.csv']);
CrIntTab = array2table(output.Spec2.Cr_height(1,:)','VariableNames',names);
writetable(CrIntTab,['/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/CrModel/Philips_Osp_CrModel.csv']);
CrIntTab = array2table(output.Spec2.Cr_height(2,:)','VariableNames',names);
writetable(CrIntTab,['/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/CrModel/Philips_LCM_CrModel.csv']);
CrIntTab = array2table(output.Spec2.Cr_height(3,:)','VariableNames',names);
writetable(CrIntTab,['/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/CrModel/Philips_Tar_CrModel.csv']);
CrIntTab = array2table(output.Spec3.Cr_height(1,:)','VariableNames',names);
writetable(CrIntTab,['/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/CrModel/Siemens_Osp_CrModel.csv']);
CrIntTab = array2table(output.Spec3.Cr_height(2,:)','VariableNames',names);
writetable(CrIntTab,['/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/CrModel/Siemens_LCM_CrModel.csv']);
CrIntTab = array2table(output.Spec3.Cr_height(3,:)','VariableNames',names);
writetable(CrIntTab,['/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/CrModel/Siemens_Tar_CrModel.csv']);
%%
Vendor = {'GE','Philips','Siemens'};
for c = 1 : 3 % Lopp over container
    eval(['MRSCont = MRSCont', num2str(c)]);
    for t = 1 : 3 % Loop over tools
        fit = 'off';
        for kk = 1 : MRSCont.nDatasets
            if ~strcmp(Tools{t},'overview')
                    MRSCont.ph0(kk,t) = MRSCont.(Tools{t}).all_models.([fit '_' which]){1,kk}.ph0;
                    MRSCont.ph0ad(kk,t) = MRSCont.(Tools{t}).all_models.([fit '_' which]){1,kk}.ph0 - 1.7 * MRSCont.(Tools{t}).all_models.([fit '_' which]){1,kk}.ph1;
                    MRSCont.ph1(kk,t) = MRSCont.(Tools{t}).all_models.([fit '_' which]){1,kk}.ph1; 
            else
                MRSCont.ph0(kk,t) = MRSCont.fit.results.(fit).fitParams{1, kk}.ph0; 
                MRSCont.ph0ad(kk,t) = MRSCont.fit.results.(fit).fitParams{1, kk}.ph0 - 1.7 * MRSCont.fit.results.(fit).fitParams{1, kk}.ph1; 
                MRSCont.ph1(kk,t) = MRSCont.fit.results.(fit).fitParams{1, kk}.ph1;
            end
        end            
    end
eval(['MRSCont', num2str(c), '= MRSCont']);
end
%Export phases
mkdir('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/phases')
mkdir('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/phases')
mkdir('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/phases')
names = {'ph0','ph1','ph'};
for c = 1 : 3
    eval(['MRSCont = MRSCont', num2str(c)]);
    for t = 1 : 3
        phase = horzcat(MRSCont.ph0(:,t),MRSCont.ph1(:,t),MRSCont.ph0ad(:,t));
        phaseTab = array2table(phase,'VariableNames',names);
        writetable(phaseTab,['/Volumes/Samsung_T5/working/ISMRM/'  Vendor{c}  '/derivativesLCM/phases/'  Vendor{c}  '_' Tools{t} '_phases.csv']);
    end
end

end