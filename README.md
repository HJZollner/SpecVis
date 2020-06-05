<img src="/Logo.png" width="250">
# SpecVis
SpecVis is a repository of R functions to visualize quantitative MRS results from different linear-combination algorithms.
# Getting started

## Prerequisites

SpecVis was developed in [RStudio (Version 1.2.5019)](https://rstudio.com/) on macOS Catalina (Version 10.15.3 (19D76)) and
the needed libraries are downloaded and installed automatically.

For high-resolution pdf files you need to have a functioning cairo_pdf device. You can always change the ggsave output format to any other format. 

## Installation

Download the latest **SpecVis** code from its [GitHub
repository](https://github.com/hezoe100/SpecVis), then include the SpecVis folder as
workdir (setwd()). Make sure to regularly check for updates, as we frequently commit new features, bug fixes, and improved
functions.

## Example markdown and script

An example [markdown](https://github.com/hezoe100/SpecVis/blob/master/examples/Example.md) is included in the repository. You can adapt your own script based on this [function](https://github.com/hezoe100/SpecVis/blob/master/examples/LC_comp.R).

# Features
- Load LCM-native result files from Osprey (.csv), LCModel (.coord), and Tarquin (.csv).
- Load statistics .csv-files which include group variables and correlation measures
- Raincloud plots (https://wellcomeopenresearch.org/articles/4-63) with individual datapoints, boxplots, distributions, and mean +- SD representations.
- Boxplots with individual datapoints
- Correlation plots with collapsed-correlations, group-level correlations, and indicators for sub-groups.
- Correlation plots with group-level facets and correlations for sub-groups.
- Statistics script which automatically performs appropriate statistics, including descriptive statistics, tests for normality, variance analysis, and post hoc tests. So far, only paired post hoc tests are performed.

## Supported file formats
- Osprey .csv-files
- LCModel .coord-files
- Tarquin .csv-files
- arbitrary .csv-files

# Example plots
### Raincloud plot (https://wellcomeopenresearch.org/articles/4-63)
![Raincloud](/examples/RaincloudByLCMwithLimits4colums.png)
### Correlation plot
![Correlation](/examples/CorrelationByVendorWithSubgroups.png)
### Correlation facet plot
![CorrelationFacet](/examples/CorrelationFacetSmall.png)

## Planned features
- Tests without paired post hoc tests.
- Bland-Altmann plots

# Contact, Feedback, Suggestions

For any sort of questions, feedback, suggestions, or critique, please reach out to us via hzoelln2@jhu.edu. We also welcome your direct contributions to SpecVis here in the GitHub repository.

# Developers

- [Helge J. Zöllner](mailto:hzoelln2@jhu.edu)
- [Georg Oeltzschner](mailto:goeltzs1@jhu.edu)

Should you publish material that made use of SpecVis, please cite the following publication:

[G Oeltzschner, HJ Zöllner, SCN Hui, M Mikkelsen, MG Saleh, S Tapper, RAE Edden. Osprey: Open-Source Processing, Reconstruction  & Estimation of Magnetic Resonance Spectroscopy Data. bioRxiv 2020.](https://www.biorxiv.org/content/10.1101/2020.02.12.944207v1)

Should you publish material that made use of the Raincloud plot script, please additionally cite: 

[Allen M, Poggiali D, Whitaker K et al. Raincloud plots: a multi-platform tool for robust data visualization. Wellcome Open Res 2019, 4:63](https://wellcomeopenresearch.org/articles/4-63)

## Acknowledgements

We wish to thank Martin Wilson (University of Birmingham, Birmingham) for shared import code from the 'spant' R-package https://martin3141.github.io/spant/index.html. This code builds on modified version of the raincloud plots by Davide      Poggiali https://github.com/RainCloudPlots/RainCloudPlots.

This work has been supported by NIH grants R01EB016089, P41EB15909, R01EB023963, and K99AG062230.
