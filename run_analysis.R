#Getting and Cleaning Data Course Project
#by Dan Poliseno

#You should create one R script called run_analysis.R that does the following:
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.

#Load Packages and read data into environment.

packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
datasetUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(datasetUrl, destfile = paste0(getwd(), '/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'), method = "auto")
unzip("getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",exdir = "dataset")
library("data.table")

#Load Train Datasets. “features.new” extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("./UCI HAR Dataset/features.txt")[, 2]
features.new <- grepl("mean|std", features)
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[, 2]

xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

#Label the dataset with descriptive variable names.

names(xtrain) <- features
xtrain <- xtrain[, features.new]

#Use descriptive activity names to name the activities in the dataset.

ytrain[, 2] <- activity.labels[ytrain[, 1]]
names(ytrain) <- c("Activity_ID", "Activity_Label")

SubjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(SubjectTrain) <- "subject"

#Creating one train dataset.

train <- cbind(SubjectTrain, ytrain, xtrain)

#Load Test Datasets.

xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")

#Label the dataset with descriptive variable names.

names(xtest) <- features
xtest <- xtest[, features.new]

#Use descriptive activity names to name the activities in the dataset.

ytest[, 2] <- activity.labels[ytest[, 1]]
names(ytest) <- c("Activity_ID", "Activity_Label")

SubjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(SubjectTest) <- "subject"

#Creating one test dataset.

test <- cbind(SubjectTest, ytest, xtest)

#Creating one dataset by combining train and test. 

data.merge <- rbind(train, test)

#Creating a second independent tidy dataset with the average of each variable for each activity and each subject.

id.labels = c("subject", "Activity_ID", "Activity_Label")
variable.labels = setdiff(colnames(data.merge), id.labels)
melt.data.merge = melt(data.merge, id.vars = id.labels, measure.vars = variable.labels)
tidy.data = dcast(melt.data.merge, subject + Activity_Label ~ variable, mean)
