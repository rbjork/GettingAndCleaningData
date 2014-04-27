# Clean Data Assignment 
# Code written by Ronald G. Bjork

# Loading of Feature data
featuresFile <- "./features.txt"
features <- read.table(featuresFile)
featureChar = as.character(features[,2]) # character vector of feature names

# Assemble names of columns that have 'std' or 'mean' in them. These are the columns containing means and standard deviations of features
# These are the name of the features which the assignment has requested be extracted ans assembled
library(stringr)
desiredFeatures <- str_detect(as.character(features[,2]),"(-std)|(-mean[^F])") 

# Load in activity table that associates activityCode with activityName.
activityLabels <- read.table("./activity_labels.txt",col.names=c("activityCode","activityName")) 

trainPath <- "./train/";

# Load the id's of people(subjects) that wore the samsung phone and recorded there movements
subjectTrainLabels <- read.table("./train/subject_train.txt")

# Load in computed features of sensor data and assign column names - 
# The training data columns are assumed to be in the same order as the list of names in features
trainLabels <- read.table(paste(trainPath,"y_train.txt",sep=""),col.names=c("Activity"))
trainData <- read.table(paste(trainPath,"x_train.txt",sep=""), col.names=featureChar)
# The features of interest, desiredFeatures(computed above), are extracted and other features discarded.
# This results in a reduction in the used columns in table
trainData <- trainData[,desiredFeatures]


# Adds column for activityCode
trainData$activityCode <- trainLabels[,1]
trainData$subjectCode <- subjectTrainLabels[,1]
# Merge into table activity names using activityCode id's in both trainData(added above) and activitylabels
mergedTrainingData = merge(trainData, activityLabels,by.x="activityCode",by.y="activityCode",all=TRUE)

testPath <- "./test/";
subjectTestLabels <- read.table("./test/subject_test.txt")
testLabels <- read.table(paste(testPath,"y_test.txt",sep=""),col.names=c("Activity"))
testData <- read.table(paste(testPath,"X_test.txt",sep=""), col.names=featureChar)
testData <- testData[,desiredFeatures]

testData$activityCode <- testLabels[,1]
testData$subjectCode <- subjectTestLabels[,1]
mergedTestData = merge(testData, activityLabels,by.x="activityCode",by.y="activityCode",all=TRUE)

# Training and Test data is aggregated - trining data first followed by rows of test data
appendedDataSets <- rbind(mergedTrainingData,mergedTestData) # result meeting requirements 1,2,3,4

#
# Create new tidy dataset - requirement #5
#
colNames <- names(appendedDataSets)
columnsToAvg <- !str_detect(colNames,"(activityName)|(activityCode)|(subjectCode)") # Bool array to select all but these three columns
# OR
#columnsToAvg <- -grep("(activityName)|(activityCode)|(subjectCode)",colNames)

NSubjects = 30 # Number of subjects
NActivities = 6 # Number of activity types 
first = TRUE
for(i in 1:NSubjects){
  subject <- appendedDataSets[appendedDataSets$subjectCode == i,]
  subjectCode <- subject[1,]$subjectCode
  for(j in 1:NActivities){
    activities <- subject[subject$activityCode == j,]
    if(dim(activities)[1] == 0)next
    activityName <- activities[1,]$activityName
    colmeans <- data.frame(matrix(colMeans(activities[,columnsToAvg]),nrow=1))
    colnames(colmeans) = colNames[columnsToAvg]
    colmeans$Activity_Name = activityName;
    colmeans$Subject_Code = subjectCode;
    if(first){
      meanActivityValues <- colmeans
    }else{
      meanActivityValues <- rbind(meanActivityValues,colmeans)
    }
    first = FALSE
  }
}

orderColumns <- append(c("Subject_Code","Activity_Name"),colNames[columnsToAvg])


tidyData <- data.frame(meanActivityValues[,orderColumns])

# Create more readable column headers
colNames <- names(tidyData) # Clean heading names
newColNames <- gsub("mean()"," mean ", colNames);
newColNames <- gsub("std()"," std ", newColNames);
newColNames <- gsub("[.]+","", newColNames);
newColNames <- gsub("^[t]","", newColNames);
newColNames <- gsub("^[f]","FFT ", newColNames);
colnames(tidyData) <- newColNames


#write.table(tidyData,file="tidy.txt")
write.csv(tidyData,file="tidy.csv")

            
            