# encoding: UTF-8
require "rinruby"
require_relative "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\math_tools.rb"

#the bundle-aggregate mystery
#pretty up and double-check averages
#detailed output for individual predictions
#add normalization for individual
#try random slopes
#anonymize individuals

step = 4

def measure_error(measure, predictions, actuals)
    R.assign "fpredictions", predictions
    R.assign "factuals", actuals

    if measure == "mae"
        R.eval "error = mean(abs(fpredictions-factuals))"
    elsif measure == "koplenig"
        R.eval "error = mean(sqrt((log(fpredictions/factuals))^2))"
    elsif measure == "rmse"
        R.eval "error = sqrt(mean((fpredictions-factuals)^2))"
    elsif measure == "se"
        R.eval "error = sqrt(mean((fpredictions-factuals)^2))/(sqrt(length(fpredictions)))"
    end
    error = R.pull "error"
    return error
end

ncohorts = 32/step

normalize = 0
#topredict = "uncertainty"
topredict = "innovativeness"
aggregate = false
individual = true
do_smoothing = 0
measure = "mae"
plot_aggregate = false

if topredict == "innovativeness"
    addendum = ""
elsif topredict == "uncertainty"
    addendum = 2
end

intersection = ""
function = "linear"
#intersection = "_intersection"

STDERR.puts "Step: #{step}; dependent variable: #{topredict}; normalization mode: #{normalize}; intersection: #{intersection}; smoothing: #{do_smoothing}; link function #{function}; error measure: #{measure}"

excluded_variables = ["behaga", "lova"]
variables = ["fortsätta", "försöka", "glömma", "komma", "planera", "riskera", "slippa", "sluta", "vägra"]#,"behaga", "lova"]
#variables = ["fortsätta", "försöka", "glömma", "komma", "slippa", "sluta", "vägra"]


mainresults = File.open("regr_summary_step#{step}_norm#{normalize}_dv#{topredict}#{intersection}_#{function}_smooth#{do_smoothing}_#{measure}_nvars#{variables.length}.tsv","w:utf-8")


mainresults.puts "analysis\tbaseline0\tlabel1\tbundle2\tbundle_re3\tbundle_newconstr4"


#modelformula = "(1/(1+exp(-cohort))) + community + (1/(1+exp(-cohort))):community + freq + trend + (1/(1+exp(-cohort))):freq + (1/(1+exp(-cohort))):trend"
#modelformula1 = "(1/(1+exp(-cohort)))"



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

#=begin

indbaseline_per_variable = {}
indbundle_per_variable = {}
indbundle_re_per_variable = {}
indcategorical_per_variable = {}

#R.eval "2+2"
R.eval "R.version"

STDERR.puts "I will load lme4"
#R.eval '.libPaths("C:/R/win-library/4.1")'
R.eval "library(lme4)"
STDERR.puts "I did load lme4"

