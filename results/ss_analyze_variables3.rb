#TODO:
#prolific speakers
#deviances
#visualize RQ2

# encoding: UTF-8


require_relative "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\math_tools.rb"

#check that the order within arrays is equivalent
#extract samples for manual control
#check consistency
#zoom in?

require "rinruby"
require_relative "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\results\\intersection.rb"
R.eval "setwd('plots')"

cohorttype = 10
part = 2
plottype = "stripchart"
year = "2008,2009,2010"
t = 0
t2 = 10 #prolific speaker



variables = ["behaga", "fortsätta", "försöka", "glömma", "komma", "lova", "planera", "riskera","slippa", "sluta", "vägra"]
plotrq1 = false
plotrq2 = false
plotrq3 = true


if plotrq1
    R.eval "pdf(file='#{plottype}_v2bycohort#{cohorttype}_t#{t}_#{year}_part#{part}.pdf')"
    if cohorttype == 5
        R.eval "par(mfrow=c(2,2))"
        if part == 1
            variables = ["behaga", "fortsätta", "försöka", "glömma"]#, "planera", "riskera","slippa", "sluta", "vägra"]
        elsif part == 2
            variables = ["komma", "lova", "planera", "riskera"]
        elsif part == 3
            variables = ["slippa", "sluta", "vägra"]
        else part == "allverbs"
            variables = ["behaga", "fortsätta", "försöka", "glömma", "komma", "lova", "planera", "riskera","slippa", "sluta", "vägra"]
        end
    elsif cohorttype == 10
        R.eval "par(mfrow=c(2,3))"
        if part == 1
            variables = ["behaga", "fortsätta", "försöka", "glömma", "komma", "lova"]#, "planera", "riskera","slippa", "sluta", "vägra"]
        elsif part == 2
            variables = ["planera", "riskera","slippa", "sluta", "vägra"]
        else part == "allverbs"
            variables = ["behaga", "fortsätta", "försöka", "glömma", "komma", "lova", "planera", "riskera","slippa", "sluta", "vägra"]
        end
    
    end
end

variables2 = ["försöka", "fortsätta",  "glömma", "komma", "slippa", "sluta", "vägra"]
variables3 = ["försöka", "fortsätta",  "komma", "slippa", "sluta", "vägra"]
variables3 = ["försöka", "komma", "slippa", "vägra"]

intersection = find_intersection(year, t2, variables3)
STDERR.puts intersection.length
#__END__

flag = true
intersection_age = {}

#STDERR.puts entropy([0.01, 0.99])


#__END__
def yob_to_cohort(yob)
    if yob > 1992
        #abort("Invalid yob") 
        cohort = 0
    elsif yob >= 1983
        cohort = 4
    elsif yob >= 1973
        cohort = 3
    elsif yob == 1970
        cohort = 0 #this year must be exluded. It was already done by query_conllu, so this is just an extra safety
    elsif yob >= 1963
        cohort = 2
    elsif yob >= 1947
        cohort = 1
    else
        abort("Invalid yob") 
    end
       
    return cohort
end

def yob_to_cohort2(yob)
    if yob > 1992
        #abort("Invalid yob") 
        cohort = 0
    elsif yob >= 1988
        cohort = 9
    elsif yob >= 1983
        cohort = 8
    elsif yob >= 1978
        cohort = 7
    elsif yob >= 1973
        cohort = 6
    elsif yob == 1970
        cohort = 0 #this year must be exluded. It was already done by query_conllu, so this is just an extra safety
    elsif yob >= 1968
        cohort = 5
    elsif yob >= 1963
        cohort = 4
    elsif yob >= 1958
        cohort = 3
    elsif yob >= 1953
        cohort = 2
    elsif yob >= 1947
        cohort = 1
    else
        abort("Invalid yob") 
    end
       
    return cohort
end


avar_enthash = {}
var_v2 = {}
var_age = {}
innovativity = {}
avar_community = {}
var_ent = {}

