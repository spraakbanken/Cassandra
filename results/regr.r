#library("lme4")
dataset = read.csv("for_regression_step4.tsv", sep="\t",header=TRUE)
names = c("rec_type","outcome","rec_def","rec_anim","theme_type","theme_def","theme_anim","verb_sem","variety")
train2 = train
train2[,names] <- lapply(train2[,names],factor)
m3 = glm(outcome ~ rec_type + rec_def + rec_anim + theme_type + theme_def + theme_anim + diff_length + variety + rec_type:variety + rec_def:variety + rec_anim:variety + theme_type:variety + theme_def:variety + theme_anim:variety + diff_length:variety, data=train2,family="binomial")
test = read.csv("datives_test.tsv", sep="\t",header=TRUE)
test2 = test
test2[,names] <- lapply(test2[,names],factor)
preds = predict.glm(m3,test2,type="response")
preds2 = ifelse(preds <= 0.5,"D","P")
sum(preds2 == test2$outcome)/length(preds2)

