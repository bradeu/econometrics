* Percentage in college by parent rank, by data source.

use ${rep_data}/appx_paper_fig_9 , clear

* Produce and export graph.
#delimit ;
twoway scatter ever_all rank, c(l) msize(small) || 
	scatter ever_pell rank, ms(circle_hollow) msize(small) c(l) || 
	scatter ever_tax rank, ms(triangle_hollow) msize(small) c(l)  
	legend(order(3 "IRS Data" 2 "Pell Grant Data" 1 "Combined IRS + Pell Data" )) 
	xtitle("Parent Rank") ytitle("Percentage in College") 
	ylabel(0(20)100) title(" ")
	;
#delimit cr

graph export "${figs}/app_paper_fig_9a.${image_suffix}", replace

