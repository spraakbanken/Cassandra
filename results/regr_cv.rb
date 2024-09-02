# encoding: UTF-8
require "rinruby"
#require_relative "ba.rb"

#R.eval "library('lme4')"
step = 8
testsize = 8/step
xcoords = {4 => "7,8", 8 => "4"}
R.eval "dataset = read.csv('for_regression_step#{step}.tsv', sep='\t',header=TRUE)"
#R.eval "names = c('rec_type','outcome','rec_def','rec_anim','theme_type','theme_def','theme_anim','verb_sem','variety')"
#R.eval "train2 = train"
#R.eval "train2[,names] <- lapply(train2[,names],factor)"

excluded_variables = ["behaga", "lova"]
variables = ["fortsätta", "försöka", "glömma", "komma", "planera", "riskera", "slippa", "sluta", "vägra"]

#fix encoding
#cross-validation
#from individuals
#uncertainty

#nonlinearity
#exclude unknown verbs and try on them?

R.eval "train2 = dataset[dataset$test == 0,]"
R.eval "names = c('trend','sclass')"
R.eval "train2[,names] <- lapply(train2[,names],factor)"
R.eval "test2 = dataset[dataset$test == 1,]"
R.eval "m2 = lm(value ~ cohort + community + freq + trend + sclass + cohort:community + cohort:freq + cohort:trend + cohort:sclass, data = train2)"
#R.eval "m2 = lm(value ~ cohort, data = train2)"
R.eval "preds2 = predict.lm(m2,test2,type='response')"
preds2 = R.pull "preds2"
R.eval "mae2 = mean(abs(preds2-test2$value))"
mae2 = R.pull "mae2"
STDERR.puts "Joint (interactions with cohort): #{mae2}"

#__END__

sum_mae = 0.0
variables.each.with_index do |variable,index|
    #R.assign "variable", variable.encode("windows-1252")
    R.eval "pdf(file='predicting_#{variable.encode("utf-8")}_#{step}.pdf')"
    
    R.eval "dataset2 = dataset[dataset$variable == '#{variable}',]"
    R.eval "train = dataset2[dataset2$test == 0,]"
    R.eval "test = dataset2[dataset2$test == 1,]"
    R.eval "m1 = lm(value ~ cohort, data = train)"
    R.eval "preds = predict.lm(m1,test,type='response')"
    R.eval "mae = mean(abs(preds-test$value))"
    R.eval "mape = mean((abs(preds-test$value))/test$value)*100"
    mae = R.pull "mae"
    sum_mae += mae
    mape = R.pull "mape"
    preds = R.pull "preds"
    actual = R.pull "test$value"
    STDERR.puts "#{variable} #{mae}"
    #preds.each.with_index do |element,index|
        #STDERR.puts "#{element} #{actual[index]}"
    #end
    R.eval "plot(dataset2$value ~ dataset2$cohort, ylim = c(0,1), type = 'b')"
    R.eval "points(c(#{xcoords[step]}),preds, pch=21, col = 'black', bg='orange')"
    if step == 4
        preds2var = preds2[index*2..index*2 + 1]
    elsif step == 8
        preds2var = preds2[index]
    end
    #STDERR.puts preds2var
    R.assign "preds2var", preds2var
    R.eval "points(c(#{xcoords[step]}),preds2var, pch=24, col = 'black', bg='blue')"
    
    R.eval "dev.off()"
end
ave_mae = sum_mae/variables.length
STDERR.puts "Average mae separately: #{ave_mae}"

__END__

R.eval "train2 = dataset[dataset$test == 0,]"
R.eval "names = c('trend','sclass')"
R.eval "train2[,names] <- lapply(train2[,names],factor)"

R.eval "test2 = dataset[dataset$test == 1,]"
R.eval "m2 = lm(value ~ cohort + community + freq + trend + sclass, data = train2)"
R.eval "preds2 = predict.lm(m2,test2,type='response')"
R.eval "mae2 = mean(abs(preds2-test2$value))"
mae2 = R.pull "mae2"
STDERR.puts "Joint (no interactions): #{mae2}"

R.eval "m2 = lm(value ~ cohort + community + freq + trend + sclass + cohort:community + cohort:freq + cohort:trend + cohort:sclass, data = train2)"
R.eval "preds2 = predict.lm(m2,test2,type='response')"
R.eval "mae2 = mean(abs(preds2-test2$value))"
mae2 = R.pull "mae2"
STDERR.puts "Joint (interactions with cohort): #{mae2}"

R.eval "m2 = lm(value ~ cohort * community * freq * trend * sclass, data = train2)"
R.eval "preds2 = predict.lm(m2,test2,type='response')"
R.eval "mae2 = mean(abs(preds2-test2$value))"
mae2 = R.pull "mae2"
STDERR.puts "Joint (all interactions): #{mae2}"


__END__
R.eval "m3 = glm(outcome ~ rec_type + rec_def + rec_anim + theme_type + theme_def + theme_anim + diff_length + variety + rec_type:variety + rec_def:variety + rec_anim:variety + theme_type:variety + theme_def:variety + theme_anim:variety + diff_length:variety, data=train2,family='binomial')"

R.eval "tpreds = predict.glm(m3,train2,type='response')"
#=begin
threshold = 0.25
accs = {}
bas = {}
begin 
    STDERR.puts threshold
    R.eval "tpreds2 = ifelse(tpreds <= #{threshold},'D','P')"
    R.eval "acc = sum(tpreds2 == train$outcome)/length(tpreds2)"
    acc = R.pull "acc"
    tpreds2 = R.pull "tpreds2"
    #R.eval "tgold = train2$outcome"
    tgold = R.pull "as.character(train$outcome)"
    ba = acc_and_ba(tpreds2,tgold)
    accs[acc] = threshold
    bas[ba] = threshold
    threshold += 0.01
    STDERR.puts "#{acc} #{ba}"
end until threshold > 0.75

=begin
accs.each_pair do |acc,threshold|
    STDERR.puts "#{acc}\t#{threshold}"
end

bas.each_pair do |acc,threshold|
    STDERR.puts "#{acc}\t#{threshold}"
end
=end

threshold = accs[accs.keys.max]
STDERR.puts "Final threshold #{threshold}, yields acc #{accs.keys.max}"

#threshold = bas[bas.keys.max]


#=end
R.eval "test = read.csv('datives_test_full.tsv', sep='\t',header=TRUE)"
R.eval "test2 = test"
R.eval "test2[,names] <- lapply(test2[,names],factor)"
R.eval "preds = predict.glm(m3,test2,type='response')"
R.eval "preds2 = ifelse(preds <= #{threshold},'D','P')"
#R.eval "gold = test2$outcome"
preds = R.pull "preds2"
gold = R.pull "as.character(test$outcome)"
#STDOUT.puts preds

R.eval "acc = sum(preds2 == test$outcome)/length(preds2)"
acc = R.pull "acc"
STDERR.puts acc

ba = acc_and_ba(preds,gold)
STDERR.puts ba