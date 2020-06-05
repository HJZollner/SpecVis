outdir = '/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/TarquinTransmitFreq';
MRSCont = MRSContGE;
for kk = 1 : MRSCont.nDatasets
    [path,filename,~]       = fileparts(MRSCont.files{kk});
    % For batch analysis, get the last two sub-folders (e.g. site and
    % subject)
    path_split          = regexp(path,filesep,'split');
    if length(path_split) > 2
        name = [path_split{end-1} '_' path_split{end} '_' filename];
    end
    in = MRSCont.processed.A{kk};
    fid=fopen(fullfile(outdir , [name '.txt']),'w+');
    fprintf(fid,'%i \n ',in.txfrq);
    fclose(fid);
end
%%
outdir = '/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/TarquinTransmitFreq';
MRSCont = MRSContPh;
for kk = 1 : MRSCont.nDatasets
    [path,filename,~]       = fileparts(MRSCont.files{kk});
    % For batch analysis, get the last two sub-folders (e.g. site and
    % subject)
    path_split          = regexp(path,filesep,'split');
    if length(path_split) > 2
        name = [path_split{end-1} '_' path_split{end} '_' filename];
    end
    in = MRSCont.processed.A{kk};
    fid=fopen(fullfile(outdir , [name '.txt']),'w+');
    fprintf(fid,'%i \n ',in.txfrq);
    fclose(fid);
end
%%
outdir = '/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/TarquinTransmitFreq';
MRSCont = MRSContSi;
for kk = 1 : MRSCont.nDatasets
    [path,filename,~]       = fileparts(MRSCont.files{kk});
    % For batch analysis, get the last two sub-folders (e.g. site and
    % subject)
    path_split          = regexp(path,filesep,'split');
    if length(path_split) > 2
        name = [path_split{end-1} '_' path_split{end} '_' filename];
    end
    in = MRSCont.processed.A{kk};
    fid=fopen(fullfile(outdir , [name '.txt']),'w+');
    fprintf(fid,'%i \n ',in.txfrq);
    fclose(fid);
end