rq2 = Hash.new{|hash, key| hash[key] = Array.new}
speaker_general_properties = {}
speaker_properties = Hash.new{|hash, key| hash[key] = Hash.new}



variables.each do |variable|
    agehash = {}
    v2hash = {}
    enthash = {}
    coh_enthash = Hash.new{|hash, key| hash[key] = Array.new}
    coh_v2hash  = Hash.new{|hash, key| hash[key] = Array.new}
    coh_v2hash2  = Hash.new{|hash, key| hash[key] = Array.new}
    #coh_total = Hash.new(0.0)
    entsum = 0.0

    STDERR.puts variable

#=begin
    if variables2.include?(variable)
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
    end
#=end

    filename = "ss30_2008,2009,2010\\familjeliv_#{variable}_t#{t}_#{year}.tsv"
    filename2 = "ss30_2008,2009,2010\\familjeliv_#{variable}_t#{t}_#{year}_withcohort.tsv"
    f = File.open(filename, "r:utf-8")
    f2 = File.open(filename2, "w:utf-8")
    f2.puts "period	username	yob	agebin	total	v1abs	v2abs	v1rel	v2rel\tagebin2"
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.split("\t")
            speaker = line2[1]
            yob = line2[2].to_i
            innov = line2[-1].to_f
            v2hash[speaker] = innov
            cohort = yob_to_cohort(yob)
            cohort2 = yob_to_cohort2(yob)
            total = line2[4].to_i 
            if speaker_general_properties[speaker].nil?
                speaker_general_properties[speaker] = [yob, cohort, cohort2]
            end
            

            speaker_properties[variable][speaker] = [total, innov]


            if cohort != 0
                coh_v2hash[cohort] << v2hash[speaker]
                coh_v2hash2[cohort2] << v2hash[speaker]
                f2.puts "\t#{speaker}\t#{yob}\t#{cohort}\t#{line2[4..-1].join("\t").strip}\t#{cohort2}"
            end
            if variables2.include?(variable)
                
                if total >= t2
                    rq2[variable] << innov 
                end
            end
        end
    end
    #var_v2[variable] = v2hash
    #var_age[variable] = agehash
    #var_ent[variable] = enthash
    
    #if flag
    #    intersection = agehash.keys
#        STDERR.puts intersection.length
    #else
    #    intersection = intersection & agehash.keys
