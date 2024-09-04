# encoding: UTF-8
require "rinruby"
#require_relative "ba.rb"

#R.eval "library('lme4')"
step = 4
testsize = 8/step
xcoords1 = {4 => "6.9,7.9", 8 => "3.9"}
xcoords2 = {4 => "7.1,8.1", 8 => "4.1"}
R.eval "dataset = read.csv('for_regression_step#{step}.tsv', sep='\t',header=TRUE)"
R.eval "names = c('trend','sclass')"
R.eval "dataset[,names] <- lapply(dataset[,names],factor)"

#R.eval "names = c('rec_type','outcome','rec_def','rec_anim','theme_type','theme_def','theme_anim','verb_sem','variety')"
#R.eval "train2 = train"
#R.eval "train2[,names] <- lapply(train2[,names],factor)"

def bound_pred(unbound_preds)
    if unbound_preds.kind_of?(Array)
        bound_preds = []
        unbound_preds.each do |pred|
            if pred > 1
                bound_preds << 1.0
            elsif pred < 0 
                bound_preds << 0.0
            else
                bound_preds << pred
            end
        end
    else
        
        if unbound_preds > 1
            bound_preds = 1.0
        elsif unbound_preds < 0 
            bound_preds = 0.0
        else
            bound_preds = unbound_preds
        end
        
    end
    return bound_preds
end



excluded_variables = ["behaga", "lova"]
variables = ["fortsätta", "försöka", "glömma", "komma", "planera", "riskera", "slippa", "sluta", "vägra"]


#fix encoding
#cross-validation
#from individuals
#uncertainty

#nonlinearity
#exclude unknown verbs and try on them?
preds2 = []
#fold = 1
#sum_mae2 = 0.0
#joint_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}
#separate_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}

R.eval "pdf(file='predicting_verb_#{step}.pdf')"
R.eval "par(mfrow=c(3,3))"
for fold in 1..9 do
    STDERR.puts "Joint fold #{fold}"
    v_test = [variables[fold-1]]
    v_train = variables.reject{|n| n==v_test[0]}
    

    R.assign "v_train", v_train
    R.assign "v_test", v_test
    R.eval "train2 = dataset[dataset$variable %in% v_train,]"
    R.eval "test2 = dataset[dataset$variable %in% v_test,]"
    STDERR.puts "assigned"
    #R.eval "m2 = lm(value ~ cohort + community + freq + trend + sclass + cohort:community + cohort:freq + cohort:trend + cohort:sclass, data = train2)"
    #R.eval "m2 = lm(value ~ cohort + community + sclass + cohort:sclass, data = train2)"
    #R.eval "m2 = lm(value ~ cohort + community + sclass + cohort:sclass + cohort:community, data = train2)"
    R.eval "m2 = lm(value ~ cohort + community + trend + freq + cohort:community + cohort:freq + cohort:trend, data = train2)"
    STDERR.puts "modelled"
    #R.eval "m2 = lm(value ~ cohort, data = train2)"
    R.eval "preds2 = predict.lm(m2,test2,type='response')"
    preds2[fold] = R.pull "preds2"
    preds2[fold] = bound_pred(preds2[fold])
    R.assign "preds2", preds2[fold]
    R.eval "mae2 = mean(abs(preds2-test2$value))"
    mae2 = R.pull "mae2"
    STDERR.puts mae2

    v_test.each.with_index do |tvariable,index|
        #R.eval "pdf(file='predicting_variables_#{tvariable}_#{step}.pdf')"
        R.assign "tvariable",tvariable
        R.eval "dataset2 = dataset[dataset$variable == tvariable,]"
        R.eval "plot(dataset2$value ~ dataset2$cohort, ylim = c(0,1), pch=21, col = 'black', bg='black')"
        if step == 4
            preds = preds2[fold][index*8..index*8+7]
            R.assign "preds",preds
            R.eval "points(c(1,2,3,4,5,6,7,8), preds, pch=22, col = 'black', bg='orange')"
            
        elsif step == 8
            preds = preds2[fold][index*4..index*4+3]
            R.assign "preds",preds
            R.eval "points(c(1,2,3,4), preds, pch=22, col = 'black', bg='orange')"
            
        end
    end
end 
R.eval "dev.off()"
