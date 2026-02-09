* Children’s Earnings Ranks by Age of Earnings Measurement

************************************************************
* Panel A: Rank Stability by Group
************************************************************
use ${rep_data}/appx_paper_fig_2acd , clear

#delimit ;	
twoway scatter k_wagse_rank age if group==1, c(l) ms(circle) || 
	scatter k_wagse_rank age if group==2, c(l) ms(circle_hollow) || 
	scatter k_wagse_rank age if group==3, c(l) ms(triangle) || 
	scatter k_wagse_rank age if group==4, c(l) ms(triangle_hollow) ||, 
	legend(label(1 "Ivy Plus") label(2 "Other Elite") 
	label(3 "Other Four-Year") label(4 "Two-Year") 
	ring(0) pos(11) c(1)) 
	ylab(50(10)90, gmax) xlab(25(2)35)  
	xtitle("Age of Income Measurement")	ytitle("Mean Child Earnings Rank") 
	title(" ")
;
#delimit cr

graph export "$figs/app_paper_fig_2a.$image_suffix", replace

************************************************************
* Panel B: Age Correlations
************************************************************
use ${rep_data}/appx_paper_fig_2b , clear
#delimit ;	
scatter corr_coll age, c(line) xtitle("Age") ytitle("Correlation of Mean Rank at Age x with Mean Rank at Age 36") 
	title(" ") xlab(25(2)35) ylab(.80(.05)1, format(%03.2f))
;
#delimit cr
graph export "$figs/app_paper_fig_2b.$image_suffix", replace


************************************************************
* Panel C: Top 20% Stability by Group
************************************************************
use ${rep_data}/appx_paper_fig_2acd , clear

#delimit ;	
twoway scatter k_wagse_dum_q5 age if group==1, c(l) ms(circle) || 
	scatter k_wagse_dum_q5 age if group==2, c(l) ms(circle_hollow) || 
	scatter k_wagse_dum_q5 age if group==3, c(l) ms(triangle) || 
	scatter k_wagse_dum_q5 age if group==4, c(l) ms(triangle_hollow) ||, 
	legend(label(1 "Ivy Plus") label(2 "Other Elite") 
	label(3 "Other Four-Year") label(4 "Two-Year") 
	ring(0) pos(11) c(1)) 
	ylab(20(20)80, gmax) xlab(25(2)35) xline(34.5, lp(dash) lc(red))
	xtitle("Age of Income Measurement")	ytitle("Percent of Students in Top 20%") 
	title(" ")
;
#delimit cr

graph export "$figs/app_paper_fig_2c.$image_suffix", replace

************************************************************
* Panel D: Top 1% Stability by Group
************************************************************
use ${rep_data}/appx_paper_fig_2acd , clear

#delimit ;	
twoway scatter k_wagse_dum_top1pc age if group==1, c(l) ms(circle) || 
	scatter k_wagse_dum_top1pc age if group==2, c(l) ms(circle_hollow) || 
	scatter k_wagse_dum_top1pc age if group==3, c(l) ms(triangle) || 
	scatter k_wagse_dum_top1pc age if group==4, c(l) ms(triangle_hollow) ||, 
	legend(label(1 "Ivy Plus") label(2 "Other Elite") 
	label(3 "Other Four-Year") label(4 "Two-Year") 
	ring(0) pos(11) c(1)) 
	ylab(0(5)25, gmax) xlab(25(2)35) xline(34.5, lp(dash) lc(red))
	xtitle("Age of Income Measurement")	ytitle("Percent of Students in Top 1%") 
	title(" ")
;
#delimit cr

graph export "$figs/app_paper_fig_2d.$image_suffix", replace