#        STDERR.puts intersection.length
    #end

    #flag = false
    v2array = v2hash.values
    #avar_enthash[variable] = entsum/v2array.length
    #R.eval "pdf(file='intra_#{variable}_t#{t}_#{year}.pdf')"
    #R.assign "v2rels",v2array
    #R.eval "hist(v2rels, main = \"Proportion of innovations for #{variable}\")"
    #R.eval "dev.off()"
    
    #R.eval "pdf(file='entropy_#{variable}_t#{t}_#{year}.pdf')"
    #R.assign "entropy",enthash.values
    #R.eval "hist(entropy, main = \"Entropy for #{variable}\")"
    #R.eval "dev.off()"

    #R.eval "pdf(file='entropybyage_#{variable}_t#{t}_#{year}.pdf')"
    #R.assign "age",agehash.values
    #R.eval "plot(entropy~age, main = \"Entropy by age #{variable}\")"
    #R.eval "dev.off()"

    #R.eval "pdf(file='entropybycohort_#{variable}_t#{t}_#{year}.pdf')"

    if plotrq1
        if cohorttype == 10
            for i in 1..4 do 
                R.assign "d#{i}",coh_v2hash[i]
            end
            if plottype == "boxplot"
                R.eval "boxplot(d1,d2,d3,d4, main = \"#{variable.encode("windows-1252")}\", varwidth = TRUE, names = c(\"47-62\",\"-72\",\"-82\",\"-92\"))"
            elsif plottype == "stripchart"
                #R.eval "df <- data.frame(d1,d2,d3,d4)"
                #R.eval "names(df) <- c(\"47-62\",\"-72\",\"-82\",\"-92\")"
                R.eval "stripchart(list(d1,d2,d3,d4), main = \"#{variable.encode("windows-1252")}\", group.names = c(\"47-62\",\"-72\",\"-82\",\"-92\"), vertical = TRUE, method=\"jitter\")"
                R.eval "points(c(median(d1),median(d2),median(d3),median(d4)), pch=19, col=\"green\")"
            end
            R.eval "points(c(mean(d1),mean(d2),mean(d3),mean(d4)), pch=15, col=\"red\")"
            
        elsif cohorttype == 5
            for j in 1..9 do 
	            R.assign "e#{j}",coh_v2hash2[j]
            end
            if plottype == "boxplot"
                R.eval "boxplot(e1,e2,e3,e4,e5,e6,e7,e8,e9, main = \"#{variable.encode("windows-1252")}\", varwidth = TRUE, names = c(\"-52\",\"-57\",\"-62\",\"-67\",\"-72\",\"-77\",\"-82\",\"-87\",\"-92\"),cex.axis=0.75)"
            elsif plottype == "stripchart"
                R.eval "stripchart(list(e1,e2,e3,e4,e5,e6,e7,e8,e9), main = \"#{variable.encode("windows-1252")}\", group.names = c(\"-52\",\"-57\",\"-62\",\"-67\",\"-72\",\"-77\",\"-82\",\"-87\",\"-92\"), vertical = TRUE, method=\"jitter\")"
                R.eval "points(c(median(e1),median(e2),median(e3),median(e4),median(e5),median(e6),median(e7),median(e8),median(e9)), pch=19, col=\"green\")"
            end
	    
            R.eval "points(c(mean(e1),mean(e2),mean(e3),mean(e4),mean(e5),mean(e6),mean(e7),mean(e8),mean(e9)), pch=15, col=\"red\")"
        end
    end
    #R.eval "pdf(file='v2bycohort2_#{variable}_t#{t}_#{year}.pdf')"

    #R.eval "boxplot(e1,e2,e3,e4,e5,e6,e7,e8, main = \"Innovation across 5-year cohorts for #{variable}\", varwidth = TRUE, names = c(\"47-52\",\"63-72\",\"73-82\",\"83-92\"))"
    #R.eval "dev.off()"


    #STDERR.puts intersection.keys.length
end

if plotrq1
    R.eval "dev.off()"
end

