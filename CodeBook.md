### This file -- Codebook Markdown document -- describes all the variables, data and any transformations I did to clean up the Wearable Computing Datasets obtained from

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](Original%20Dataset%20Location)

Obtaining Tidy Dataset 1:
=========================

Description how to Read in the Data
-----------------------------------

### Step 1 Requirements : "Merges the training and the test sets to create one data set."

> The workflow has been implemented in the following steps:

-   Firstly, I defined a function called `fileLocation` that stores the full paths of the given files named `train.txt`, `train.txt`, `features.txt`, `activity_labels.txt`, `y_test.txt`, `y_train.txt`, `subject_test.txt`, `subject_train.txt`. The datasets are read in using the `read.table` function.
-   Secondly, train and test sets were combined using the `rbind` command and variable names were assigned by reading in the features into the `featureNames` variable and then assigning this vector to the column names of the merged dataset.

### Step 2 Requirements: "Extracts only the measurements on the mean and standard deviation for each measurement. "

> The workflow has been implemented in the following steps:

-   Firstly, The required columns were found by using the `grep` command for the `mean`, `std` on the `featureNames` vector and then the united dataset is subsetted using this.

### Step 3 & Step 4 Requirements: "3. Uses descriptive activity names to name the activities in the data set", "4. Appropriately labels the data set with descriptive variable names"

> The feature cleaning transformations were implemented as follows:

-   `t` into `time` (`t` at the beginning of a variable name)
-   `t` into `freq` (`f` at the beginning of a variable name)
-   `?mean[(][)]-?` into `Mean` (obtaining a cleaned variable `Mean`)
-   `-?std[()][)]-?` into `Std` (obtaining a cleaned variable `Std`)
-   `-?meanFreq[()][)]-?` into `MeanFreq` (obtaining a cleaned variable `MeanFreq`)
-   `BodyBody` into `Body` (removing duplicates from names)

> Appropriately labelling the dataset:

-   Firstly created the activity column for the entire dataset called `ActivityLabels`. The activity labels were read using `read.table` command and the column names were changed to `activityID` and `activityLabel`.
-   Secondly, read in the activity files using `read.table` and then joined them using `plyr::join` by `activityID`, obtaining the activity column called `activities` for the entire dataset
-   Thirdly, combined the `activities` variable with the whole dataset `allRecords`
-   Fourthly, read in the data on the subjects and combined them using `rbind` into `allSubjects` and then column-binded that variable with the whole dataset `allRecords`
-   Fithly, the complete dataset was ordered by subject and activity -- the resulting dataset is the Tidy Dataset 1

Obtaining Tidy Dataset 2:
=========================

### Step 5 Requirements: "From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. "

> The workflow has be implemented like this: The function `GetBothDatasets_in_List` makes calls to two functions: `GetDataSet1` and `GetDataSet2` (this one uses the tidy data produced by `GetDataSet1`). The one relevant for obtaining the 2nd dataset is `GetDataSet2`, which uses the following:

-   `melt` function applied to the tidy dataset no 1, `id` variables are the required `subject`and `activity` variables
-   `dcast` applied on the resulting tall and skinny dataframe, using `activity + subject` as the dependent variable and `variable` as the independent variable using `mean` as the aggregation function, the output is a dataframe of width of the original dataframe, with the means of all the other variables for all the combinations of `activity` and `subject` in the columns.
