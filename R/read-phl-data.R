## Read Philadelphia Discrimination Data

# Load packages
library(tidyverse); library(vroom); library(janitor); 
library(sf); library(tigris)

# Read csv and preview
philly <- vroom("../data/phl_data.csv") %>% rename(fips_tract = FIPStract)
glimpse(philly)

# Extract County FIPS code from longer tract strings
philly2 <- philly %>% 
  mutate(ctyfips = str_sub(fips_tract, 1, 5))

philly2$ctyfips %>% unique() # Check counties in data

# Counties/FIPS codes:
# Bucks - 42017;
# Chester - 42029;
# Delaware - 42045;
# Montgomery - 42091;
# Philadelphia - 42101


# Load shape files
shapes <- tracts(state = 'PA', county = c("Bucks", "Chester", "Delaware", "Montgomery", "Philadelphia")) %>% 
  clean_names() %>% 
  mutate(fips_tract = as.numeric(paste0(statefp, countyfp, tractce)))

# Merge discrimination data with shape file
philly_tracts <- full_join(philly, shapes) %>%
  mutate(included = if_else(is.na(p_white), 0, 1)) %>% 
  st_as_sf()

# Save data
write_rds(philly_tracts, "../data/philly_tracts.rds")

# Preview which tracts are included in experiment
ggplot(philly_tracts) +
  geom_sf(aes(fill = as.factor(included))) +
  scale_fill_manual(values = c("#6EA9E2", "#EE5ED1")) +
  labs(title = "Tracts Included in Christensen & Timmins (2020)", fill = "Included") +
  theme_bw()



