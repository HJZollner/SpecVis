function osp_extract_BaselinePower(MRSCont1,MRSCont2,MRSCont3)
%% out = osp_extract_BaselinePower(MRSCont1,MRSCont2,MRSCont3)
%   This function generates csv files with the baseline power of all
%   inididual datasets, LC algorithms, and container of tNAA, tCho, Ins,
%   and Glx.  It is currently only working with the dataset of  the
%   Big PRESS software comparison paper (REF)
%
%   USAGE:
%       osp_extract_BaselinePower(MRSCont1,MRSCont2,MRSCont3)
%
%   OUTPUTS:
%       generates csv files with baseline powers
%
%   OUTPUTS:
%       MRSCont  = Osprey data container.
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2019-10-02)
%       hzoelln2@jhmi.edu
%
%   HISTORY:
%       2020-05-07: First version of the code.

% Check that OspreyOverview has been run before
if ~MRSCont1.flags.didOverview
    error('Trying to create overview plots, but no overview data has been created. Run OspreyOverview first.')
end
Tools = {'overview','LCModel','Tarquin'}; % THIS POSSIBLY DIFFERS FOR OTHER DATASETS
Vendor = {'GE','Philips','Siemens'}; % THIS POSSIBLY DIFFERS FOR OTHER DATASETS IT NEDS TO BE IN THE ORDER OF THE MRSCONTAINER
model = 'off_A';
for t = 1 : 3 % Loop over tools
    for c = 1 : 3 % Loop over container
        eval(['MRSCont = MRSCont', num2str(c)]);
        for kk = 1 : MRSCont.nDatasets
        data_mean = MRSCont.(Tools{t}).all_models.(model){1,kk}.data;
        Cr_height = max(data_mean(MRSCont.(Tools{t}).all_models.(model){1,kk}.ppm>2.9 & MRSCont.(Tools{t}).all_models.(model){1,kk}.ppm<3.1));
        MRSCont.(Tools{t}).all_models.(model){1,kk}.fittMM = MRSCont.(Tools{t}).all_models.(model){1,kk}.fittMM/Cr_height;
        MRSCont.(Tools{t}).all_models.(model){1,kk}.baseline = MRSCont.(Tools{t}).all_models.(model){1,kk}.baseline/Cr_height;
        end
        eval(['MRSCont', num2str(c), '= MRSCont']);
    end


    for c = 1 : 3
        eval(['MRSCont = MRSCont', num2str(c)]);
    for kk = 1 : MRSCont.nDatasets
         data_mean = MRSCont.(Tools{t}).all_models.(model){1,kk}.baseline + MRSCont.(Tools{t}).all_models.(model){1,kk}.fittMM;
        edge_cont(c,kk) = min(data_mean(MRSCont.(Tools{t}).all_models.(model){1,kk}.ppm>2.66 & MRSCont.(Tools{t}).all_models.(model){1,kk}.ppm<2.7));
    end

    end
    max_edge = max(max(edge_cont));
    edge_diff = max_edge - edge_cont(:,:);

    for c = 1 : 3
        eval(['MRSCont = MRSCont', num2str(c)]);
    for kk = 1 : MRSCont.nDatasets
        MRSCont.(Tools{t}).all_models.(model){1,kk}.baseline = MRSCont.(Tools{t}).all_models.(model){1,kk}.baseline + edge_diff(c,kk);
    end
        eval(['MRSCont', num2str(c), '= MRSCont']);
    end
