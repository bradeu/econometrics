estimates clear

* Summary Stats for Main College Collapse. Median Earnings stats for
* parent and kid earnings should come from inside the IRS environment. 
* Non-college goer columns use the true data from the tiers, college goer
* columns use the publically released data.

********************************************************************************
* Using the tier data, loop over two subsets: all children and non-college goers.
use "${tier_paragi_pooled}", clear

drop if par_pctile == 99.9

* First subset to get total coll goers
foreach subset in 1 tier>13 {

	di ""
	di ""
	di "TABLE FOR `subset'"
	di ""
	di ""

	preserve
	keep if `subset'

	* Count people.
	egen total_count = total(count)

	* Count people attending different classifications of colleges.
	egen attending_college 			= total(count * inrange(tier,1,13))
	egen attending_college_insample = total(count * inrange(tier,1,12))
	egen attending_ivy 				= total(count * (tier == 1))
	egen attending_other_elite 		= total(count * (tier == 2))
	egen attending_other_four_year  = total(count * inlist(tier,3,4,5,6,7,8,10))
	egen attending_two_year_less 	= total(count * inlist(tier,9,11,12))
	egen never_attending         	= total(count * (tier == 14.2))

	* Calculate proportions attending different classifications of colleges.
	gen prop_attending_college          = attending_college          / total_count
	gen prop_attending_college_insample = attending_college_insample / total_count
	gen prop_attending_ivy              = attending_ivy              / total_count
	gen prop_attending_other_elite      = attending_other_elite      / total_count
	gen prop_attending_other_four_year  = attending_other_four_year  / total_count
	gen prop_attending_two_year_less    = attending_two_year_less    / total_count
	gen prop_never_attending            = never_attending            / total_count

	* Calculate parent/kid earning conditionals and joints.
	egen par_q1			= total(count*(par_pctile<20))
	egen par_q1_kid_q5  = total(count*(par_pctile<20)*k_q5)
	egen par_q1_kid_p99 = total(count*(par_pctile<20)*k_top1pc)
	generate kq5_cond_parq1_mean  = par_q1_kid_q5  / par_q1
	generate kp99_cond_parq1_mean = par_q1_kid_p99 / par_q1
	generate kq5_joint_parq1  = par_q1_kid_q5  / total_count 
	generate kp99_joint_parq1 = par_q1_kid_p99 / total_count

	* Calculate employment rate, parent/kid mean income/earnings, and positional
	* statistics.
	egen employment 		= wtmean(1-k_nowork),      weight(count)
	egen par_mean_overall   = wtmean(par_mean),        weight(count) 
	egen par_q1_overall		= wtmean(par_pctile<20),   weight(count) 
	egen par_q5_overall		= wtmean(par_pctile>79),   weight(count) 
	egen par_top1pc_overall	= wtmean(par_pctile==99),  weight(count)
	egen k_mean_overall     = wtmean(k_mean),          weight(count)   
	egen k_q5_overall       = wtmean(k_q5),            weight(count)   
	egen k_top1pc_overall   = wtmean(k_top1pc),        weight(count)   
		   
	* Count proportion of sample included.
	if "`subset'" == "1" local total_attending_college = attending_college[1]
	gen prop_covered = total_count / `total_attending_college'
	
	if "`subset'" == "tier>13" replace prop_attending_college = .
	if "`subset'" == "tier>13" replace prop_attending_college_insample = .
	

	* Present statistics in a table.
	eststo: estpost summarize ///
			prop_attending_college ///
			prop_attending_college_insample ///
			prop_never_attending ///
			par_mean_overall ///
			k_mean_overall ///
			employment ///
			total_count, ///
			meanonly
			
	restore
}


