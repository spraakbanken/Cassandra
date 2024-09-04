# encoding: UTF-8
require "rinruby"


#R.eval "library('lme4')"
step = 4
testsize = 8/step
xcoords1 = {4 => "6.9,7.9", 8 => "3.9"}
xcoords2 = {4 => "7.1,8.1", 8 => "4.1"}
R.eval "dataset = read.csv('for_regression_step#{step}.tsv', sep='\t',header=TRUE)"
R.eval "names = c('trend','sclass')"
R.eval "dataset[,names] <- lapply(dataset[,names],factor)"
    

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
modelformula = "cohort + community + cohort:community + freq + trend + cohort:freq + cohort:trend"

vpreds2 = {}

vmae2_sum = 0.0
variables.each do |variable|
    STDERR.puts variable
    v_test = [variable]
    v_train = variables.reject{|n| n==variable}
    

    R.assign "v_train", v_train
    R.assign "v_test", v_test
    R.eval "train2 = dataset[dataset$variable %in% v_train,]"
    R.eval "test2 = dataset[dataset$variable %in% v_test,]"
    
    R.eval "m2 = lm(value ~ #{modelformula}, data = train2)"
    R.eval "preds2 = predict.lm(m2,test2,type='response')"
    
    vpreds2[variable] = R.pull "preds2"
    vpreds2[variable] = bound_pred(vpreds2[variable])
    R.assign "preds2", vpreds2[variable]
    R.eval "vmae2 = mean(abs(preds2-test2$value))"
    vmae2 = R.pull "vmae2"
    STDERR.puts vmae2
    vmae2_sum += vmae2
end 
ave_vmae2 = vmae2_sum / variables.length

#__END__


preds2 = []

sum_mae2 = 0.0
joint_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}
separate_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}
for fold in 1..4 do
    STDERR.puts "Joint fold #{fold}"
    R.eval "train2 = dataset[dataset$test#{fold} == 0,]"
    R.eval "test2 = dataset[dataset$test#{fold} == 1,]"
    #R.eval "m2 = lm(value ~ cohort + community + freq + trend + sclass + cohort:community + cohort:freq + cohort:trend + cohort:sclass, data = train2)"
    #R.eval "m2 = lm(value ~ cohort + community + sclass + cohort:sclass, data = train2)"
    R.eval "m2 = lm(value ~ #{modelformula}, data = train2)"
    #R.eval "m2 = lm(value ~ cohort + scale(freq), data = train2)"
    #R.eval "m2 = lm(value ~ cohort * community * freq * trend, data = train2)"
    #R.eval "m2 = lm(value ~ cohort, data = train2)"
    R.eval "preds2 = predict.lm(m2,test2,type='response')"
    preds2[fold] = R.pull "preds2"
    preds2[fold] = bound_pred(preds2[fold])
    R.assign "preds2", preds2[fold]
    R.eval "mae2 = mean(abs(preds2-test2$value))"
    mae2 = R.pull "mae2"
    #STDERR.puts mae2
    sum_mae2 += mae2
end

ave_mae2 = sum_mae2/4




#sum_fold_mae = 0.0
sum_micro_mae = 0.0
R.eval "pdf(file='predicting_#{step}.pdf')"
R.eval "par(mfrow=c(3,3), mar=c(2,2,2,2))"

