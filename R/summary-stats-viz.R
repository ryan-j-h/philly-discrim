# Summary Statistics and Visualizations

## Load packages and data
library(tidyverse); library(sf); library(knitr)
discrim <- read_rds("../data/discrim.rds")
discrim_city <- read_rds("../data/discrim_city.rds")
discrim_suburb <- read_rds("../data/discrim_suburb.rds")
census <- read_rds("../data/census.rds")

## Discrimination Summary Statistics

#### City
ss_city <- discrim_city %>% 
  st_drop_geometry() %>% 
  summarize(
    "Mean White"= mean(presp_white, na.rm = T),
    "SD White" = sd(presp_white, na.rm = T),
    "Mean Black" = mean(presp_black, na.rm = T),
    "SD Black" = sd(presp_black, na.rm = T),
    "Mean Gap" = mean(p_discrim, na.rm = T),
    "SD Gap" = sd(p_discrim, na.rm = T)
  ) %>%   t()

#### Suburbs
ss_suburb <- discrim_suburb %>% 
  st_drop_geometry() %>% 
  summarize(
    "Mean White"= mean(presp_white, na.rm = T),
    "SD White" = sd(presp_white, na.rm = T),
    "Mean Black" = mean(presp_black, na.rm = T),
    "SD Black" = sd(presp_black, na.rm = T),
    "Mean Gap" = mean(p_discrim, na.rm = T),
    "SD Gap" = sd(p_discrim, na.rm = T)
  ) %>% t()

cbind(ss_city, ss_suburb) %>% 
  kable(format = "markdown", col.names = c("City", "Suburbs"))


## Discrimination Maps
plot(discrim["presp_white"], main = "Percent Response to White Inquirers")
plot(discrim["presp_black"], main = "Percent Response to Black Inquirers")
plot(discrim["p_discrim"], main = "Response Gap")

plot(discrim_city["presp_white"], main = "Percent Response to White Inquirers")
plot(discrim_city["presp_black"], main = "Percent Response to Black Inquirers")
plot(discrim_city["p_discrim"], main = "Response Gap")


## Gentrification Summary Statistics

#### City
ss2_city <- discrim_city %>% 
  st_drop_geometry() %>%
  filter(!is.na(presp_white)) %>% 
  summarize(
    "Total" = n(),
    "Gentrify Composite" = sum(gentrify_composite),
    "Gentrify Income" = sum(gentrify_income),
    "Gentrify Value" = sum(gentrify_housevalue)
  ) %>% 
  t()

#### Suburbs
ss2_suburb <- discrim_suburb %>% 
  st_drop_geometry() %>%
  filter(!is.na(presp_white)) %>% 
  summarize(
    "Total" = n(),
    "Gentrify Composite" = sum(gentrify_composite),
    "Gentrify Income" = sum(gentrify_income),
    "Gentrify Value" = sum(gentrify_housevalue)
  ) %>% 
  t()

cbind(ss2_city, ss2_suburb) %>% 
  kable(format = "markdown", col.names = c("City", "Suburbs"))


### Demographic Characteristics BY Gentrify Composite

backup_options <- options()
options(scipen=999)

#### City
ss3_city <- discrim_city %>% 
  st_drop_geometry() %>%
  filter(!is.na(presp_white)) %>% 
  group_by(gentrify_composite) %>% 
  summarize(
    "Total" = n(),
    "Mean White Response"= mean(presp_white, na.rm = T),
    "Mean Black Response" = mean(presp_black, na.rm = T),
    "Mean Response Gap" = mean(p_discrim, na.rm = T),
    "Mean Income 2000" = mean(med_hh_inc_2000, na.rm = T),
    "Mean Income 2017" = mean(med_hh_inc_2017, na.rm = T),
    "Mean Value 2000" = mean(med_value_owner_occ_2000, na.rm = T),
    "Mean Value 2017" = mean(med_value_owner_occ_2017, na.rm = T),
    "Mean Gross Rent 2000" = mean(med_gross_rent_2000, na.rm = T),
    "Mean Gross Rent 2017" = mean(med_gross_rent_2017, na.rm = T),
    "Mean Owner Occupied 2000" = mean(perc_owner_2000, na.rm = T),
    "Mean Owner Occupied 2017" = mean(perc_owner_2017, na.rm = T)
  ) %>% t() %>% 
  round(digits = 2) %>% 
  kable(format = "markdown")

