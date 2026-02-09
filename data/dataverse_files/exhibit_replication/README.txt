Replication Code for "Income Segregation and Intergenerational Mobility Across Colleges in the United States"

This folder contains replication code that replicates publicly replicable figures and tables in the paper using Stata. 
To run the exhibit replication code, update the file path in /code/draw_paper_figs_tabs.do to the location of the replication folder on your computer. Running that do file will then download the public data tables from opportunityinsights.org and replicate figures and tables. Output is saved in /output/


Steps:

1. Save the replication code folder in your desired directory and change your stata directory to that location.

2. Open the file draw_paper_figs_tabs.do and set the global macro on line 7 to be the filepath of the replication folder. You can also set the output format of the figs by changing the global image_suffix on line 13 (default is pdf).

3. Run draw_paper_figs_tabs.do. It will populate the results folder with figures and csv files for replicating tables.