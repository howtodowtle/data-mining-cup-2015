# put this into your code to automatically set the working directory
# source("yourPathName/load_data.R", chdir = TRUE)
# make sure the source file is in the same folder as the data
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

dmcTrain <- subset(dmcTemp,dmcTemp$trainingSetIndex==1)
dmcTest <- subset(dmcTemp,dmcTemp$trainingSetIndex==0)
dmcClass <- subset(dmcTemp,dmcTemp$trainingSetIndex==-1)
dmcTrain$trainingSetIndex <- NULL
dmcTest$trainingSetIndex <- NULL
dmcClass$trainingSetIndex <- NULL
rm(dmcTemp)

dmcTrain2 <- dmcTrain[,-(70:90)]

dmcTrain3 <- dmcTrain[!names(dmcTrain) %in%  grep("lust",colnames(dmcTrain), value=TRUE)]


