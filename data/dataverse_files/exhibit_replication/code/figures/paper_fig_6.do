* Impacts of Counterfactuals on Income Segregation and Intergenerational Mobility

************************************************************
* Panel A: Fraction of Peers from Top-Quintile 
************************************************************

use ${rep_data}/paper_fig_6a  , clear

#delimit;
tw  (bar share_of_peers_q5_1 x1, barwidth(0.3) color("0 32 96"))
	(bar share_of_peers_q5_2 x2, barwidth(0.3) color("84 130 53"))
	(bar share_of_peers_q5_3 x3, barwidth(0.3) color("169 209 142"))
	(function y = 30.8, range(.75 3.75) color(black) lpattern(dash)),
	ylabel(0(10)40, nogrid)
	ytitle("Share of College Peers with Top-Quintile" "Parents (%)")
	xlabel(1.5 "Children from Bottom Quintile" 3 "Children from Top Quintile")
	legend(on order(1 "Actual" 
					2 "Income-Neutral Student Allocations counterfactual (0-point SAT increment)" 
					3 "Need-Affirmative Student Allocations counterfactual (${cbaa_adj}-point SAT increment)") 
		row(3)  size(small) )
	text(32 1.32 "Random allocation benchmark", size(medsmall))
;
#delimit cr

graph export "${figs}/paper_fig_6a.${image_suffix}", replace

************************************************************
* Panel B: Fraction of Students with Low-Income Parents
************************************************************

use ${rep_data}/paper_fig_6b  , clear

#delimit ;
tw (bar share_parq_tier_act x1, barwidth(0.5) color("0 32 96")) 
	(bar share_parq_tier_sat x2, barwidth(0.5) color("84 130 53")) 
	(bar share_parq_tier_bump x3, barwidth(0.5) color("169 209 142")) 
	, ylabel(0(5)15, nogrid) 
	xlabel(3 "Ivy Plus" 6 "Selective Tiers" 9 "Unselective Tiers") 
	legend(col(1) pos(7) ring(6) order(1 "Actual" 
										2 "Income-Neutral Student Allocations counterfactual (0-point SAT increment)" 
										3 "Need-Affirmative Student Allocations counterfactual (${cbaa_adj}-point SAT increment)") 
			size(small) ) 
	ytitle("Share of Students with Bottom-Quintile" "Parents (%)") 
	graphregion(margin(t+2))
	;
#delimit cr

graph export "${figs}/paper_fig_6b.${image_suffix}", replace
	

************************************************************
* Panel C: Counterfactual Gaps in Chance of Reaching Top Earnings Quintile
************************************************************

use ${rep_data}/paper_fig_6c  , clear

* save difference betweeen actual and counterfactuals
summ gap if bump == -1
local gap_actual = `r(mean)'
summ gap if bump == 0 
local gap_0 = `r(mean)'
local diff_gap_actual_0 : ///
					di %4.1f (`gap_actual' - `gap_0') / `gap_actual' * 100
summ gap if bump == ${cbaa_adj}
local gap_${cbaa_adj} = `r(mean)'
local diff_gap_actual_${cbaa_adj} : ///
					di %4.1f (`gap_actual' - `gap_${cbaa_adj}') / `gap_actual' * 100
					
* bar graph 
#delimit ;
twoway 
	(bar gap xaxis if xaxis == 1, barw(0.5) color("0 32 96")) 
	(bar gap xaxis if xaxis == 2, barw(0.5) color("84 130 53")) 
	(bar gap xaxis if xaxis == 3, barw(0.5) color("169 209 142")) 
	, 
		plotregion(margin(r=15)) 
		legend(off) 
	ylabel(10(2)22, nogrid) 
	xlabel(1 "Actual" 
		   2 `" "Income-Neutral" "Student Allocations" "counterfactual" "(0-point SAT increment)" "' 
		   3 `" "Need-Affirmative" "Student Allocations" "counterfactual" "(${cbaa_adj}-point SAT increment)" "') 
	xtitle("") 
	ytitle("Rich-Poor Gap in Top Quintile Outcome Rate" "among College-Goers (pp)") 
	text(21.05 1.78  "`=ustrunescape("\u23AB")'" "`=ustrunescape("\u23AC")'"  "`=ustrunescape("\u23AD")'" , size(*1.38) color(black)) 
	text(21.5 1.8 "`diff_gap_actual_0'% reduction", place(e)) 
	text(20.8 1.82 "in gap", place(e)) 
	text(19.4 2.82  "`=ustrunescape("\u23AB")'" "`=ustrunescape("\u23AC")'"  "`=ustrunescape("\u23AD")'" , size(*3.68) color(black)) 
	text(19.8  2.86 "`diff_gap_actual_${cbaa_adj}'% reduction", place(e)) 
	text(19.1 2.88 "in gap", place(e)) 
;
#delimit cr

graph export "${figs}/paper_fig_6c.${image_suffix}", replace
