* Major Distributions
use "${college_collapse}", clear
merge 1:1 super using "${covariates}", keepusing(pct_art-pct_trade)
replace multi=0 if inlist(super,129,216) // include Harvard and OSU
drop if _m==2
drop _m
g mr_q5 = par_q1*kq5_cond_parq1

global majors pct_arthuman pct_health pct_multidisci pct_publicsocial pct_socialscience ///
	pct_tradepersonal pct_business pct_stem 


sum kq5_cond_parq1 if tier==1 [w=count*par_q1], d
local low = r(p10)
local high = r(p90)
g ivy_range = inrange(kq5_cond_parq1,`low'-0.001, `high'+0.001) //Note this code uses the 2nd highest and 2nd lowest to define the range, as we do for top 1% stats
sum mr_q5 [w=count] if multi==0, d
g high_mr = mr_q5>r(p90)


***************************************
* Panel A: All Colleges vs Top MR Decile
***************************************
preserve
collapse (mean) ${majors} [w=count] if multi==0, by(high_mr)
	
* Shares of each major
foreach v of global majors {
	sum `v' if !high_mr
	local all_`v' : di %3.1f r(mean)
	sum `v' if high_mr
	local high_`v' : di %3.1f r(mean)
}
#delimit ;
graph bar (asis) ${majors}, stack over(high_mr, label(angle(0)) relabel(1 "All Other Colleges" 2 "High Mobility Rate Colleges")) 
	ytitle("Pct. of Degree Awards by Major in 2000 (%)") title(" ") bar(1, color("16 45 72")) bar(2, color("45 78 137")) 
	 bar(3, color("64 109 190")) bar(4, color("99 131 201"))  
	  bar(5, color("143 162 212")) bar(6, color("173 185 221")) 
	   bar(7, color("198 206 230")) bar(8, color("230 230 230")) 
	   legend(c(2) order(8 7 6 5 4 3 2 1) 
		lab(1 "Arts and Humanities") 
		lab(2 "Health and Medicine") 
		lab(3 "Multi/Interdisciplinary Studies") 
		lab(4 "Public and Social Services") 
		lab(5 "Social Sciences") 
		lab(6 "Trades and Personal Services") 
		lab(7 "Business") 
		lab(8 "STEM")) 
	text(	95 25 "STEM = `all_pct_stem'%" 
			78 24 "Business = `all_pct_business'%" 
			94 78 "STEM = `high_pct_stem'%" 
			75 77 "Business = `high_pct_business'%" )
	;
#delimit cr
graph export "${figs}/app_paper_fig_5a.${image_suffix}", replace
restore


***************************************
* Panel B: Ivy Colleges vs Ivy-level Top MR Decile
***************************************
preserve
collapse (mean) ${majors} [w=count] if multi==0 & ivy_range==1 & (tier==1 | high_mr==1), by(high_mr)
	
* Shares of each major
foreach v of global majors {
	sum `v' if !high_mr
	local all_`v' : di %3.1f r(mean)
	sum `v' if high_mr
	local high_`v' : di %3.1f r(mean)
}

#delimit ;
graph bar (asis) ${majors}, stack over(high_mr, label(angle(0)) relabel(1 "Ivy-Plus Colleges" 2 `" "High Mobility Rate Colleges with" "Success Rate Similar to Ivy-Plus""')) 
	ytitle("Pct. of Degree Awards by Major in 2000 (%)") title(" ") bar(1, color("16 45 72")) bar(2, color("45 78 137")) 
	 bar(3, color("64 109 190")) bar(4, color("99 131 201"))  
	  bar(5, color("143 162 212")) bar(6, color("173 185 221")) 
	   bar(7, color("198 206 230")) bar(8, color("230 230 230")) 
	legend(c(2) order(8 7 6 5 4 3 2 1) 
		lab(1 "Arts and Humanities") 
		lab(2 "Health and Medicine") 
		lab(3 "Multi/Interdisciplinary Studies") 
		lab(4 "Public and Social Services") 
		lab(5 "Social Sciences") 
		lab(6 "Trades and Personal Services") 
		lab(7 "Business") 
		lab(8 "STEM")) 
		text(	84 25 "STEM = `all_pct_stem'%" 
				70 46 "Business"  
				63 47 "= `all_pct_business'%" 
				85 78 "STEM = `high_pct_stem'%" 
				63 80 "Business = `high_pct_business'%" )
		;
#delimit cr
graph export "${figs}/app_paper_fig_5b.${image_suffix}", replace
restore
