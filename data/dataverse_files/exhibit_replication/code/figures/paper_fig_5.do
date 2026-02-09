* Ivy-Plus Attendance Rates and SAT Scores by Parental Income

************************************************************
* Panel A: High-SAT Scorers vs. Ivy-Plus Colleges
************************************************************

use ${rep_data}/paper_fig_5a  , clear

gen parq1 = parq - 0.2 if series == 1 // "Nationwide 1300+ SAT-scorers"
gen parq2 = parq + 0.2 if series == 2 // "Ivy-Plus enrollees"

#delimit ;
twoway (bar q parq1, barw(0.4) color(cranberry*.8))
		(bar q parq2, barw(0.4) color("0 32 96"))
	, ylabel( , nogrid) 
	xlabel(1(1)5)
	legend(col(1) pos(6) ring(6) order(1 "Nationwide 1300+ SAT-scorers" 2 "Ivy-Plus actual")) 
	ytitle("Share of Students (%)") 
	xtitle("Parent Income Quintile")
	ylabel(0(10)70)
	graphregion(margin(t+2))
	;
# delimit cr

graph export "${figs}/paper_fig_5a.${image_suffix}", replace


************************************************************
* Panel B: Ivy-Plus Attendance Rates for Students with an SAT/ACT Score of 1400
************************************************************

use ${rep_data}/paper_fig_5b  , clear
	
* Switches
local par_bin pctile

* Calculate average
foreach series in 1400 {
		sum ivy_rate_`series' [aw = cnt_`series' ] , d
		local yline_`series' = `r(mean)'
}

** x axis
local pctile_xcale "0 99"
local pctile_xlabel " "

** y axis
local att_ivy_plus_ytitle   "Probability of Attending an Ivy Plus (%)"
local yscale "`r(min)'(5)`r(max)'"


** Only 1400 scorers
#delimit ;
twoway (lowess ivy_rate_1400 par_agi_pctile , lc(navy) bwidth(.2))
	(scatter ivy_rate_1400 par_agi_pctile, mc(navy) 					  
	title(" ")											  
	ytitle("Share attending an Ivy-Plus college")							  
	xtitle("Parent Income Percentile")							  
	ysc(r(5(5)25))
	xsc(r(``par_bin'_xscale'))			                  
	xlabel(``par_bin'_xlabel')		                      
	graphregion(color("white")) bgcolor(white)			  
	legend( off )										      
	yline(`yline_1400', lp(dash) lc(black))
	)
	;
#delimit cr

graph export "${figs}/paper_fig_5b.${image_suffix}", replace
