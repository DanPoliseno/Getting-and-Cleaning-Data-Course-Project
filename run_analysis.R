#Getting and Cleaning Data Course Project
#by Dan Poliseno

#You should create one R script called run_analysis.R that does the following:
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.

#Dataset Prepartion:
#Download File
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
datasetUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(datasetUrl, destfile = paste0(getwd(), '/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'), method = "auto")
unzip("getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",exdir = "dataset")

# Load activity labels + features
features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "feature_label"))
activity_labels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("classlabels", "activity_label"))
extract_features <- grep("(mean|std)\\(\\)", features[, feature_label])
measurements <- features[extract_features, feature_label]
measurements <- gsub('[()]', '', measurements)

