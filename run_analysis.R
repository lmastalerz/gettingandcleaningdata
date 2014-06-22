# Get the file, unzip and set wd 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "HAR.zip")
unzip("HAR.zip")
setwd("./UCI HAR Dataset")

# Read and join test and traing set 
tst <- read.table("test/X_test.txt")
trn <- read.table("train/X_train.txt")
complete.set <- rbind(tst, trn)
remove(tst)
remove(trn)

# Read features
features <- read.table("features.txt", col.names=c("ID", "Feature"))

# Limit features to mean and std only 
f.mean.std <- rbind(features[grep("-mean\\(\\)", features$Feature),], features[grep("-std\\(\\)", features$Feature),])

# Subset dataset to only mean and std columns 
complete.set <- complete.set[,f.mean.std[,c("ID")]]

# Create proper names 
f.mean.std$ColName <- gsub("\\(\\)", "", f.mean.std[,c("Feature")])
f.mean.std$ColName <- make.names(f.mean.std$ColName) 

# Assign column names
names(complete.set) <- f.mean.std$ColName


# Read test and traing activity labels 
tst.activities <- read.table("test/y_test.txt", col.names=c("ActivityID"))
trn.activities <- read.table("train/y_train.txt", col.names=c("ActivityID"))

# Join activity labels
# It's critical to execute rbind with the same parameter order as in rbind 
# joining main datasets
complete.activities <- rbind(tst.activities, trn.activities)
remove(tst.activities)
remove(trn.activities)

# Read activity labels
activity.names <- read.table("activity_labels.txt", col.names=c("ActivityID", "ActivityName"))

# Assign names to activities 
complete.activities$ActivityName <- activity.names[complete.activities$ActivityID, c("ActivityName")]

# Add activity name to main dataset
complete.set$ActivityName <- complete.activities[, c("ActivityName")]


# Read test and train subject ID's
tst.subject <- read.table("test/subject_test.txt", col.names=c("SubjectID"))
trn.subject <- read.table("train/subject_train.txt", col.names=c("SubjectID"))
# Join subject datasets (order!)
complete.subject <- rbind(tst.subject, trn.subject)
remove(tst.subject)
remove(trn.subject)

# Add subject to main dataset
complete.set$Subject <- complete.subject[, c("SubjectID")]

# Melt and dcast to calculate avg over ActivityName / Subject
library(reshape2)
complete.set.M <- melt(complete.set, id=c("ActivityName", "Subject"), measure.vars=f.mean.std$ColName)
final.wide <- dcast(complete.set.M, ActivityName + Subject ~ variable, mean)
# Prefix measures with Avg.
names(final.wide) <-  ifelse(names(final.wide) %in% c("Subject", "ActivityName"), names(final.wide), make.names(paste("Avg", names(final.wide))))

write.table(final.wide, file="final.wide.txt")
