# Gentrification and Housing Discrimination in Philadelphia

Repository for group term paper "Exploring the Relationship between Housing Discrimination and Gentrification in Philadelphia" for ECON 432: Environmental Justice, Duke University. Group members: Alexi DeLara, Ryan Hastings, and Michael Heilweil. All empirical work done by Ryan Hastings.

## Data
Discrimination data was provided by Professor Chris Timmins from the Christensen, Sarmiento-Barbieri, and Timmins (2020) online correspondence study of housing discrimination, which Ryan Hastings assisted in collecting. The data can be found in `data/phl_data.csv`.

Demographic data was pulled from 2000 Census and 2013-2017 ACS 5-year estimates using NHGIS interface and uploaded to `data/nhgis`.

## Workflow
The data was cleaned and wrangled in `R`. `read-phl-data.R` and `read-merge-census-data.R` read in each data source, before `merge-phl-census.R` merges the two. `summary-stats-viz.R` calculates summary statistics and creates maps.

The data was then exported to `STATA` to perform propensity score matching and estimate the average treatment effect on the treated. Matching scripts are located in the `STATA/` folder.




