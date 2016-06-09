Initiation of the project
-------------------------

-   Create a directory for the project called `data`
-   Download the script `run_analysis.R` to the `data` folder Download the original raw data from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> to the `data` folder and extract it to the data directory.

Data Analysis
-------------

-   Change the R working directoryto the location of the `data` directory using the `setwd()` command (the same folder created in the previous point)
-   Source the script `run_analysis.R` in R: `source("run_analysis.R")`

-   To get the datasets into `R`, run the first of the two last lines in the script: `tidydatalist <- GetBothDatasets_in_List()`
-   To output the postprocessed tidy datasets to files, run the last line of the script: `WriteDataToFiles(tidydatalist)` -- two new files containing the tidy datasets `tidy1.csv` and `tidy2.csv`, two independent tidy data sets with the average of each variable for each activity and each subject, will be created.

Codebook
--------

To see more information on the analysis implemented, please see the MarkDown file `CodeBook.md`.
