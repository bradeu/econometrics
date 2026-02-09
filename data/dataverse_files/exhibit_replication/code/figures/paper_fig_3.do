* Relationship Between Children’s and Parents’ Ranks within Colleges

************************************************************
* Panel A: National Averages
************************************************************
use ${rep_data}/paper_fig_3a , clear

#delimit ;
tw (scatter coef_noFE par_rank)
    (lfit coef_noFE par_rank, lcolor(navy))
    (scatter coef_superFE par_rank, mcolor(cranberry) ms(t))
    (lfit coef_superFE par_rank, lcolor(cranberry))
	(scatter coef_supersatFE par_rank, mcolor(dkgreen) ms(s))
    (lfit coef_supersatFE par_rank, lcolor(dkgreen))
    ,
    ytitle("Child Rank")
    xtitle("Parent Rank")
    legend( region(color(none)) lab(1 "National (slope: .288)")
    	   lab(3 "with College Fixed Effects (slope: .139)")
		   lab(5 "with College*SAT/ACT Fixed Effects (slope: .125)")
    	   row(3) /*span*/ order(1 3 5) lcolor(white)
		   ring(0) position(4) bmargin(l+4 b+2 r-4))
	plotregion(fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white))
;
#delimit cr
graph export "${figs}/paper_fig_3a.${image_suffix}", replace

************************************************************
* Panel B: Individual-School Binscatter Points
************************************************************
use ${rep_data}/paper_fig_3b , clear

* Slopes
reg k_rank par_pctile [w=count]
local nat : di %4.3f _b[par_pctile]
reg truepts rhs if super==1312 [w=people]
local berk : di %4.3f _b[rhs]
reg truepts rhs if super==2838 [w=people]
local suny : di %4.3f _b[rhs]
reg truepts rhs if super==1203 [w=people]
local glen : di %4.3f _b[rhs]

tw (scatter k_rank par_pctile, color(gs10) msiz(small))	(lfit k_rank par_pctile [w=count], color(gs10)) ///
	(scatter truepts rhs if super==1312, msiz(small) color("118 145 169") ms(circle_hollow)) (lfit truepts rhs if super==1312, color("118 145 169")) ///
	(scatter truepts rhs if super==2838, msiz(small) color("119 145 89") ms(triangle)) (lfit truepts rhs if super==2838, color("119 145 89")) ///
	(scatter truepts rhs if super==1203, msiz(small) color("233 152 51") ms(triangle_hollow)) (lfit truepts rhs if super==1203, color("233 152 51")) ///
	, title(" ") ytitle("Child Rank") xtitle("Parent Rank") ///
	yscale(range(30 80)) ylab(30(10)80) xscale(range(0 105)) xlab(0(20)100) ///
	legend(order(1 3 5 7) c(1) pos(4) ring(0) region(color(none)) ///
		lab(1 "National (Slope: `nat')") ///
		lab(3 "UC Berkeley (Slope: `berk')") ///
		lab(5 "SUNY Stony Brook (Slope: `suny')") ///
		lab(7 "Glendale CC (Slope: `glen')"))

graph export "${figs}/paper_fig_3b.${image_suffix}", replace


************************************************************
* Panel C: Aggregated Binscatter Points
************************************************************
use ${rep_data}/paper_fig_3c , clear


* Note: draw slopes from rank-rank table 
*       (inside regressions inside regs account for within bin variation)
tw (scatter k_rank par_pctile , color(gs10) msiz(small)) (lfit k_rank par_pctile, color(gs10) msiz(small)) ///
	(scatter truepts  rhs if group==1, color("118 145 169") msiz(small) ms(circle_hollow)) (lfit truepts  rhs if group==1, color("118 145 169")) ///
	(scatter truepts  rhs if group==2, color("119 145 89") msiz(small) ms(triangle)) (lfit truepts  rhs if group==2, color("119 145 89")) ///
	(scatter truepts  rhs if group==3, color("233 152 51") msiz(small) ms(triangle_hollow)) (lfit truepts  rhs if group==3, color("233 152 51")) ///
	, title(" ") xtitle(Parent Rank) ytitle(Child Rank) ///
	yscale(range(30 80)) ylab(30(10)80) xscale(range(0 105)) xlab(0(20)100) ///
	legend(order(1 3 5 7) ring(0) c(1) pos(4) ///
		lab(1 "National (Slope: `nat')") lab(3 "Elite Colleges (Slope: 0.065)") ///
		lab(5 "Other Four-Year Colleges (Slope: 0.095)") lab(7 "Two-Year (Slope: 0.110)"))
	
graph export "$figs/paper_fig_3c.${image_suffix}", replace

