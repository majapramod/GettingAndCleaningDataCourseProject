==================================================================
## Creating Tidy Dataset for Human Activity Recognition Using Smartphones Dataset
###Version 1.0
==================================================================
## Author
###Janakiram Pramod Mallapragada.
###https://github.com/majapramod
==================================================================
## Dataset Information
* Source Dataset used is at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Description of the dataset can be found in http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

==================================================================
## Files Included:
This project contains 
* README.md - the current file you are viewing.
* run_analysis.R - has the R code to create the tiday dataset.
* tidy_data.txt - has the tiday data that was created after running the run_analysis.R in R studio.
==================================================================
## Assumptions: 
* The source data (getdata-projectfiles_UCI HAR data.zip) is already downloaded to the current working directory.
* The run_analysis.R has to unzip the "getdata-projectfiles_UCI HAR data.zip" file and created the "UCI HAR dataset" which has all necessary datasets.
* The tiday data needs to be in the following format subject, activity, variable, mean, standard_deviation, frequency. 
* For future use I also included standard_deviation & frequency columns in the tidy data.
* tiday_data will be stored in a tidy_data.txt file at the end of the script into the "UCI HAR dataset" directory present inside your working directory.

==================================================================
## Notes: 
### Steps involved in converting the dataset into tidy dataset 
(not performed in the same order. Please refer to the run_analysis.R for greater clarity.
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive activity names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

==================================================================
## License Information:
This code is not licensed. You are free to use it any way you want.
You can copy, edit and reuse the code. 
As long as you do not cliam the code is yours, the author is okay with you.
 