/*******************************************************************************
	Section 0: Get the college counts for pre-imputation, from online table 3.
*******************************************************************************/ 

* Load data.
use "${college_taxyr}", clear
drop if cohort > 1982 | count == .
keep tier super_opeid
drop if tier > 12

* Create counts, including a duplicate to calculate totals.
collapse (first) tier, by(super_opeid)
expand 2, gen(fortotals)
replace tier = 99 if fortotals == 1
drop fortotals
collapse (count) numcollege=super_opeid,  by(tier)

* Label.
g tier_name = ""
replace tier_name = "Ivy Plus"                  if tier==1
replace tier_name = "Other elite schools (public and private)"       if tier==2
replace tier_name = "Highly selective public"   if tier==3
replace tier_name = "Highly selective private"  if tier==4
replace tier_name = "Selective public" 			if tier==5
replace tier_name = "Selective private" 		if tier==6
replace tier_name = "Nonselective four-year public"    if tier==7
replace tier_name = "Nonselective four-year private not-for-profit"   if tier==8
replace tier_name = "Two-year (public and private not-for-profit)" if tier==9
replace tier_name = "Four-year for-profit" 		if tier==10
replace tier_name = "Two-year for-profit" 		if tier==11
replace tier_name = "Less than two-year schools of any type" 		if tier==12
replace tier_name = "All good-quality colleges" if tier==99

* Export.
keep tier_name tier numcollege

tempfile tier_numcollege
save `tier_numcollege', replace

/*******************************************************************************
	Section 1: Provide P(tier Y | par QX) and P(parQX | tier Y) 
		for all tiers and parQs, to mirror the figures for access
*******************************************************************************/


* Load data.
use "${tier_paragi_pooled}", clear

* Drop the 99.9th percentile, who are included in the 99th.
drop if par_pctile == 99.9

* Note quintile.
egen parq = cut(par_pctile), at(0(20)100) ic
replace parq = parq+1

* Duplicate college attending tiers, to calculate totals.
expand 2 if tier<13, gen(fortotals)
replace tier = 99 if fortotals == 1
drop fortotals

* Calculatae proportions in each tier, by quintile.
egen count_tier = total(count), by(tier)
egen count_parq = total(count), by(parq)
egen count_parq_tier = total(count), by(tier parq)
g parq_cond_tier = count_parq_tier/count_tier
collapse (mean) *cond*, by(tier parq)
	
* Check.
egen sum1 = total(1000*parq_cond_tier), by(tier)
assert round(sum1) == 1000
drop sum*
	
* Export.
reshape wide parq_cond_tier, i(tier) j(parq)
generate access60 = parq_cond_tier1 + parq_cond_tier2 + parq_cond_tier3
rename parq_cond_tier1 access20
g tier_name = ""
replace tier_name = "Ivy Plus"                  if tier==1
replace tier_name = "Other elite schools (public and private)"       if tier==2
replace tier_name = "Highly selective public"   if tier==3
replace tier_name = "Highly selective private"  if tier==4
replace tier_name = "Selective public" 			if tier==5
replace tier_name = "Selective private" 		if tier==6
replace tier_name = "Nonselective four-year public"    if tier==7
replace tier_name = "Nonselective four-year private not-for-profit"   if tier==8
replace tier_name = "Two-year (public and private not-for-profit)" if tier==9
replace tier_name = "Four-year for-profit" 		if tier==10
replace tier_name = "Two-year for-profit" 		if tier==11
replace tier_name = "Less than two-year schools of any type" 		if tier==12
replace tier_name = "Attending college with insufficient data" 	if tier==13
replace tier_name = "Late attender (ages 23-28)" 	if tier==14.1
replace tier_name = "Never attended college (before year 2013)" if tier==14.2
replace tier_name = "All good-quality colleges" if tier==99
keep tier_name access*

tempfile tier_parq_crosstabs
save `tier_parq_crosstabs', replace 

/*******************************************************************************
	Section 2: Provide E(Rank | parQX and tier Y), along with the slopes 
		of the best-fit lines to mirror the figures on flat slope
*******************************************************************************/

/*
* Data not public

*/

/*******************************************************************************
	Section 3: Provide count-weighted access, top 20% success, 
		top 20% mobility rate, top 1% success, and 
		top 1% mobility rate for each tier
*******************************************************************************/

* Load data.
use "${tier_paragi_pooled}", clear

* Drop the 99.9th percentile, who are included in the 99th.
drop if par_pctile == 99.9

