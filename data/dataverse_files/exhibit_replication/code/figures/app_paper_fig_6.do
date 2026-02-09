* Validation of SAT/ACT Imputation

use ${rep_data}/appx_paper_fig_6 , clear

local stat avg

#delimit ;
twoway (scatter `stat'_pct1 `stat'_pct0) 
			(lfit `stat'_pct1 `stat'_pct0) , 
			plotregion(fcolor(white) lcolor(white)) 
			graphregion(fcolor(white) lcolor(white)) 
			xtitle("Actual SAT/ACT score (de-meaned)") ytitle("Imputed SAT/ACT score (de-meaned)") 
			legend(off) xlabel(-300(100)300) ylabel(-300(100)300)
	;
#delimit cr

graph export "${figs}/app_paper_fig_6.${image_suffix}", replace

