## Read and Merge Census Data

# Load packages
library(tidyverse); library(janitor)


# Read data
d2000_1 <- read_csv("../data/nhgis/nhgis0002_ds146_2000_tract.csv") %>% 
  clean_names()

d2000_2 <- read_csv("../data/nhgis/nhgis0002_ds151_2000_tract.csv") %>% 
  clean_names()

d2010 <- read_csv("../data/nhgis/nhgis0002_ds172_2010_tract.csv") %>% 
  clean_names()

d2017_1E <- read_csv("../data/nhgis/nhgis0002_ds233_20175_2017_tract_E.csv") %>% 
  clean_names() # Estimates

# d2017_1M <- read_csv("../data/nhgis/nhgis0002_ds233_20175_2017_tract_M.csv") %>% 
#   clean_names() # Margins of Error

d2017_2E <- read_csv("../data/nhgis/nhgis0002_ds234_20175_2017_tract_E.csv") %>% 
  clean_names() # Estimates

# d2017_2M <- read_csv("../data/nhgis/nhgis0002_ds234_20175_2017_tract_M.csv") %>% 
#   clean_names() # Margins of Error

# Preview data as needed
glimpse(d2000_1)
glimpse(d2000_2)
glimpse(d2010)
glimpse(d2017_1E)
glimpse(d2017_1M)
glimpse(d2017_2E)
glimpse(d2017_2M)

# Merge and rename variables of all 2000 Census data
d2000 <- full_join(d2000_1, d2000_2) %>% 
  select(gisjoin:name, 
         totalpop_2000 = fl5001,
         pop_white_only_2000 = fl9001,
         pop_black_only_2000 = fl9002,
         pop_hispanic_2000 = fmc001,
         pop_male_2000 = fmy001,
         median_age_2000 = fm6001,
         pop_less_18_2000 = fpq001,
         pop_over_65_2000 = fqi001,
         house_occupied_2000 = fkl001,
         house_vacant_2000 = fkl002,
         house_occ_owner_2000 = fkn001,
         house_occ_renter_2000 = fkn002,
         med_hh_inc_2000 = gmy001,
         pop_below_poverty_2000 = gn6001,
         pop_atabove_poverty_2000 = gn6002,
         med_rent_asked_2000 = gbl001,
         med_gross_rent_2000 = gbo001,
         med_value_owner_occ_2000 = gcl001,
         med_price_asked_2000 = gcp001) %>% 
  filter(statea == "42",  #PA
         countya %in% c("017", "029", "045", "091", "101")) %>% #Philly counties
  mutate(year = as.character(year))

# Merge and rename variables of all 2017 ACS data
d2017 <- full_join(d2017_1E, d2017_2E) %>% 
  select(gisjoin:name, 
         median_age_2017 = ahyre001,
         totalpop_2017 = ahy1e001,
         pop_white_only_2017 = ahy2e002,
         pop_black_only_2017 = ahy2e003,
         pop_hispanic_2017 = ahzbe003, 
         pop_25over_2017 = ah04e001,
         pop_25over_hs_2017 = ah04e017,
         pop_25over_bach = ah04e022,
         med_hh_inc_2017 = ah1pe001,
         house_total_2017 = ah36e001,
         house_occupied_2017 = ah36e002,
         house_vacant_2017 = ah36e003,
         house_occ_owner_2017 = ah37e002,
         house_occ_renter_2017 = ah37e003,
         med_gross_rent_2017 = ah5re001,
         med_value_owner_occ_2017 = ah53e001,
         pop_less_18_2017 = aicpe001,
         pop_below_poverty_2017 = aigle002,
         pop_poverty_determined_2017 = aigle001)%>% 
  filter(statea == "42", 
         countya %in% c("017", "029", "045", "091", "101"))

# Join 2000 and 2017 data
census <- full_join(d2000, d2017, by = c("gisjoin", "state", "statea", "countya", "placea", "tracta", "aianhha", "res_onlya", "trusta", "anrca"))

# Save data
write_rds(census, "../data/census.rds")


