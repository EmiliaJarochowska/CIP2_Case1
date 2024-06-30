# Cyclostratigraphy Intercomparison Project 2.0 - Case 1 (non-)solution

Code for analysing [Case 1](https://www.cyclostratigraphy.org/fileadmin/user_upload/Microsite_Cyclostratigraphy/CIP_cases/CIPII/CIP2.0_Case_1.zip) for [CIP 2.0](https://www.cyclostratigraphy.org/the-cip-initiative).

## Structure

`Case1` contains: 
- `Case1.R` script 
- file `IODP_Site_U1514_splice_AlTi.csv` from [CIP2.0 website](https://www.cyclostratigraphy.org/fileadmin/user_upload/Microsite_Cyclostratigraphy/CIP_cases/CIPII/CIP2.0_Case_1.zip) 

## Requirements

The R Studio IDE and packages `admtools` and `astrochron`. `astrochron` can be downloaded from CRAN, installation instructions for `admtools`:

```{r}
remotes::install_github(repo = "MindTheGap-ERC/admtools", 
                        ref = "dev", 
                        force = TRUE,
                        build_vignettes = T)
```
As you can see, this implicitly also requires the package `remotes`. The code checks which packages are needed and installs them as necessary.

## Usage

In the RStudion IDE, open the file `CIP2_ej`. This will start the R project and set all paths correctly. Then you can start to inspect and run the code.

## References

- Hohmann N (2023). “admtools package for R.” doi:10.5281/zenodo.10213587 <https://doi.org/10.5281/zenodo.10213587>.
  
- Meyers, S.R. (2014). Astrochron: An R Package for Astrochronology. https://cran.r-project.org/package=astrochron
  
- Vahlenkamp, M., De Vleeschouwer, D., Batenburg, S.J., Edgar, K.M., Hanson, E., Martinez, M., Pälike, H., MacLeod, K.G., Li, Y.X., Richter, C. and Bogus, K., 2020. A lower to middle Eocene astrochronology for the Mentelle Basin (Australia) and its implications for the geologic time scale. Earth and Planetary Science Letters, 529, p.115865.

## Authors

The problem and data were provided by the [organizers of CIP 2.0](https://www.cyclostratigraphy.org/the-cip-initiative).

Code by E. Jarochowska (e.b.jarochowska [at] uu.nl) with contributions by N. Hohmann (n.h.hohmann [at] uu.nl).

