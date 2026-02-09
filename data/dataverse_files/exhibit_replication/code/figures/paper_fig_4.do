* Children’s Outcomes vs. Fraction of Low Income Students, by College

************************************************************
* Panel A: Top Quintile Outcomes - Ivy-Plus and Public Flagships
************************************************************
use "${college_collapse}", clear
keep if super>0
merge 1:1 super using "${covariates}", nogen keepusing(tier flagship)
g kq5_parq1 = kq5_cond_parq1 * par_q1

foreach v of varlist kq5_cond_parq1 par_q1 kq5_parq1 {
	replace `v'= `v'*100
}

sum kq5_parq1 [w=count], d
local p10 : di %3.1f r(p10)
local p50 : di %3.1f r(p50)
local p90 : di %3.1f r(p90)
local p10_line = r(p10)*100
local p50_line = r(p50)*100
local p90_line = r(p90)*100
local allmean : di %3.1f r(mean)
local allsd : di %3.2f r(sd)

sum kq5_parq1 [w=count] if tier==1
local ivymean : di %3.1f r(mean)

sum kq5_parq1 [w=count] if flagship==1
local flagmean : di %3.1f r(mean)

#delimit ;
tw (scatter kq5_cond_parq1 par_q1 if par_q1<60, msize(vsmall) mcol(gs10)) 
	(scatter kq5_cond_parq1 par_q1 if tier==1, color(blue) msiz(small)) 
	(scatter kq5_cond_parq1 par_q1 if flagship==1, color(maroon) msiz(small) ms(triangle)) 
	(function y=`p10_line'/x, range(1.8 55) color(gs7)) 
	(function y=`p50_line'/x, range(2 55) color(gs7)) 
	(function y=`p90_line'/x, range(3.5 55) color(gs7)) 
	, title(" ") ytitle("Top-Quintile Outcome Rate: P(Child in Q5 | Par in Q1)") 
	xtitle("Fraction Low-Income: Percent of Parents in Bottom Quintile")  
	xscale(range(0 60)) xlab(0(20)60) 
	legend(order(2 3) c(1) pos(3) ring(0) 
		lab(2 "Ivy Plus Colleges (Avg. MR = `ivymean'%)") 
		lab(3 "Public Flagships (Avg. MR = `flagmean'%)")) 
	text(95 15 "MR = `p90'% (90th Percentile)" 
		82 11 "MR = `p50'% (50th Percentile)" 
		0 11 "MR = `p10'% (10th Percentile)" 
		70 39 "MR = Top-Quintile Outcome Rate x Fraction Low-Income" 
		65 55 "SD of MR = `allsd'%")
	;
#delimit cr
graph export "${figs}/paper_fig_4a.${image_suffix}", replace


************************************************************
* Panel B: Top Percentile Outcomes - Ivy-Plus and Public Flagships
************************************************************
use "${college_collapse}", clear
keep if super>0
merge 1:1 super using "${covariates}", nogen keepusing(tier flagship)
g ktop1_parq1 = ktop1pc_cond_parq1 * par_q1

foreach v of varlist ktop1pc_cond_parq1 par_q1 ktop1_parq1 {
	replace `v'= `v'*100
}

sum ktop1_parq1 [w=count], d
local p10 : di %3.2f r(p10)
local p50 : di %3.2f r(p50)
local p90 : di %3.2f r(p90)
local p10_line = r(p10)*100
local p50_line = r(p50)*100
local p90_line = r(p90)*100
local allmean : di %3.1f r(mean)
local allsd : di %3.2f r(sd)

sum ktop1_parq1 [w=count] if tier==1
local ivymean : di %3.1f r(mean)

sum ktop1_parq1 [w=count] if flagship==1
local flagmean : di %3.1f r(mean)

di in red `p10'
di in red `p50'
di in red `p90'
#delimit ;
tw (scatter ktop1pc_cond_parq1 par_q1 if par_q1<60 & ktop1pc_cond_parq1<20, msize(vsmall) mcol(gs10)) 
	(scatter ktop1pc_cond_parq1 par_q1 if tier==1, color(blue) msize(small)) 
	(scatter ktop1pc_cond_parq1 par_q1 if flagship==1, color(maroon) msize(small) ms(triangle)) 
	(function y=`p10_line'/x, range(1.3 55) color(gs7)) 
	(function y=`p50_line'/x, range(1 55) color(gs7)) 
	(function y=`p90_line'/x, range(1 55) color(gs7)) 
	, title(" ") ytitle("Top-Percentile Outcome Rate: P(Child in Top1 | Par in Q1)") 
	xtitle("Fraction Low-Income: Percent of Parents in Bottom Quintile") 
	xscale(range(0 60)) xlab(0(10)60) 
	legend(order(2 3) c(1) pos(3) ring(0) 
		lab(2 "Ivy-Plus Colleges (Avg. UMR = `ivymean'%)") 
		lab(3 "Public Flagships (Avg. UMR = `flagmean'%)")) 
	text(16 13 "UMR = `p90'% (90th Percentile)" 
		1 50 "UMR = `p50'% (50th Percentile)" 
		14 33 "Upper-Tail MR = Top-Percentile Outcome Rate x Fraction Low-Income" 
		13 51 "SD of UMR = `allsd'%")
	;
#delimit cr
graph export "${figs}/paper_fig_4b.${image_suffix}", replace
