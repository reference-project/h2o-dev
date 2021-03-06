#----------------------------------------------------------------------
# Purpose:  Split Airlines dataset into train and validation sets.
#           Build model and predict on a test Set.
#           Print Confusion matrix and performance measures for test set
#----------------------------------------------------------------------

setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source('../h2o-runit.R')

options(echo=TRUE)

heading("BEGIN TEST")
conn <- h2o.init(ip=myIP, port=myPort)

#uploading data file to h2o
air <- h2o.importFile(conn, path=locate("smalldata/airlines/AirlinesTrain.csv.zip"))

#Constructing validation and train sets by sampling (20/80)
#creating a column as tall as airlines(nrow(air))
s <- h2o.runif(air)    # Useful when number of rows too large for R to handle
air.train <- air[s <= 0.8,]
air.valid <- air[s > 0.8,]

myX <- c("Origin", "Dest", "Distance", "UniqueCarrier", "fMonth", "fDayofMonth", "fDayOfWeek" )
myY <- "IsDepDelayed"

#gbm
air.gbm <- h2o.gbm(x = myX, y = myY, loss = "bernoulli", training_frame = air.train, ntrees = 10, max_depth = 3, learn_rate = 0.01, nbins = 100, validation_frame = air.valid)
print(air.gbm@model)

#glm
air.glm <- h2o.glm(x = myX, y = myY, family = "binomial", training_frame = air.train, do_classification=TRUE, solver = "L_BFGS")
print(air.glm@model)

#uploading test file to h2o
air.test <- h2o.importFile(conn, path=locate("smalldata/airlines/AirlinesTest.csv.zip"))

#predicting & performance on test file
pred.gbm <- predict(air.gbm, air.test)
head(pred.gbm)
perf.gbm <- h2o.performance(air.gbm, air.test)
print(perf.gbm)

pred.glm <- predict(air.glm, air.test)
head(pred.glm)
perf.glm <- h2o.performance(air.glm, air.test)
print(perf.glm)

#Building confusion matrix for test set
CM.gbm <- h2o.confusionMatrices(perf.gbm, 0.5)
print(CM.gbm)
CM.glm <- h2o.confusionMatrices(perf.glm, 0.5)
print(CM.glm)

#Plot ROC for test set
h2o.precision(perf.gbm)
h2o.accuracy(perf.gbm)
h2o.auc(perf.gbm)
plot(perf.gbm,type="roc")

h2o.precision(perf.glm)
h2o.accuracy(perf.glm)
h2o.auc(perf.glm)
plot(perf.glm,type="roc")

PASS_BANNER()


