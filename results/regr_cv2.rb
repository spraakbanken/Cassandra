# encoding: UTF-8
require "rinruby"


#R.eval "library('lme4')"
step = 8
testsize = 8/step

if step == 8
    step2 = 4
elsif step == 4
    step2 = 8
end

normalize = 0
topredict = "uncertainty"
#topredict = "innovativeness"

if topredict == "innovativeness"
    addendum = ""
elsif topredict == "uncertainty"
    addendum = 2
end
STDERR.puts "Step: #{step}; dependent variable: #{topredict}; normalization mode: #{normalize}"

R.eval "dataset = read.csv('for_regression_step#{step}.tsv', sep='\t',header=TRUE)"
R.eval "names = c('trend','sclass')"
R.eval "dataset[,names] <- lapply(dataset[,names],factor)"
joint_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}
separate_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}
byverb_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}


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

sum_micro_fmae = 0.0

normalized_per_verb = {}

max_normalized = 0.0
if normalize == 2
    variables.each do |variable|
        v_test = [variable]
        R.assign "v_test", v_test

        R.eval "test2 = dataset[dataset$variable %in% v_test,]"
        R.eval "normalized = max(test2$value#{addendum}) - min(test2$value#{addendum})"
        normalized = R.pull "normalized"
        if normalized > max_normalized
            max_normalized = normalized.clone
        end
    end
end

variables.each do |variable|
    STDERR.puts variable
    if normalize == 2
        normalized_per_verb[variable] = max_normalized
    end
    v_test = [variable]
    v_train = variables.reject{|n| n==variable}
    

    R.assign "v_train", v_train
    R.assign "v_test", v_test
    R.eval "train2 = dataset[dataset$variable %in% v_train,]"
    R.eval "test2 = dataset[dataset$variable %in% v_test,]"
    
    R.eval "m2 = lm(value#{addendum} ~ #{modelformula}, data = train2)"
    R.eval "preds2 = predict.lm(m2,test2,type='response')"
    
    vpreds2[variable] = R.pull "preds2"
    vpreds2[variable] = bound_pred(vpreds2[variable])
    R.assign "preds2", vpreds2[variable]
    if normalize == 1
        R.eval "normalized = max(test2$value#{addendum}) - min(test2$value#{addendum})"
        normalized = R.pull "normalized"
        normalized_per_verb[variable] = normalized
    end
    #R.eval "vmae2 = mean(abs(preds2-test2$value#{addendum}))"
    #vmae2 = R.pull "vmae2"
    #if normalize > 0
    #    vmae2 = vmae2 / normalized_per_verb[variable]
    #end
    #STDERR.puts vmae2
    #vmae2_sum += vmae2
    actual = R.pull "test2$value#{addendum}"
    fmae_sum = 0.0
    for fold in 1..4 do
        if step == 4
            predsf = vpreds2[variable][(fold-1)*2..(fold-1)*2 + 1]
            actualf = actual[(fold-1)*2..(fold-1)*2 + 1]
        elsif step == 8
            predsf = vpreds2[variable][fold-1]
            actualf = actual[fold-1]
        end
        R.assign "predsf", predsf
        R.assign "actual", actual
        R.eval "fmae = mean(abs(predsf-actual))"
        fmae = R.pull "fmae"
        if normalize > 0
            fmae = fmae / normalized_per_verb[variable]
        end
        byverb_mae_all[variable][fold] = fmae
        fmae_sum += fmae
    end
    sum_micro_fmae += fmae_sum
end 
ave_vmae2 = sum_micro_fmae / (variables.length * 4)
#STDERR.puts normalized_per_verb
#__END__


preds2 = []

sum_mae2 = 0.0
for fold in 1..4 do
    STDERR.puts "Joint fold #{fold}"
    R.eval "train2 = dataset[dataset$test#{fold} == 0,]"
    R.eval "test2 = dataset[dataset$test#{fold} == 1,]"
    #R.eval "m2 = lm(value#{addendum} ~ cohort + community + freq + trend + sclass + cohort:community + cohort:freq + cohort:trend + cohort:sclass, data = train2)"
    #R.eval "m2 = lm(value#{addendum} ~ cohort + community + sclass + cohort:sclass, data = train2)"
    R.eval "m2 = lm(value#{addendum} ~ #{modelformula}, data = train2)"
    #R.eval "m2 = lm(value#{addendum} ~ cohort + scale(freq), data = train2)"
    #R.eval "m2 = lm(value#{addendum} ~ cohort * community * freq * trend, data = train2)"
    #R.eval "m2 = lm(value#{addendum} ~ cohort, data = train2)"
    R.eval "preds2 = predict.lm(m2,test2,type='response')"
    preds2[fold] = R.pull "preds2"
    preds2[fold] = bound_pred(preds2[fold])
    R.assign "preds2", preds2[fold]
    R.eval "mae2 = mean(abs(preds2-test2$value#{addendum}))"
    mae2 = R.pull "mae2"
    #STDERR.puts mae2
    sum_mae2 += mae2
end

ave_mae2 = sum_mae2/4




#sum_fold_mae = 0.0
sum_micro_mae = 0.0
R.eval "pdf(file='predicting_#{step}_norm#{normalize}_dv#{topredict}.pdf')"
R.eval "par(mfrow=c(3,3), mar=c(2,2,2,2))"

