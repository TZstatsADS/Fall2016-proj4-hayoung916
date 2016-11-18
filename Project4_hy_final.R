# ADS project4, Words 4 Music, hayoung kim (hk2857)

# library used
library(rhdf5)
library(purrr)
library(Hmisc)
library(fields)
library(lsa)
library(proxy)
library(matrixStats)

# set working directory
setwd("C:/Users/user/Desktop/Statistics/3rd semester/ADS/Project4/Project4_data")
# load bag-of-words
load("./lyr.rdata")
# delete absurd lyric
lyr<-lyr[,-c(1,2,3,6:30)]
# loop through folders to load all features
   # search all file names
   dir.list.train<-dir(path="./data/data",recursive=TRUE)
   dir.list.test<-dir(path="./TestSongFile100/TestSongFile100",recursive=TRUE) # consider this order when submitting results
   # preallocate an empty list
   features.train<-vector("list",length(dir.list.train))
   features.test<-vector("list",length(dir.list.test))
   
   # fill out 'train features', list of 2350
   for(i in 1:length(dir.list.train)){
	   filename = sprintf("./data/data/%s",dir.list.train[i])
	   print(filename)
	   features.train[[i]]<-h5read(filename,"/analysis")}
   # delete 'songs' in each list
   for (i in 1:length(dir.list.train)){
      features.train[[i]]$songs<-NULL}
   
   # fill out 'test features', list of 100
   for(i in 1:length(dir.list.test)){
	   filename = sprintf("./TestSongFile100/TestSongFile100/%s",dir.list.test[i])
	   print(filename)
	   names(features.test[i])<-dir.list.test[i]
	   features.test[[i]]<-h5read(filename,"/analysis")}

# recheck data structure
str(features.train[[1]]) #2350 list 15 features
str(features.test[[1]]) #100 list

# set up function to use for feature extraction
   # original range
   org.range<-function(x){
      org<-max(x)-min(x)
      return(org)
      }
# interquartile range
   int.range<-function(x){
      int<-quantile(x,probs=3/4)-quantile(x,probs=1/4)
      names(int)<-NULL
      return(int)
      }
# average range
   avrg.range<-function(x){
      avrg<-(max(x)-min(x))/length(x)
      return(avrg)
   }
   
# preallocate an empty matrix
features.train.selected<-matrix(nrow=length(dir.list.train),ncol=46)
features.test.selected<-matrix(nrow=length(dir.list.test),ncol=46)

# extract 46 features from train set (based on my judgement)
   system.time(for(i in 1:length(dir.list.train)){
         features.train.selected[i,]<-cbind(mean(features.train[[i]]$bars_confidence),
                                            sd(features.train[[i]]$bars_confidence),
                                            org.range(features.train[[i]]$bars_confidence),
                                            int.range(features.train[[i]]$bars_confidence),
                                            
                                            avrg.range(features.train[[i]]$bars_start),
                                            
                                            mean(features.train[[i]]$beats_confidence),
                                            sd(features.train[[i]]$beats_confidence),
                                            org.range(features.train[[i]]$beats_confidence),
                                            int.range(features.train[[i]]$beats_confidence),
                                            
                                            avrg.range(features.train[[i]]$beats_start),
                                             
                                            mean(features.train[[i]]$sections_confidence),
                                            sd(features.train[[i]]$sections_confidence),
                                            org.range(features.train[[i]]$sections_confidence),
                                            int.range(features.train[[i]]$sections_confidence),
                                            
                                            avrg.range(features.train[[i]]$sections_start),
                                             
                                            mean(features.train[[i]]$segments_confidence),
                                            sd(features.train[[i]]$segments_confidence),
                                            org.range(features.train[[i]]$segments_confidence),
                                            int.range(features.train[[i]]$segments_confidence),
                                            
                                            mean(features.train[[i]]$segments_loudness_max),
                                            sd(features.train[[i]]$segments_loudness_max),
                                            org.range(features.train[[i]]$segments_loudness_max),
                                            int.range(features.train[[i]]$segments_loudness_max),
                                            
                                            mean(features.train[[i]]$segments_loudness_max_time),
                                            sd(features.train[[i]]$segments_loudness_max_time),
                                            org.range(features.train[[i]]$segments_loudness_max_time),
                                            int.range(features.train[[i]]$segments_loudness_max_time),
                                            
                                            mean(features.train[[i]]$segments_loudness_start),
                                            sd(features.train[[i]]$segments_loudness_start),
                                            org.range(features.train[[i]]$segments_loudness_start),
                                            int.range(features.train[[i]]$segments_loudness_start),
                                          
                                            mean(as.vector(features.train[[i]]$segments_pitches)),
                                            sd(as.vector(features.train[[i]]$segments_pitches)),
                                            org.range(as.vector(features.train[[i]]$segments_pitches)),
                                            int.range(as.vector(features.train[[i]]$segments_pitches)),
                                            
                                            avrg.range(features.train[[i]]$segments_start),
                                            
                                            mean(as.vector(features.train[[i]]$segments_timbre)),
                                            sd(as.vector(features.train[[i]]$segments_timbre)),
                                            org.range(as.vector(features.train[[i]]$segments_timbre)),
                                            int.range(as.vector(features.train[[i]]$segments_timbre)),
                                            
                                            mean(as.vector(features.train[[i]]$tatums_confidence)),
                                            sd(as.vector(features.train[[i]]$tatums_confidence)),
                                            org.range(as.vector(features.train[[i]]$tatums_confidence)),
                                            int.range(as.vector(features.train[[i]]$tatums_confidence)),
                                       
                                            avrg.range(features.train[[i]]$tatums_start),
                                            mean(features.train[[i]]$tatums_start))})