********************************************************************************
* Using the college collapse, loop over two subsets: all college goers in the
* data release except imputed schools and all college goers in the data release.
use "$college_collapse", clear
foreach subset in (tier<13)&(imputed==0) tier<13 {

	di ""
	di ""
	di "TABLE FOR `subset'"
	di ""
	di ""

	preserve
	keep if `subset'

	* Count people.
	egen total_count = total(count)

	* Count people attending different classifications of colleges.
	egen attending_college 			= total(count * inrange(tier,1,13))
	egen attending_college_insample = total(count * inrange(tier,1,12))
	egen attending_ivy 				= total(count * (tier == 1))
	egen attending_other_elite 		= total(count * (tier == 2))
	egen attending_other_four_year 	= total(count * inlist(tier,3,4,5,6,7,8,10))
	egen attending_two_year_less 	= total(count * inlist(tier,9,11,12))
	egen never_attending         	= total(count * (super_opeid == -9))

	* Calculate proportions attending different classifications of colleges.
	gen prop_attending_college 			= attending_college          / total_count
	gen prop_attending_college_insample = attending_college_insample / total_count
	gen prop_attending_ivy 				= attending_ivy 			 / total_count
	gen prop_attending_other_elite 		= attending_other_elite      / total_count
	gen prop_attending_other_four_year 	= attending_other_four_year  / total_count
	gen prop_attending_two_year_less 	= attending_two_year_less    / total_count
	gen prop_never_attending            = never_attending            / total_count

	* Calculate parent/kid earning conditionals and joints.
	egen kq5_cond_parq1_mean  = wtmean(kq5_cond_parq1),  weight(count * par_q1)
	egen kp99_cond_parq1_mean = wtmean(k_top1pc),        weight(count * par_q1)
	egen kq5_joint_parq1   = wtmean(kq5_cond_parq1     * par_q1),      weight(count)
	egen kp99_joint_parq1  = wtmean(ktop1pc_cond_parq1 * par_q1),      weight(count)

	* Calculate parent/kid mean income/earnings, and positional statistics.
	egen par_mean_overall   = wtmean(par_mean),   weight(count) 
	egen par_q1_overall		= wtmean(par_q1),     weight(count) 
	egen par_q5_overall		= wtmean(par_q5),     weight(count) 
	egen par_top1pc_overall	= wtmean(par_top1pc), weight(count)   
	egen k_mean_overall     = wtmean(k_mean),     weight(count)   
	egen k_q5_overall       = wtmean(k_q5),       weight(count)   
	egen k_top1pc_overall   = wtmean(k_top1pc),   weight(count)   

	* Calculate employment rate.
	egen employment 		= wtmean(1-k_0), weight(count)
		   
	* Replace total count with an count more comparable to the three-year sample.
	replace total_count = total_count*3

	* Count proportion of sample included.
	if "`subset'" == "imputed<1" ///
							local total_attending_college = attending_college[1]
	gen prop_covered = total_count / (3*`total_attending_college')
	
	if "`subset'" == "tier<13" replace prop_attending_college = .
	if "`subset'" == "tier<13" replace prop_attending_college_insample = .
	if "`subset'" == "tier<13" replace prop_never_attending = .

	* Present statistics in a table.
	eststo: estpost summarize ///
			prop_attending_college ///
			prop_attending_college_insample ///
			prop_never_attending ///
			par_mean_overall ///
			k_mean_overall ///
			employment ///
			total_count, ///
			meanonly 
			
	restore
}

********************************************************************************
* Export:
esttab est1 est4 est2 using "$tabs/table1_slim.csv", 					///
	replace cells(mean(fmt(%12.0g))) noobs plain collabels("")		    ///
	mtitles("all" "imputed" "non-goers")
*log close


insheet using $tabs/table1_slim.csv, clear 
drop if _n == 1
rename v1 statistic

gen rownum = _n
replace rownum = rownum + 12 if rownum > 5
replace rownum = 11 if rownum == 5

tempfile table1_slim_clean
save `table1_slim_clean', replace

rm ${tabs}/table1_slim.csv

* Get percentile threshold earnings
use "${cutoffs}", clear

keep if inrange(cohort, 1980, 1982)
keep if pctile < 99.4
keep if pctile == 20 | pctile == 40 | pctile == 60 | pctile == 80 | pctile == 99
collapse (mean) par_hh_inc k_indv_earn, by(pctile)
list

* Clean up to send to CSV
rename par_hh_inc  allparent
rename k_indv_earn allkid

reshape long all, i(pctile) j(generation, string)

gsort -generation pctile 
tostring pctile, force replace
gen statistic = generation + "_" + pctile + "th_pctile_earnings"

keep statistic all
order statistic all

gen rownum = _n 
replace rownum = rownum + 7 if rownum > 5
replace rownum = rownum + 5 if rownum < 6

list

append using `table1_slim_clean'

* Reorder rows
sort rownum
drop rownum

outsheet using $tabs/table1.csv, comma replace