if individual
    #variables = ["fortsätta", "försöka", "glömma", "komma", "planera", "riskera", "slippa", "sluta", "vägra"]
    modelformula = "scale(scohort) + scale(community) + scale(scohort):scale(community) + scale(freq) + trend + scale(scohort):scale(freq) + scale(scohort):trend"
    modelformula2 = "scale(scohort) + variable + scale(scohort):variable"
    modelformula0 = "scale(scohort)"
    
    #modelformula = "scale(yob)"
    STDERR.puts "Individual analysis"
    #R.eval '.libPaths("C:/Users/Sasha/Documents/R/win-library/3.6")'
    
    R.eval "dataset_indiv = read.csv('for_regression_step#{step}_indiv#{intersection}.tsv', sep='\t',header=TRUE)"
    #R.eval "dataset_indiv$yob <- dataset_indiv$cohort"
    R.eval "names = c('trend','sclass')"
    R.eval "dataset_indiv[,names] <- lapply(dataset_indiv[,names],factor)"
    if function == "scurve"
        R.eval "dataset_indiv$scohort <- (1/(1+exp(-dataset_indiv$cohort)))"
    elsif function == "log"
        R.eval "dataset_indiv$scohort <- log(dataset_indiv$cohort)"
    elsif function == "sqrt"
        R.eval "dataset_indiv$scohort <- sqrt(dataset_indiv$cohort)"
    elsif function == "linear"
        R.eval "dataset_indiv$scohort <- dataset_indiv$cohort"
    elsif function == "poly"
        R.eval "dataset_indiv$scohort <- dataset_indiv$cohort"
        R.eval "dataset_indiv$scohort2 <- dataset_indiv$cohort^2"
        R.eval "dataset_indiv$scohort3 <- dataset_indiv$cohort^3"
        
        modelformula = "scale(scohort) + scale(scohort2) + scale(scohort3)"
        modelformula2 = "scale(scohort) + scale(scohort2) + scale(scohort3) + variable + scale(scohort):variable + scale(scohort2):variable + scale(scohort3):variable"
        modelformula = "scale(scohort) + scale(scohort2) + scale(scohort3) + scale(community) + scale(scohort):scale(community) + scale(scohort2):scale(community) + scale(scohort3):scale(community) + scale(freq) + trend + scale(scohort):scale(freq) + scale(scohort2):scale(freq) + scale(scohort3):scale(freq) + scale(scohort):trend + scale(scohort2):trend + scale(scohort3):trend" # + sag + so + scohort:sag + scohort:so
        
    end
    
    sumind = 0.0
    indmae0s = []
    indmae2s = []
    indmae3s = []
    indmae4s = []
    indindmae0s = []
    indindmae2s = []
    indindmae3s = []
    indindmae4s = []

    indiv_preds_byverb = {}
    indiv_maes = []
    indindiv_maes = []
    averaged_preds_byverb = {}
    # BY VERB
    variables.each do |variable|
        STDERR.puts variable
     
        v_test = [variable]
        v_train = variables.reject{|n| n==variable}
        
        R.assign "v_train", v_train
        R.assign "v_test", v_test
        R.eval "train3 = dataset_indiv[dataset_indiv$variable %in% v_train,]"
        R.eval "test3 = dataset_indiv[dataset_indiv$variable %in% v_test,]"
        
        #modelformula = "yob + community + yob:community + freq + trend + yob:freq + yob:trend"
        
        R.eval "m2 = lmer(indvalue ~ #{modelformula} + (1|speaker2), data = train3)"
        #R.eval "m2 = lm(indvalue ~ #{modelformula}, data = train2)"
        R.eval "indiv_preds_byverb = predict(m2,test3,type='response')"
        indiv_preds_byverb[variable] = R.pull "indiv_preds_byverb"
        indiv_preds_byverb[variable] = bound_pred(indiv_preds_byverb[variable])
        R.assign "indiv_preds_byverb", indiv_preds_byverb[variable]


        
        
        #R.eval "indindmae_byverb = mean(abs(indiv_preds_byverb-test3$indvalue))" 
        #R.eval "indindmae_byverb = mean(sqrt((log(indiv_preds_byverb/test3$indvalue))^2))" 
        actuals = R.pull "test3$indvalue"
        indindiv_mae = measure_error(measure,indiv_preds_byverb[variable],actuals)
