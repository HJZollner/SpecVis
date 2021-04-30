function out = calc_Model_Scores(MRSCont)
%% calc_Model_Scores(MRSCont1)
%   Calculates AICs of the differnt modeling strategies. Akaike 1974
%   (10.1109/TAC.1974.1100705)
%
%   USAGE:
%       calc_Model_Scores(MRSCont1)
%
%   OUTPUTS:
%       generates .csv files with GABAtoCrAreas
%
%   OUTPUTS:
%       MRSCont  = Osprey data container (e.g. GE, Philips, Siemens).
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2019-10-02)
%       hzoelln2@jhmi.edu
%
%   HISTORY:
%       2020-01-07: First version of the code.
%% Initlaize
% Set up output struct
out.ACI_ll = 0;
out.ACI_mse = 0;
out.soACI_ll = 0;
out.soACI_mse = 0;
out.BCI_ll = 0;

%% Parameters and Datapoints
%  amplitudes + ph0 + ph1 + gaussLB + lorentzLB + freqShift + lineshape + beta_j
%  Here the number of parameters are calcualted, as well as the number of datapoints     

K = (length(MRSCont.fit.results.diff1.fitParams{1, 1}.ampl)+ 1   + 1   + 1 ...
        + length(MRSCont.fit.results.diff1.fitParams{1, 1}.lorentzLB)  +length(MRSCont.fit.results.diff1.fitParams{1, 1}.freqShift) ...
        +length(MRSCont.fit.results.diff1.fitParams{1, 1}.lineShape)  + length(MRSCont.fit.results.diff1.fitParams{1, 1}.beta_j));
    
% Soft constraints are counted as half parameters 
if contains(MRSCont.opts.fit.coMM3,'soft')
    K = K - 0.5;
end

%number of points
n = length(MRSCont.overview.Osprey.all_models_voxel_1.diff1_diff1{1, 1}.res);

%% Calculate AICs and BCI
% Different implementations were tested here. ll means loglikelihood calcualtion while mse
% is based on the mean squared error. Additionally, approximations for lower numbers of
% datapoints were tested. Baysian information was alos calculated.


for rr = 1 : MRSCont.nDatasets
    loglike = MRSCont.overview.Osprey.all_models_voxel_1.diff1_diff1{1, rr}.data .* log(MRSCont.overview.Osprey.all_models_voxel_1.diff1_diff1{1, rr}.fit) + ((1-MRSCont.overview.Osprey.all_models_voxel_1.diff1_diff1{1, rr}.data) .* log(1 - MRSCont.overview.Osprey.all_models_voxel_1.diff1_diff1{1, rr}.fit));
     out.ACI_ll(rr) =   2* (real (sum(-loglike)) + 2 * K);
    out.ACI_mse(rr) =   2* (real(log(-sum((MRSCont.overview.Osprey.all_models_voxel_1.diff1_diff1{1, rr}.res).^2))) + 2 * K);
    out.soACI_ll(rr) =   2* (real(sum(-loglike)) + 2 * K + (2*K*(K+1)/(n-K-1)));
    out.soACI_mse(rr) =   2* (real(log(-sum((MRSCont.overview.Osprey.all_models_voxel_1.diff1_diff1{1, rr}.res).^2))) + 2 * K + (2*K*(K+1)/(n-K-1)));
    out.BCI_ll(rr) =   2* ( n * real(sum(-loglike)) + K * log(n));
end


out.means =[ nanmean(out.ACI_ll) nanmean(out.ACI_mse) nanmean(out.soACI_ll) nanmean(out.soACI_mse) nanmean(out.BCI_ll)];
end