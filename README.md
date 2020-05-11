# SpecVis
SpecVis is a repository of R functions to visualize quantitative MRS results from different linear-combination algorithms.

## Features
- Load LCM-native result files from Osprey (.csv), LCModel (.coord), and Tarquin (.csv).
- Load statistics .csv-files which include group variables and correlation measures
- Raincloud plots with individual datapoints, boxplots, distributions, and mean +- SD representations.
- Boxplots with individual datapoints
- Correlation plots with collapsed-correlations, group-level correlations, and indicators for sub-groups.
- Correlation plots with group-level facets and correlations for sub-groups.
- Statistics script which automatically performs appropriate statistics, including descriptive statistics, tests for normality, variance analysis, and post hoc tests. So far, only paired post hoc tests are performed.

## Example plots

![Raincloud](/examples/RaincloudByLCMwithLimits4colums.pnf)

## Supported file formats
- Osprey .csv-files
- LCModel .coord-files
- Tarquin .csv-files
- arbitrary .csv-files

## Planned features
- Tests without paired post hoc tests.
- Bland-Altmann plots


# Getting started

## Prerequisites

SpecVis was developed in [RStudio](https://rstudio.com/) and
the needed libraries are downloaded and installed automatically.

## Installation

Download the latest **SpecVis** code from its [GitHub
repository](https://github.com/hezoe100/SpecVis), then include the SpecVis folder as
workdir (setwd()). Make sure to regularly check for updates, as we frequently commit new features, bug fixes, and improved
functions.

## Examples

An example script is included in the /examples folder of the repository. You can adapt your own script based on it.

# Contact, Feedback, Suggestions

For any sort of questions, feedback, suggestions, or critique, please reach out to us via hzoelln2@jhu.edu. We also welcome your direct contributions to SpecVis here in the GitHub repository.

# Developers

- [Helge J. Zöllner](mailto:hzoelln2@jhu.edu)
- [Georg Oeltzschner](mailto:goeltzs1@jhu.edu)

Should you publish material that made use of SpecVis, please cite the following publication:

[G Oeltzschner, HJ Zöllner, SCN Hui, M Mikkelsen, MG Saleh, S Tapper, RAE Edden. Osprey: Open-Source Processing, Reconstruction  & Estimation of Magnetic Resonance Spectroscopy Data. bioRxiv 2020.](https://www.biorxiv.org/content/10.1101/2020.02.12.944207v1)

## Acknowledgements

We wish to thank Martin Wilson (University of Birmingham, Birmingham) for shared import code from the 'spant' R-package https://martin3141.github.io/spant/index.html

This work has been supported by NIH grants R01EB016089, P41EB15909, R01EB023963, and K99AG062230.