# delete na rows from train set
index.na<-which(is.na(features.train.selected),TRUE)[,1][which(duplicated(which(is.na(features.train.selected),TRUE)[,1])==FALSE)]
features.train.selected<-features.train.selected[-index.na,]
lyr<-lyr[-index.na,]

# extract 46 features from test set (based on my judgement)
   system.time(for(i in 1:length(dir.list.test)){
         features.test.selected[i,]<-cbind(mean(features.test[[i]]$bars_confidence),
                                            sd(features.test[[i]]$bars_confidence),
                                            org.range(features.test[[i]]$bars_confidence),
                                            int.range(features.test[[i]]$bars_confidence),
                                            
                                            avrg.range(features.test[[i]]$bars_start),
                                            
                                            mean(features.test[[i]]$beats_confidence),
                                            sd(features.test[[i]]$beats_confidence),
                                            org.range(features.test[[i]]$beats_confidence),
                                            int.range(features.test[[i]]$beats_confidence),
                                            
                                            avrg.range(features.test[[i]]$beats_start),
                                             
                                            mean(features.test[[i]]$sections_confidence),
                                            sd(features.test[[i]]$sections_confidence),
                                            org.range(features.test[[i]]$sections_confidence),
                                            int.range(features.test[[i]]$sections_confidence),
                                            
                                            avrg.range(features.test[[i]]$sections_start),
                                             
                                            mean(features.test[[i]]$segments_confidence),
                                            sd(features.test[[i]]$segments_confidence),
                                            org.range(features.test[[i]]$segments_confidence),
                                            int.range(features.test[[i]]$segments_confidence),
                                            
                                            mean(features.test[[i]]$segments_loudness_max),
                                            sd(features.test[[i]]$segments_loudness_max),
                                            org.range(features.test[[i]]$segments_loudness_max),
                                            int.range(features.test[[i]]$segments_loudness_max),
                                            
                                            mean(features.test[[i]]$segments_loudness_max_time),
                                            sd(features.test[[i]]$segments_loudness_max_time),
                                            org.range(features.test[[i]]$segments_loudness_max_time),
                                            int.range(features.test[[i]]$segments_loudness_max_time),
                                            
                                            mean(features.test[[i]]$segments_loudness_start),
                                            sd(features.test[[i]]$segments_loudness_start),
                                            org.range(features.test[[i]]$segments_loudness_start),
                                            int.range(features.test[[i]]$segments_loudness_start),
                                          
                                            mean(as.vector(features.test[[i]]$segments_pitches)),
                                            sd(as.vector(features.test[[i]]$segments_pitches)),
                                            org.range(as.vector(features.test[[i]]$segments_pitches)),
                                            int.range(as.vector(features.test[[i]]$segments_pitches)),
                                            
                                            avrg.range(features.test[[i]]$segments_start),
                                            
                                            mean(as.vector(features.test[[i]]$segments_timbre)),
                                            sd(as.vector(features.test[[i]]$segments_timbre)),
                                            org.range(as.vector(features.test[[i]]$segments_timbre)),
                                            int.range(as.vector(features.test[[i]]$segments_timbre)),
                                            
                                            mean(as.vector(features.test[[i]]$tatums_confidence)),
                                            sd(as.vector(features.test[[i]]$tatums_confidence)),
                                            org.range(as.vector(features.test[[i]]$tatums_confidence)),
                                            int.range(as.vector(features.test[[i]]$tatums_confidence)),
                                       
                                            avrg.range(features.test[[i]]$tatums_start),
                                            mean(features.test[[i]]$tatums_start))})

# check the existence of na rows from test set: NO na rows
which(is.na(features.test.selected),TRUE)

# calculate cosine distance (idea from amazon recommendation document) - 1: correlated
system.time(cos.dist<-cosine(cbind(t(features.train.selected),t(features.test.selected))))
# partition needed (train-test transaction)
cos.dist.part<-cos.dist[1:(dim(features.train.selected)[1]),(dim(features.train.selected)[1]+1):(dim(features.train.selected)[1]+dim(features.test.selected)[1])]

# rank based on cosine distance (mean of closest 30)
rank.cos.30<-matrix(data=NA,nrow=dim(cos.dist.part)[2],ncol=dim(lyr)[2])
   system.time(for (i in 1:dim(cos.dist.part)[2]){
      sim.row<-which(cos.dist.part[,i]%in%sort(cos.dist.part[,i],decreasing=T)[1:30])
      rank.cos.30[i,]<-rank(-colWeightedMeans(lyr[sim.row,],w=cos.dist.part[sim.row,i])) # ties are averaged 
      })
   
rownames(rank.cos.30)<-dir.list.test
colnames(rank.cos.30)<-colnames(lyr)

write.csv(rank.cos.30,file = "rank.cos.30.check.csv",col.names=TRUE,row.names=TRUE)