* Duplicate college attending tiers, to calculate totals (we of course have to
* re-do the counts).
expand 2 if tier<13, gen(fortotals)
replace tier = 99   							  if fortotals == 1
replace tier_name = "All good-quality colleges"   if fortotals == 1
drop fortotals
egen new_tot_count = total(count), by(tier)
replace density = count / new_tot_count if tier == 99

* Note quintile.
egen parq = cut(par_pctile), at(0(20)100) ic
replace parq = parq+1

* Calculate proportion from bottom quintile enrolled, by tier.
egen access = total(density) if parq==1, by(tier)

* Calculate proportion of kids from bottom quintile parents reaching the top
* percentiles, by tier.
egen kq5_cond_parq1     = wtmean(k_q5)     if parq==1, by(tier) weight(count)
egen ktop1pc_cond_parq1 = wtmean(k_top1pc) if parq==1, by(tier) weight(count)

* Collapse data to the tier level, and calculate joint probabilities.
collapse (mean) par_q1=access kq5_cond ktop1pc_cond, by(tier_name)
g mr_kq5_pq1   = par_q1 * kq5_cond
g mr_ktop1_pq1 = par_q1 * ktop1pc_cond

* Export.
drop par_q1
tempfile mobility_summary_BYtier
save `mobility_summary_BYtier', replace

/*******************************************************************************
	Section 4: Provide trend-line slope (multiplied by 11 to give 
		predicted gains over the period) in parq1, bottom 40, 
		and bottom 60 for each tier.
*******************************************************************************/

* Load data, and drop the top percentile.
use "${tier_paragi_cohort}", clear
drop if par_ventile>20

* Duplicate college attending tiers, to calculate totals.
expand 2 if tier<13, gen(fortotals)
replace tier = 99   							  if fortotals == 1
replace tier_name = "All good-quality colleges"   if fortotals == 1
drop fortotals

* Note quintile.
egen parq = cut(par_ventile), at(1(4)21) ic

* Calculate access by tier and cohort.
egen tier_cohort_count    = total(count),             by(tier cohort)
egen q1_tier_cohort_count = total(count) if parq==0 , by(tier cohort)
egen bot40_tier_cohort_count = total(count) if inrange(parq,0,1), by(tier cohort)
egen bot60_tier_cohort_count = total(count) if inrange(parq,0,2), by(tier cohort)
g par_q1       = q1_tier/tier_cohort
g par_bottom40 = bot40/tier_cohort
g par_bottom60 = bot60/tier_cohort
collapse par_q1 par_bottom40 par_bottom60 count=tier_cohort_count, by(tier tier_name cohort)

* Calculate trend-line slopes:
g delta_parq1 = .
g delta_bottom40 = .
g delta_bottom60 = .
* ... by each tier,
levelsof tier
foreach t in `r(levels)' {
	* ... for bottom quinitle of students,
	reg par_q1 cohort [w=count] if tier==`t'
	replace delta_parq1 = 11*_b[cohort] if tier==`t'
	* ... for bottom 40% of students,
	reg par_bottom40 cohort [w=count] if tier==`t'
	replace delta_bottom40 = 11*_b[cohort] if tier==`t'
	* ... and the bottom 60% of students,
	reg par_bottom60 cohort [w=count] if tier==`t'
	replace delta_bottom60 = 11*_b[cohort] if tier==`t'
}
* which we collapse to the tier level.
collapse delta* , by(tier_name)

* Export.
drop delta_bottom40

tempfile access_trends_BYtier
save `access_trends_BYtier', replace

/*******************************************************************************
	Section 5: Median parent income, by tier.
*******************************************************************************/

* Load parent percentile data, and drop the 99.9th percentile.
use "${tier_paragi_pooled}", clear
drop if par_pctile == 99.9

* Note totals among those attending college, and append to other data.
keep if tier < 13
egen  meanpcincome = wtmean(par_mean), by(par_pctile) weight(count)
egen  totalcount   = total(count),     by(par_pctile)
keep par_pctile meanpcincome totalcount
duplicates drop
generate tier_name = "All good-quality colleges"
rename (meanpcincome totalcount) (par_mean count)
replace par_mean = round(par_mean, 100)
append using "${tier_paragi_pooled}"
drop if par_pctile == 99.9

* For each tier, calculate e.d.f.,
sort tier_name par_pctile
egen tiertotal  = total(count), by(tier_name)
by tier_name: gen tiercumsum = sum(count)
gen tierpctile = tiercumsum/tiertotal

* find the percentile which includes the tier-median parent.
sort tier_name par_pctile
generate median = tierpctile > 0.5 & tierpctile[_n-1] < 0.5
keep if median 
keep tier_name par_mean

* and treat the within-percentile mean as the overall median.
rename par_mean par_median

* Export.
tempfile median_parent_BYtier
save `median_parent_BYtier', replace

