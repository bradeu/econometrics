* Parental Income and College Attendance


************************************************************
* Panel A: College Attendance by Parent Income Percentile
************************************************************

use ${rep_data}/paper_fig_1a  , clear

* Produce and export graph.
#delimit ;
twoway (scatter cg22_80 par_agi, c(l) msize(small))  
	   ,
	legend(off)
	xtitle("Parent Rank") 
	ytitle("Percentage Attended College") 
	ylabel(0(20)100) 
	title(" ")
	;
#delimit cr
graph export "${figs}/paper_fig_1a.${image_suffix}", replace

gen quint = floor(par_agi_pctile/20) + 1
collapse (mean) cg22_80, by(quint)
list

************************************************************
* Panel B: Distribution of Parent Incomes at Various Schools
************************************************************

use "${college_collapse}", clear

/* Relevant Super-OPEIDs:
	* Harvard = 129
	* UC Berkeley = 1312
	* SUNY Stony Brook = 2838
	* Glendale Community College = 1203
*/

keep name super par_q* par_top1pc
reshape long par_q, i(super par_top1pc name) j(quintile)

foreach q of varlist par_q* par_top1pc {
	replace `q' = `q'*100
}

g xaxis = .
replace xaxis = quintile - 0.3 if super==129
replace xaxis = quintile - 0.1 if super==1312
replace xaxis = quintile + 0.1 if super==2838
replace xaxis = quintile + 0.3 if super==1203

replace par_top1pc = . if quintile!=5 
 
tw (bar par_q xaxis if super==129, color("126 32 57") barw(0.2)) ///
	(bar par_q xaxis if super==1312, color("85 111 133") barw(0.2)) ///
	(bar par_q xaxis if super==2838, color("128 157 97") barw(0.2)) ///
	(bar par_q xaxis if super==1203, color("244 203 154") barw(0.2)) ///
	(bar par_top1 xaxis if super==129, color("126 32 57") fi(50) barw(0.2)) ///
	(bar par_top1 xaxis if super==1312, color("85 111 133") fi(50) barw(0.2)) ///
	(bar par_top1 xaxis if super==2838, color("128 157 97") fi(50) barw(0.2)) ///
	(bar par_top1 xaxis if super==1203, color("244 203 154") fi(50) barw(0.2)) ///
	, title(" ") xtitle("Parent Income Quintile") ytitle("Percent of Students") ///
	legend(order(1 2 3 4) c(1) ring(0) pos(11) region(color(none)) ///
		lab(1 "Harvard University") lab(2 "UC Berkeley") ///
		lab(3 "SUNY-Stony Brook") lab(4 "Glendale Community College")) ///
	text(30 4 "Top 1%", size(*1.2))
graph export "${figs}/paper_fig_1b.${image_suffix}", replace

list name par_top1pc par_q if quintile==5 & inlist(super,129,1312,2838,1203)

******************************************************
* Panel C: Parent Income distributions at all Ivy Plus
******************************************************

use "${tier_paragi_pooled}", clear
keep if tier==1
drop if par_pctile > 99
collapse (rawsum) count, by(par_pctile) 
egen tot_count = total(count)
g pct_count = 100*count/tot_count

sum pct_count if inrange(par_pctile,0,99)
local pct_mean = r(mean)

egen bot20 = total(pct_count) if inrange(par_pctile,0,19)
sum bot20
local b20 : di %3.1f r(mean)

sum pct_count if par_pctile==99
local top1 : di %3.1f r(mean)

tw connect pct_count par_pctile if inrange(par_pctile,0,99), ///
	msiz(small)  ///
	title(" ") ytitle("Percent of Students") xtitle("Parent Rank") ///
	plotregion(margin(b=0)) ///
	text(3 22 "`b20'% of students from bottom 20%" ///
		14 60 "`top1'% of students from top 1%")
graph export "${figs}/paper_fig_1c.${image_suffix}", replace


