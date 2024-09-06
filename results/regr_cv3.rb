# encoding: UTF-8
require "rinruby"

step = 4
testsize = 8/step

if step == 8
    ncohorts = 4
elsif step == 4
    ncohorts = 8
end

normalize = 0
#topredict = "uncertainty"
topredict = "innovativeness"
aggregate = true
individual = true

if topredict == "innovativeness"
    addendum = ""
elsif topredict == "uncertainty"
    addendum = 2
end
intersection = "_intersection"

STDERR.puts "Step: #{step}; dependent variable: #{topredict}; normalization mode: #{normalize}; intersection: #{intersection}"

excluded_variables = ["behaga", "lova"]
variables = ["fortsätta", "försöka", "glömma", "komma", "planera", "riskera", "slippa", "sluta", "vägra"]
modelformula = "cohort + community + cohort:community + freq + trend + cohort:freq + cohort:trend"

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



if aggregate
    R.eval "dataset = read.csv('for_regression_step#{step}#{intersection}.tsv', sep='\t',header=TRUE)"
    R.eval "names = c('trend','sclass')"
    R.eval "dataset[,names] <- lapply(dataset[,names],factor)"
    joint_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}
    separate_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}
    byverb_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}
    
    preds_byverb = {}
    
    sum_micro_byverb_mae = 0.0

    #normalization basis
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
    
    # BY VERB
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
        R.eval "preds2 = predict(m2,test2,type='response')"
        
        preds_byverb[variable] = R.pull "preds2"
        preds_byverb[variable] = bound_pred(preds_byverb[variable])
        R.assign "preds2", preds_byverb[variable]

        if normalize == 1
            R.eval "normalized = max(test2$value#{addendum}) - min(test2$value#{addendum})"
            normalized = R.pull "normalized"
            normalized_per_verb[variable] = normalized
        end
        
        actual = R.pull "test2$value#{addendum}"

        #sssum = 0.0
        #if variable == "riskera"
        #    for c in 0..ncohorts-1
        #        STDERR.puts "#{preds_byverb[variable][c]},#{actual[c]},#{(preds_byverb[variable][c]-actual[c]).abs}" 
        #        sssum += (preds_byverb[variable][c]-actual[c]).abs
        #    end
        #    STDERR.puts sssum/ncohorts
        #end
        
        
        byverb_mae_sum = 0.0
        for cohort in 1..ncohorts do
            predsf = preds_byverb[variable][cohort-1]
            actualf = actual[cohort-1]
            
            R.assign "predsf", predsf
            R.assign "actualf", actualf
            R.eval "byverb_mae = mean(abs(predsf-actualf))"
            byverb_mae = R.pull "byverb_mae"
            #if variable == "riskera"
            #    STDERR.puts "#{fold} #{byverb_mae}"
            #    STDERR.puts "F #{fold} A #{actualf.join(" ")} P #{predsf.join(" ")}"
            #end
            if normalize > 0
                byverb_mae = byverb_mae / normalized_per_verb[variable]
            end
            byverb_mae_all[variable][cohort] = byverb_mae
            byverb_mae_sum += byverb_mae
        end
        sum_micro_byverb_mae += byverb_mae_sum
    end 
    micro_byverb_mae = sum_micro_byverb_mae / (variables.length * ncohorts)
 
    # JOINT REGRESSION
    preds2 = []
    sum_mae2 = 0.0
    for cohort in 1..ncohorts do
        STDERR.puts "Joint: cohort #{cohort}"
        R.eval "train2 = dataset[dataset$cohort != #{cohort},]"
        R.eval "test2 = dataset[dataset$cohort == #{cohort},]"
        R.eval "m2 = lm(value#{addendum} ~ #{modelformula}, data = train2)"
        R.eval "preds2 = predict(m2,test2,type='response')"
        preds2[cohort] = R.pull "preds2"
        preds2[cohort] = bound_pred(preds2[cohort])
        R.assign "preds2", preds2[cohort]
        R.eval "mae2 = mean(abs(preds2-test2$value#{addendum}))"
        mae2 = R.pull "mae2"
        sum_mae2 += mae2
    end
    
    joint_ave_mae2 = sum_mae2/ncohorts
    
    # SEPARATE REGRESSIONS
    sum_micro_mae = 0.0
    R.eval "pdf(file='predicting_#{step}_dv#{topredict}#{intersection}.pdf')"
    R.eval "par(mfrow=c(3,3), mar=c(2,2,2,2))"
    
    variables.each.with_index do |variable,index|
        
        STDERR.puts "Separately: #{variable}"
        
        R.eval "dataset2 = dataset[dataset$variable == '#{variable}',]"
        R.eval "min = min(dataset2$value#{addendum})-0.1"
        R.eval "max = max(dataset2$value#{addendum})+0.1"
        R.eval "if (min < 0 ) {min = 0}"
        R.eval "if (max > 1 ) {max = 1}"
    
        R.eval "plot(dataset2$value#{addendum} ~ dataset2$cohort, ylim = c(min,max), pch=21, col = 'black', bg='black', xlab = '', ylab = '', main = '#{variable.encode("windows-1252")}', xaxt = 'n')"
        R.eval "axis(1, at = seq(1, #{ncohorts}, by = 1))"
    
        sum_mae = 0.0
        
        for cohort in 1..ncohorts do
            R.eval "train = dataset2[dataset2$cohort != #{cohort},]"
            R.eval "test = dataset2[dataset2$cohort == #{cohort},]"
            R.eval "m1 = lm(value#{addendum} ~ cohort, data = train)"
            R.eval "preds = predict(m1,test,type='response')"
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
            verb_preds = preds_byverb[variable]
            R.assign "verb_preds",verb_preds
            
            #separate
            R.eval "points(c(#{cohort-0.1}), preds, pch=22, col = 'black', bg='orange')"

            #joint
            preds2var = preds2[cohort][index]
            R.assign "preds2var", preds2var
            R.eval "points(c(#{cohort+0.1}), preds2var, pch=24, col = 'black', bg='green')"

            #per verb
            R.eval "points(c(1:#{ncohorts}), verb_preds, pch=23, type = 'l', col ='blue')"

            R.eval "mae_joint = mean(abs(preds2var-test$value#{addendum}))"
            mae_joint = R.pull "mae_joint"
            if normalize > 0
                mae_joint = mae_joint/normalized_per_verb[variable]
            end
            joint_mae_all[variable][cohort] = mae_joint
            separate_mae_all[variable][cohort] = mae
        end

        sum_micro_mae += sum_mae
    end
    R.eval "dev.off()"
    ave_micro_mae = sum_micro_mae/(variables.length * ncohorts)
    
    STDERR.puts "Average mae predicting unknown verbs: #{micro_byverb_mae}"
    STDERR.puts "Average micromae separately: #{ave_micro_mae}"
    


    o1 = File.open("predicting_step#{step}_norm#{normalize}_dv#{topredict}#{intersection}_error_separate.tsv","w:utf-8")
    o2 = File.open("predicting_step#{step}_norm#{normalize}_dv#{topredict}#{intersection}_error_joint.tsv","w:utf-8")
    o3 = File.open("predicting_step#{step}_norm#{normalize}_dv#{topredict}#{intersection}_error_byverb.tsv","w:utf-8")
    
    cohortlist = "variable"
    for cohort in 1..ncohorts
        cohortlist << "\tcohort#{cohort}"
    end

    o1.puts "variable#{cohortlist}\tmean"
    o2.puts "variable#{cohortlist}\tmean"
    o3.puts "variable#{cohortlist}\tmean"
    
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
        vhash.each_pair do |cohort,mae|
            output1 << "\t#{mae}"
            sum_mae += mae
            mae2 = joint_mae_all[variable][cohort]
            output2 << "\t#{mae2}"
            sum_mae2 += mae2
            sum_mae_per_fold[cohort] += mae
            sum_mae2_per_fold[cohort] += mae2
            mae3 = byverb_mae_all[variable][cohort]
            output3 << "\t#{mae3}"
    
            sum_mae3 += mae3
            sum_mae3_per_fold[cohort] += mae3
        end
        output1 << "\t#{sum_mae/ncohorts}"
        output2 << "\t#{sum_mae2/ncohorts}"
        output3 << "\t#{sum_mae3/ncohorts}"
        sum_mae2_per_variable += sum_mae2 / ncohorts
        o1.puts output1
        o2.puts output2
        o3.puts output3
    end
    
    output1 = "mean"
    output2 = "mean"
    output3 = "mean"
        
    for cohort in 1..ncohorts
        output1 << "\t#{sum_mae_per_fold[cohort]/variables.length}"
        output2 << "\t#{sum_mae2_per_fold[cohort]/variables.length}"
        output3 << "\t#{sum_mae3_per_fold[cohort]/variables.length}"
    end
    output1 << "\t#{ave_micro_mae}"
    output3 << "\t#{micro_byverb_mae}"
    
    
    if normalize > 0
        normalized_joint_ave_mae2 = sum_mae2_per_variable/variables.length
        output2 << "\t#{normalized_joint_ave_mae2}"
        STDERR.puts "Joint (interactions with cohort) mae overall: #{normalized_joint_ave_mae2}"
    else
        output2 << "\t#{joint_ave_mae2}" 
        STDERR.puts "Joint (interactions with cohort) mae overall: #{joint_ave_mae2}"
    end
    
    o1.puts output1
    o2.puts output2
    o3.puts output3
