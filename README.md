# SpecVis
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/HJZollner/SpecVis)](https://github.com/HJZollner/SpecVis/releases)
[![GitHub Release Date](https://img.shields.io/github/release-date/HJZollner/SpecVis)](https://github.com/HJZollner/SpecVis/releases)
[![GitHub last commit](https://img.shields.io/github/last-commit/HJZollner/SpecVis)](https://github.com/HJZollner/SpecVis/commits/develop)
[![Website](https://img.shields.io/website?down_color=lightgrey&down_message=offline&up_color=green&up_message=online&url=https%3A%2F%2Fhjzollner.github.io)](https://hjzollner.github.io)
[![License](https://img.shields.io/github/license/HJZollner/SpecVis)](https://github.com/HJZollner/SpecVis/blob/develop/LICENSE.md)

<img src="/Logo.png" width="250">

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
- Bland-Altman plots with distribution ellipse with collapsed-distribution and group-distributions.
- Statistics script which automatically performs appropriate statistics, including descriptive statistics, tests for normality, variance analysis, and post hoc tests.

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
### Bland Altmann plot
![BlandAltmann](/examples/BlandAltmann.png)
### Correlation facet plot
![CorrelationFacet](/examples/CorrelationFacetSmall.png)

## Planned features
- Integration of spectra visualization

# Contact, Feedback, Suggestions

For any sort of questions, feedback, suggestions, or critique, please reach out to us via hzoelln2@jhu.edu. We also welcome your direct contributions to SpecVis here in the GitHub repository.

# Developers

- [Helge J. Zöllner](mailto:hzoelln2@jhu.edu)
- [Georg Oeltzschner](mailto:goeltzs1@jhu.edu)

Should you publish material that made use of SpecVis, please cite the following publication:

[HJ Zöllner, Michal Považan, SCN Hui, S Tapper, RAE Edden, Georg Oeltzschner, Agreement between different linear-combination modelling algorithms for short-TE proton spectra. bioRxiv 2020.](https://doi.org/10.1101/2020.06.05.136796)

Should you publish material that made use of the Raincloud plot script, please additionally cite: 

[Allen M, Poggiali D, Whitaker K et al. Raincloud plots: a multi-platform tool for robust data visualization. Wellcome Open Res 2019, 4:63](https://wellcomeopenresearch.org/articles/4-63)

## Acknowledgements

We wish to thank Martin Wilson (University of Birmingham, Birmingham) for shared import code from the 'spant' R-package https://martin3141.github.io/spant/index.html. This code builds on modified version of the raincloud plots by Davide      Poggiali https://github.com/RainCloudPlots/RainCloudPlots.

This work has been supported by NIH grants R01EB016089, P41EB15909, R01EB023963, and K99AG062230.