if plotrq2
    plottype = "stripchart"
    part = "allverbs"
    mode = "_deviances"
    R.eval "pdf(file='#{plottype}_rq2innovation#{mode}_t2#{t2}_#{year}_part#{part}.pdf')"
    variables = ["försöka", "fortsätta",  "glömma", "komma", "slippa", "sluta", "vägra"]
    
    rq2a = Hash.new{|hash, key| hash[key] = Array.new}
    if mode == "_deviances"
        variables.each do |variable|
            rq2[variable].each do |value|
                rq2a[variable] << value - avar_community[variable]
            end
        end
    else
        rq2a = rq2
    end

    #R.eval "par(mfrow=c(2,2))"
    if part == 1
        variables = variables[0..3]
        for i in 1..4 do
            R.assign "d#{i}",rq2a[variables[i-1]]
        end
        R.assign "plotnames", ["försöka".encode("windows-1252"), "fortsätta".encode("windows-1252"),  "glömma".encode("windows-1252"), "komma".encode("windows-1252")]
        R.assign "community", [avar_community["försöka"], avar_community["fortsätta"], avar_community["glömma"], avar_community["komma"]]
    elsif part == 2
        variables = variables[4..6]
        for i in 1..3 do
            
            R.assign "d#{i}",rq2a[variables[i-1]]
            
        end
        R.assign "plotnames", ["slippa".encode("windows-1252"), "sluta".encode("windows-1252"), "vägra".encode("windows-1252")]
        R.assign "community", [avar_community["slippa"], avar_community["sluta"], avar_community["vägra"]]
    elsif part == "allverbs"
        for i in 1..7 do
            R.assign "d#{i}",rq2a[variables[i-1]]
        end
        R.assign "plotnames", ["försöka".encode("windows-1252"), "fortsätta".encode("windows-1252"),  "glömma".encode("windows-1252"), "komma".encode("windows-1252"),"slippa".encode("windows-1252"), "sluta".encode("windows-1252"), "vägra".encode("windows-1252")]
        R.assign "community", [avar_community["försöka"], avar_community["fortsätta"], avar_community["glömma"], avar_community["komma"],avar_community["slippa"], avar_community["sluta"], avar_community["vägra"]]
    end
    
    

    if plottype == "boxplot"
        if part == "allverbs"
            R.eval "boxplot(list(d1,d2,d3,d4,d5,d6,d7), names = plotnames, varwidth = TRUE)" 
            R.eval "points(community, pch=15, col=\"orange\")"
        end

    elsif plottype == "stripchart"
        if part == 1
            R.eval "stripchart(list(d1,d2,d3,d4), group.names = plotnames, jitter = 0.3, vertical = TRUE, method=\"jitter\")" #main = \"#{variable.encode("windows-1252")}\",
            R.eval "points(community, pch=15, col=\"orange\")"
        elsif part == 2
            R.eval "stripchart(list(d1,d2,d3), group.names = plotnames, jitter = 0.3, vertical = TRUE, method=\"jitter\")" 
            R.eval "points(community, pch=15, col=\"orange\")"
        elsif part == "allverbs"
            R.eval "stripchart(list(d1,d2,d3,d4,d5,d6,d7), group.names = plotnames, jitter = 0.3, vertical = TRUE, method=\"jitter\")" 
            R.eval "points(community, pch=15, col=\"orange\")"
        end
    end
    
    
    
    R.eval "dev.off()"
end


cohort_coherence = Hash.new{|hash, key| hash[key] = Array.new}
plotrq3b = true


if plotrq3
    o = File.open("coherence_t2_#{t2}.tsv","w:utf-8")
    o.puts "speaker\tyob\tcohort10\tcohort5\tförsöka\tfortsätta\tkomma\tslippa\tsluta\tvägra\tcoherence"
    intersection.each do |speaker|
        oline = ""
        oline << "#{speaker}\t#{speaker_general_properties[speaker].join("\t")}"
        conservative = 0.0
        innovative = 0.0
        variables3.each do |variable|
            if speaker_properties[variable][speaker][1] > avar_community[variable]
                innovative += 1
            else
                conservative += 1
            end
            oline << "\t#{speaker_properties[variable][speaker][1] - avar_community[variable]}"
        end
        cohort = speaker_general_properties[speaker][1]
        coherence = entropy([innovative / (innovative + conservative),conservative / (innovative + conservative)])
        cohort_coherence[cohort] << coherence
        oline << "\t#{coherence}"
        o.puts oline
    end
    if plotrq3b
        plottype = "boxplot"
        R.eval "pdf(file='#{plottype}_rq3coherence_t2#{t2}_#{year}_verbs#{variables3.length}.pdf')"
   
        for i in 1..4 do 
            R.assign "d#{i}",cohort_coherence[i]
        end
            if plottype == "boxplot"
                R.eval "boxplot(d1,d2,d3,d4, varwidth = TRUE, names = c(\"47-62\",\"-72\",\"-82\",\"-92\"))"
            elsif plottype == "stripchart"
                R.eval "stripchart(list(d1,d2,d3,d4), group.names = c(\"47-62\",\"-72\",\"-82\",\"-92\"), vertical = TRUE, method=\"jitter\")"
                R.eval "points(c(median(d1),median(d2),median(d3),median(d4)), pch=19, col=\"green\")"
            end
            R.eval "points(c(mean(d1),mean(d2),mean(d3),mean(d4)), pch=15, col=\"red\")"
        R.eval "dev.off()"
    end
end