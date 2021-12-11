# we are using here caret package for machine learning algorithms and dplyr package for data preprocessing

# installation of both the packages 
# command
# install.packages('caret')
# install.packages('dplyr')

# add package into the working environment
library(caret)
library(dplyr)

# load the dataset
x <- c(1:100)
x1 <- seq(1,100, by =1)
x2 <- sample(100)
x3 <- sample(100)
y <-  sample(c(0,1), replace=TRUE, size=100)

data <- data.frame(x, x1, x2, x3,y)
View(data)
str(data)

#convert the target variable into the factor
data$y <- as.factor(data$y)
str(data)
nrow(data)
dim(data)

# do the data partition for the training and testing of the machine learning model
set.seed(3303)
intrain <- createDataPartition(y = data$y, p = 0.70, list = FALSE)
training <- data[intrain,]
testing <- data[-intrain,]

# check out is there any na or missing values
anyNA(data)

summary(data)

trctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

svm_Linear <- train(y~., data = training, method = "svmLinear",
                    trControl = trctrl, preProcess = c("center", "scale"), tuneLength = 10)

svm_Linear

test_pred <- predict(svm_Linear, newdata = testing)
test_pred

# check the performance of the model
confusionMatrix(table(test_pred, testing$y))


grid <- expand.grid(C = c(0, 0.1, 0.5, 0.1, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 5))

grid_model <- train(y~., data = training, method = "svmLinear", 
                    trControl = trctrl, preProcess = c("center", "scale"),
                    tuneGrid = grid, tuneLength = 10)

grid_model
grid_pred <- predict(grid_model, newdata = testing)
grid_pred

confusionMatrix(table(grid_pred, testing$y))
