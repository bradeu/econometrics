* Ivy-Plus Attendance Rates by Parental Income Conditional on SAT/ACT Scores

* Switches
local par_bin pctile

** x axis
local pctile_xcale "0 99"
local pctile_xlabel " "

** y axis
local att_ivy_plus_ytitle   "Probability of Attending an Ivy Plus (%)"
local yscale "`r(min)'(5)`r(max)'"

use ${rep_data}/appx_paper_fig_7 , clear

foreach series in ivy 1500_pooled 1400  {
		local yvar ivy_rate_`series'	
		
		if "`series'" == "ivy" {
			sum mean_`yvar'
			local yline_`series' = round(`r(mean)', 0.1)
		}
		if "`series'" != "ivy" {
			di "`series'"
			sum ivy_rate_`series' [aw = cnt_`series' ] , d
			local yline_`series' = `r(mean)'
		}
}

************************************************************
* Panel A: 1400, 1500 series
************************************************************

#delimit ;
twoway (lowess ivy_rate_1400 par_agi_pctile , lc(navy) bwidth(.2))
	(lowess ivy_rate_1500_pooled par_agi_pctile, lc(cranberry) bwidth(.2))
	(scatter ivy_rate_1400 par_agi_pctile, mc(navy) )
	(scatter ivy_rate_1500_pooled par_agi_pctile , mc(cranberry) msymbol(triangle)	
	title(" ")											  
	ytitle("Share attending an Ivy-Plus college")							  
	xtitle("Parent Income Percentile")							  
	ysc(r(5(5)30))
	xsc(r(``par_bin'_xscale'))			                  
	xlabel(``par_bin'_xlabel')		                      
	graphregion(color("white")) bgcolor(white)			  
	legend(order(4 3) label(3 "Children with a 1400 SAT/ACT") 
		label(4 "Children with a 1500 SAT/ACT") 
		rows(3) )										      
	yline(`yline_1500_pooled', lp(dash) lc(black))
	yline(`yline_1400', lp(dash) lc(black))
	)
	;
#delimit cr

graph export "${figs}/app_paper_fig_7a.${image_suffix}", replace


************************************************************
* Panel B: Ivy reweighting series	
************************************************************

#delimit ;
twoway
	(lowess ivy_rate_ivy par_agi_pctile, lc(navy) bwidth(.2))
	(scatter ivy_rate_ivy par_agi_pctile , mc(navy)						  
	title(" ")											  
	ytitle("Share attending an Ivy-Plus college")							  
	xtitle("Parent Income Percentile")							  
	ysc(r(5(5)30))
	xsc(r(``par_bin'_xscale'))			                  
	xlabel(``par_bin'_xlabel')		                      
	graphregion(color("white")) bgcolor(white)			  
	legend( off )										      
	yline(`yline_ivy', lp(dash) lc(black))
	)
	;
#delimit cr

graph export "${figs}/app_paper_fig_7b.${image_suffix}", replace

