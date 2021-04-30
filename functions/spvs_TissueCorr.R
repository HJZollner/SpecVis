spvs_TissueCorr <- function(dataFrame,metabTE,metabTR,waterTE,waterTR) {
  # spvs_TissueCorr <- function(dataFrame)
  # This will perfrom tisseu-corrected water-scaled estiamtes using Gasparovic et al. MRM 2006
  #
  #
  #
  #   USAGE:
  #     spvs_TissueCorr <- function(dataFrame)
  #
  #   INPUTS:
  #     dataframe = metabolites as calculated in LCModel or Tarquin with Osprey analogeus naming
  #             
  #   OUTPUTS:
  #     dataframe     = concentrations after Tissue correction
  #     
  #   AUTHOR:
  #     Dr. Helge Zöllner (Johns Hopkins University, 2021-04-10)
  #     hzoelln2@jhmi.edu
  #         
  #   CREDITS:    
  #     This code is based on numerous functions from the spant toolbox by
  #     Dr. Martin Wilson (University of Birmingham)
  #     https://martin3141.github.io/spant/index.html
  #     It is also borrows code from the OspreyQuantify function.
  #      
  #      
  #   HISTORY:
  #     2021-04-10: First version of the code.
  # 1 Calculate priors ----------------------------------------------------------
   # Define Constants
  # Water relaxation
  # From Lu et al. 2005 (JMRI)
  T1w_WM    <- 0.832
  T2w_WM    <- 0.0792
  T1w_GM    <- 1.331
  T2w_GM    <- 0.110
  T1w_CSF   <- 3.817
  T2w_CSF   <- 0.503
  
  # Determine concentration of water in GM, WM and CSF
  # Gasparovic et al. 2006 (MRM) uses relative densities, ref to
  # Ernst et al. 1993 (JMR)
  # fGM = 0.78
  # fWM = 0.65
  # fCSF = 0.97
  # such that
  # concw_GM = 0.78 * 55.51 mol/kg = 43.30
  # concw_WM = 0.65 * 55.51 mol/kg = 36.08
  # concw_CSF = 0.97 * 55.51 mol/kg = 53.84
  
  concW_GM    = 43300
  concW_WM    = 36080
  concW_CSF   = 53840
  
  # Calculate molal fractions from volume fractions
  dataFrame$molal_fGM  <- (dataFrame$GM*concW_GM) / (dataFrame$GM*concW_GM + dataFrame$WM*concW_WM + dataFrame$CSF*concW_CSF)
  dataFrame$molal_fWM  <- (dataFrame$WM*concW_WM) / (dataFrame$GM*concW_GM + dataFrame$WM*concW_WM + dataFrame$CSF*concW_CSF)
  dataFrame$molal_fCSF <- (dataFrame$CSF*concW_CSF) / (dataFrame$GM*concW_GM + dataFrame$WM*concW_WM + dataFrame$CSF*concW_CSF)
  
  # Setup Lookup table form metaboltie relaxation times
  # T1 values for NAA, Glu, Cr, Cho, Ins from Mlynarik et al, NMR Biomed
  # 14:325-331 (2001)
  # T1 for GABA from Puts et al, J Magn Reson Imaging 37:999-1003 (2013)
  # T2 values from Wyss et al, Magn Reson Med 80:452-461 (2018)
  # T2 values are averaged between OCC and pACC for GM; and PVWM for WM

  # Calulate mean relaxation values
  Asc   = (1340 +1190)/2/1000
  Asp   = (1340 +1190)/2/1000
  Cr    = (1460 +1240)/2/1000
  GABA  = (1310+ 1310)/2/1000
  Glc   = (1340 +1190)/2/1000
  Gln   = (1340+ 1190)/2/1000
  Glu   = (1270+ 1170)/2/1000
  Gly   = (1340+ 1190)/2/1000
  GPC   = (1300+ 1080 )/2/1000
  GSH   = (1340+ 1190 )/2/1000
  Lac   = (1340+ 1190)/2/1000
  Ins   = (1230+ 1010)/2/1000
  NAA   = (1470+ 1350 )/2/1000
  NAAG  = (1340+ 1190)/2/1000
  PCh   = (1300+ 1080 )/2/1000
  PCr   = (1460+ 1240 )/2/1000
  PE    = (1340+ 1190)/2/1000
  Scyllo   = (1340+ 1190)/2/1000
  Tau   = (1340+ 1190)/2/1000
  tNAA  = (1470+1340+1350+119)/4/1000 
  tCr  = (1460+1460+1240+1240)/4/1000
  tCho  = (1300+1080+1080+1080)/4/1000
  Glx  =  (1340+1270+1190+1170)/4/1000
  
  T1Relax <- data.frame(Asc, Asp,Cr,GABA,Glc,Gln,Glu,Gly,GPC,GSH,Lac,Ins,NAA,NAAG,PCh,PCr,PE,Scyllo,Tau,tNAA,tCr,tNAA,tCho,Glx)
  
  Asc   = (125+105+ 172)/3/1000
  Asp   = (111+90+ 148)/3/1000
  Cr    = (148+144+ 166)/3/1000
  GABA  = (102+75+ 102+75)/4/1000
  Glc   = (117+88+ 155)/3/1000
  Gln   = (122+99+ 168)/3/1000
  Glu   = (135+122+ 124)/3/1000
  Gly   = (102+81+ 152)/3/1000
  GPC   = (274+222+ 218)/3/1000
  GSH   = (100+77+ 145 )/3/1000
  Lac   = (110+99+ 159)/3/1000
  Ins   = (244+229+ 161)/3/1000
  NAA   = (253+263+ 343 )/3/1000
  NAAG  = (128+107+ 185)/3/1000
  PCh   = (274+221+ 213 )/3/1000
  PCr   = (148+144+ 166 )/3/1000
  PE    = (119+86+ 158)/3/1000
  Scyllo   = (125+107+ 170)/3/1000
  Tau   = (123+102+ 123+102)/4/1000
  tNAA  = (253+263+128+107+343+185)/6/1000
  tCr  =  (148+144+148+144+166+166)/6/1000
  tCho  = (274+222+274+221+218+213)/6/1000
  Glx  = (122+99+135+122+168+124)/6/1000
  
  T2Relax <- data.frame(Asc, Asp,Cr,GABA,Glc,Gln,Glu,Gly,GPC,GSH,Lac,Ins,NAA,NAAG,PCh,PCr,PE,Scyllo,Tau,tNAA,tCr,tNAA,tCho,Glx)

  # Asc   = 4
  # Asp   = 3
  # Cr    = 6
  # GABA  = 6
  # Glc   = 12
  # Gln   = 5
  # Glu   = 5
  # Gly   = 2
  # GPC   = 10
  # GSH   = 10
  # Lac   = 4
  # Ins   = 6
  # NAA   = 7
  # NAAG  = 13
  # PCh   = 5
  # PCr   = 3
  # PE    = 4
  # Scyllo   = 1
  # Tau   = 4
  # tNAA  = 20
  # tCr  =  9
  # tCho  = 15
  # Glx  = 10
  # 
  # Protons <- data.frame(Asc, Asp,Cr,GABA,Glc,Gln,Glu,Gly,GPC,GSH,Lac,Ins,NAA,NAAG,PCh,PCr,PE,Scyllo,Tau,tNAA,tCr,tNAA,tCho,Glx)
  # Protons <- 2/Protons
  subjects <- nrow(dataFrame)
  # T1Relax <- do.call("rbind", replicate(subjects, T1Relax, simplify = FALSE))
  # T2Relax <- do.call("rbind", replicate(subjects, T2Relax, simplify = FALSE))
  
  for (i in colnames(T1Relax)){
    if (i %in% colnames(dataFrame)){
    dataFrame[[i]] <- dataFrame[[i]] *55510* (dataFrame$molal_fGM * (1-exp(-waterTR/T1w_GM)) * exp(-waterTE/T2w_GM)/((1-exp(-metabTR/T1Relax[[i]])) * exp(-metabTE/T2Relax[[i]])) +
                                       dataFrame$molal_fWM * (1-exp(-waterTR/T1w_WM)) * exp(-waterTE/T2w_WM)/((1-exp(-metabTR/T1Relax[[i]])) * exp(-metabTE/T2Relax[[i]])) +
                                       dataFrame$molal_fCSF * (1-exp(-waterTR/T1w_CSF)) * exp(-waterTE/T2w_CSF)/((1-exp(-metabTR/T1Relax[[i]])) * exp(-metabTE/T2Relax[[i]])) ) / (1-dataFrame$molal_fCSF)}
  }
  
  dataFrame
  
  
} # end of function