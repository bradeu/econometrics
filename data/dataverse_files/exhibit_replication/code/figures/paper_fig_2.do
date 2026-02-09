* Income Segregation across Colleges vs. Pre-College Neighborhoods


* Load data
use ${rep_data}/paper_fig_2 , clear

************************************************************
* Panel A: Peers of Children from Bottom Quintile
************************************************************

local cond pq==1
local panel a

#delimit ;
graph bar (asis) peers_pqResidential peers_pqCollege if `cond',
	  over(parq)
	  ytitle("Share of Peers (%)")
	  b1title("Peers' Parent Income Quintile")
	  bar(1, color("0 32 96")) bar(2, color("169 209 142"))
	  legend(lab(1 "Pre-College Neighborhoods (ZIP Codes)")
			 lab(2 "Colleges")
			 row(1) span)
;
#delimit cr

graph export "${figs}/paper_fig_2`panel'.${image_suffix}", replace

************************************************************
* Panel B: Peers of Children from Top Quintile
************************************************************

local cond pq==5&ivies==0
local panel b

#delimit ;
graph bar (asis) peers_pqResidential peers_pqCollege if `cond',
	  over(parq)
	  ytitle("Share of Peers (%)")
	  b1title("Peers' Parent Income Quintile")
	  bar(1, color("0 32 96")) bar(2, color("169 209 142"))
	  legend(lab(1 "Pre-College Neighborhoods (ZIP Codes)")
			 lab(2 "Colleges")
			 row(1) span)
;
#delimit cr

graph export "${figs}/paper_fig_2`panel'.${image_suffix}", replace

************************************************************
* Panel C: Peers of Ivy-Plus College Students from Top Quintile
************************************************************

local cond ivies==1
local panel c

#delimit ;
graph bar (asis) peers_pqResidential peers_pqCollege if `cond',
	  over(parq)
	  ytitle("Share of Peers (%)")
	  b1title("Peers' Parent Income Quintile")
	  bar(1, color("0 32 96")) bar(2, color("169 209 142"))
	  legend(lab(1 "Pre-College Neighborhoods (ZIP Codes)")
			 lab(2 "Colleges")
			 row(1) span)
;
#delimit cr

graph export "${figs}/paper_fig_2`panel'.${image_suffix}", replace
