#source("https://bioconductor.org/biocLite.R")
#biocLite("rhdf5")
load("~/Downloads/Project4_data/lyr.RData")
library(rhdf5)
lyr.new<-lyr[,-c(1,2,3,6:30)]

###Use LDA to determine K=10 topics

library(topicmodels)
topics<- LDA(lyr.new, k=10, method = "Gibbs", control = NULL, model = NULL)

###music features: keep the segments_pitches and segments_timbre features

files <- dir('~/Downloads/Project4_data/data/', recursive = T, full.names = T, pattern = '\\.h5$')
pitches <- vector("list", length = length(files))
timbre <- vector ("list", length = length(files))
for (i in 1:length(files)){
  pitches[[i]] <- h5read(file = files[i], "/analysis")[[11]]
  timbre[[i]] <- h5read(file = files[i], "/analysis")[[13]]
}

###Transform the matrixs into vectors

pitches.df<-t(sapply(pitches,function(x) rep(x,length.out=6000)))
timbre.df<-t(sapply(timbre,function(x) rep(x,length.out=6000)))
feature<-cbind(pitches.df,timbre.df)

####Ridge regression and cross validation 

library(glmnet)
library(MASS)
ridge.fit <- cv.glmnet(feature, topics@gamma, family=c("mgaussian"), alpha=0, nfold=5)
ridge.fit.test <- glmnet(feature, topics@gamma, family=c("mgaussian"), lambda = ridge.fit$lambda.min, alpha = 0)

####Test Prediction

files.test <- dir('~/Downloads/TestSongFile100/', recursive = T, full.names = T, pattern = '\\.h5$')
pitches.test <- vector("list", length = length(files.test))
timbre.test <- vector ("list", length = length(files.test))
for (i in 1:length(files.test)){
  pitches.test[[i]] <- h5read(file = files.test[i], "/analysis")[[11]]
  timbre.test[[i]] <- h5read(file = files.test[i], "/analysis")[[13]]
}
pitches.df.test<-t(sapply(pitches.test,function(x) rep(x,length.out=6000)))
timbre.df.test<-t(sapply(timbre.test,function(x) rep(x,length.out=6000)))
feature.test<-cbind(pitches.df,timbre.df)
prediction<-predict(ridge.fit.test,as.matrix(feature.test),type="response")[1:100,1:10,1]%*%exp(topics@beta)
rank<-t(apply(-prediction,1,rank))

###Add the removed columns & Produce output as required format

id<-sprintf("testsong%d",seq(1,100))
v<-rep(4987,100)
output<-cbind(id,v,v,rank[,1:2],matrix(rep(v,25),100),rank[,3:4973])
colnames(output)<-colnames(lyr)
write.csv(output,file="~/downloads/output.csv")
