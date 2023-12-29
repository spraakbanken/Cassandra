# encoding: UTF-8

#require_relative "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\math_tools.rb"

#check that the order within arrays is equivalent
#extract samples for manual control
#check consistency
#zoom in?

require "rinruby"
R.eval "setwd('plots')"

cohorttype = 5
part = 1
plottype = "stripchart"
year = "2008,2009,2010"
t = 0

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





intersection = []
flag = true
intersection_age = {}

def entropy(array)
    e = 0.0
    array.each do |p|
        if p != 0
            e += p * Math.log(p, 2)
        end
    end
    e = -e
    return e
end

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

=begin
    fcommunity = "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\variables\\ss_#{variable}\\familjeliv\\all\\all_users.tsv"
    fc = File.open(fcommunity, "r:utf-8")
    community_average = nil
    fc.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            period = line2[0].to_i
            if period == year
                community_average = line2[5].to_f
                break
            end
            
        end
    end
    avar_community[variable] = community_average
    fc.close
=end

    filename = "ss30_2008,2009,2010\\familjeliv_#{variable}_t#{t}_#{year}.tsv"
    filename2 = "ss30_2008,2009,2010\\familjeliv_#{variable}_t#{t}_#{year}_withcohort.tsv"
    f = File.open(filename, "r:utf-8")
    f2 = File.open(filename2, "w:utf-8")
    f2.puts "period	username	yob	agebin	total	v1abs	v2abs	v1rel	v2rel\tagebin2"
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.split("\t")
            speaker = line2[1]
            #STDERR.puts speaker
            #agehash[speaker] = line2[2].to_i
            yob = line2[2].to_i
            #STDERR.puts yob
            #if yob != 1970
            v2hash[speaker] = line2[-1].to_f
            #    enthash[speaker] = entropy([v2hash[speaker],1-v2hash[speaker]])
            #    entsum += enthash[speaker]
                cohort = yob_to_cohort(yob)
                cohort2 = yob_to_cohort2(yob)
                if cohort != 0
                    #coh_total[cohort] += 1
            #        coh_enthash[cohort] << enthash[speaker]
                    coh_v2hash[cohort] << v2hash[speaker]
                    coh_v2hash2[cohort2] << v2hash[speaker]
                    f2.puts "\t#{speaker}\t#{yob}\t#{cohort}\t#{line2[4..-1].join("\t").strip}\t#{cohort2}"
                end
            #end
            #STDOUT.puts "#{line2[1]}\t#{v2hash[speaker]}\t#{enthash[speaker]}"
            
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

    #R.eval "pdf(file='v2bycohort2_#{variable}_t#{t}_#{year}.pdf')"

    #R.eval "boxplot(e1,e2,e3,e4,e5,e6,e7,e8, main = \"Innovation across 5-year cohorts for #{variable}\", varwidth = TRUE, names = c(\"47-52\",\"63-72\",\"73-82\",\"83-92\"))"
    #R.eval "dev.off()"


    #STDERR.puts intersection.keys.length
end

R.eval "dev.off()"
__END__
STDOUT.puts "#{avar_enthash}"
STDOUT.puts intersection.length

intersection_v2 = Hash.new{|hash, key| hash[key] = Hash.new}
intersection_entropy = Hash.new{|hash, key| hash[key] = Hash.new}
consistency = {}
#coh_intersection = {}
coh_innovativity = Hash.new{|hash, key| hash[key] = Array.new}
coh_consistency = Hash.new{|hash, key| hash[key] = Array.new}

intersection.each do |speaker|
    i_sum = 0.0
    more = 0.0
    less = 0.0
    ageflag = true
        
    variables.each do |variable|
        intersection_v2[variable][speaker] = var_v2[variable][speaker]
        intersection_entropy[variable][speaker] = var_ent[variable][speaker]
        i_sum += var_v2[variable][speaker]
        if ageflag
            intersection_age[speaker] = var_age[variable][speaker]
            
            ageflag = false
        end
        if var_v2[variable][speaker] >= avar_community[variable]
            more += 1
        else
            less += 1
        end
        
        

    end
    cohort = yob_to_cohort(year - intersection_age[speaker])
    nvariables = variables.length
    innovativity[speaker] = i_sum/nvariables
    coh_innovativity[cohort] << innovativity[speaker]
    consistency[speaker] = entropy([more/nvariables,less/nvariables])
    coh_consistency[cohort] << consistency[speaker]

end

used_pairs = []
variables.each do |variable1|
    variables.each do |variable2|
        if variable1 != variable2 and !used_pairs.include?([variable1, variable2].sort)
            R.eval "pdf(file='correlv2_#{variable1}by#{variable2}_t#{t}_#{year}.pdf')"
            R.assign "var1",intersection_v2[variable1].values
            R.assign "var2",intersection_v2[variable2].values
            R.eval "plot(var1~var2, main = \"V2: #{variable1} by #{variable2}\")"
            R.eval "dev.off()"

            R.eval "pdf(file='correlentropy_#{variable1}by#{variable2}_t#{t}_#{year}.pdf')"
            R.assign "var1",intersection_entropy[variable1].values
            R.assign "var2",intersection_entropy[variable2].values
            R.eval "plot(var1~var2, main = \"Entropy: #{variable1} by #{variable2}\")"
            R.eval "dev.off()"

            used_pairs << [variable1, variable2].sort
        end
    end
end
R.eval "pdf(file='innovativity_t#{t}_#{year}.pdf')"
R.assign "innov",innovativity.values
R.eval "hist(innov, main = \"innovativity across variables\")"
R.eval "dev.off()"

R.eval "pdf(file='innovbyage_t#{t}_#{year}.pdf')"
R.assign "int_age",intersection_age.values
R.eval "plot(innov~int_age, main = \"innovativity by age\")"
R.eval "dev.off()"

R.eval "pdf(file='consistency_t#{t}_#{year}.pdf')"
R.assign "consistency",consistency.values
R.eval "hist(consistency, main = \"consistency\")"
R.eval "dev.off()"

R.eval "pdf(file='consbyage_t#{t}_#{year}.pdf')"
R.eval "plot(consistency~int_age, main = \"consistency by age\")"
R.eval "dev.off()"

R.eval "pdf(file='innovbycohort_t#{t}_#{year}.pdf')"
for i in 1..5 do 
    R.assign "c#{i}",coh_innovativity[i]
    #R.assign "d#{i}",coh_consistency[i]
end
R.eval "boxplot(c1,c2,c3,c4,c5, main = \"innovativity by cohort\")"
R.eval "dev.off()"

R.eval "pdf(file='consbycohort_t#{t}_#{year}.pdf')"

R.eval "boxplot(d1,d2,d3,d4,d5, main = \"consistency by cohort\")"
R.eval "dev.off()"