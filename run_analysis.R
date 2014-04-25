# Clean Data Assignment 
# Code written by Ronald G. Bjork


featuresFile <- "./features.txt"
features <- read.table(featuresFile)
featureChar = as.character(features[,2])
desiredFeatures <- str_detect(as.character(features[,2]),"(-std)|(-mean[^F])") 

activityLabels <- read.table("./activity_labels.txt",col.names=c("activityCode","activityName")) # Merge with tainData

trainPath <- "./train/";

subjectTrainLabels <- read.table("./train/subject_train.txt")
trainLabels <- read.table(paste(trainPath,"y_train.txt",sep=""),col.names=c("Activity"))
trainData <- read.table(paste(trainPath,"x_train.txt",sep=""), col.names=featureChar)
trainData <- trainData[,desiredFeatures]


trainData$activityCode <- trainLabels[,1]
trainData$subjectCode <- subjectTrainLabels[,1]
mergedTrainingData = merge(trainData, activityLabels,by.x="activityCode",by.y="activityCode",all=TRUE)

dim(trainData)
dim(trainLabels)
head(trainData,1)
str(trainData)

testPath <- "./test/";
subjectTestLabels <- read.table("./test/subject_test.txt")
testLabels <- read.table(paste(testPath,"y_test.txt",sep=""),col.names=c("Activity"))
testData <- read.table(paste(testPath,"X_test.txt",sep=""), col.names=featureChar)
testData <- testData[,desiredFeatures]

testData$activityCode <- testLabels[,1]
testData$subjectCode <- subjectTestLabels[,1]
mergedTestData = merge(testData, activityLabels,by.x="activityCode",by.y="activityCode",all=TRUE)

appendedDataSets <- rbind(mergedTrainingData,mergedTestData)

#
# Create new tidy dataset - requirement #5
#
colNames <- names(appendedDataSets)
columnsToAvg <- !str_detect(colNames,"(activityName)|(activityCode)|(subjectCode)") # Bool array to select all but these three columns
#columnsToAvg <- -grep("(activityName)|(activityCode)|(subjectCode)",colNames)

NSubjects = 30
NActivities = 6
first = TRUE
for(i in 1:NSubjects){
  subject <- appendedDataSets[appendedDataSets$subjectCode == i,]
  subjectCode <- subject[1,]$subjectCode
  for(j in 1:NActivities){
    activities <- subject[subject$activityCode == j,]
    if(dim(activities)[1] == 0)next
    activityName <- activities[1,]$activityName
    if(first){
      colmeans <- data.frame(matrix(colMeans(activities[,columnsToAvg]),nrow=1))
      colnames(colmeans) = colNames[columnsToAvg]
      colmeans$Activity_Name = activityName;
      colmeans$Subject_Code = subjectCode;
      meanActivityValues <- colmeans
    }else{
      colmeans <- data.frame(matrix(colMeans(activities[,columnsToAvg]),nrow=1))
      colnames(colmeans) = colNames[columnsToAvg]
      colmeans$Activity_Name = activityName;
      colmeans$Subject_Code = subjectCode;
      meanActivityValues <- rbind(meanActivityValues,colmeans)
    }
    first = FALSE
  }
}

orderColumns <- append(c("Subject_Code","Activity_Name"),colNames[columnsToAvg])
tidyData <- data.frame(meanActivityValues[,orderColumns])
#write.table(tidyData,file="tidy.txt")
write.csv(tidyData,file="tidy.csv")

            
            