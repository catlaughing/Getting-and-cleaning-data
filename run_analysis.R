## load the library
library(data.table)
library(dplyr)

## Load the test data
test_X <- fread("./UCI HAR Dataset/test/X_test.txt")
test_Y <- fread("./UCI HAR Dataset/test/y_test.txt")
test_subject <- fread("./UCI HAR Dataset/test/subject_test.txt")

## Load the train data
train_X <- fread("./UCI HAR Dataset/train/X_train.txt")
train_Y <- fread("./UCI HAR Dataset/train/y_train.txt")
train_subject <- fread("./UCI HAR Dataset/train/subject_train.txt")

## Load the the features and activity
features <- fread("./UCI HAR Dataset/features.txt")
activity <- fread("./UCI HAR Dataset/activity_labels.txt")

## merge the test datasets
test <- cbind(test_subject, test_Y, test_X)

## merge the train datasets
train <- cbind(train_subject, train_Y, train_X)

## Merge train and test
final_dataset <- rbind(test,train)

## Change the column name
names(final_dataset) <- c("subject", "label", features$V2)

## Search variable position for mean and std
variable_position <- grep("mean\\(\\)|std\\(\\)",features$V2,value = TRUE) 

## subset the dataset to extract only the mean and std
final_dataset <- final_dataset[,c("subject","label", ..variable_position)]

## Order the datasets by subject and label
final_dataset <- arrange(final_dataset, subject, label)

## factorize the label and subject
final_dataset$label <- factor(final_dataset$label, labels = activity$V2)
final_dataset$subject <- as.factor(final_dataset$subject)

## change the column names
names(final_dataset) <- sub("-", "",names(final_dataset))
names(final_dataset) <- sub("-", "",names(final_dataset))
names(final_dataset) <- sub("^t", "time",names(final_dataset))
names(final_dataset) <- sub("^f", "freq",names(final_dataset))

## group,  summarise and write the file
tidy <- final_dataset %>% group_by(label, subject) %>% summarize_each(funs(mean))
write.table(tidy, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)