ss3_city

#### Suburbs
ss3_suburb <- discrim_suburb %>% 
  st_drop_geometry() %>%
  filter(!is.na(presp_white)) %>% 
  group_by(gentrify_composite) %>% 
  summarize(
    "Total" = n(),
    "Mean White Response"= mean(presp_white, na.rm = T),
    "Mean Black Response" = mean(presp_black, na.rm = T),
    "Mean Response Gap" = mean(p_discrim, na.rm = T),
    "Mean Income 2000" = mean(med_hh_inc_2000, na.rm = T),
    "Mean Income 2017" = mean(med_hh_inc_2017, na.rm = T),
    "Mean Value 2000" = mean(med_value_owner_occ_2000, na.rm = T),
    "Mean Value 2017" = mean(med_value_owner_occ_2017, na.rm = T),
    "Mean Gross Rent 2000" = mean(med_gross_rent_2000, na.rm = T),
    "Mean Gross Rent 2017" = mean(med_gross_rent_2017, na.rm = T),
    "Mean Owner Occupied 2000" = mean(perc_owner_2000, na.rm = T),
    "Mean Owner Occupied 2017" = mean(perc_owner_2017, na.rm = T)
  ) %>% t() %>% 
  round(digits = 2) %>%
  kable(format = "markdown")

ss3_suburb

### Demographic Characteristics BY Gentrify Income

backup_options <- options()
options(scipen=999)

#### City
ss4_city <- discrim_city %>% 
  st_drop_geometry() %>%
  filter(!is.na(presp_white)) %>% 
  group_by(gentrify_income) %>% 
  summarize(
    "Total" = n(),
    "Mean White Response"= mean(presp_white, na.rm = T),
    "Mean Black Response" = mean(presp_black, na.rm = T),
    "Mean Response Gap" = mean(p_discrim, na.rm = T),
    "Mean Income 2000" = mean(med_hh_inc_2000, na.rm = T),
    "Mean Income 2017" = mean(med_hh_inc_2017, na.rm = T),
    "Mean Value 2000" = mean(med_value_owner_occ_2000, na.rm = T),
    "Mean Value 2017" = mean(med_value_owner_occ_2017, na.rm = T),
    "Mean Gross Rent 2000" = mean(med_gross_rent_2000, na.rm = T),
    "Mean Gross Rent 2017" = mean(med_gross_rent_2017, na.rm = T),
    "Mean Owner Occupied 2000" = mean(perc_owner_2000, na.rm = T),
    "Mean Owner Occupied 2017" = mean(perc_owner_2017, na.rm = T)
  ) %>% t() %>% 
  round(digits = 2) %>% 
  kable(format = "markdown")

ss4_city

#### Suburbs
ss4_suburb <- discrim_suburb %>% 
  st_drop_geometry() %>%
  filter(!is.na(presp_white)) %>% 
  group_by(gentrify_income) %>% 
  summarize(
    "Total" = n(),
    "Mean White Response"= mean(presp_white, na.rm = T),
    "Mean Black Response" = mean(presp_black, na.rm = T),
    "Mean Response Gap" = mean(p_discrim, na.rm = T),
    "Mean Income 2000" = mean(med_hh_inc_2000, na.rm = T),
    "Mean Income 2017" = mean(med_hh_inc_2017, na.rm = T),
    "Mean Value 2000" = mean(med_value_owner_occ_2000, na.rm = T),
    "Mean Value 2017" = mean(med_value_owner_occ_2017, na.rm = T),
    "Mean Gross Rent 2000" = mean(med_gross_rent_2000, na.rm = T),
    "Mean Gross Rent 2017" = mean(med_gross_rent_2017, na.rm = T),
    "Mean Owner Occupied 2000" = mean(perc_owner_2000, na.rm = T),
    "Mean Owner Occupied 2017" = mean(perc_owner_2017, na.rm = T)
  ) %>% t() %>% 
  round(digits = 2) %>%
  kable(format = "markdown")

