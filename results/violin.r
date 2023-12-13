#performing the statistical analyses described in the paper and creating the figures. Set threshold to the desired value below. Make sure the necessary packages (lmerTest etc) are installed, change the R directory to the Data folder.

#library(lmerTest)
#library(effsize)
library(ggplot2)
library(gridExtra)

#langs <- c("komma")
langs <- c("riskera")

#threshold <- 200
for (lang in langs){
    print(lang)
    dataset <- read.csv(paste("ss30_2008,2009,2010\\familjeliv_",lang, "_t0_2008,2009,2010_withcohort.tsv", sep = ""),header=TRUE,sep="\t",dec=".",quote="")
    dataset$agebin <- as.factor(dataset$agebin)
    #if (lang == "Italian"){
      p1 <- ggplot(dataset, aes(x=agebin, y=v2rel, fill=agebin)) + geom_violin(trim=FALSE, scale = "count") + geom_boxplot(width = 0.1) + theme(legend.position="none") + ggtitle(lang) + xlab("cohort") + ylim(0,1) + stat_summary(fun = "mean",  geom = "crossbar", width = 0.5, colour = "yellow") 
     
    #}
    
    
}

grid.arrange(p1)#,p2,p3,p4)
#dev.new()
#grid.arrange(b1,b2,b3,b4)
#dev.new()
#grid.arrange(c1,c2,c3,c4)