/*******************************************************************************
	Section 6: Median child earnings, by tier.
*******************************************************************************/

* Load kid percentile data.
use "${tier_kid_pooled}", clear

* Note totals among those attending college, and append to other data.
keep if tier < 13
egen  meankincome = wtmean(k_mean), by(k_pctile) weight(count)
egen  totalcount  = total(count),   by(k_pctile)
keep k_pctile totalcount meankincome
duplicates drop
generate tier_name = "All good-quality colleges"
rename (meankincome totalcount) (k_mean count)
replace k_mean = round(k_mean, 100)
append using "${tier_kid_pooled}"

* For each tier, calculate e.d.f.,
sort tier_name k_pctile
egen tiertotal  = total(count), by(tier_name)
by tier_name: gen tiercumsum = sum(count)
gen tierpctile = tiercumsum/tiertotal

* find the percentile which includes the tier-median kid.
sort tier_name k_pctile
generate median = tierpctile > 0.5 & tierpctile[_n-1] < 0.5
keep if median 
keep tier_name k_mean

* and treat the within-percentile mean as the overall median.
rename k_mean k_median

* Export
tempfile median_kid_BYtier
save `median_kid_BYtier', replace


/*******************************************************************************
	Section 7: Parents from the top 1%, by tier.
*******************************************************************************/

* Load data.
use "${tier_paragi_pooled}", clear
drop if par_pctile == 99.9

* Duplicate college attending tiers, to calculate totals (we of course have to
* re-do the counts).
expand 2 if tier<13, gen(fortotals)
replace tier      = 99 						    if fortotals == 1
replace tier_name = "All good-quality colleges" if fortotals == 1
drop fortotals
egen new_tot_count = total(count), by(tier)
collapse (sum) count (mean) new_tot_count (mean) density, by(tier par_pctile tier_name)
replace density = count / new_tot_count if tier == 99

* Keep data on the top percentile.
keep if par_pctile == 99

* Export.
keep tier_name density
rename density top1percent
label variable top1percent "Proportion of tier with parents in the top 1%."

tempfile top1percent_BYtier
save `top1percent_BYtier', replace

/*******************************************************************************
	Section 8: Count students by tier.
*******************************************************************************/

* Load data.
use "${tier_paragi_pooled}", clear

* Drop the 99.9th percentile, who are included in the 99th.
drop if par_pctile == 99.9

* Duplicate college attending tiers, to calculate totals.
expand 2 if tier<13, gen(fortotals)
replace tier      = 99                          if fortotals == 1
replace tier_name = "All good-quality colleges" if fortotals == 1
drop fortotals

* Collapse and export.
collapse (sum) numstudents=count, by (tier_name tier)
sort tier
keep tier_name numstudents

tempfile tier_numstudents
save `tier_numstudents', replace

/*******************************************************************************
	Combine sections and export.
*******************************************************************************/
clear
use `tier_numcollege'
foreach file in tier_parq_crosstabs      ///
				/*inschool_outcomes_BYtier*/ ///
				mobility_summary_BYtier  ///
				access_trends_BYtier     ///
				median_parent_BYtier     ///
				median_kid_BYtier       ///
				top1percent_BYtier       ///
				tier_numstudents {
	merge 1:1 tier_name using ``file'', nogen
}

sort tier
drop if tier > 99
drop tier
cap order tier_name numcollege numstudents

g slope_inschool = .

foreach var of varlist access20 access60 top1percent kq5_cond_parq1	ktop1pc_cond_parq1	mr_kq5_pq1	mr_ktop1_pq1 {
	replace `var' = `var'*100
}

#delimit ;
local vars tier_name 
		   access20 
		   access60 
		   top1percent 
		   par_median 
		   k_median 
		   slope_inschool 
		   kq5_cond_parq1 
		   ktop1pc_cond_parq1 
		   mr_kq5_pq1 
		   mr_ktop1_pq1 
		   numcollege 
		   numstudents;
#delimit cr

keep `vars'
order `vars'

export delimited using "${tabs}/table2.csv", replace
