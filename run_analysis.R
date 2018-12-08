#Call library and Read all data for the Assignment

#Call required library and 
library(dplyr)

#Read all training set files

X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/Y_train.txt")
train_subject <- read.table("./train/subject_train.txt")

#Read all test set files
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/Y_test.txt")
test_suject <- read.table("./test/subject_test.txt")

#Read feature
features <- read.table("./features.txt")

# read activity labels
activity_labels <- read.table("./activity_labels.txt")


#Merges the training and the test sets to create one data set
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(train_subject, test_suject)


#Extracts only the measurements on the mean and standard deviation for each measurement
Extracts <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
X_total <- X_total[,Extracts[,1]]


#Uses descriptive activity names to name the activities in the data set

colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activity_labels <- Y_total[,-1]



#Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- features[Extracts[,1],2]



#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activity_labels, Sub_total)
total_mean <- total %>% group_by(activity_labels, subject) %>% summarize_all(funs(mean))
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)