variables.each.with_index do |variable,index|
    #R.assign "variable", variable.encode("windows-1252")
    STDERR.puts "Separately: #{variable}"
    #R.eval "pdf(file='predicting_#{variable}_#{step}.pdf')"
    R.eval "dataset2 = dataset[dataset$variable == '#{variable}',]"
    R.eval "min = min(dataset2$value#{addendum})-0.1"
    R.eval "max = max(dataset2$value#{addendum})+0.1"
    R.eval "if (min < 0 ) {min = 0}"
    R.eval "if (max > 1 ) {max = 1}"

    R.eval "plot(dataset2$value#{addendum} ~ dataset2$cohort, ylim = c(min,max), pch=21, col = 'black', bg='black', xlab = '', ylab = '', main = '#{variable.encode("windows-1252")}', xaxt = 'n')"
    R.eval "axis(1, at = seq(1, #{step2}, by = 1))"

    sum_mae = 0.0
    
    #sum_mae_joint = 0.0
    for fold in 1..4 do
        
        R.eval "train = dataset2[dataset2$test#{fold} == 0,]"
        R.eval "test = dataset2[dataset2$test#{fold} == 1,]"
        R.eval "m1 = lm(value#{addendum} ~ cohort, data = train)"
        R.eval "preds = predict.lm(m1,test,type='response')"
        R.eval "mae = mean(abs(preds-test$value#{addendum}))"
        
        mae = R.pull "mae"
        if normalize > 0
            mae = mae/normalized_per_verb[variable]
        end
        sum_mae += mae
        
        preds = R.pull "preds"
        preds = bound_pred(preds)
        R.assign "preds", preds
        actual = R.pull "test$value#{addendum}"
        
        #per verb
        verb_preds = vpreds2[variable]
        R.assign "verb_preds",verb_preds
        

        if step == 4
            #separate
            R.eval "points(c(#{fold*2-1-0.1},#{fold*2-0.1}), preds, pch=22, col = 'black', bg='orange')"
            
            #joint
            preds2var = preds2[fold][index*2..index*2 + 1]
            R.assign "preds2var", preds2var
            R.eval "points(c(#{fold*2-1+0.1},#{fold*2+0.1}), preds2var, pch=24, col = 'black', bg='green')"
 
            #per verb
            R.eval "points(c(1,2,3,4,5,6,7,8), verb_preds, pch=23, type = 'l', col ='blue')"
        

        elsif step == 8
            #separate
            R.eval "points(c(#{fold-0.1}), preds, pch=22, col = 'black', bg='orange')"
                        
            #joint
            preds2var = preds2[fold][index]
            R.assign "preds2var", preds2var
            R.eval "points(c(#{fold+0.1}), preds2var, pch=24, col = 'black', bg='green')"

            #per verb
            R.eval "points(c(1,2,3,4), verb_preds, pch=23, type = 'l', col ='blue')"

        end
        #STDERR.puts preds
        #STDERR.puts preds2var
        
        R.eval "mae_joint = mean(abs(preds2var-test$value#{addendum}))"
        mae_joint = R.pull "mae_joint"
        if normalize > 0
            mae_joint = mae_joint/normalized_per_verb[variable]
        end
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
STDERR.puts "Average micromae separately: #{ave_micro_mae}"
#if !normalize
    
#end

o1 = File.open("predicting_step#{step}_norm#{normalize}_dv#{topredict}_error_separate.tsv","w:utf-8")
o2 = File.open("predicting_step#{step}_norm#{normalize}_dv#{topredict}_error_joint.tsv","w:utf-8")
o3 = File.open("predicting_step#{step}_norm#{normalize}_dv#{topredict}_error_byverb.tsv","w:utf-8")

o1.puts "variable\tfold1\tfold2\tfold3\tfold4\tmean"
o2.puts "variable\tfold1\tfold2\tfold3\tfold4\tmean"
o3.puts "variable\tfold1\tfold2\tfold3\tfold4\tmean"

sum_mae_per_fold = Hash.new(0.0)
sum_mae2_per_fold = Hash.new(0.0)
sum_mae3_per_fold = Hash.new(0.0)
sum_mae2_per_variable = 0.0

separate_mae_all.each_pair do |variable,vhash|
    output1 = "#{variable}"
    output2 = "#{variable}"
    output3 = "#{variable}"
    sum_mae = 0.0
    sum_mae2 = 0.0
    sum_mae3 = 0.0
    vhash.each_pair do |fold,mae|
        output1 << "\t#{mae}"
        sum_mae += mae
        mae2 = joint_mae_all[variable][fold]
        output2 << "\t#{mae2}"
        sum_mae2 += mae2
        sum_mae_per_fold[fold] += mae
        sum_mae2_per_fold[fold] += mae2
        mae3 = byverb_mae_all[variable][fold]
        output3 << "\t#{mae3}"

        sum_mae3 += mae3
        sum_mae3_per_fold[fold] += mae3
    end
    output1 << "\t#{sum_mae/4}"
    output2 << "\t#{sum_mae2/4}"
    output3 << "\t#{sum_mae3/4}"
    sum_mae2_per_variable += sum_mae2 / 4
    o1.puts output1
    o2.puts output2
    o3.puts output3
end

output1 = "mean"
output2 = "mean"
output3 = "mean"
    
for fold in 1..4
    output1 << "\t#{sum_mae_per_fold[fold]/variables.length}"
    output2 << "\t#{sum_mae2_per_fold[fold]/variables.length}"
    output3 << "\t#{sum_mae3_per_fold[fold]/variables.length}"
end
output1 << "\t#{ave_micro_mae}"
output3 << "\t#{ave_vmae2}"


if normalize > 0
    normalized_ave_mae2 = sum_mae2_per_variable/variables.length
    output2 << "\t#{normalized_ave_mae2}"
    STDERR.puts "Joint (interactions with cohort) mae overall: #{normalized_ave_mae2}"
else
    output2 << "\t#{ave_mae2}" 
    STDERR.puts "Joint (interactions with cohort) mae overall: #{ave_mae2}"
end

o1.puts output1
o2.puts output2
o3.puts output3