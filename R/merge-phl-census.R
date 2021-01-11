## Combine Discrimination and Census Data

# Load packages
library(tidyverse); library(lmtest); library(sandwich); library(sf)
```

# Read in data files
phl <- read_rds("../data/philly_tracts.rds")

census <- read_rds("../data/census.rds") %>% 
  mutate(fips_tract = as.numeric(paste0(statea, countya, tracta)))

# Merge files
discrim_raw <- full_join(phl, census) %>% st_as_sf()

# Calculate variables for greater Philadelphia area
discrim <- discrim_raw %>% 
  mutate(
    p_discrim = presp_white - presp_black ,
    p_white_2017 = pop_white_only_2017/ totalpop_2017,
    p_white_2000 = pop_white_only_2000/ totalpop_2000,
    change_value = med_value_owner_occ_2017 - med_value_owner_occ_2000,
    perc_change_value = change_value/med_value_owner_occ_2000,
    change_inc = med_hh_inc_2017 - med_hh_inc_2000,
    perc_change_inc = change_inc/med_hh_inc_2000,
    change_gross_rent = med_gross_rent_2017 - med_gross_rent_2000,
    perc_change_gross_rent = change_gross_rent/med_gross_rent_2000,
    perc_owner_2000 = house_occ_owner_2000/house_occupied_2000,
    perc_owner_2017 = house_occ_owner_2017/house_occupied_2017,
    change_perc_owner = perc_owner_2017 - perc_owner_2000, 
    med_medhhinc_2000 = median(med_hh_inc_2000, na.rm = T),
    med_medhhinc_2017 = median(med_hh_inc_2017, na.rm = T),
    rentburden_2000 = med_gross_rent_2000*12/med_hh_inc_2000,
    rentburden_2017 = med_gross_rent_2017*12/med_hh_inc_2017,
    change_rentburden = rentburden_2017 - rentburden_2000,
    perc_change_rentburden = change_rentburden /rentburden_2000,
    gentrify_composite = case_when(
      perc_change_value > 0.5 & perc_change_gross_rent > 0.5 &
        perc_change_inc > 0.3 & change_perc_owner > 0 &
        med_hh_inc_2000 < 50000 ~ 1,
      TRUE ~ 0
    ),
    gentrify_housevalue = case_when(
      med_hh_inc_2000 < med_medhhinc_2000 & 
        ((perc_change_value > 1 & change_value > 120000) |
        (perc_change_value > 0.5 & change_value > 150000)) ~ 1,
      TRUE ~ 0
    ),
    gentrify_rentburden = case_when(
      med_hh_inc_2000 < med_medhhinc_2000 &
        ((rentburden_2000 < 0.15 & rentburden_2017 > 0.25) | 
           change_rentburden > 0.2) ~ 1,
      TRUE ~ 0
    ),
    gentrify_income = case_when(
      med_hh_inc_2000 < med_medhhinc_2000 &
        med_hh_inc_2017 > med_medhhinc_2017 &
        perc_change_inc > 0.1 ~ 1,
      TRUE ~ 0
    ),
    wealth = case_when(
      med_hh_inc_2017 > quantile(med_hh_inc_2017, 0.65, na.rm = T) ~ 1,
      TRUE ~ 0
    ),
    newwealth = case_when(
      med_hh_inc_2017 > quantile(med_hh_inc_2017, 0.55, na.rm = T) &
        med_hh_inc_2000 < quantile(med_hh_inc_2000, 0.45, na.rm = T) ~ 1,
      TRUE ~ 0
    )
  )

# Calculate variables for City of Philadelphia only
discrim_city <- discrim_raw %>% 
  filter(countya == 101) %>% 
  mutate(
    p_discrim = presp_white - presp_black ,
    p_white_2000 = pop_white_only_2000/ totalpop_2000,
    p_white_2017 = pop_white_only_2017/ totalpop_2017,
    change_value = med_value_owner_occ_2017 - med_value_owner_occ_2000,
    perc_change_value = change_value/med_value_owner_occ_2000,
    change_inc = med_hh_inc_2017 - med_hh_inc_2000,
    perc_change_inc = change_inc/med_hh_inc_2000,
    change_gross_rent = med_gross_rent_2017 - med_gross_rent_2000,
    perc_change_gross_rent = change_gross_rent/med_gross_rent_2000,
    perc_owner_2000 = house_occ_owner_2000/house_occupied_2000,
    perc_owner_2017 = house_occ_owner_2017/house_occupied_2017,
    change_perc_owner = perc_owner_2017 - perc_owner_2000, 
    med_medhhinc_2000 = median(med_hh_inc_2000, na.rm = T),
    med_medhhinc_2017 = median(med_hh_inc_2017, na.rm = T),
    rentburden_2000 = med_gross_rent_2000*12/med_hh_inc_2000,
    rentburden_2017 = med_gross_rent_2017*12/med_hh_inc_2017,
    change_rentburden = rentburden_2017 - rentburden_2000,
    perc_change_rentburden = change_rentburden /rentburden_2000,
    gentrify_composite = case_when(
      perc_change_value > 0.5 & perc_change_gross_rent > 0.5 &
        perc_change_inc > 0.3 & change_perc_owner > 0 &
        med_hh_inc_2000 < 50000 ~ 1,
      TRUE ~ 0
    ),
    gentrify_housevalue = case_when(
      med_hh_inc_2000 < med_medhhinc_2000 & 
        ((perc_change_value > 1 & change_value > 120000) |
        (perc_change_value > 0.5 & change_value > 150000)) ~ 1,
      TRUE ~ 0
    ),
    gentrify_rentburden = case_when(
      med_hh_inc_2000 < med_medhhinc_2000 &
        ((rentburden_2000 < 0.15 & rentburden_2017 > 0.25) | 
           change_rentburden > 0.2) ~ 1,
      TRUE ~ 0
    ),
    gentrify_income = case_when(
      med_hh_inc_2000 < med_medhhinc_2000 &
        med_hh_inc_2017 > med_medhhinc_2017 &
        perc_change_inc > 0.1 ~ 1,
      TRUE ~ 0
    ),
    wealth = case_when(
      med_hh_inc_2017 > quantile(med_hh_inc_2017, 0.6, na.rm = T) ~ 1,
      TRUE ~ 0
    ),
    newwealth = case_when(
      med_hh_inc_2017 > quantile(med_hh_inc_2017, 0.6, na.rm = T) &
        med_hh_inc_2000 < quantile(med_hh_inc_2000, 0.5, na.rm = T) ~ 1,
      TRUE ~ 0
    )
  )

# Calculate variables for Philadelphia area excluding city
discrim_suburb <- discrim_raw %>% 
  filter(countya != 101) %>% 
  mutate(
    p_discrim = presp_white - presp_black ,
    p_white_2000 = pop_white_only_2000/ totalpop_2000,
    p_white_2017 = pop_white_only_2017/ totalpop_2017,
    change_value = med_value_owner_occ_2017 - med_value_owner_occ_2000,
    perc_change_value = change_value/med_value_owner_occ_2000,
    change_inc = med_hh_inc_2017 - med_hh_inc_2000,
    perc_change_inc = change_inc/med_hh_inc_2000,
    change_gross_rent = med_gross_rent_2017 - med_gross_rent_2000,
    perc_change_gross_rent = change_gross_rent/med_gross_rent_2000,
    perc_owner_2000 = house_occ_owner_2000/house_occupied_2000,
    perc_owner_2017 = house_occ_owner_2017/house_occupied_2017,
    change_perc_owner = perc_owner_2017 - perc_owner_2000, 
    med_medhhinc_2000 = median(med_hh_inc_2000, na.rm = T),
    med_medhhinc_2017 = median(med_hh_inc_2017, na.rm = T),
    rentburden_2000 = med_gross_rent_2000*12/med_hh_inc_2000,
    rentburden_2017 = med_gross_rent_2017*12/med_hh_inc_2017,
    change_rentburden = rentburden_2017 - rentburden_2000,
    perc_change_rentburden = change_rentburden /rentburden_2000,
    gentrify_composite = case_when(
      perc_change_value > 0.5 & perc_change_gross_rent > 0.5 &
        perc_change_inc > 0.3 & change_perc_owner > 0 &
        med_hh_inc_2000 < 50000 ~ 1,
      TRUE ~ 0
    ),
    gentrify_housevalue = case_when(
      med_hh_inc_2000 < med_medhhinc_2000 & 
        ((perc_change_value > 1 & change_value > 120000) |
        (perc_change_value > 0.5 & change_value > 150000)) ~ 1,
      TRUE ~ 0
    ),
    gentrify_rentburden = case_when(
      med_hh_inc_2000 < med_medhhinc_2000 &
        ((rentburden_2000 < 0.15 & rentburden_2017 > 0.25) | 
           change_rentburden > 0.2) ~ 1,
      TRUE ~ 0
    ),
    gentrify_income = case_when(
      med_hh_inc_2000 < med_medhhinc_2000 &
        med_hh_inc_2017 > med_medhhinc_2017 &
        perc_change_inc > 0.1 ~ 1,
      TRUE ~ 0
    ),
    wealth = case_when(
      med_hh_inc_2017 > quantile(med_hh_inc_2017, 0.6, na.rm = T) ~ 1,
      TRUE ~ 0
    ),
    newwealth = case_when(
      med_hh_inc_2017 > quantile(med_hh_inc_2017, 0.6, na.rm = T) &
        med_hh_inc_2000 < quantile(med_hh_inc_2000, 0.5, na.rm = T) ~ 1,
      TRUE ~ 0
    )
  )

# Save as RDS and CSV files
write_rds(discrim, "../data/discrim.rds")
write_rds(discrim_city, "../data/discrim_city.rds")
write_rds(discrim_suburb, "../data/discrim_suburb.rds")

discrim %>%
  as_tibble() %>% 
  select(-geometry) %>% 
  write_csv("../data/discrim.csv")

discrim_city %>% 
  st_drop_geometry() %>% 
  write_csv("../data/discrim_city.csv")

discrim_suburb %>% 
  st_drop_geometry() %>% 
  write_csv("../data/discrim_suburb.csv")







