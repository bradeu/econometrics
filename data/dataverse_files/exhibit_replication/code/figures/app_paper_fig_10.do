********************************************************************************
* Study how the share of upper-quartile kids changes as the share of Asian kids
* changes.
*
********************************************************************************

local adjustment 0.2351 

** Produce figure.

* Load college collapse.
use $college_collapse, clear
keep if super > 0

* Merge on proportion of Asian students.
merge 1:1 super using $covariates, keepusing(asian*) keep(match) nogen
rename asian asian_share 
* Binscatter the relationship.
binscatter k_q5 asian_share [w=count], n(20) genxq(ventile) 
* Calculate within-group means, to binscatter manually.
egen x_ventile_mean = wtmean(asian_share), weight(count) by(ventile)
egen y_ventile_mean = wtmean(k_q5),        weight(count) by(ventile)
replace x_ventile_mean = 100*x_ventile_mean 
replace y_ventile_mean = 100*y_ventile_mean 
su x_ventile_mean if ventile == 1
local bin1_xmean = r(mean)
su y_ventile_mean if ventile == 1
local bin1_ymean = r(mean)
* Add a 45 degree line from the left-most dot.
generate upperbound1 = 1*(x_ventile_mean      - `bin1_xmean') + `bin1_ymean'
* Add a 0.2344 line from the left-most dot.
generate upperbound2 = `adjustment'*(x_ventile_mean - `bin1_xmean') + `bin1_ymean'

* Binscatter the relationship (manually, so we can add the upper bound lines).
#delimit ;
twoway 	(scatter y_ventile_mean x_ventile_mean, ms(circle))  				
		(line    upperbound1    x_ventile_mean, c(1) sort)   				
	, legend(label(1 "Empirical Values") label(2 "Non-Parametric Bound") 				
		   ring(0) pos(5) c(1)) 	 				
	ylab(10(10)50) ytitle("Percentage of Students with Earnings in Top Quintile") 		
	xlab(0(5)35) xtitle("Percentage of Asian Students") 									
	title(" ")
	;
#delimit cr
	
graph export "${figs}/app_paper_fig_10.${image_suffix}", replace



** Produce correlations between adjusted and actual mobility rate.
generate mobility = kq5_cond_parq1 * par_q1

* Create Asian-adjusted success rate.
generate adjusted_success  = max(kq5_cond_parq1 - `adjustment'*asian_share, 0) if asian_share != .
generate adjusted_mobility = adjusted_success * par_q1

* Note correlation between adjusted and unadjusted mobility.
corr adjusted_mobility mobility [w=count]
	
* Note correlation between adjusted and unadjusted mobility in California.
corr adjusted_mobility mobility [w=count] if state=="CA"

* Note correlation between unadjusted mobility and Asian shares.
corr mobility asian_share [w=count] if (multi==0|super==129|super==216) 

* Note correlation between adjusted mobility and Asian shares.
corr adjusted_mobility asian_share [w=count] if (multi==0|super==129|super==216) 
