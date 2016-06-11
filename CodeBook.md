### This file -- Codebook Markdown document -- describes all the variables, data and any transformations I did to clean up the Wearable Computing Datasets obtained from

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](Original%20Dataset%20Location)

Data Set Information: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


Attribute Information:

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

These signals were used to estimate variables of the feature vector for each pattern: 'XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag

The set of variables that were estimated from these signals are:

mean(): Mean value

std(): Standard deviation

mad(): Median absolute deviation

max(): Largest value in array

min(): Smallest value in array

sma(): Signal magnitude area

energy(): Energy measure. Sum of the squares divided by the number of values.

iqr(): Interquartile range

entropy(): Signal entropy

arCoeff(): Autorregresion coefficients with Burg order equal to 4

correlation(): correlation coefficient between two signals

maxInds(): index of the frequency component with largest magnitude

meanFreq(): Weighted average of the frequency components to obtain a mean frequency

skewness(): skewness of the frequency domain signal

kurtosis(): kurtosis of the frequency domain signal

bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.

angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable: gravityMean, tBodyAccMean, tBodyAccJerkMean, tBodyGyroMean, tBodyGyroJerkMean.

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
