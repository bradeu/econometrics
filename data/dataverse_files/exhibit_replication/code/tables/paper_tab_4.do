* Panel A
* Top 10 Colleges by Mobility Rate (Top 20%) 
use "${college_collapse}", clear

* Combine colleges in CUNY
egen mean_success = wtmean(kq5_cond_parq1) if inlist(super,7273,2688,7022, ///
	2693,2696,2687,2689,2690,4759,8611,2691,10051,2692,2697,10097,2694,2698), ///
	weight(count * par_q1)
keep if inlist(super,7273,2688,7022,2693,2696,2687,2689,2690,4759,8611,2691,10051,2692,2697,10097,2694,2698)
collapse (mean) mr_kq5_pq1 par_q1 kq5_cond_parq1=mean_success (rawsum) count [w=count]
gen super_opeid = 9999
gen name = "CUNY System"
tempfile temp
save `temp'
use "${college_collapse}", clear
drop if super_opeid < 0
drop if inlist(super,7273,2688,7022,2693,2696,2687,2689,2690,4759,8611,2691,10051,2692,2697,10097,2694,2698)
keep super_opeid name mr_kq5_pq1 par_q1 kq5_cond_parq1 count
append using `temp'

* Export top 10
foreach v of varlist mr_kq5_pq1 par_q1 kq5_cond_parq1{
	replace `v' = `v'*100
}

cap drop _merge
merge 1:1 super_opeid using ${closed_supers}, keepusing(super_opeid)
drop if _merge == 3 | _merge == 2
drop _merge

gsort -mr_kq5_pq1
preserve
keep if count >= 300
keep if _n <= 10
keep super name mr_kq5_pq1 par_q1 kq5_cond_parq1 
list super name 

gen panel = "A"
gen row = _n
order super name par_q1 kq5_cond_parq1 mr_kq5_pq1

export delimited using "${tabs}/table4a.csv", replace

restore

* Panel B
* Top 10 Colleges by Upper-Tail Mobility Rate (Top 1%) 
use "${college_collapse}", clear

* Combine colleges in CUNY
egen mean_success = wtmean(ktop1pc_cond_parq1) if inlist(super,7273,2688,7022, ///
	2693,2696,2687,2689,2690,4759,8611,2691,10051,2692,2697,10097,2694,2698), ///
	weight(count * par_q1)
keep if inlist(super,7273,2688,7022,2693,2696,2687,2689,2690,4759,8611,2691,10051,2692,2697,10097,2694,2698)
collapse (mean) mr_ktop1_pq1 par_q1 ktop1pc_cond_parq1=mean_success (rawsum) count [w=count]
gen super_opeid = 9999
gen name = "CUNY System"
tempfile temp
save `temp'
use "${college_collapse}", clear
drop if super_opeid < 0
drop if inlist(super,7273,2688,7022,2693,2696,2687,2689,2690,4759,8611,2691,10051,2692,2697,10097,2694,2698)
keep super_opeid name mr_ktop1_pq1 par_q1 ktop1pc_cond_parq1 count
append using `temp'

* Export top 10
foreach v of varlist mr_ktop1_pq1 par_q1 ktop1pc_cond_parq1{
	replace `v' = `v'*100
}

cap drop _merge
merge 1:1 super_opeid using ${closed_supers}, keepusing(super_opeid)
drop if _merge == 3 | _merge == 2
drop _merge

gsort -mr_ktop1_pq1

preserve
keep if count >= 300
keep if _n <= 10 
keep  super name mr_ktop1_pq1 par_q1 ktop1pc_cond_parq1 
list super name

gen panel = "B"
gen row = _n + 10
order super name par_q1 ktop1pc_cond_parq1 mr_ktop1_pq1

export delimited using "${tabs}/table4b.csv", replace
restore
