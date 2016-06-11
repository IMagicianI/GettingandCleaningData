install.packages("plyr")
library("plyr")
install.packages("reshape2")
library("reshape2")

GetDataSet1 <- function(root_directory= "UCI HAR Dataset") {
  
  # function to store the individual file full paths
  fileLocation <- function(file) {
    paste(root_directory,"/",file,sep="")
  }
  
  # Get File directories for reading in the data
  testData <- fileLocation("test/X_test.txt")
  trainData <- fileLocation("train/X_train.txt")
  featuresData <- fileLocation("features.txt")
  activityLabelsData <- fileLocation("activity_labels.txt")
  testactivitiesData <- fileLocation("test/y_test.txt")
  trainingactivitiesData <- fileLocation("train/y_train.txt")
  subjectTestData <- fileLocation("test/subject_test.txt")
  subjectTrainData <- fileLocation("train/subject_train.txt")
  
  # Use rbind to combine the datasets
  testSet <- read.table(testData)
  trainingSet <- read.table(trainData)
  allRecords <- rbind(testSet,trainingSet)
  
  #add feature names as column names
  featureNames <- read.table(featuresData,stringsAsFactors=FALSE)[[2]]
  colnames(allRecords) <- featureNames
  
  #STEP2: 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
  allRecords <- allRecords[,grep("mean|std|activityLabel",featureNames)]
  
  #variable engineering
  
  variableNames <- names(allRecords)
  variableNames <- gsub(pattern="^t",replacement="time",variableNames) # beginning of line
  variableNames <- gsub(pattern="^f",replacement="freq",variableNames) # beginning of line
  variableNames <- gsub(pattern="BodyBody",replacement="Body",x=variableNames)
  variableNames <- gsub(pattern="-?mean[(][)]-?",replacement="Mean",x=variableNames)
  variableNames <- gsub(pattern="-?std[()][)]-?",replacement="Std",x=variableNames)
  variableNames <- gsub(pattern="-?meanFreq[()][)]-?",replacement="MeanFreq",x=variableNames)
  names(allRecords) <- variableNames
  
  #use the activity names to name the activities in the set
  activityLabels <- read.table(activityLabelsData,stringsAsFactors=FALSE)
  colnames(activityLabels) <- c("activityID","activityLabel")
  
  #appropriately label the data set with descriptive activity names
  #first we create the activity column for the entire dataset, test+train:
  testActivities <- read.table(testactivitiesData,stringsAsFactors=FALSE)
  trainingActivities <- read.table(trainingactivitiesData,stringsAsFactors=FALSE)
  allActivities <- rbind(testActivities,trainingActivities)
  
  #assign a column name so that we could do a join using this as the key

  colnames(allActivities)[1] <- "activityID"
  #join the activityLabels - we use join from the plyr package and not merge, because join
  #preserves order
  activities <- join(allActivities,activityLabels,by="activityID")
  
  #and add the column to the entire dataset
  allRecords <- cbind(activity=activities[,"activityLabel"],allRecords)
  
  #extra step: include the subject ids, for processing in the next step
  testSubjects <- read.table(subjectTestData,stringsAsFactors=FALSE)
  trainingSubjects <- read.table(subjectTrainData,stringsAsFactors=FALSE)
  allSubjects <- rbind(testSubjects,trainingSubjects)
  colnames(allSubjects) <- "subject"
  allRecords <- cbind(allSubjects,allRecords)
  
  tidy1 <- allRecords[order(allRecords$subject,allRecords$activity),]
  tidy1
}

GetDataSet2 <- function(tidy) {
  
  #create a long shaped dataset from a wide shaped dataset
  melted <- melt(tidy,id= c("subject","activity"))
  
  # we only retained subject and activity since we're interested in the means of the others
  # for these. the other features will go under 'variable' column (value col for values)
  #transform the long shaped dataset back into a wide shaped dataset, 
  #aggregating on subject and activity using the mean function
  
  tidy2 <- dcast(melted, subject+activity ~ variable, fun.aggregate=mean)
  
}

GetBothDatasets_in_List <- function(){
  tidy_data_1 <- GetDataSet1()
  tidy_data_2<- GetDataSet2(tidy_data_1)
  return (list(tidy1=tidy_data_1, tidy2=tidy_data_2))
}

WriteDataToFiles <- function(sets=tidydatalist){
  tidy_main <- sets$tidy1
  tidy_summarized <- sets$tidy2
  write.csv(tidy_main,file="tidy1.csv")
  write.csv(tidy_summarized,file="tidy2.csv")
}

tidydatalist <- GetBothDatasets_in_List()
WriteDataToFiles(tidydatalist)

