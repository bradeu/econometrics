* Fraction of Children who Reach Top Quintile by Parent Income Rank

************************************************************
* Panel A: Q5 bins from Algo by school
************************************************************
use ${rep_data}/appx_paper_fig_3a , clear

* Slopes
reg truepts rhs if super==1312 [w=people]
local berk : di %4.3f _b[rhs]
reg truepts rhs if super==2838 [w=people]
local suny : di %4.3f _b[rhs]
reg truepts rhs if super==1203 [w=people]
local glen : di %4.3f _b[rhs]

#delimit ;
tw 	(scatter k_q5 par_pctile, color(gs10) msiz(small)) 
	(scatter truepts rhs if super==1312, msiz(small) color("118 145 169") ms(circle_hollow)) (lfit truepts rhs if super==1312, color("118 145 169")) 
	(scatter truepts rhs if super==2838, msiz(small) color("119 145 89") ms(triangle)) (lfit truepts rhs if super==2838, color("119 145 89")) 
	(scatter truepts rhs if super==1203, msiz(small) color("233 152 51") ms(triangle_hollow)) (lfit truepts rhs if super==1203, color("233 152 51")) 
	, title(" ") ytitle("Percentage of Children in Top Income Quintile") xtitle("Parent Rank") 
	yscale(range(0 70)) ylab(00(10)70) xscale(range(0 105)) xlab(0(20)100) 
	legend(order(1 2 4 6) c(1) pos(4) region(color(none)) ring(0) 
		lab(1 "National") 
		lab(2 "UC Berkeley (Slope: `berk')") 
		lab(4 "SUNY Stony Brook (Slope: `suny')") 
		lab(6 "Glendale CC (Slope: `glen')"))
	;
#delimit cr
graph export "$figs/app_paper_fig_3a.$image_suffix", replace

************************************************************
* Panel B: Q5 bins by tier
************************************************************
use ${rep_data}/appx_paper_fig_3b , clear

* Slopes
reg truepts rhs if group==1 [w=count]
local elite : di %4.3f _b[rhs] 
reg truepts rhs if group==2 [w=count]
local other4yr: di %4.3f _b[rhs]
reg truepts rhs if group==3 [w=count]
local twoyr : di %4.3f _b[rhs]

#delimit ;
tw 	(scatter k_q5 par_pctile, color(gs10) msiz(small)) 
	(scatter truepts rhs if group==1, msiz(small) color("118 145 169") ms(circle_hollow)) (lfit truepts rhs if group==1, color("118 145 169")) 
	(scatter truepts rhs if group==2, msiz(small) color("119 145 89") ms(triangle)) (lfit truepts rhs if group==2, color("119 145 89")) 
	(scatter truepts rhs if group==3, msiz(small) color("233 152 51") ms(triangle_hollow)) (lfit truepts rhs if group==3, color("233 152 51")) 
	, title(" ") ytitle("Percentage of Children in Top Income Quintile") xtitle("Parent Rank") 
	yscale(range(0 70)) ylab(00(10)70) xscale(range(0 105)) xlab(0(20)100) 
	legend(order(1 2 4 6) c(1) pos(4) region(color(none)) ring(0) 
		lab(1 "National") 
		lab(2 "Elite Colleges (Slope: `elite')") 
		lab(4 "Other 4-Year Colleges (Slope: `other4yr')") 
		lab(6 "2-Year Colleges (Slope: `twoyr')"))
	;
#delimit cr
graph export "$figs/app_paper_fig_3b.$image_suffix", replace