#R.pull "indindmae_byverb"
        indindiv_maes << indindiv_mae
 
        counter = 0
        per_cohort_predictions = []
        per_cohort_actuals = []
        for cohort in 1..ncohorts do
            R.eval "ndatapoints = length(test3[test3$cohort == #{cohort},]$indvalue)"
            ndatapoints = R.pull "ndatapoints"
            predictions = indiv_preds_byverb[variable][counter..counter+ndatapoints-1]
            per_cohort_predictions << mean(predictions)
            counter += ndatapoints
            #R.assign "cohort_predictions", predictions
            R.eval "ave_per_cohort_actual = mean(test3[test3$cohort == #{cohort},]$indvalue)"
            per_cohort_actual = R.pull "ave_per_cohort_actual"
            per_cohort_actuals << per_cohort_actual
        end
        #R.assign "per_cohort_actuals", per_cohort_actuals
        #R.assign "per_cohort_predictions", per_cohort_predictions
        averaged_preds_byverb[variable] = per_cohort_predictions
        #R.eval "indiv_mae = mean(abs(per_cohort_predictions-per_cohort_actuals))"
        #R.eval "indiv_mae = mean(sqrt((log(per_cohort_predictions/per_cohort_actuals))^2))"
        indiv_mae = measure_error(measure,per_cohort_predictions,per_cohort_actuals)

        #indiv_mae = R.pull "indiv_mae"
        indiv_maes << indiv_mae
    end 
    
    

    variables.each do |variable|
        STDERR.puts variable
        bundle = []
        bundle_re = []
        categorical = []
        baseline = []

        for cohort in 1..ncohorts do
            R.eval "train2 = dataset_indiv[((dataset_indiv$cohort != #{cohort}) | (dataset_indiv$variable != '#{variable}')) ,]"
            R.eval "test2 = dataset_indiv[((dataset_indiv$cohort == #{cohort}) & (dataset_indiv$variable == '#{variable}')),]"
            #modelformula = "yob + community + yob:community + freq + trend + yob:freq + yob:trend"
            R.eval "m0 = lmer(indvalue ~ #{modelformula0} + (1|speaker2), data = train2)"
            R.eval "m2 = lmer(indvalue ~ #{modelformula} + (1|speaker2), data = train2)"
            R.eval "m3 = lmer(indvalue ~ #{modelformula2} + (1|speaker2), data = train2)"
            R.eval "m4 = lmer(indvalue ~ #{modelformula} + (1|speaker2) + (1+scale(cohort)|variable), data = train2)"
        #R.eval "m2 = lm(indvalue ~ #{modelformula}, data = train2)"
        #R.eval "print(summary(m2))"
            R.eval "preds0 = predict(m0,test2,type='response')"
            R.eval "preds2 = predict(m2,test2,type='response')"
            R.eval "preds3 = predict(m3,test2,type='response')"
            R.eval "preds4 = predict(m4,test2,type='response')"
        
            ind_preds_baseline = R.pull "preds0"
            ind_preds_baseline = bound_pred(ind_preds_baseline)
            
            ind_preds_bundle = R.pull "preds2"
            ind_preds_bundle = bound_pred(ind_preds_bundle)
            ind_preds_categorical = R.pull "preds3"
            ind_preds_categorical = bound_pred(ind_preds_categorical)
            ind_preds_bundle_re = R.pull "preds4"
            ind_preds_bundle_re = bound_pred(ind_preds_bundle_re)
            
            #actual = R.pull "test2$indvalue"
            #STDERR.puts ind_preds_byverb[variable].join(" ")
            #STDERR.puts actual.join(" ")
            #R.assign "preds2", ind_preds_bundle 
            bundle << mean(ind_preds_bundle)
            #R.assign "preds3", ind_preds_categorical
            categorical << mean(ind_preds_categorical)
            #R.assign "preds4", ind_preds_bundle_re
            bundle_re << mean(ind_preds_bundle_re)
            baseline << mean(ind_preds_baseline)
            #R.eval "indindmae2 = mean(abs(preds2-test2$indvalue))"
            #R.eval "indindmae2 = mean(sqrt((log(preds2/test2$indvalue))^2))"
            actuals = R.pull "test2$indvalue"
            indindmae0 = measure_error(measure,ind_preds_baseline,actuals)
            indindmae2 = measure_error(measure,ind_preds_bundle,actuals)
            
            #R.eval "indindmae3 = mean(abs(preds3-test2$indvalue))"
            #R.eval "indindmae3 = mean(sqrt((log(preds3/test2$indvalue))^2))"
            indindmae3 = measure_error(measure,ind_preds_categorical,actuals)
            #R.eval "indindmae4 = mean(abs(preds4-test2$indvalue))"
            #R.eval "indindmae4 = mean(sqrt((log(preds4/test2$indvalue))^2))"
            indindmae4 = measure_error(measure,ind_preds_bundle_re,actuals)
            #indindmae2 = R.pull "indindmae2"
            #indindmae3 = R.pull "indindmae3"
            #indindmae4 = R.pull "indindmae4"
            indindmae0s << indindmae0
            indindmae2s << indindmae2
            indindmae3s << indindmae3
            indindmae4s << indindmae4
            

            R.eval "ave_per_cohort_actual = mean(test2[test2$cohort == #{cohort},]$indvalue)"
            ave_per_cohort_actual = R.pull "ave_per_cohort_actual"
            #R.eval "ave_per_cohort_pred2 = mean(preds2)"
            #R.eval "ave_per_cohort_pred3 = mean(preds3)"
            #R.eval "ave_per_cohort_pred4 = mean(preds4)"
            #R.eval "ind_mae2 = mean(abs(ave_per_cohort_pred2 - ave_per_cohort_actual))"
            #R.eval "ind_mae2 = mean(sqrt((log(ave_per_cohort_pred2/ave_per_cohort_actual))^2))"
            #R.eval "ind_mae3 = mean(abs(ave_per_cohort_pred3 - ave_per_cohort_actual))"
            #R.eval "ind_mae3 = mean(sqrt((log(ave_per_cohort_pred3/ave_per_cohort_actual))^2))"
            #R.eval "ind_mae4 = mean(abs(ave_per_cohort_pred4 - ave_per_cohort_actual))"
            #R.eval "ind_mae4 = mean(sqrt((log(ave_per_cohort_pred4/ave_per_cohort_actual))^2))"
            
            #indmae2 = R.pull "ind_mae2"
            #indmae3 = R.pull "ind_mae3"
            #indmae4 = R.pull "ind_mae4"
            indmae0 = measure_error(measure, mean(ind_preds_baseline), ave_per_cohort_actual)
            indmae2 = measure_error(measure, mean(ind_preds_bundle), ave_per_cohort_actual)
            indmae3 = measure_error(measure, mean(ind_preds_categorical), ave_per_cohort_actual)
            indmae4 = measure_error(measure, mean(ind_preds_bundle_re), ave_per_cohort_actual)

            indmae0s << indmae0
            indmae2s << indmae2
            indmae3s << indmae3
            indmae4s << indmae4
            
        end
        indbaseline_per_variable[variable] = baseline
        indbundle_per_variable[variable] = bundle
        indcategorical_per_variable[variable] = categorical
        indbundle_re_per_variable[variable] = bundle_re
    end 
    #micro_byverb_mae = sum_micro_byverb_mae / (variables.length * 4)
    #STDERR.puts sumind/variables.length
    STDERR.puts "Individual average bundle: #{mean(indmae2s)}"
    STDERR.puts "Individual average categorical: #{mean(indmae3s)}"
    STDERR.puts "Individual average bundle re: #{mean(indmae4s)}"
    STDERR.puts "Individual individual bundle: #{mean(indindmae2s)}"
    STDERR.puts "Individual individual bundle re: #{mean(indindmae4s)}"
    STDERR.puts "Individual individual categorical: #{mean(indindmae3s)}"

    STDERR.puts "Individual: Average mae per unknown verb #{mean(indiv_maes)}"
    STDERR.puts "Individual: Invididual mae per unknown verb #{mean(indindiv_maes)}"
    
    mainresults.puts "individual\t#{mean(indindmae0s)}\t#{mean(indindmae3s)}\t#{mean(indindmae2s)}\t#{mean(indindmae4s)}\t#{mean(indindiv_maes)}"
    mainresults.puts "individual_averaged\t#{mean(indmae0s)}\t#{mean(indmae3s)}\t#{mean(indmae2s)}\t#{mean(indmae4s)}\t#{mean(indiv_maes)}"
    

    #R.eval "detach('package:lme4', unload=TRUE)"
