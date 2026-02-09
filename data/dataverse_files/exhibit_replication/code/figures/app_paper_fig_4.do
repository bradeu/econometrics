* National Rank-ranks for different income definitions

use ${rep_data}/appx_paper_fig_4 , clear

foreach v of varlist k_wagse_rank k_wagse_hh k_agi {
	reg `v' par [w=count]
	local slope_`v' : di %4.3f _b[par]
	}

#delimit ;
tw (scatter k_wagse_rank par, color(navy) msiz(small)) (lfit k_wagse_rank par [w=count], color(navy)) 
	(scatter k_wagse_hh par, color(maroon) msiz(small) ms(triangle)) (lfit k_wagse_hh par [w=count], color(maroon)) 
	(scatter k_agi par, color(forest_green) msiz(small) ms(circle_hollow)) (lfit k_agi par [w=count], color(forest_green)) 
	, title(" ") xtitle(Parent Rank) ytitle(Child Rank) 
	yscale(range(30 80)) ylab(30(10)80) xscale(range(0 105)) xlab(0(20)100) 
	legend(ring(0) pos(4) c(1) region(color(none)) order(1 3 5) 
		lab(1 "Individual Earnings (Slope: `slope_k_wagse_rank_2014')") 
		lab(3 "Household Earnings (Slope: `slope_k_wagse_hh_rank_2014')") 
		lab(5 "Household Income (Slope: `slope_k_agi_rank_2014')"))
;
#delimit cr

graph export "${figs}/app_paper_fig_4.${image_suffix}", replace

