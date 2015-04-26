# 1. Merges the training and the test sets to create one data set.

  setwd("~/Spring 2015/MATH378/R/Working Directory")
  
  trainx <- read.table("UCI HAR Dataset/train/X_train.txt")
  testx <- read.table("UCI HAR Dataset/test/X_test.txt")
  
  trainy <- read.table("UCI HAR Dataset/train/y_train.txt")
  testy <- read.table("UCI HAR Dataset/test/y_test.txt")
  
  trainsubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
  testsubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
  
  xdata <- rbind(testx, trainx)
  ydata <- rbind(testy, trainy)
  subjectdata <- rbind(testsubject, trainsubject)

  
# 2. Extracts only the measurements on the mean and standard.
  
  features <- read.table("UCI HAR Dataset/features.txt")
  meanandstdev <- grep("-(mean|std)\\(\\)", features[, 2])
  xdata <- xdata[, meanandstdev]
  names(xdata) <- features[meanandstdev, 2]
  
# Cleaning up variable names.
      
  names(xdata) <- gsub("\\()", "", names(xdata))
  names(xdata) <- gsub("-", "", names(xdata))
  names(xdata) <- gsub("mean", "Mean", names(xdata))
  names(xdata) <- gsub("std", "StDev", names(xdata))
  View(xdata)
  
# 3. Uses descriptive activity names to name the activities in the data set.
  
  activities <- read.table("UCI HAR Dataset/activity_labels.txt")
  ydata[, 1] <- activities[ydata[, 1], 2]
  names(ydata) <- "activity"
  
# 4. Appropriately label the data set with descriptive variable names.
  
  names(subjectdata) <- "subject"
  combined <- cbind(xdata, ydata, subjectdata)
  
# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
  
  library(plyr)
  averages <- ddply(combined, .(combined$subject, combined$activity), function(x) colMeans(x[, 1:66]))
  
  write.table(averages, "combinedcleandata.txt", row.name= FALSE)

  