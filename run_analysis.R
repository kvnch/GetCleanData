# read feature variable names
features <- read.csv('features.txt', header = FALSE, sep = ' ')
features <- as.character(features[, 2])

# read test data
subject.test <- read.csv('test/subject_test.txt', header = FALSE)
x.test <- read.table('test/X_test.txt', header = FALSE)
y.test <- read.csv('test/y_test.txt', header = FALSE)

# read train data
subject.train <- read.csv('train/subject_train.txt', header = FALSE)
x.train <- read.table('train/X_train.txt', header = FALSE)
y.train <- read.csv('train/y_train.txt', header = FALSE)

# create data frames
test <- data.frame(subject.test, y.test, x.test)
train <- data.frame(subject.train, y.train, x.train)

# name variable names in data frame
headers <- c(c('subject', 'activity'), features)
names(test) <- headers
names(train) <- headers

# merge mean and std variables into one data frame
varToKeep <- c(1, 2, grep('mean|std', names(test)))
all <- rbind(test, train)[, varToKeep]

# read activity labels and match with activity codes
labels <-
  read.csv('activity_labels.txt', header = FALSE, sep = ' ')[, 2]
all$activity <- labels[all$activity]

# clean up variable names
cleanNames <- names(all)
cleanNames <- gsub("[(][)]", "", cleanNames)
cleanNames <- gsub("^t", "Time_", cleanNames)
cleanNames <- gsub("^f", "Frequency_", cleanNames)
cleanNames <- gsub("Acc", "Accelerometer", cleanNames)
cleanNames <- gsub("Gyro", "Gyroscope", cleanNames)
cleanNames <- gsub("Mag", "Magnitude", cleanNames)
cleanNames <- gsub("-mean", "_Mean_", cleanNames)
cleanNames <- gsub("-std", "_StandardDeviation_", cleanNames)
cleanNames <- gsub("-", "_", cleanNames)

names(all) <- cleanNames

# aggregate mean values by activity and subject
aggregated <-
  aggregate(
    x = all[, 3:81],
    by = list(activity = all$activity, subject = all$subject),
    FUN = mean
  )

# save tidied data in a text file
write.table(x = aggregated, file = "tidy_data.txt", row.names = FALSE)