## Get Census data using tidycensus package
## Note: Project used NHGIS data instead due to updates to Census API and 
## tidycensus package during Fall 2020

# Load packages
library(tidyverse); library(tidycensus); library(janitor); library(sf)
library(tigris); library(sp)

# Input Census key
key <- "0ff063c9a1ab846e58d33668b228b5d68b989a27"
census_api_key(key, install = T, overwrite = T)

# Load variable dictionary
var_library <- load_variables(2000, dataset = "sf1", cache = T)
## Variable descriptions: https://api.census.gov/data/2000/dec/sf1/variables.html

# Load shape files for Philadelphia metro area
shapes <- tracts(state = 'PA', county = c("Bucks", "Chester", "Delaware", 
                                          "Montgomery", "Philadelphia")) %>% 
   clean_names()
options(tigris_use_cache = T) # cache shape files

# Create function to pull Census data
pull_vars <- function(vars, 
                      counties = c("Bucks", "Chester", "Delaware", "Montgomery", 
                                   "Philadelphia"),
                      geom = F){
   get_decennial(geography = "tract",
                        variables = vars,
                        sumfile = "sf1",
                        year = 2000, 
                        state = "PA",
                        county = counties,
                        geometry =  geom)
}

# Example without function
# census_tenure_raw <- get_decennial(geography = "tract",
#                         variables = c(
#                            tenure_total = "H004001",
#                            tenure_owner = "H004002",
#                            tenure_renter = "H004003"
#                         ),
#                         sumfile = "sf1",
#                         year = 2000, 
#                         state = "PA",
#                         county = counties,
#                         geometry =  T)

# Create cleaning function
clean <- function(data){
   data %>% 
      janitor::clean_names() %>%
      as_tibble() %>% # convert from spatial object to data table
      pivot_wider(names_from = variable, values_from = value)
}


# Pull data by variable category and rename
counties <- c("Bucks", "Chester", "Delaware", "Montgomery", "Philadelphia")

census_tenure <- pull_vars(c(
   tenure_total = "H004001",
   tenure_vacant = "H003002",
   tenure_occupied = "H003003",
   tenure_owner = "H004002",
   tenure_renter = "H004003"
)) %>% clean()

census_race <- pull_vars(c(
   race_total = "H006001",
   race_white_only = "H006002",
   race_black_only = "H006003",
   race_white_any = "H008002",
   race_black_any = "H008003"
)) %>% clean()

census_ed <- ""

census_inc_val <- ""


# Join Census data with shape files
census_race2 <- census_race %>% 
   mutate(geoid = case_when(
      str_length(geoid) == 9 ~ paste0(geoid, "00"),
      TRUE ~ geoid
   ))
   

# Make test plots to check functionality
test <- full_join(census_race2, shapes, by = "geoid") %>% 
   st_as_sf()

plot(test["race_black_only"])

test2 <- test %>% 
   filter(countyfp == 101)
   
plot(test2["race_black_only"])

