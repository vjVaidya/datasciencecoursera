#######################################################################
# #Data
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#You should create one R script called run_analysis.R that does the following.
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Set Working Directory
setwd("C:/Users/im_g/workspace/datasciencecoursera/getting and cleaning data/UCI HAR Dataset")

## step 1 read all the data available and for training. Merge the training and the test data.
test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
test.data <- read.table("test/X_test.txt")
train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
train.data <- read.table("train/X_train.txt")

# Merge together the complete data in the format of: subjects, labels, remaining data and then merge.
data <- rbind(cbind(test.subjects, test.labels, test.data),
              cbind(train.subjects, train.labels, train.data))

## step 2: Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
# We retain the features of mean and standard deviation as required
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# The mean and standard deviations from data are selected as required 
# The subject and label columns are to be skipped, hence the increment of 2.
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

## step 3: read the labels (activities) - name the activities in the data set
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
data.mean.std$label <- labels[data.mean.std$label, 2]

## step 4: a list of the current column names and feature names is made
good.colnames <- c("subject", "label", features.mean.std$V2)
# Removing the non-alphabetic characters, converting to lowercase will make the new list tidy.
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
# the list will now be used as the column names for the data
colnames(data.mean.std) <- good.colnames

## step 5: find the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

## using row.name=FALSE (do not cut and paste a dataset directly into the text box, 
# as this may cause errors saving your submission).
write.table(format(aggr.data, scientific=T), "tidy.txt",
            row.names=F, col.names=F, quote=2)
