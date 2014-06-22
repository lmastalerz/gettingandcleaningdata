gettingandcleaningdata
======================

Repository contains a script run_analysis.R which executes following set of instrutions on Human Activity Recognition dataset:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

In order to achieve results described above following steps have been followed:
0. Setup

Script downloads the dataset, extracts it from the archive and sets working directory
(Note: Please refer to README file in the archive for details on the contents of dataset and terms used in description below)

1. Data merge
Simple rbind used to join raw data from test and train datasets. It's important to bind datasets in predefined order (here: 1.test, 2.train)

2. Mean and Standard Deviation measurements have been recognized based on measurement name. It was assumed that Mean measurement contains "-mean()" in its name and Standard Deviation contains "-std()" in its name

3. Activity names have been loaded from y_test.txt and y_train.txt files and joined in predefined order. Names have been retrieved from activity_labels.txt file

4. Based on values retrieved in step 2 names have been assigned to columns in dataset from step 1.

5. Using combination of melt and dcast average has been calculated for every combination of activity and subject.

Check comments in the run_analysis.R for depails on the implementation.


In addition to the run_analysis.R script repository contains:
- README.md 
- CodeBook.md - document describing contents on output file
- final.wide.txt - output of run_analysis.R