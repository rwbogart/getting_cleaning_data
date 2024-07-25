setwd("C:/Users/Randall Bogart/OneDrive/R_Studio/getting_cleaning_data")
getwd()

#Load Packages if Necessary

if(!require("plyr")) {
  install.packages("plyr")
}

library(plyr)

#Read the features and label information
features <- read.table('features.txt', header = FALSE)[,2]
labels <- read.table('activity_labels.txt', header = FALSE)[,2]

#Read the training information
X_train <- read.table('./train/X_train.txt', header = FALSE)
Y_train <- read.table('./train/Y_train.txt', header = FALSE)
subject_train <- read.table('./train/subject_train.txt', header = FALSE)

#Read the testing information
X_test <- read.table('./test/X_test.txt', header = FALSE)
Y_test <- read.table('./test/Y_test.txt', header = FALSE)
subject_test <- read.table('./test/subject_test.txt', header = FALSE)

#Merge into 3 data sets
x_data <- rbind(X_train, X_test)
y_data <- rbind(Y_train, Y_test)
subjectdata <- rbind(subject_train, subject_test)

#Extract the measurements of the mean and the standard deviation for each measurement
extractfeaturemean <- grep("-(mean|std)\\(\\)", features)
x_data <- x_data[, extractfeaturemean]

#Appropriately label the data set with descriptive variable names (y_data has a single column, use lower case)
y_data[, 1] <- labels[y_data[,1]
names(y_data) <- "activity"
names(subjectdata) <- "subject"
names(x_data) <- features[extractfeaturemean]

#Create the second combined set of data
combined_data <- cbind(x_data, y_data, subjectdata)
combined_data <- combined_data[c(68,67, 1:66)]

#Create final tidy data set with averages of columns grouped by activity and subject
tidy_data <- ddply(combined_data, .(subject, activity), function(x) colMeans(x[,3:68]))

#Clean names and prepare for posting file
names(tidy_data) <- gsub('-mean', 'Mean', names(tidy_data))
names(tidy_data) <- gsub('-std', 'Std', names(tidy_data))
names(tidy_data) <- gsub('()-]','',names(tidy_data))
names(tidy_data) <- gsub('BodyBody', 'Body', names(tidy_data))
write.table(tidy_data, "tidy_data.txt", row.name = FALSE)