variables.each.with_index do |variable,index|
    #R.assign "variable", variable.encode("windows-1252")
    STDERR.puts "Separately: #{variable}"
    #R.eval "pdf(file='predicting_#{variable}_#{step}.pdf')"
    R.eval "dataset2 = dataset[dataset$variable == '#{variable}',]"
    R.eval "min = min(dataset2$value)-0.1"
    R.eval "max = max(dataset2$value)+0.1"
    R.eval "if (min < 0 ) {min = 0}"
    R.eval "if (max > 1 ) {max = 1}"

    R.eval "plot(dataset2$value ~ dataset2$cohort, ylim = c(min,max), pch=21, col = 'black', bg='black', xlab = '', ylab = '', main = '#{variable.encode("windows-1252")}')"
    sum_mae = 0.0
    
    #sum_mae_joint = 0.0
    for fold in 1..4 do
        
        R.eval "train = dataset2[dataset2$test#{fold} == 0,]"
        R.eval "test = dataset2[dataset2$test#{fold} == 1,]"
        R.eval "m1 = lm(value ~ cohort, data = train)"
        R.eval "preds = predict.lm(m1,test,type='response')"
        R.eval "mae = mean(abs(preds-test$value))"
        
        mae = R.pull "mae"
        sum_mae += mae
        
        preds = R.pull "preds"
        preds = bound_pred(preds)
        R.assign "preds", preds
        actual = R.pull "test$value"
        
        #per verb
        verb_preds = vpreds2[variable]
        R.assign "verb_preds",verb_preds
        

        if step == 4
            #separate
            R.eval "points(c(#{fold*2-1-0.1},#{fold*2-0.1}), preds, pch=22, col = 'black', bg='orange')"
            
            #joint
            preds2var = preds2[fold][index*2..index*2 + 1]
            R.assign "preds2var", preds2var
            R.eval "points(c(#{fold*2-1+0.1},#{fold*2+0.1}), preds2var, pch=24, col = 'black', bg='blue')"
 
            #per verb
            R.eval "points(c(1,2,3,4,5,6,7,8), verb_preds, pch=23, type = 'l', col ='green')"
        

        elsif step == 8
            #separate
            R.eval "points(c(#{fold-0.1}), preds, pch=22, col = 'black', bg='orange')"
                        
            #joint
            preds2var = preds2[fold][index]
            R.assign "preds2var", preds2var
            R.eval "points(c(#{fold+0.1}), preds2var, pch=24, col = 'black', bg='blue')"

            #per verb
            R.eval "points(c(1,2,3,4), verb_preds, pch=23, type = 'l', col ='green')"

        end
        #STDERR.puts preds
        #STDERR.puts preds2var
        
        R.eval "mae_joint = mean(abs(preds2var-test$value))"
        mae_joint = R.pull "mae_joint"
        joint_mae_all[variable][fold] = mae_joint
        separate_mae_all[variable][fold] = mae
        #sum_mae_joint += mae_joint
        #STDERR.puts "#{variable} #{fold }joint mae #{mae_joint}"
    end
    
    
    #ave_fold_mae = sum_mae/4
    #sum_fold_mae += ave_fold_mae
    sum_micro_mae += sum_mae
    #ave_fold_joint_mae = sum_mae_joint/4
    #STDERR.puts "#{variable} mae #{ave_fold_mae}"
    #STDERR.puts "#{variable} joint mae #{ave_fold_joint_mae}"
end
R.eval "dev.off()"
#ave_var_mae = sum_fold_mae/variables.length
#STDERR.puts "Average macromae separately: #{ave_var_mae}"
ave_micro_mae = sum_micro_mae/(variables.length * 4)

STDERR.puts "Average mae predicting unknown verbs: #{ave_vmae2}"
STDERR.puts "Joint (interactions with cohort) mae overall: #{ave_mae2}"
STDERR.puts "Average micromae separately: #{ave_micro_mae}"

o1 = File.open("predicting_step#{step}_error_separate.tsv","w:utf-8")
o2 = File.open("predicting_step#{step}_error_joint.tsv","w:utf-8")

o1.puts "variable\tfold1\tfold2\tfold3\tfold4\tmean"
o2.puts "variable\tfold1\tfold2\tfold3\tfold4\tmean"

sum_mae_per_fold = Hash.new(0.0)
sum_mae2_per_fold = Hash.new(0.0)

separate_mae_all.each_pair do |variable,vhash|
    output1 = "#{variable}"
    output2 = "#{variable}"
    sum_mae = 0.0
    sum_mae2 = 0.0
    vhash.each_pair do |fold,mae|
        output1 << "\t#{mae}"
        sum_mae += mae
        mae2 = joint_mae_all[variable][fold]
        output2 << "\t#{mae2}"
        sum_mae2 += mae2
        sum_mae_per_fold[fold] += mae
        sum_mae2_per_fold[fold] += mae2
    end
    output1 << "\t#{sum_mae/4}"
    output2 << "\t#{sum_mae2/4}"
    o1.puts output1
    o2.puts output2
end

output1 = "mean"
output2 = "mean"
    
for fold in 1..4
    output1 << "\t#{sum_mae_per_fold[fold]/variables.length}"
    output2 << "\t#{sum_mae2_per_fold[fold]/variables.length}"
end
output1 << "\t#{ave_micro_mae}"
output2 << "\t#{ave_mae2}"

o1.puts output1
o2.puts output2

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