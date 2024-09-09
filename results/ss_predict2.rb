# encoding: UTF-8

year = "2008,2009,2010"
t = 0

step = 4
cohortsfile = File.open("C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\results\\cohorts_min1960_step#{step}.tsv","r:utf-8")
cohorts = {}

cohortsfile.each_line.with_index do |line,index|
    if index > 0 
        line2 = line.strip.split("\t")
        cohorts[index] = line2
    end
end

cohortidhash = {}
cohorttokenhash = {}
cohortauthorhash = {}
cohorts.each_pair do |id,cohortinfo|
    start = cohortinfo[0].to_i
    finish = cohortinfo[1].to_i
    for i in start..finish
        cohortidhash[i] = id
    end
    cohorttokenhash[id] = cohortinfo[2].to_i
    cohortauthorhash[id] = cohortinfo[3].to_i

end

ncohorts = cohorts.keys.length.to_f
testsetsize = ncohorts/4
train = []
test = []

=begin
for testid in 1..4 do
    if step == 4
        start = testid*2 - 1 
        finish = testid*2
    elsif step == 8
        start = testid
        finish = testid
    end
    test[testid] = []
    cohorts.each_key do |key|
        if key >= start and key <= finish
            test[testid] << key
        end
    end
end
=end

require_relative "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\math_tools.rb"

#check that the order within arrays is equivalent
#extract samples for manual control
#check consistency
#zoom in?

require "rinruby"
require_relative "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\results\\intersection.rb"
R.eval "setwd('plots')"
excluded_variables = ["behaga", "lova"]
variables = ["fortsätta", "försöka", "glömma", "komma", "planera", "riskera", "slippa", "sluta", "vägra"]
by_verb_by_cohort_tokens = Hash.new{|hash,key| hash[key] = Hash.new(0)}
by_verb_by_cohort_authors = Hash.new{|hash,key| hash[key] = Hash.new(0)}
macroinnov_by_variable_by_cohort = Hash.new{|hash,key| hash[key] = Hash.new(0)}
hashinnov_by_variable_by_cohort = Hash.new{|hash,key| hash[key] = Hash.new{|hash1,key1| hash1[key1] = Array.new}}
innov_by_variable_by_cohort = Hash.new{|hash,key| hash[key] = Hash.new{|hash1,key1| hash1[key1] = Hash.new}}
yobs = {}
speakers_by_variable = Hash.new{|hash,key| hash[key] = Hash.new}

avar_community = {}
freq = {}
trend = {}
sclass = {}
o3 = File.open("for_regression_step#{step}.tsv","w:utf-8")
o3.puts "variable\tcommunity\tfreq\ttrend\tsclass\tcohort\tvalue\tvalue2"
o4 = File.open("for_regression_step#{step}_indiv.tsv","w:utf-8")
o4.puts "variable\tcommunity\tfreq\ttrend\tsclass\tcohort\tvalue\tvalue2\tspeaker\tindvalue\tyob\tspeaker2"

variables.each do |variable|
    filename = "ss30_2008,2009,2010\\familjeliv_#{variable}_t#{t}_#{year}.tsv"
    f = File.open(filename,"r:utf-8")
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.split("\t")
            speaker = line2[1]
            yob = line2[2].to_i
            innov = line2[-1].to_f
            v2abs = line2[-3].to_f
            #vtotal = line2[-5].to_f
            total = line2[4].to_i
            cohort = cohortidhash[yob]

            speakers_by_variable[variable][speaker] = true
        end
    end
end

speaker_scores = Hash.new(0)
speakers_by_variable.each_pair do |variable, speakerhash|
    speakerhash.each_key do |speaker|
        speaker_scores[speaker] += 1
    end
end



variables.each do |variable|
    filename = "ss30_2008,2009,2010\\familjeliv_#{variable}_t#{t}_#{year}.tsv"
    vardata = File.open("variable_stats.tsv","r:utf-8")
    vardata.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            
            if variable == line2[0]
                freq[variable] = line2[3].to_f
                trend[variable] = line2[4]
                sclass[variable] = line2[5]
                if sclass[variable] == "deontic" or sclass[variable] == "temporal"
                    #STDERR.puts variable
                    sclass[variable] = "other"
                end
            end
        end
    end
    
    fcommunity = "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\variables\\ss90_#{variable}\\familjeliv\\all\\all_users.tsv"
    fc = File.open(fcommunity, "r:utf-8")
    community_average = 0.0
    fc.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            period = line2[0]
            if year.include?(period)
                community_average += line2[5].to_f
            end
            
        end
    end
    community_average = community_average/(year.split(",").length)
    avar_community[variable] = community_average
    fc.close


    f = File.open(filename,"r:utf-8")
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.split("\t")
            speaker = line2[1]
            yob = line2[2].to_i
            innov = line2[-1].to_f
            v2abs = line2[-3].to_f
            #vtotal = line2[-5].to_f
            total = line2[4].to_i
            cohort = cohortidhash[yob]

            macroinnov_by_variable_by_cohort[variable][cohort] += innov
            hashinnov_by_variable_by_cohort[variable][cohort] << innov
            by_verb_by_cohort_tokens[variable][cohort] += total
            by_verb_by_cohort_authors[variable][cohort] += 1
            innov_by_variable_by_cohort[variable][cohort][speaker] = innov
            yobs[speaker] = yob
            #speakers_by_variable[variable][speaker] = true
        end
    end
end

o1 = File.open("by_cohort_stats_occurrences_step#{step}.tsv","w:utf-8")
o2 = File.open("by_cohort_stats_authors_step#{step}.tsv","w:utf-8")

o1.puts "variable\t#{cohorts.keys.join("\t")}"
o2.puts "variable\t#{cohorts.keys.join("\t")}"

by_verb_by_cohort_tokens.each_pair do |verb, verbhash|
    output1 = "#{verb}"
    output2 = "#{verb}"
    cohorts.each_key do |cohort|
        output1 << "\t#{verbhash[cohort]}"
        output2 << "\t#{by_verb_by_cohort_authors[verb][cohort]}"
    end

    o1.puts output1
    o2.puts output2
    
end

variables.each do |variable|
    cohorts.each_key do |cohort|
        macroinnov = macroinnov_by_variable_by_cohort[variable][cohort].to_f/by_verb_by_cohort_authors[variable][cohort]
        mad = m_absolute_deviation(hashinnov_by_variable_by_cohort[variable][cohort], mean(hashinnov_by_variable_by_cohort[variable][cohort]), "mean")
        o3.puts "#{variable}\t#{avar_community[variable]}\t#{freq[variable]}\t#{trend[variable]}\t#{sclass[variable]}\t#{cohort}\t#{macroinnov}\t#{mad}"
        output4 = "#{variable}\t#{avar_community[variable]}\t#{freq[variable]}\t#{trend[variable]}\t#{sclass[variable]}\t#{cohort}\t#{macroinnov}\t#{mad}"
        innov_by_variable_by_cohort[variable][cohort].each_pair do |speaker,indinnov|
            if speaker_scores[speaker] > 1
                speaker2 = speaker
            else
                speaker2 = "dummy_coded_other"
            end
            o4.puts "#{output4}\t#{speaker}\t#{indinnov}\t#{yobs[speaker]}\t#{speaker2}"
        end
    end
end