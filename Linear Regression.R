#Remove warnings
options(warn=-1)

##----------------------------------------------------------------------------------##
##--- SIMPLE LINEAR REGRESSION MODEL building ------##
##----------------------------------------------------------------------------------##


##--- Step 1: Clear environment variables ------------------------------------------##
rm(list=ls(all=TRUE))

##__________________________________________________________________________________##


##--- Step 2: Set working Directory ------------------------------------------------##
##setwd
getwd()
setwd("C:/Users/Ben Roshan/Documents")
##__________________________________________________________________________________##


##--- Step 3: Read the data from the csv file --------------------------------------##
cars_data=read.csv(file='Toyota_SimpleReg.csv',header=T)
names(cars_data)
str(cars_data)
summary(cars_data)
##__________________________________________________________________________________##


##--- Step 4: Perform Exploratory Data Analysis and Data Pre-processing-------------##
## Drop any irrelevant attribute(s):
cars_data=cars_data[,-c(1,2)]

## Summary of the data and look for any missing values:
str(cars_data)
summary(cars_data)
#No missing values

## Correlation and Covariance between the attributes:
cov(cars_data)
#The covariance of the age of car and price is -59136.11
#It indicates a negative linear relationship between two variables
#This relation could be observed from the scatter plot also
plot(cars_data$Age_06_15,cars_data$Price)
plot(cars_data$Age_06_15,cars_data$Price,xlab="Age of the car",ylab="Price in ($)",pch=18,col="red")

cor(cars_data)
cor(cars_data$Age_06_15,cars_data$Price)
#The correlation coefficient of the age of the car and price is -0.8765905


##__________________________________________________________________________________##


##--- Step 5: Split the data into train and test datasets --------------------------##
#Split in (train:test) in (80:20) ratio
rows=seq(1,nrow(cars_data),1)
set.seed(123)
trainRows=sample(rows,(70*nrow(cars_data))/100)
cars_train=cars_data[trainRows,]
cars_test=cars_data[-trainRows,]

trainRows1=sample(rows,(80*nrow(cars_data))/100)
cars_train1=cars_data[trainRows1,]
cars_test1=cars_data[-trainRows1,]

trainRows2=sample(rows,(90*nrow(cars_data))/100)
cars_train2=cars_data[trainRows2,]
cars_test2=cars_data[-trainRows2,]

##__________________________________________________________________________________##


##--- Step 6: Linear regression model building--------------------------------------##
linreg=lm(Price~Age_06_15,data=cars_train)
linreg
coefficients(linreg)
linreg1=lm(Price~Age_06_15,data=cars_train1)
linreg1
coefficients(linreg1)
linreg2=lm(Price~Age_06_15,data=cars_train2)
linreg2
coefficients(linreg2)

## Summary of model:
summary(linreg)
plot(linreg$residuals)

linreg$fitted.values
plot(linreg$fitted.values)


##__________________________________________________________________________________##


##--- Step 7: Check for validity of linear regression assumptions ------------------##
#HINT: plot the 4 graphs to check. Write your comments
par(mfrow=c(2,2))
plot(linreg)
par(mfrow=c(1,1))
##__________________________________________________________________________________##


##--- Step 8: Predict on testdata --------------------------------------------------##
test_prediction=predict(linreg,cars_test)
test_prediction
plot(test_prediction)
test_actual=cars_test$Price
plot(test_actual)
##__________________________________________________________________________________##


##--- Step 9: Error Metrics --------------------------------------------------------##
library(DMwR)

#Error verification on train data
regr.eval(cars_train$Price,linreg$fitted.values)
plot(regr.eval(cars_train$Price,linreg$fitted.values))

#Error verification on test data
regr.eval(test_actual,test_prediction)


##__________________________________________________________________________________##


##--- Step 10: Confidence and Prediction Intervals----------------------------------##
#Find the confidence and prediction intervals and plot them for the WHOLE dataset
conf_pred=data.frame(predict(linreg,cars_test,interval="confidence",level=0.95))
pred_pred=data.frame(predict(linreg,cars_test,interval="prediction",level=0.95))
str(conf_pred)
names(conf_pred)
summary(conf_pred)
plot(conf_pred)

points(cars_test$Age_06_15,conf_pred$fit,type="l",col="green",lwd=2)
points(cars_test$Age_06_15,conf_pred$fit,type="-",col="green",lwd=4)
##__________________________________________________________________________________##
#-----------------------end---------------------------------------------------------##