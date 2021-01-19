***
* Ryan Hastings
* EJ Paper
* Matching
***

*** 2000 Control Group
*Set up and load file
clear 
cd "C:\Users\ryanh\Box\Philly Discrimination Empirical Work\philly-discrim\STATA"
import delimited "C:\Users\ryanh\Box\Philly Discrimination Empirical Work\philly-discrim\data\discrim_city.csv"

*Drop NA's
drop if presp_white == "NA"
drop if med_value_owner_occ_2017 == "NA"
drop if p_white_2000 == "NA"

*Destring numeric variables
destring p_discrim presp_white presp_black p_white p_black p_white_2000 med_hh_inc_2000  med_value_owner_occ_2000 med_gross_rent_2000 perc_owner_2000 med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, replace

*Set variable vectors
global treatment gentrify_composite
global ylist p_discrim
global xlist p_white_2000 med_hh_inc_2000 med_gross_rent_2000 perc_owner_2000  
*med_value_owner_occ_2000

*Summary statistics and preliminary regressions
bysort $treatment : summarize $ylist $xlist
reg $ylist $treatment
reg $ylist $treatment $xlist

*Propensity score matching
pscore $treatment $xlist, pscore(myscore) blockid(myblock) comsup
attnd $ylist $treatment $xlist, pscore(myscore) comsup dots
psmatch2 $treatment $xlist, outcome(p_discrim) neighbor(2) logit odds
bootstrap r(att): psmatch2 $treatment $xlist, outcome(p_discrim) neighbor(2) logit odds


********

***2017 Control Group
*Set up and load data
clear 
import delimited "C:\Users\ryanh\Box\Philly Discrimination Empirical Work\philly-discrim\data\discrim_city.csv"

*Drop NA's
drop if presp_white == "NA"
drop if med_value_owner_occ_2017 == "NA"
drop if med_gross_rent_2017 == "NA"

*Destring numeric variables
destring presp_white presp_black med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool p_discrim p_white_2017 med_hh_inc_2017 med_gross_rent_2017 perc_owner_2017, replace

*Set variable vectors
global treatment gentrify_composite
global ylist p_discrim
global xlist p_white_2017 med_hh_inc_2017 med_gross_rent_2017 perc_owner_2017  

*Summary statistics and preliminary regressions
bysort $treatment : summarize $ylist $xlist
reg $ylist $treatment
reg $ylist $treatment $xlist

*Propensity score matching
pscore $treatment $xlist, pscore(myscore) blockid(myblock) comsup
attnd $ylist $treatment $xlist, pscore(myscore) comsup dots
psmatch2 $treatment $xlist, outcome(p_discrim) neighbor(2) logit odds
bootstrap r(att): psmatch2 $treatment $xlist, outcome(p_discrim) neighbor(2) logit odds

*****************
* Match using teffects
*teffects psmatch (presp_white) (gentrify_composite med_value_owner_occ_2017 p_white), atet nneighbor(2)
*regress presp_white gentrify_composite med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
*outreg2 using reg1111_city.doc, replace

*teffects nnmatch (presp_white med_value_owner_occ_2017 p_white) (gentrify_composite)


