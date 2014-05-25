## This code is assuming the data (zip file)
## present in the URL https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## is already downloaded to the working directory.


#setwd("C:/Users/pramod/Documents/Coursera/DataScience/03 - Getting and Cleaning Data/CourseProject")
#getwd()



## Unzipping the zip file.
## This will create the "UCI HAR dataset" folder which has all the files that this code  will read.
if (!file.exists("UCI HAR dataset")) {
  if (!file.exists("getdata-projectfiles_UCI HAR data.zip")) {
    stop("was expecting HAR data folder or zip file")
  } else {
    unzip("getdata_projectfiles_UCI HAR data.zip")
  }
}


## Loading the features file
features <- read.table(file="./UCI HAR dataset/features.txt", sep = " ", header=F)
## I am renaming the columns of this data set to "feature_id" & "feature_description"
colnames(features) <- c("feature_id", "feature_description")
## Loading the activities file 
activity <- read.table(".//UCI HAR dataset//activity_labels.txt", sep = " ")
## I am renaming the columns of this data set to "activity_id" & "activity_description"
colnames(activity) <- c("activity_id", "activity_description")

# Loading the train files 
x_train <- read.table("./UCI HAR dataset/train/X_train.txt", sep="", header = F )
y_train <- read.table("./UCI HAR dataset/train/Y_train.txt", sep="", header = F )
subject_train <- read.table("./UCI HAR dataset/train/subject_train.txt", sep="", header = F )

# Loading the test files 
x_test <- read.table("./UCI HAR dataset/test/X_test.txt", sep="", header = F )
y_test <- read.table("./UCI HAR dataset/test/Y_test.txt", sep="", header = F )
subject_test <- read.table("./UCI HAR dataset/test/subject_test.txt", sep="", header = F )

# Merging test and train data sets into one dataset. 
# For our readability I am adding subject first, then activity and then rest of the measurement variables from the files.
data <- rbind(cbind(subject_train,y_train,x_train),cbind(subject_test,y_test,x_test))

# Now the data is at one place, however the column names are not updated.
# Creating a column names vector using the features dataframe. The first two columns are hard coded to subject_id & activity
# I am storing activity instead of activity_id intentionally as I will be replacing this column with the descriptions later. 
column_names <- c("subject_id", "activity",as.vector(features$feature_description))
# replacing the data's columns names with the vector value.
colnames(data) <- column_names 

# Replacing the activity number with its description
data$activity <- activity$activity_description[match(data$activity, activity$activity_id)]

# Finding all columns that have mean, standard deviation in them
# I am ignoring the mean frequency columns from my code.
# Taking only the pure mean and pure sd columns.
# I am using grepl function to find out which columns qualify for this criteria.
# grepl("mean\\(\\)|std\\(\\)|subject|activity", as.vector(colnames(data)))
# We get 66 columns which have mean and sd and 2 id columns that are subject and activity
# Creating a new dataframe with these subset of columns
data2 <- data[,grepl("mean\\(\\)|std\\(\\)|subject|activity", as.vector(colnames(data)))]

## Before reshaping the data to a much more readable format 
## I am changing the names of the columns to more understandable notation. 
## I am using gusb function to replace all the patterns with the corresponding replacement strings from the column names 
# This part of code is extremely tidious and looks bad for coding.
# new_column_names <- gsub("-","_",colnames(data2))
# new_column_names <- gsub("mean\\(\\)", "mean_", new_column_names)
# new_column_names <- gsub("std\\(\\)", "standard_deviation_", new_column_names)
# new_column_names <- gsub("^t", "time_", new_column_names)
# new_column_names <- gsub("^f", "frequency_", new_column_names)
# new_column_names <- gsub("Body", "body_", new_column_names)
# new_column_names <- gsub("Gravity", "gravity_", new_column_names)
# new_column_names <- gsub("Gyro", "gyroscope_", new_column_names)
# new_column_names <- gsub("Jerk", "jerk_", new_column_names)
# new_column_names <- gsub("Acc", "acceleration_", new_column_names)
# new_column_names <- gsub("Mag", "magnitude_", new_column_names)
# new_column_names <- gsub("body_body_", "body_",new_column_names)
# new_column_names <- gsub("_+", "_",new_column_names)
# new_column_names <- gsub("_$", "",new_column_names)
# new_column_names



## Trying with a wrapper function for gsub which I found in stackoverflow. 
# http://stackoverflow.com/questions/15253954/replace-multiple-arguments-with-gsub
# First obtaining the column names of the new dataframe.  
column_names <- colnames(data2)
#column_names

# Declaring the patterns that need to be replaced.
patterns <- c("-","mean\\(\\)","std\\(\\)","^t","^f","Body","Gravity","Gyro","Jerk","Acc","Mag","body_body_","_+","_$")
# Declaring the pattern replacement strings.
pattern_replacements <- c("_","mean_","standard_deviation_","time_","frequency_","body_","gravity_","gyroscope_","jerk_","acceleration_","magnitude_","body_","_","")

# We can cross verify if the lengths are the same are not 
# length(patterns) ; length(pattern_replacements)
# Writing a gsub_updated function. 
gsub_updated <- function(pattern, replacement, x, ...) {
  if (length(pattern)!=length(replacement)) {
    stop("pattern and replacement do not have the same length.")
  }
  result <- x
  for (i in 1:length(pattern)) {
    result <- gsub(pattern[i], replacement[i], result, ...)
  }
  result
}

# Replacing all the patterns using the gsub_updated function in the column names vector.
column_names <- gsub_updated(patterns,pattern_replacements,column_names)

# Replacing the column names of data2 with the column_names vector
colnames(data2) <- column_names
#data2[1:10, 1:5]



## Loading library reshape2  
library(reshape2)
# creating id_variables vector. I am using this vector to reshape the dataframe into tidy data.
id_variables <- c("subject_id", "activity")
# creating the measuring variables vector. This is every column except the id columns from data2.
meassuring_variables <- column_names[!column_names %in% id_variables]
# meassuring_variables

# Reshaping the data2 into a more convenient format.
dataMelt <- melt(data2,id = id_variables, measure.vars=meassuring_variables)
nrow(dataMelt) # has 679,734 rows
ncol(dataMelt) # has 4 columns
head(dataMelt) 

#ActivityData <- dcast(dataMelt, activity ~ variable,mean)
#nrow(ActivityData);ncol(ActivityData)
#ActivityData[,1:6]

# Loading plyr library to create the variables for means, standard deviation and frequency.
library(plyr)
## creating tidy data from the melted dataset.
tidy_data <- ddply(dataMelt, .(subject_id,activity,variable), summarize, mean = mean(value), standard_deviation = sd(value), frequency = length(variable))
#nrow(tidy_data)
#head(tidy_data)
#tail(tidy_data)

## Writing tidy data to a today_data.txt file.
## I am assuming that the file needs to be stored in the "UCI HAR dataset" directory.
# I am storing the file in .txt format with tab separation.
# For convenience I am not storing the row names and am not enclosing the strings with quotations.
write.table(tidy_data, "./UCI HAR dataset/tiday_data.txt", sep = "\t", row.names = F, col.names = T, quote = F)


