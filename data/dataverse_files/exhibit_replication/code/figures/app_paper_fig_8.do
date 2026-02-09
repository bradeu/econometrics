* Counterfactual Low-Income Shares at the Ivy-Plus


use ${rep_data}/appx_paper_fig_8 , clear

local cbaa_pos = ${cbaa_adj} - 5

#delimit ;
tw (scatter b20_1 adj, c(l) ms(none) yaxis(1) lc(navy) lwidth(thick))
   (scatter b60_1 adj, c(l) ms(none) yaxis(2) lc(cranberry) lp(shortdash) lwidth(thick)),
   xlabel(-100(50)300) xmtick(##5)
   xtitle("Increment to SAT Scores")
   ytitle("Share of Ivy-Plus Students from Bottom 20%", axis(1))
   ytitle("Share of Ivy-Plus Students from Bottom 60%", axis(2))
   legend(lab(1 "Share from Bottom 20%")
   	      lab(2 "Share from Bottom 60%")
   	      row(1) span)
   text(17.5 -5 "Income-Neutral" "Student" "Allocations" "Counterfactual", just(right) placement(w))
   text(17.5 `cbaa_pos' "Need-Affirmative" "Student Allocations" "Counterfactual", just(right) placement(w))
   xline(${cbaa_adj}, lcolor(black))
   xline(0, lcolor(black))
   yline(3.8, lcolor(black) axis(1))
   yline(18.2, lcolor(black) axis(2))
   ylabel(10(10)60 , axis(2) nogrid)
   ylabel( , axis(1) nogrid)
   text(4.5 240 "Actual Bottom-20%", just(right))
   text(2.35 240 "Actual Bottom-60%", just(right))
   ;
#delimit cr

graph export "${figs}/app_paper_fig_8.${image_suffix}", replace