end
%% Generate output csv files with baseline and MM+baseline power estimates
for t = 1 : 3 % Loop over tools
    for c = 1 : 3 % Loop over container
        eval(['MRSCont = MRSCont', num2str(c)]);
    baselinetNAA = zeros(1,MRSCont.nDatasets);
    baselinetCho = baselinetNAA;
    baselineIns = baselinetNAA;
    baselineGlx = baselinetNAA;
    for kk = 1 : MRSCont.nDatasets
        baseline = MRSCont.(Tools{t}).all_models.(model){1,kk}.baseline;
        ppm = MRSCont.(Tools{t}).all_models.(model){1,kk}.ppm;
        baselinetNAA(kk) = trapz(ppm(ppm>1.9 & ppm<2.1),baseline(ppm>1.9 & ppm<2.1))/length(ppm(ppm>1.9 & ppm<2.1))*(length(ppm(ppm>1.9 & ppm<2.5))+length(ppm(ppm>3.6 & ppm<3.8)));
        baselinetCho(kk) = trapz(ppm(ppm>3.1 & ppm<3.3),baseline(ppm>3.1 & ppm<3.3))/length(ppm(ppm>3.1 & ppm<3.3))*(length(ppm(ppm>1.9 & ppm<2.5))+length(ppm(ppm>3.6 & ppm<3.8)));
        baselineIns(kk) = trapz(ppm(ppm>3.33 & ppm<3.75),baseline(ppm>3.33 & ppm<3.75))/length(ppm(ppm>3.33 & ppm<3.75))*(length(ppm(ppm>1.9 & ppm<2.5))+length(ppm(ppm>3.6 & ppm<3.8)));
        baselineGlx(kk) = (trapz(ppm(ppm>1.9 & ppm<2.5),baseline(ppm>1.9 & ppm<2.5)) + trapz(ppm(ppm>3.6 & ppm<3.8),baseline(ppm>3.6 & ppm<3.8)));
        if issorted(ppm, 'descend')
            baselinetNAA(kk) = -baselinetNAA(kk);
            baselinetCho(kk) = -baselinetCho(kk);
            baselineIns(kk) = -baselineIns(kk);
            baselineGlx(kk) = -baselineGlx(kk);        
        end
    end             

    names = {'bNAA','bCho','bIns','bGlx'};
    baselineInt = horzcat(baselinetNAA',baselinetCho',baselineIns',baselineGlx');
    baselineIntTab = array2table(baselineInt,'VariableNames',names);
    writetable(baselineIntTab,['/Volumes/Samsung_T5/working/ISMRM/' Vendor{c} '/derivativesLCM/baselineValue/' Vendor{c} '_' Tools{t} '_baseline.csv']);

    baselinetNAAptMM = zeros(1,MRSCont.nDatasets);
    baselinetChoptMM = baselinetNAAptMM;
    baselineInsptMM = baselinetNAAptMM;
    baselineGlxptMM = baselinetNAAptMM;
    for kk = 1 : MRSCont.nDatasets
        baseline = MRSCont.(Tools{t}).all_models.(model){1,kk}.baseline + MRSCont.(Tools{t}).all_models.(model){1,kk}.fittMM;
        ppm = MRSCont.(Tools{t}).all_models.(model){1,kk}.ppm;    
        baselinetNAAptMM(kk) = trapz(ppm(ppm>1.9 & ppm<2.1),baseline(ppm>1.9 & ppm<2.1))/length(ppm(ppm>1.9 & ppm<2.1))*(length(ppm(ppm>1.9 & ppm<2.5))+length(ppm(ppm>3.6 & ppm<3.8)));
        baselinetChoptMM(kk) = trapz(ppm(ppm>3.1 & ppm<3.3),baseline(ppm>3.1 & ppm<3.3))/length(ppm(ppm>3.1 & ppm<3.3))*(length(ppm(ppm>1.9 & ppm<2.5))+length(ppm(ppm>3.6 & ppm<3.8)));
        baselineInsptMM(kk) = trapz(ppm(ppm>3.33 & ppm<3.75),baseline(ppm>3.33 & ppm<3.75))/length(ppm(ppm>3.33 & ppm<3.75))*(length(ppm(ppm>1.9 & ppm<2.5))+length(ppm(ppm>3.6 & ppm<3.8)));
        baselineGlxptMM(kk) = (trapz(ppm(ppm>1.9 & ppm<2.5),baseline(ppm>1.9 & ppm<2.5)) + trapz(ppm(ppm>3.6 & ppm<3.8),baseline(ppm>3.6 & ppm<3.8)));
        if issorted(ppm, 'descend')
            baselinetNAAptMM(kk) = -baselinetNAAptMM(kk);
            baselinetChoptMM(kk) = -baselinetChoptMM(kk);
            baselineInsptMM(kk) = -baselineInsptMM(kk);
            baselineGlxptMM(kk) = -baselineGlxptMM(kk);        
        end
    end   

    names = {'bNAA','bCho','bIns','bGlx'};
    baselineMMInt = horzcat(baselinetNAAptMM',baselinetChoptMM',baselineInsptMM',baselineGlxptMM');
    baselineIntMMTab = array2table(baselineMMInt,'VariableNames',names);
    writetable(baselineIntMMTab,['/Volumes/Samsung_T5/working/ISMRM/' Vendor{c} '/derivativesLCM/baselineValue/' Vendor{c} '_' Tools{t} '_baselinepMM.csv']);
    end
end