end

ind_preds_byverb = {}

if individual
    variables = ["fortsätta", "försöka", "glömma", "komma", "planera", "riskera", "slippa", "sluta", "vägra"]
    modelformula = "scale(yob) + scale(community) + scale(yob):scale(community) + scale(freq) + trend + scale(yob):scale(freq) + scale(yob):trend"
    #modelformula = "scale(yob)"
    STDERR.puts "Individual analysis"
    R.eval '.libPaths("C:/Users/Sasha/Documents/R/win-library/3.6")'
    R.eval "library(lme4)"
    R.eval "dataset_indiv = read.csv('for_regression_step#{step}_indiv#{intersection}.tsv', sep='\t',header=TRUE)"
    R.eval "names = c('trend','sclass')"
    R.eval "dataset_indiv[,names] <- lapply(dataset_indiv[,names],factor)"
    sumind = 0.0
    variables.each do |variable|
        STDERR.puts variable
        if normalize == 2
            normalized_per_verb[variable] = max_normalized
        end
        v_test = [variable]
        v_train = variables.reject{|n| n==variable}
        
        
        R.assign "v_train", v_train
        R.assign "v_test", v_test
        R.eval "train2 = dataset_indiv[dataset_indiv$variable %in% v_train,]"
        R.eval "test2 = dataset_indiv[dataset_indiv$variable %in% v_test,]"
        #modelformula = "yob + community + yob:community + freq + trend + yob:freq + yob:trend"
        R.eval "m2 = lmer(indvalue ~ #{modelformula} + (1|speaker), data = train2)"
        #R.eval "m2 = lm(indvalue ~ #{modelformula}, data = train2)"
        #R.eval "print(summary(m2))"
        R.eval "preds2 = predict(m2,test2,type='response')"
        
        ind_preds_byverb[variable] = R.pull "preds2"
        ind_preds_byverb[variable] = bound_pred(ind_preds_byverb[variable])
        actual = R.pull "test2$indvalue"
        #STDERR.puts ind_preds_byverb[variable].join(" ")
        #STDERR.puts actual.join(" ")
        R.assign "preds2", ind_preds_byverb[variable]
        #R.eval "indmae = mean(abs(preds2-test2$indvalue))"
        #indmae = R.pull "indmae"
        #STDERR.puts indmae
        ave_per_cohort_actual = {}
        ave_per_cohort_pred = {}
        offset = 1
        sum = 0.0
        for cohort in 1..ncohorts do
            
            #STDERR.puts offset
            R.eval "cohort = test2[test2$cohort == #{cohort},]"
            R.eval "actual_cohort = mean(cohort$indvalue)"
            R.assign "offset",offset
            R.eval "l = length(cohort$indvalue)"
            R.eval "preds_cohort = mean(preds2[offset:offset+l-1])"
            R.eval "offset = offset + l"
            offset = R.pull "offset"
            pred_cohort = R.pull "preds_cohort"
            actual_cohort = R.pull "actual_cohort"
            #STDERR.puts "#{cohort} #{pred_cohort} #{actual_cohort}"
            sum += (pred_cohort - actual_cohort).abs
        end
        STDERR.puts sum/ncohorts
        sumind += sum/ncohorts
=begin        
        if normalize == 1
            R.eval "normalized = max(test2$value#{addendum}) - min(test2$value#{addendum})"
            normalized = R.pull "normalized"
            normalized_per_verb[variable] = normalized
        end
        actual = R.pull "test2$value#{addendum}"
        byverb_mae_sum = 0.0
        for fold in 1..4 do
            if step == 4
                predsf = preds_byverb[variable][(fold-1)*2..(fold-1)*2 + 1]
                actualf = actual[(fold-1)*2..(fold-1)*2 + 1]
            elsif step == 8
                predsf = preds_byverb[variable][fold-1]
                actualf = actual[fold-1]
            end
            R.assign "predsf", predsf
            R.assign "actual", actual
            R.eval "byverb_mae = mean(abs(predsf-actual))"
            byverb_mae = R.pull "byverb_mae"
            if normalize > 0
                byverb_mae = byverb_mae / normalized_per_verb[variable]
            end
            byverb_mae_all[variable][fold] = byverb_mae
            byverb_mae_sum += byverb_mae
        end
        sum_micro_byverb_mae += byverb_mae_sum
=end
    end 
    #micro_byverb_mae = sum_micro_byverb_mae / (variables.length * 4)
    STDERR.puts sumind/variables.length
end