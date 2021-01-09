***
* Ryan Hastings
* EJ Paper
* Preliminary Regressions
***

clear 

cd "C:\Users\ryanh\Box\Philly Discrimination Empirical Work\philly-discrim\STATA"

import delimited "C:\Users\ryanh\Box\Philly Discrimination Empirical Work\philly-discrim\data\discrim_city.csv"

drop if presp_white == "NA"
drop if med_value_owner_occ_2017 == "NA"

destring presp_white presp_black med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, replace

regress presp_white gentrify_composite med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022_city.doc, replace

regress presp_black gentrify_composite med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022_city.doc, append


regress presp_white gentrify_housevalue med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022_city.doc, append

regress presp_black gentrify_housevalue med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022_city.doc, append


regress presp_white gentrify_rentburden med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022_city.doc, append

regress presp_black gentrify_rentburden med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022_city.doc, append


regress presp_white gentrify_income med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022_city.doc, append

regress presp_black gentrify_income med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022_city.doc, append


********

clear 

import delimited "C:\Users\ryanh\Box\Philly Discrimination Empirical Work\philly-discrim\data\discrim.csv"


drop if presp_white == "NA"
drop if med_value_owner_occ_2017 == "NA"

destring presp_white presp_black med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, replace

regress presp_white gentrify_composite med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022.doc, replace

regress presp_black gentrify_composite med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022.doc, append


regress presp_white gentrify_housevalue med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022.doc, append

regress presp_black gentrify_housevalue med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022.doc, append


regress presp_white gentrify_rentburden med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022.doc, append

regress presp_black gentrify_rentburden med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022.doc, append


regress presp_white gentrify_income med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022.doc, append

regress presp_black gentrify_income med_value_owner_occ_2017 p_white tract_assault_all tract_high_schol_score tract_nata_respiratory_hazard p_higherthan_highschool, robust
outreg2 using reg1022.doc, append