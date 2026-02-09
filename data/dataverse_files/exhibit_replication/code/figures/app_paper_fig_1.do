* Fraction of kids who have attended college at any point by age (19 to 31,
* baseline cohorts) by parent ventile.

use ${rep_data}/appx_paper_fig_1 , clear

#delimit ;
tw scatter inby_22 inby_28 inby_32 par_v , color(navy maroon forest_green) ms(circle circle_hollow triangle_hollow) connect(l l l) 
	title(" ") xtitle("Parent Rank") ytitle("Percent of Students in College") 
	yscale(range(20 100)) ylab(20(20)100) xscale(range(5 100)) xlab(0(20)100) 
	legend(order(1 2 3) ring(0) c(1) pos(4) 
		lab(1 "By Age 22") lab(2 "By Age 28") 
		lab(3 "By Age 32"))
;
#delimit cr

graph export "${figs}/app_paper_fig_1.${image_suffix}", replace

