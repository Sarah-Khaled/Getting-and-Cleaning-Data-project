########download and unzip the the data################################
setwd("G:\\datascience\\project3\\")
if(!file.exists("./dataset")){dir.create("./dataset")}
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./dataset/project3.zip")
##Unzip the dataset
unzip(zipfile="./dataset/project3.zip",exdir="./dataset")
#########################################################################

#############Read ALL Data##############################################
subject_test <- read.table("dataset\\UCI HAR Dataset\\test\\subject_test.txt")
subject_train <- read.table("dataset\\UCI HAR Dataset\\train\\subject_train.txt")
X_test <- read.table("dataset\\UCI HAR Dataset\\test\\X_test.txt")
X_train <- read.table("dataset\\UCI HAR Dataset\\train\\X_train.txt")
y_test <- read.table("dataset\\UCI HAR Dataset\\test\\y_test.txt")
y_train <- read.table("dataset\\UCI HAR Dataset\\train\\y_train.txt")
activity_labels <- read.table("dataset\\UCI HAR Dataset\\activity_labels.txt")
features <- read.table("dataset\\UCI HAR Dataset\\features.txt") 
########################################################################

########### Task 1Mearge Data##################################################
subject_Data<-rbind(subject_train,subject_test)
names(subject_Data) <- "subjectID"      #give name to subject_data column
X_Data<-rbind(X_train,X_test)
names(X_Data) <- features$V2     #give features names to X_Data columns 
y_Data<-rbind(y_train,y_test)
names(y_Data) <- "activity"      #give  name to y_Data columns
        ##create one dataset##
dataset<-cbind(subject_Data,y_Data,X_Data)
########################################################################

########### Task 2 Extracts only the measurements on the mean and std###########
##get mean and std positions 
mean_std_only <- grep("mean()|std()", names(dataset))
Extracteddataset <- dataset[,mean_std_only]
dataset<-cbind(dataset[,1:2],Extracteddataset)    #Keep the Activity and subject ID columns
#######################################################################

#######Task 3 Uses descriptive activity names to name the activities in the data set.
              ####already done above###########

#############Task4 Appropriately labels the data set with descriptive variable names#
names(dataset)<-gsub("^t", "time", names(dataset))
names(dataset)<-gsub("^f", "frequency", names(dataset))
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("BodyBody", "Body", names(dataset))
#####################################################################################

#######Task 5 Creates a second, independent tidy data set with the
#######average of each variable for each activity and each subject
library(reshape2)
melt_data <- melt(dataset, id=c("subjectID","activity"))
tidy_dataset <- dcast(melt_data, subjectID+activity ~ variable, mean)
write.csv(tidy_dataset, "tidy_dataset", row.names=FALSE)