# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(data.table)
library(reshape2)

activity_labels <- read.table("/Users/apple/Desktop/rr/clean data class/UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("/Users/apple/Desktop/rr/clean data class/UCI HAR Dataset/features.txt",)[,2]
features_extract <- grepl("mean|std", features)
features_extract

# load data 
X_test <- read.table("/Users/apple/Desktop/rr/clean data class/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("/Users/apple/Desktop/rr/clean data class/UCI HAR Dataset/test/Y_test.txt") 
subject_test <- read.table("/Users/apple/Desktop/rr/clean data class/UCI HAR Dataset/test/subject_test.txt") 
X_train <- read.table("/Users/apple/Desktop/rr/clean data class/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("/Users/apple/Desktop/rr/clean data class/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("/Users/apple/Desktop/rr/clean data class/UCI HAR Dataset/train/subject_train.txt")

# Extract only the measurements on the mean and standard deviation for each measurement - test data
names(X_test) <- features 
X_test <- X_test[,features_extract] 
head(X_test,3) 

# Set activity lables - test data 
Y_test[,2] <- activity_labels[Y_test[,1]]    # match labels with y-test 
names(Y_test) <- c("activity_ID", "activity_labels") 
names(subject_test) <- "subject"

# bind data sets - test data 
test_data <- cbind(as.data.table(subject_test),X_test,Y_test)
head(test_data, 3) 

# Extract only the measurements on the mean and standard deviation for each measurement - train data 
names(X_train) = features 
X_train <- X_train[,features_extract]

# Set activity lables - train data 
Y_train[,2] <- activity_labels[Y_train[,1]]
names(Y_train) <- c("activity_ID","activity_labels")
names(subject_train) <- "subject" 

# bind data sets - train data  
train_data <- cbind(as.data.table(subject_train),X_train,Y_train)
head(train_data,3)

# merge & tidy data 
Merged <- rbind(test_data,train_data)
head(Merged,3)
tail(Merged,3) 

ids <- c ("subject", "activity_ID", "activity_labels") 
?setdiff
data_labels <- setdiff(colnames(Merged), ids) 
melt_data <- melt(Merged, id = ids, measure.vars = data_labels) 

# independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- dcast(melt_data, subject+activity_labels~variable,mean)
head(tidy_data) 

# write table 
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)


