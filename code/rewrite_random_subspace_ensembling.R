## Rewrite Random Subspace Ensembling

rm(list = ls())

# Function Definitions ----------------------------------------------------

acs <- function(y, yhat){ 
  denom <- mean(y)
  crit  <- (abs(y - yhat) / denom) ^ 2
  crit  <- sum(crit)
  return(crit)
}


# Loading Script ----------------------------------------------------------

setwd("../data")
source("load_shortdata.R", chdir = TRUE)

fileList <- list.files()
dmcTemp <- read.csv(fileList[grepl("dmc_",fileList)], stringsAsFactors=FALSE)

dropVarsDmc <- c("orderTime","couponsReceived" 
                 ,"orderWeekday","receivedWeekday","orderDaytime","receivedDaytime"
                 ,"orderedDayOfMonth"
                 ,as.vector(outer(c("couponID","brand","productGroup","categoryIDs","productID"), 1:3, paste, sep="")))
dmcTemp<-dmcTemp[!names(dmcTemp) %in%  dropVarsDmc]


for (var in c("coupon1Used","coupon2Used","coupon3Used", "userID"
)){
  dmcTemp[,var] <- as.factor(dmcTemp[,var])
}

for (var in colnames(dmcTemp)[grepl("Cluster",colnames(dmcTemp))& !grepl("woe",colnames(dmcTemp))]){
  dmcTemp[,var] <- factor(dmcTemp[,var])
}

# dmcTrain <- subset(dmcTemp,dmcTemp$trainingSetIndex==1)
dmcTest <- subset(dmcTemp,dmcTemp$trainingSetIndex==0)
# dmcClass <- subset(dmcTemp,dmcTemp$trainingSetIndex==-1)
# dmcTrain$trainingSetIndex <- NULL
dmcTest$trainingSetIndex <- NULL
# dmcClass$trainingSetIndex <- NULL
rm(dmcTemp)

# dmcTrain2 <- dmcTrain[,-(70:90)]
# 
# dmcTrain3 <- dmcTrain[!names(dmcTrain) %in%  grep("lust",colnames(dmcTrain), value=TRUE)]

rm("dmcClass", "dmcTrain", "dmcTrain2", "dmcTrain3", "dropVarsDmc", "fileList", "var")

t1.real.test <- as.numeric(dmcTest$coupon1Used) - 1
t2.real.test <- as.numeric(dmcTest$coupon2Used) - 1
t3.real.test <- as.numeric(dmcTest$coupon3Used) - 1
bv.real.test <- as.numeric(dmcTest$basketValue)

rm(dmcTest)

# Load individual model prediction matrix on test set ---------------------

setwd("../model-library/predictions")

t1.pred.test <- read.csv("meta_pred_test_all_t1.csv", header = TRUE,
                                    sep = ";", dec = ",")
t2.pred.test <- read.csv("meta_pred_test_all_t2.csv", header = TRUE,
                         sep = ";", dec = ",")
t3.pred.test <- read.csv("meta_pred_test_all_t3.csv", header = TRUE,
                         sep = ";", dec = ",")
bv.pred.test <- read.csv("meta_pred_test_all_bv.csv", header = TRUE,
                         sep = ";", dec = ",")

# Load individual model performance on test set ---------------------------

setwd("../model-library/Test Set Comparisons")

t1.perf <- read.csv("basemodels_t1_all.data.sets_.csv", header = TRUE,
                    sep = ";", dec = ",")
t2.perf <- read.csv("basemodels_t2_all.data.sets_.csv", header = TRUE,
                    sep = ";", dec = ",")
t3.perf <- read.csv("basemodels_t3_all.data.sets_.csv", header = TRUE,
                    sep = ";", dec = ",")[, c(1, 3)]
bv.perf <- read.csv("basemodels_bv_all.data.sets_.csv", header = TRUE,
                    sep = ";", dec = ",")

t1.perf[[2]] <- as.numeric(levels(t1.perf[[2]])[t1.perf[[2]]])
t2.perf[[2]] <- as.numeric(levels(t2.perf[[2]])[t2.perf[[2]]])
t3.perf[[2]] <- as.numeric(levels(t3.perf[[2]])[t3.perf[[2]]])
bv.perf[[2]] <- as.numeric(levels(bv.perf[[2]])[bv.perf[[2]]])

# Parameter settings ------------------------------------------------------

# loss function scores to beat
t1.lo <- 3579.953
t2.lo <- 5551.846
t3.lo <- 5896.166
bv.lo <- 2486.104

# coupon baselines (global mean + 10 %)
t1.bl <- 3891.394 * 1.1
t2.bl <- 6038.020 * 1.1
t3.bl <- 6455.445 * 1.1
# bv baseline (4th worst individual base model - mlpWeightDecay)
bv.bl <- 3832.265

# # first, simple approach
# # t1 probability weights
# t1.pw <- nrow(t1.perf):1 / sum(nrow(t1.perf):1)
# # t2 probability weights
# t2.pw <- nrow(t2.perf):1 / sum(nrow(t2.perf):1)
# # t3 probability weights
# t3.pw <- nrow(t3.perf):1 / sum(nrow(t3.perf):1)
# # bv probability weights
# bv.pw <- nrow(bv.perf):1 / sum(nrow(bv.perf):1)

# second, more sophisticated approach
t1.diff <- (t1.bl - t1.perf[[2]])
t1.diff[t1.diff < 0] <- 0
t1.diff[which(t1.perf[, 1] %in% "econ")] <- max(t1.diff) # manually give equally high weight to econ approach (because it views the data differently and ensemble profit from that)
t2.diff <- (t2.bl - t2.perf[[2]])
t2.diff[t2.diff < 0] <- 0
t2.diff[which(t2.perf[, 1] %in% "econ")] <- max(t2.diff) 

t3.diff <- (t3.bl - t3.perf[[2]])
t3.diff[t3.diff < 0] <- 0
t3.diff[which(t3.perf[, 1] %in% "econ")] <- max(t3.diff) 

bv.diff <- (bv.bl - bv.perf[[2]])
bv.diff[bv.diff < 0] <- 0
bv.diff[which(bv.perf[, 1] %in% "econ")] <- max(bv.diff) 

# t1 probability weights
t1.pw <- t1.diff / sum(t1.diff) 
# t2 probability weights
t2.pw <- t2.diff / sum(t2.diff) 
# t3 probability weights
t3.pw <- t3.diff / sum(t3.diff) 
# bv probability weights
bv.pw <- bv.diff / sum(bv.diff) 

# max. iterations 
k <- 10 ^ 2
# 10^5 = 1 min
# 10^6 = 10 min
# 10^7 = 1.5 h

# sample size
n <- 10

rm(t1.bl, t2.bl, t3.bl, bv.bl, t1.diff, t2.diff, t3.diff, bv.diff)

# Subspace Creation -------------------------------------------------------

for(i in 1:k) {
  while(t1.ens.loss < t1.lo) {
    t1.ens <- sample(t1.perf[, 1], n, replace = TRUE, prob = t1.pw)
    for(j in 1:n) {
      t1.pred.test[which(t1.pred.test[[1]]%in% t1.ens), ]
    }
    t1.ens.loss <- acs(t1.real.test, t1.pred.test[])
  }
}

# Prediction and Saving ---------------------------------------------------

#which(names(pred_t2) %in% t2.best
