*********************************
* Paper Figure and Table Creation
*********************************
set more off

* Set to replication folder location
global replication_folder XXset to the location of the replication folder (ex. "~/Downloads/exhibit_replication")XX

* Run metafile
do "${replication_folder}/code/header.do"

* Figure output extension 
global image_suffix pdf


********************************************************************************
* Main Figures
********************************************************************************
* Figure 1
// panel A is constructed directly from the individual-level microdata
do "$fig_code/paper_fig_1.do"

* Figure 2 
// constructed directly from the individual-level microdata
do "$fig_code/paper_fig_2.do"

* Figure 3 
// constructed directly from the individual-level microdata
do "$fig_code/paper_fig_3.do"

* Figure 4
do "$fig_code/paper_fig_4.do"

* Figure 5
// constructed directly from the individual-level microdata
do "$fig_code/paper_fig_5.do"

* Figure 6
// constructed directly from the individual-level microdata
do "$fig_code/paper_fig_6.do"


********************************************************************************
* Main Tables
********************************************************************************
* Table 1
do "$tab_code/paper_tab_1.do"

* Table 2
//parts constructed directly from the individual-level microdata
do "$tab_code/paper_tab_2.do"

* Table 3
// constructed directly from the individual-level microdata
// see excel file

* Table 4
do "$tab_code/paper_tab_4.do"

* Table 5
//parts constructed directly from the individual-level microdata 
do "$tab_code/paper_tab_5.do"

* Table 6
// constructed directly from the individual-level microdata
// see excel file

* Table 7
// constructed directly from the individual-level microdata
// see excel file

* Table 8
// constructed directly from the individual-level microdata
// see excel file




********************************************************************************
* Appendix Figures
********************************************************************************
* Appendix Figure 1
// constructed directly from the individual-level microdata
do "$fig_code/app_paper_fig_1.do"

* Appendix Figure 2
// constructed directly from the individual-level microdata
do "$fig_code/app_paper_fig_2.do"

* Appendix Figure 3
// constructed directly from the individual-level microdata
do "$fig_code/app_paper_fig_3.do"

* Appendix Figure 4 
do "$fig_code/app_paper_fig_4.do"

* Appendix Figure 5
// constructed directly from the individual-level microdata
do "$fig_code/app_paper_fig_5.do"

* Appendix Figure 6
// constructed directly from the individual-level microdata
do "$fig_code/app_paper_fig_6.do"

* Appendix Figure 7
do "$fig_code/app_paper_fig_7.do"

* Appendix Figure 8
do "$fig_code/app_paper_fig_8.do"

* Appendix Figure 9
// constructed directly from the individual-level microdata
do "$fig_code/app_paper_fig_9.do"

* Appendix Figure 10
do "$fig_code/app_paper_fig_10.do"

* Appendix Figure 11
// constructed directly from the individual-level microdata










