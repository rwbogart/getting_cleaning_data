setwd("C:/Users/Randall Bogart/OneDrive/R_Studio/getting_cleaning_data")
getwd()

#Load Packages if Necessary

if(!require("plyr")) {
  install.packages("plyr")
}

library(plyr)

#Read the features and label information
features <- read.table('features.txt', header = FALSE)
labels <- read.table('activity_labels.txt', header = FALSE)

#Read the training information
X_train <- read.table('./train/X_train.txt', header = FALSE)
Y_train <- read.table('./train/Y_train.txt', header = FALSE)
subject_train <- read.table('./train/subject_train.txt', header = FALSE)

#Read the testing information
X_test <- read.table('./test/X_test.txt', header = FALSE)
Y_test <- read.table('./test/Y_test.txt', header = FALSE)
subject_test <- read.table('./test/subject_test.txt', header = FALSE)

#Assigning Variable Names
colnames(X_train) <- features[,2]
colnames(X_test) <- features[,2]
colnames(Y_train) <- "activityID"
colnames(Y_test) <- "activityID"
colnames(subject_train) <- "subjectID"
colnames(subject_test) <- "subjectID"
colnames(labels) <- c("activityID", "activityType")

#Merge into 3 data sets
Y_test <- merge(Y_test, labels)
Y_train <- merge(Y_train, labels)
training_data <- cbind(Y_train, subject_train, X_train)
test_data <- cbind(Y_test, subject_test, X_test)
combined_data <- rbind(training_data, test_data)

#Extract measurements for the mean and standard deviation for each measurement

#Get Column Names
columnNames <- colnames(combined_data)

#Get vector for ID, mean, and standard deviation
mean_and_stdev <- (grepl("activityType", columnNames) | grepl("subjectID", columnNames) | grepl("mean..", columnNames) | grepl("std...", columnNames))

#Get the final subset
finalsubset <- combined_data[,mean_and_stdev == TRUE]


#create tidy data set and do final clean up
tidy_data <- aggregate(.~subjectID + activityType, finalsubset, mean)
names(tidy_data) <- gsub('-mean', 'Mean', names(tidy_data))
names(tidy_data) <- gsub('-std', 'Std', names(tidy_data))
names(tidy_data) <- gsub('()-]','',names(tidy_data))

write.table(tidy_data, "tidy_data.txt", row.name = FALSE)