end
#=end


if aggregate
    STDERR.puts "Aggregate analysis"
    modelformula = "scale(scohort) + scale(community) + scale(scohort):scale(community) + scale(freq) + trend + scale(scohort):scale(freq) + scale(scohort):trend" # + sag + so + scohort:sag + scohort:so
    #modelformula = "scohort + comcat + scohort:comcat + freqlog + trend + scohort:freqlog + scohort:trend" # + sag + so + scohort:sag + scohort:so
    modelformula1 = "scale(scohort)"
    modelformula2 = "scale(scohort) + variable + scale(scohort):variable"
    modelformula4 = "scale(scohort) + scale(community) + scale(scohort):scale(community) + scale(freq) + trend + scale(scohort):scale(freq) + scale(scohort):trend + (1 + scale(scohort)|variable)" #+ sag + so + scale(scohort):sag + scale(scohort):so 

    STDERR.puts "Reading in the dataset"
    R.eval "dataset = read.csv('for_regression_step#{step}#{intersection}.tsv', sep='\t',header=TRUE)"
    
    if do_smoothing > 0
        STDERR.puts "Smoothing"
        variables.each do |variable|
            #STDERR.puts variable
            values = R.pull "dataset[dataset$variable == '#{variable}',]$value"
            #STDERR.puts values.join(" ")
            smoothed_values = smooth(values,3)
            #STDERR.puts smoothed_values.join(" ")
            
            R.assign "smoothed_values",smoothed_values
            R.eval "dataset[dataset$variable == '#{variable}',]$value <- smoothed_values"
            values = R.pull "dataset[dataset$variable == '#{variable}',]$value"
            #STDERR.puts values.join(" ")
            #abort
        end
    end
    
    if function == "scurve"
        R.eval "dataset$scohort <- (1/(1+exp(-dataset$cohort)))"
    elsif function == "log"
        R.eval "dataset$scohort <- log(dataset$cohort)"
    elsif function == "sqrt"
        R.eval "dataset$scohort <- sqrt(dataset$cohort)"
    elsif function == "linear"
        R.eval "dataset$scohort <- dataset$cohort"
    elsif function == "poly"
        R.eval "dataset$scohort <- dataset$cohort"
        R.eval "dataset$scohort2 <- dataset$cohort^2"
        R.eval "dataset$scohort3 <- dataset$cohort^3"
        modelformula1 = "scale(scohort) + scale(scohort2) + scale(scohort3)"
        modelformula2 = "scale(scohort) + scale(scohort2) + scale(scohort3) + variable + scale(scohort):variable + scale(scohort2):variable + scale(scohort3):variable"
        modelformula = "scale(scohort) + scale(scohort2) + scale(scohort3) + scale(community) + scale(scohort):scale(community) + scale(scohort2):scale(community) + scale(scohort3):scale(community) + scale(freq) + trend + scale(scohort):scale(freq) + scale(scohort2):scale(freq) + scale(scohort3):scale(freq) + scale(scohort):trend + scale(scohort2):trend + scale(scohort3):trend" # + sag + so + scohort:sag + scohort:so
        modelformula4 = "scale(scohort) + scale(scohort2) + scale(scohort3) + scale(community) + scale(scohort):scale(community) + scale(scohort2):scale(community) + scale(scohort3):scale(community) + scale(freq) + trend + scale(scohort):scale(freq) + scale(scohort2):scale(freq) + scale(scohort3):scale(freq) + scale(scohort):trend + scale(scohort2):trend + scale(scohort3):trend + (1 + scale(scohort)|variable)"
    end
    #R.eval "head(dataset)"
    R.eval "names = c('trend','sclass')"
    R.eval "dataset[,names] <- lapply(dataset[,names],factor)"
    joint_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}
    joint_mae_all3 = Hash.new{|hash,key| hash[key] = Hash.new}
    separate_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}

    byverb_mae_all = Hash.new{|hash,key| hash[key] = Hash.new}
    
    preds_byverb = {}
    
    sum_micro_byverb_mae = 0.0

    #normalization basis
    normalized_per_verb = {}
    max_normalized = 0.0
    if normalize == 2
        STDERR.puts "normalizing"
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
    STDERR.puts "By-verb analysis"
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
        #STDERR.puts "train, test ready"
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
            byverb_mae = measure_error(measure,predsf,actualf)
            #R.assign "predsf", predsf
            #R.assign "actualf", actualf
            #R.eval "byverb_mae = mean(abs(predsf-actualf))"
            #R.eval "byverb_mae = mean(sqrt((log(predsf/actualf))^2))"
            #byverb_mae = R.pull "byverb_mae"
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
    preds0 = Hash.new{|hash,key| hash[key] = Array.new}
    preds2 = Hash.new{|hash,key| hash[key] = Array.new}
    preds3 = Hash.new{|hash,key| hash[key] = Array.new}
    preds4 = Hash.new{|hash,key| hash[key] = Array.new}
    sum_mae2 = 0.0
    sum_mae3 = 0.0
    sum_mae0 = 0.0
    sum_mae4 = 0.0

    STDERR.puts "Other joint analyses"
    variables.each do |variable|
        for cohort in 1..ncohorts do
            #STDERR.puts "Joint: cohort #{cohort}"
            STDERR.puts variable
            R.eval "train2 = dataset[((dataset$cohort != #{cohort}) | (dataset$variable != '#{variable}')) ,]"
            R.eval "test2 = dataset[((dataset$cohort == #{cohort}) & (dataset$variable == '#{variable}')),]"
            #R.eval "print(train#)"
            #abort
            R.eval "m0 = lm(value#{addendum} ~ #{modelformula1}, data = train2)"
            R.eval "m2 = lm(value#{addendum} ~ #{modelformula}, data = train2)"
            R.eval "m3 = lm(value#{addendum} ~ #{modelformula2}, data = train2)"
            R.eval "m4 = lmer(value#{addendum} ~ #{modelformula4}, data = train2)"
            #R.eval "summary(m2)"
            #R.eval "summary(m3)"
           
            R.eval "preds0 = predict(m0, test2, type='response')"
            R.eval "preds2 = predict(m2, test2, type='response')"
            R.eval "preds3 = predict(m3, test2, type='response')"
            R.eval "preds4 = predict(m4, test2, type='response')"
            preds2[variable][cohort] = R.pull "preds2"
            preds2[variable][cohort] = bound_pred(preds2[variable][cohort])
            preds3[variable][cohort] = R.pull "preds3"
            preds3[variable][cohort] = bound_pred(preds3[variable][cohort])
            preds4[variable][cohort] = R.pull "preds4"
            preds4[variable][cohort] = bound_pred(preds4[variable][cohort])
            
            preds0[variable][cohort] = R.pull "preds0"
            #if variable == "fortsätta" 
            #    STDERR.puts cohort
            #    STDERR.puts preds2[variable][cohort]
            #    STDERR.puts preds3[variable][cohort] 
            #end
            #abort

            R.assign "preds2", preds2[variable][cohort]
            R.assign "preds3", preds3[variable][cohort]
            R.assign "preds4", preds4[variable][cohort]
            #R.eval "mae2 = mean(abs(preds2-test2$value#{addendum}))"
            #R.eval "mae2 = mean(sqrt((log(preds2/test2$value#{addendum}))^2))"
            #mae2 = R.pull "mae2"
            actuals = R.pull "test2$value#{addendum}"
            mae2 = measure_error(measure, preds2[variable][cohort], actuals)
            sum_mae2 += mae2
            #R.eval "mae3 = mean(abs(preds3-test2$value#{addendum}))"
            #R.eval "mae3 = mean(sqrt((log(preds3/test2$value#{addendum}))^2))"
            #mae3 = R.pull "mae3"
            mae3 = measure_error(measure, preds3[variable][cohort], actuals)
            sum_mae3 += mae3
            #R.eval "mae4 = mean(abs(preds4-test2$value#{addendum}))"
            #R.eval "mae4 = mean(sqrt((log(preds4/test2$value#{addendum}))^2))"
            #mae4 = R.pull "mae4"
            mae4 = measure_error(measure, preds4[variable][cohort], actuals)
            sum_mae4 += mae4
            
            #R.eval "mae0 = mean(abs(preds0-test2$value#{addendum}))"
            #R.eval "mae0 = mean(sqrt((log(preds0/test2$value#{addendum}))^2))"
            #mae0 = R.pull "mae0"
            mae0 = measure_error(measure, preds0[variable][cohort], actuals)
            sum_mae0 += mae0
            
        end
    end
    joint_ave_mae2 = sum_mae2/(ncohorts*variables.length)
    joint_ave_mae3 = sum_mae3/(ncohorts*variables.length)
    joint_ave_mae4 = sum_mae4/(ncohorts*variables.length)
    joint_ave_mae0 = sum_mae0/(ncohorts*variables.length)
    
    # SEPARATE REGRESSIONS
    sum_micro_mae = 0.0
    R.eval "pdf(file='predicting_#{step}_dv#{topredict}#{intersection}_#{function}_smooth#{do_smoothing}_nvars#{variables.length}.pdf')"
    if variables.length > 9
        R.eval "par(mfrow=c(4,3), mar=c(2,2,2,2))"
    else
        R.eval "par(mfrow=c(3,3), mar=c(2,2,2,2))"
    end
    
    
    variables.each.with_index do |variable,index|
        
        STDERR.puts "Separately: #{variable}"
        
        R.eval "dataset2 = dataset[dataset$variable == '#{variable}',]"
        R.eval "min = min(dataset2$value#{addendum})-0.1"
        R.eval "max = max(dataset2$value#{addendum})+0.1"
        R.eval "if (min < 0 ) {min = 0}"
        R.eval "if (max > 1 ) {max = 1}"
    
        R.eval "plot(dataset2$value#{addendum} ~ dataset2$cohort, ylim = c(min,max), pch=21, col = 'black', bg='black', xlab = '', ylab = '', main = '#{variable.encode("windows-1252")}', xaxt = 'n', type= 'b')"
        R.eval "axis(1, at = seq(1, #{ncohorts}, by = 1))"
    
        sum_mae = 0.0
        allpreds_sep = []
        allpreds_joint = []
        allpreds_joint3 = []
        allpreds_joint4 = []
        allpreds_joint0 = []

        for cohort in 1..ncohorts do
            R.eval "train = dataset2[dataset2$cohort != #{cohort},]"
            R.eval "test = dataset2[dataset2$cohort == #{cohort},]"
            R.eval "m1 = lm(value#{addendum} ~ #{modelformula1}, data = train)"
            #R.eval "summary(m1)"
            R.eval "preds = predict(m1,test,type='response')"
            #R.eval "mae = mean(abs(preds-test$value#{addendum}))"
            R.eval "mae = mean(sqrt((log(preds/test$value#{addendum}))^2))"
            
            mae = R.pull "mae"
            if normalize > 0
                mae = mae/normalized_per_verb[variable]
            end
            sum_mae += mae
            
            preds = R.pull "preds"
            preds = bound_pred(preds)
            allpreds_sep << preds
            R.assign "preds", preds
            actual = R.pull "test$value#{addendum}"
            
            verb_preds = preds_byverb[variable]
            R.assign "verb_preds",verb_preds
            
            
            #joint
            preds2var = preds2[variable][cohort]
            allpreds_joint << preds2var
            R.assign "preds2var", preds2var
            
            preds3var = preds3[variable][cohort]
            allpreds_joint3 << preds3var
            R.assign "preds3var", preds3var

            preds4var = preds4[variable][cohort]
            allpreds_joint4 << preds4var
            R.assign "preds4var", preds4var

            preds0var = preds0[variable][cohort]
            allpreds_joint0 << preds0var
            R.assign "preds0var", preds0var
            
            #if variable == "fortsätta" 
            #    STDERR.puts cohort
            #    STDERR.puts preds2var
            #    STDERR.puts preds3var
            #end
            
            
            #R.eval "mae_joint = mean(abs(preds2var-test$value#{addendum}))"
            #R.eval "mae_joint = mean(sqrt((log(preds2var/test$value#{addendum}))^2))"
            #mae_joint = R.pull "mae_joint"
            actuals = R.pull "test$value#{addendum}"
            mae_joint = measure_error(measure, preds2var, actuals)

            #R.eval "mae_joint3 = mean(abs(preds3var-test$value#{addendum}))"
            #R.eval "mae_joint3 = mean(sqrt((log(preds3var/test$value#{addendum}))^2))"
            #mae_joint3 = R.pull "mae_joint3"
            mae_joint3 = measure_error(measure, preds3var, actuals)
            if normalize > 0
                mae_joint = mae_joint/normalized_per_verb[variable]
                mae_joint3 = mae_joint3/normalized_per_verb[variable]
            end
            joint_mae_all[variable][cohort] = mae_joint
            joint_mae_all3[variable][cohort] = mae_joint3
            separate_mae_all[variable][cohort] = mae
        end
        #separate
        R.assign "allpreds_sep", allpreds_sep.flatten
        R.assign "allpreds_joint", allpreds_joint.flatten #bundle
        R.assign "allpreds_joint3", allpreds_joint3.flatten #categorical
        R.assign "allpreds_joint4", allpreds_joint4.flatten #bundle+random
        R.assign "allpreds_joint0", allpreds_joint0.flatten #null
        #R.eval "print(allpreds_sep)"
        #R.eval "print(allpreds_joint3)"
        

        xcoords = (1..ncohorts).to_a
        R.assign "xcoords", xcoords
        #R.eval "points(xcoords-0.1, allpreds_sep, pch=22, col = 'black', bg='orange', type = 'b')"
        if plot_aggregate
            R.eval "points(xcoords, allpreds_joint0, pch=21, col = 'black', bg='white', type = 'b')" #baseline
            R.eval "points(xcoords, allpreds_joint4, pch=21, col = 'black', bg='orange', type = 'b')" #bundle-random
            R.assign "preds_byverb", preds_byverb[variable] #by verb
            R.eval "points(xcoords, preds_byverb, pch=21, col = 'black', bg='gray', type = 'b')"
            R.eval "points(xcoords+0.1, allpreds_joint, pch=24, col = 'black', bg='green', type = 'b')" #bundle
            R.eval "points(xcoords-0.1, allpreds_joint3, pch=25, col = 'black', bg='yellow', type = 'b')" #categorical
        end
 
        if individual
            R.assign "indbaseline",indbaseline_per_variable[variable]
            R.assign "indbundle",indbundle_per_variable[variable]
            R.assign "indbundle_re",indbundle_re_per_variable[variable]
            R.assign "indcategorical",indcategorical_per_variable[variable]
            R.assign "indbyverb",averaged_preds_byverb[variable]
            #R.eval "print(indbundle)"
            #R.eval "print(indcategorical)"
            R.eval "points(xcoords+0.1, indbundle, pch=22, col = 'black', bg='blue', type = 'b')"
            R.eval "points(xcoords, indbundle_re, pch=21, col = 'black', bg='green', type = 'b')"
            R.eval "points(xcoords-0.1, indcategorical, pch=23, col = 'black', bg='yellow', type = 'b')"
            R.eval "points(xcoords, indbyverb, pch=24, col = 'black', bg='gray', type = 'b')"
            R.eval "points(xcoords, indbaseline, pch=25, col = 'black', bg='white', type = 'b')"
         end
        #per verb
        #R.eval "points(xcoords, verb_preds, pch=23, type = 'b', col ='blue')"

 
        sum_micro_mae += sum_mae
    end
    R.eval "dev.off()"
    ave_micro_mae = sum_micro_mae/(variables.length * ncohorts)
    
    
    STDERR.puts "Average mae predicting unknown verbs: #{micro_byverb_mae}"
    STDERR.puts "Average micromae separately: #{ave_micro_mae}"
    


    o1 = File.open("predicting_step#{step}_norm#{normalize}_dv#{topredict}#{intersection}_#{function}_smooth#{do_smoothing}_#{measure}_nvars#{variables.length}_error_separate.tsv","w:utf-8")
    o2 = File.open("predicting_step#{step}_norm#{normalize}_dv#{topredict}#{intersection}_#{function}_smooth#{do_smoothing}_#{measure}_nvars#{variables.length}_error_joint_bundle.tsv","w:utf-8")
    o3 = File.open("predicting_step#{step}_norm#{normalize}_dv#{topredict}#{intersection}_#{function}_smooth#{do_smoothing}_#{measure}_nvars#{variables.length}_error_joint_categorical.tsv","w:utf-8")
    
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
    sum_mae3_per_variable = 0.0

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
            mae3 = joint_mae_all3[variable][cohort]
            output3 << "\t#{mae3}"
    
            sum_mae3 += mae3
            sum_mae3_per_fold[cohort] += mae3
        end
        output1 << "\t#{sum_mae/ncohorts}"
        output2 << "\t#{sum_mae2/ncohorts}"
        output3 << "\t#{sum_mae3/ncohorts}"
        sum_mae2_per_variable += sum_mae2 / ncohorts
        sum_mae3_per_variable += sum_mae3 / ncohorts
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
    #output3 << "\t#{micro_byverb_mae}"
    
    
    if normalize > 0
        normalized_joint_ave_mae2 = sum_mae2_per_variable/variables.length
        normalized_joint_ave_mae3 = sum_mae3_per_variable/variables.length
        output2 << "\t#{normalized_joint_ave_mae2}"
        output3 << "\t#{normalized_joint_ave_mae3}"
        STDERR.puts "Joint (interactions with cohort) mae bundle: #{normalized_joint_ave_mae2}" 
        STDERR.puts "Joint (interactions with cohort) mae categorical: #{normalized_joint_ave_mae3}"
    else
        output2 << "\t#{joint_ave_mae2}" 
        output3 << "\t#{joint_ave_mae3}" 
        STDERR.puts "Joint (interactions with cohort) mae bundle: #{joint_ave_mae2}"
        STDERR.puts "Joint (interactions with cohort) mae categorical: #{joint_ave_mae3}"
        STDERR.puts "Null model: #{joint_ave_mae0}"
        STDERR.puts "Random-effect model: #{joint_ave_mae4}"
    end
    mainresults.puts "aggregate\t#{joint_ave_mae0}\t#{joint_ave_mae3}\t#{joint_ave_mae2}\t#{joint_ave_mae4}\t#{micro_byverb_mae}"
    o1.puts output1
    o2.puts output2
    o3.puts output3
end

ind_preds_byverb = {}