ss4_suburb

### Demographic Characteristics BY Gentrify House Value
backup_options <- options()
options(scipen=999)

#### City

ss5_city <- discrim_city %>% 
  st_drop_geometry() %>%
  filter(!is.na(presp_white)) %>% 
  group_by(gentrify_housevalue) %>% 
  summarize(
    "Total" = n(),
    "Mean White Response"= mean(presp_white, na.rm = T),
    "Mean Black Response" = mean(presp_black, na.rm = T),
    "Mean Response Gap" = mean(p_discrim, na.rm = T),
    "Mean Income 2000" = mean(med_hh_inc_2000, na.rm = T),
    "Mean Income 2017" = mean(med_hh_inc_2017, na.rm = T),
    "Mean Value 2000" = mean(med_value_owner_occ_2000, na.rm = T),
    "Mean Value 2017" = mean(med_value_owner_occ_2017, na.rm = T),
    "Mean Gross Rent 2000" = mean(med_gross_rent_2000, na.rm = T),
    "Mean Gross Rent 2017" = mean(med_gross_rent_2017, na.rm = T),
    "Mean Owner Occupied 2000" = mean(perc_owner_2000, na.rm = T),
    "Mean Owner Occupied 2017" = mean(perc_owner_2017, na.rm = T)
  ) %>% t() %>% 
  round(digits = 2) %>% 
  kable(format = "markdown")

ss5_city

#### Suburbs

ss5_suburb <- discrim_suburb %>% 
  st_drop_geometry() %>%
  filter(!is.na(presp_white)) %>% 
  group_by(gentrify_housevalue) %>% 
  summarize(
    "Total" = n(),
    "Mean White Response"= mean(presp_white, na.rm = T),
    "Mean Black Response" = mean(presp_black, na.rm = T),
    "Mean Response Gap" = mean(p_discrim, na.rm = T),
    "Mean Income 2000" = mean(med_hh_inc_2000, na.rm = T),
    "Mean Income 2017" = mean(med_hh_inc_2017, na.rm = T),
    "Mean Value 2000" = mean(med_value_owner_occ_2000, na.rm = T),
    "Mean Value 2017" = mean(med_value_owner_occ_2017, na.rm = T),
    "Mean Gross Rent 2000" = mean(med_gross_rent_2000, na.rm = T),
    "Mean Gross Rent 2017" = mean(med_gross_rent_2017, na.rm = T),
    "Mean Owner Occupied 2000" = mean(perc_owner_2000, na.rm = T),
    "Mean Owner Occupied 2017" = mean(perc_owner_2017, na.rm = T)
  ) %>% t() %>% 
  round(digits = 2) %>%
  kable(format = "markdown")

ss5_suburb


## Gentrification Maps

plot(discrim_city["gentrify_composite"])
plot(discrim_city["gentrify_income"])
plot(discrim_city["gentrify_housevalue"])

plot(discrim_suburb["gentrify_composite"])
plot(discrim_suburb["gentrify_income"])
plot(discrim_suburb["gentrify_housevalue"])


## Other (Miscellaneous or Not Used)
hist(discrim$perc_change_value)
median(discrim$perc_change_value, na.rm=T)

hist(discrim$perc_change_gross_rent)
median(discrim$perc_change_gross_rent, na.rm=T)

hist(discrim$perc_change_inc)
median(discrim$perc_change_inc, na.rm=T)

hist(discrim$change_perc_owner)
median(discrim$change_perc_owner, na.rm=T)

median(discrim$med_hh_inc_2000, na.rm=T)

discrim %>%
  group_by(gentrify) %>% 
  summarize(mean(presp_black, na.rm = T),
            mean(presp_white, na.rm = T))

ggplot(discrim)+
  geom_histogram(aes(x = presp_black), binwidth = 0.1)+
  facet_wrap(vars(gentrify)) +
  theme_bw()

ggplot(discrim)+
  geom_histogram(aes(x = presp_white), binwidth = 0.1)+
  facet_wrap(vars(gentrify)) +
  theme_bw()





