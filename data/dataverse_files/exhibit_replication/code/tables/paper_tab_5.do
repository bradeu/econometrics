set more off


use "${college_collapse}", clear
drop if super < 0
keep if (multi==0|super==129|super==216) 


local list_covs pct_stem_2000 public grad_rate_150_p_2002 ///
	sticker_price_2000 scorecard_netprice_2013 exp_instr_pc_2000 ///
	avgfacsal_2001 endowment_pc_2000 ipeds_enrollment_2000 ///
	asian_or_pacific_share_fall_2000 black_share_fall_2000 ///
	hisp_share_fall_2000
	
	
	
*merge on co-variates
merge 1:1 super_opeid using "${covariates}", keepusing(`list_covs' barrons) keep(match)



* generate ranks
xtile rank_mr = 1/mr_kq5 [w=count], n(100)
xtile rank_parq1 = 1/par_q1 [w=count], n(100)
xtile rank_cond = 1/kq5_cond_parq1 [w=count*par_q1], n(100)
* upper tail
xtile rank_mr_top1 = 1/mr_ktop1 [w=count], n(100)
xtile rank_cond_top1 = 1/ktop1pc_cond_parq1 [w=count*par_q1], n(100)

* selectivity public/private
label list label_tier
g sel = .
replace sel = 1 if tier==1 // Ivy Plus
replace sel = 2 if tier==2 // Other Elite
replace sel = 3 if barrons==2 // Highly Selective
replace sel = 4 if inlist(barrons,3,4,5) // Selective
replace sel = 5 if inlist(barrons,9,999) // Non-Selective
label var sel "Selectivity"

local list_sel sel 

preserve
	clear
	
	tempfile table
	save `table', replace emptyok
restore

local list_correlation mobility lowinc topquint

local mobility_covs_var_a mr_kq5_pq1
local mobility_sel_var_a rank_mr

local lowinc_covs_var_a par_q1
local lowinc_sel_var_a rank_parq1

local topquint_covs_var_a kq5_cond_parq1
local topquint_sel_var_a rank_cond

local mobility_covs_var_b mr_ktop1_pq1
local mobility_sel_var_b rank_mr_top1

local lowinc_covs_var_b par_q1
local lowinc_sel_var_b rank_parq1

local topquint_covs_var_b ktop1pc_cond_parq1
local topquint_sel_var_b rank_cond_top1

** Weight variables
local mobility_wt "count"
local lowinc_wt "count"
local topquint_wt "count*par_q1"

qui {
foreach panel in a b {

	foreach correlation in `list_correlation' {

		foreach var in `list_covs' {

				if "`correlation'" == "mobility" & "`panel'" == "a" {
					* Standardize outcome and covariate on pairawise set of obs.
					su ``correlation'_covs_var_`panel'' [aw=``correlation'_wt'] 
					gen eb = (``correlation'_covs_var_`panel'' - r(mean))/r(sd) if ~missing(``correlation'_covs_var_`panel'') & ~missing(`var')
					su `var'  [aw=``correlation'_wt'] if ~missing(``correlation'_covs_var_`panel'') & ~missing(`var')
					gen vb = (`var' - r(mean))/r(sd)
				}
				if "`correlation'" == "mobility" & "`panel'" == "b" {
					* Standardize outcome and covariate on pairawise set of obs.
					su ``correlation'_covs_var_`panel'' [aw=``correlation'_wt'] if ~missing(``correlation'_covs_var_`panel'') & ~missing(`var')
					gen eb = (``correlation'_covs_var_`panel'' - r(mean))/r(sd) 
					su `var'  [aw=``correlation'_wt'] if ~missing(``correlation'_covs_var_`panel'') & ~missing(`var')
					gen vb = (`var' - r(mean))/r(sd)
				}
				if "`correlation'" == "lowinc" {
					* Standardize outcome and covariate on pairawise set of obs.
					su ``correlation'_covs_var_`panel'' [aw=``correlation'_wt'] if ~missing(``correlation'_covs_var_`panel'') & ~missing(`var')
					gen eb = (``correlation'_covs_var_`panel'' - r(mean))/r(sd) 
					su `var'  [aw=``correlation'_wt'] if ~missing(``correlation'_covs_var_`panel'') & ~missing(`var')
					gen vb = (`var' - r(mean))/r(sd)
				}
				if "`correlation'" == "topquint" {
					* Standardize outcome and covariate on pairawise set of obs.
					su ``correlation'_covs_var_`panel'' [aw=``correlation'_wt'] if ~missing(``correlation'_covs_var_`panel'') & ~missing(`var')
					gen eb = (``correlation'_covs_var_`panel'' - r(mean))/r(sd) 
					su `var'  [aw=``correlation'_wt'] if ~missing(``correlation'_covs_var_`panel'') & ~missing(`var')
					gen vb = (`var' - r(mean))/r(sd)
				}

				* Regress and obtain correlation coefficient
				reg eb vb  [aw=``correlation'_wt'] , robust
				noi di "``correlation'_covs_var_`panel''"
				noi di `"`: var label `var''"' 
				noi di in red round(_b[vb],.01)
				noi di in red = round(_se[vb],.001)
				qui drop eb vb
				
				preserve
					clear
					set obs 1
					gen var = "`var'"
					gen corr = "`correlation'"
					gen panel = "`panel'"
					gen coef = round(_b[vb],.01)
					gen se = round(_se[vb],.001)
					
					append using `table'
					save `table' , replace
				restore
				
		}
		
		foreach var in `list_sel' {

			if "`correlation'" == "mobility" {
				* Standardize outcome and covariate on pairawise set of obs.
				qui su ``correlation'_sel_var_`panel'' [aw=``correlation'_wt']
				qui gen eb = (``correlation'_sel_var_`panel'' - r(mean))/r(sd) if ~missing(``correlation'_sel_var_`panel'') & ~missing(`var')
				qui su `var' [aw=``correlation'_wt'] if ~missing(``correlation'_sel_var_`panel'') & ~missing(`var')
				qui gen vb = (`var' - r(mean))/r(sd)
			}
			if "`correlation'" == "lowinc" {
				* Standardize outcome and covariate on pairawise set of obs.
				qui su ``correlation'_sel_var_`panel'' [aw=``correlation'_wt']
				qui gen eb = (``correlation'_sel_var_`panel'' - r(mean))/r(sd) if ~missing(``correlation'_sel_var_`panel'') & ~missing(`var')
				qui su `var' [aw=``correlation'_wt'] if ~missing(``correlation'_sel_var_`panel'') & ~missing(`var')
				qui gen vb = (`var' - r(mean))/r(sd)
			}
			if "`correlation'" == "topquint" {
				* Standardize outcome and covariate on pairawise set of obs.
				qui su ``correlation'_sel_var_`panel'' [aw=``correlation'_wt']
				qui gen eb = (``correlation'_sel_var_`panel'' - r(mean))/r(sd) if ~missing(``correlation'_sel_var_`panel'') & ~missing(`var')
				qui su `var' [aw=``correlation'_wt'] if ~missing(``correlation'_sel_var_`panel'') & ~missing(`var')
				qui gen vb = (`var' - r(mean))/r(sd)
			}

			* Regress and obtain correlation coefficient
			qui reg eb vb [aw=``correlation'_wt'], robust
			noi di "``correlation'_sel_var_`panel''"
			noi di `"`: var label `var''"' 
			noi di in red round(_b[vb],.01)
			noi di in red = round(_se[vb],.001)
			qui drop eb vb
			
			preserve
				clear
				set obs 1
				gen var = "`var'"
				gen corr = "`correlation'"
				gen panel = "`panel'"
				gen coef = round(_b[vb],.01)
				gen se = round(_se[vb],.001)
				
				append using `table'
				save `table' , replace
			restore
			
		}
	}
}

}
use `table' , clear


* clean and order
reshape wide coef se , i(var panel) j(corr) string

rename coef* *_coef
rename se* *_se
order panel var lowinc_coef lowinc_se topquint_coef topquint_se mobility_coef mobility_se


gen var_wt = 1 if var == "pct_stem_2000"
replace var_wt = 2 if var == "public"
replace var_wt = 3 if var == "sel"
replace var_wt = 4 if var == "grad_rate_150_p_2002"
replace var_wt = 5 if var == "sticker_price_2000"
replace var_wt = 6 if var == "scorecard_netprice_2013"
replace var_wt = 7 if var == "exp_instr_pc_2000"
replace var_wt = 8 if var == "avgfacsal_2001"
replace var_wt = 9 if var == "endowment_pc_2000"
replace var_wt = 10 if var == "ipeds_enrollment_2000"
replace var_wt = 11 if var == "asian_or_pacific_share_fall_2000"
replace var_wt = 12 if var == "black_share_fall_2000"
replace var_wt = 13 if var == "hisp_share_fall_2000"


sort panel var_wt
drop var_wt


outsheet using $tabs/table5.csv, comma replace
