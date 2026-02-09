
*************************************
* Metafile - College Paper
*************************************
set more off
set matsize 800

set scheme leap_slides

global root "${replication_folder}"  


*************
* Code
*************
global code ${root}/code
global fig_code ${code}/figures
global tab_code ${code}/tables

*************
* Output
*************
* Figures output directory
global output ${root}/output
global figs ${output}/figures
global tabs ${output}/tables

*************
* Input
*************
global input ${root}/input

* Published online datatables
global data ${input}/online_tables
* Figure replication input
global rep_data ${input}/replication


* College collapse
global college_collapse "${data}/mrc_table2.dta" 

* College collapse by tax year
global college_taxyr "${data}/mrc_table3.dta" 

* College collapse robustness checks
global robustness "${data}/mrc_table4.dta"

* Table 5: Robustness by Cohort
global robustness_cohort "${data}/mrc_table5.dta"

* Tier-Paragi - pooled
global tier_paragi_pooled "${data}/mrc_table6.dta"

* Tier kid-wagse 
global tier_kid_pooled "${data}/mrc_table7.dta"

* Paragi tier by cohort - quintile
global tier_paragi_cohort "${data}/mrc_table8.dta"

* Cutoffs
global cutoffs "${data}/mrc_table9.dta"

* College Covariates 
global covariates "${data}/mrc_table10.dta"

* OPEID - Super-OPEID crosswalk
global cross "${data}/mrc_table11.dta"

* Normed Parent Income and Mobility Rate Estimates
global normed "${data}/mrc_table14.dta"

* Close Super-OPEIDs
global closed_supers "${data}/mrc_table15.dta"



* Counterfactuals
global cbaa_adj 160
