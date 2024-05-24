# encoding: UTF-8

# median: orange circle
# macroave: green triangle up
# microave: blue diamond
# mad from median: yellow triange down

require_relative "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\math_tools.rb"

#check that the order within arrays is equivalent
#extract samples for manual control
#check consistency
#zoom in?

require "rinruby"
require_relative "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\results\\intersection.rb"
R.eval "setwd('plots')"


cohorttype = 10
part = 1
plottype = "stripchart"
year = "2008,2009,2010"
t = 0
t2 = 10 #prolific speaker
ylimsrq1 = "fixed"

if ylimsrq1 == "fixed"
    ylimrq1l = Hash.new(0)
    ylimrq1u = Hash.new(1)
elsif ylimsrq1 == "flex"
    ylimrq1l = {"behaga" => 0.6, "fortsätta" => 0, "försöka" => 0.8, "glömma" => 0.7, "komma" => 0, "lova" => 0, "planera" => 0, "riskera" => 0, "slippa" => 0.9, "sluta" => 0.9, "vägra" => 0}
    ylimrq1u = {"behaga" => 1, "fortsätta" => 1, "försöka" => 1, "glömma" => 1, "komma" => 1, "lova" => 0.25, "planera" => 0.2, "riskera" => 0.2, "slippa" => 1, "sluta" => 1, "vägra" => 1}
end



variables = ["behaga", "fortsätta", "försöka", "glömma", "komma", "lova", "planera", "riskera","slippa", "sluta", "vägra"]
plotrq1 = true
plotrq2 = false
plotrq3 = false
plotrq3a = false
plotrq3b = false
plotrq3c = false
plotrq3d = false

if plotrq1
    R.eval "pdf(file='#{plottype}_v2bycohort#{cohorttype}_t#{t}_#{year}_part#{part}_ylim#{ylimsrq1}_cohorta.pdf')"
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
#variables3 = ["försöka", "komma", "slippa", "vägra"]

intersection = find_intersection(year, t2, variables3)
#STDERR.puts intersection.length
#__END__

flag = true
intersection_age = {}

#STDERR.puts entropy([0.01, 0.99])


#__END__
def yob_to_cohort(yob)
    if yob > 1992
        #abort("Invalid yob") 
        cohort = 0
    elsif yob >= 1980
        cohort = 3
    elsif yob == 1970
        cohort = 0 #this year must be exluded. It was already done by query_conllu, so this is just an extra safety
    elsif yob >= 1965
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

#STDOUT.puts "variable\tdiffmean21\tdiffmean32\tdiffmean43\trel_diffmean21\trel_diffmean32\trel_diffmean43"

variables.each do |variable|
    agehash = {}
    v2hash = {}
    enthash = {}
    coh_enthash = Hash.new{|hash, key| hash[key] = Array.new}
    coh_v2hash  = Hash.new{|hash, key| hash[key] = Array.new}
    coh_v2hash_var = Hash.new{|hash, key| hash[key] = Array.new}
    coh_v2hash2  = Hash.new{|hash, key| hash[key] = Array.new}
    coh_v2abs = Hash.new(0.0)
    coh_v2abs2 = Hash.new(0.0)
    coh_total = Hash.new(0.0)
    coh_total2 = Hash.new(0.0)
        
    #coh_total = Hash.new(0.0)
    entsum = 0.0

    STDERR.puts variable

#=begin
    #if variables2.include?(variable)
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
    #end
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
            v2abs = line2[-3].to_f
            vtotal = line2[-5].to_f
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
                coh_v2abs[cohort] += v2abs
                coh_v2abs2[cohort2] += v2abs
                coh_total[cohort] += vtotal
                coh_total2[cohort2] += vtotal
                
                coh_v2hash2[cohort2] << v2hash[speaker]
                f2.puts "\t#{speaker}\t#{yob}\t#{cohort}\t#{line2[4..-1].join("\t").strip}\t#{cohort2}"
                if avar_community[variable] > 0.5
                    if v2hash[speaker] < 1 #and v2hash[speaker] > 0
                        coh_v2hash_var[cohort] << v2hash[speaker]
                    end
                else #avar_community[variable] > 0.5
                    if v2hash[speaker] > 0
                        coh_v2hash_var[cohort] << v2hash[speaker]
                    end

                end
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
            for i in 1..3 do 
                R.assign "d#{i}",coh_v2hash[i]
                R.assign "dvar#{i}",coh_v2hash_var[i]
                microave = coh_v2abs[i]/coh_total[i]
                R.assign "m#{i}",microave
            end
            if plottype == "boxplot"
                R.eval "boxplot(d1,d2,d3,d4, main = \"#{variable.encode("windows-1252")}\", varwidth = TRUE, names = c(\"47-62\",\"-72\",\"-82\",\"-92\"))"
            elsif plottype == "stripchart"
                #R.eval "df <- data.frame(d1,d2,d3,d4)"
                #R.eval "names(df) <- c(\"47-62\",\"-72\",\"-82\",\"-92\")"
                R.eval "stripchart(list(d1,d2,d3), main = \"#{variable.encode("windows-1252")}\", group.names = c(\"47-64\",\"-79\",\"-92\"), vertical = TRUE, method=\"jitter\", pch=15, col=rgb(0, 0, 0, 0.2), ylim = c(#{ylimrq1l[variable]}, #{ylimrq1u[variable]}))"
                R.eval "medians = c(median(d1),median(d2),median(d3))"
                R.eval "points(medians, pch=21, col = 'black', bg='orange')"
            end
            R.eval "means = c(mean(d1),mean(d2),mean(d3))"
            R.eval "points(means, pch=24, col='black', bg = 'green')"
            R.eval "ref = c(1,2,3)"
            kendall_medians = R.pull "cor.test(medians,ref,method='kendall')$estimate"
            kendall_means = R.pull "cor.test(means,ref,method='kendall')$estimate"

            R.eval "diffmean21 = mean(d2) - mean(d1)"
            R.eval "diffmean32 = mean(d3) - mean(d2)"
            #R.eval "diffmean43 = mean(d4) - mean(d3)"
            R.eval "sum_diffmean = sum(diffmean21,diffmean32)"
            R.eval "rel_diffmean21 = diffmean21/sum_diffmean"
            R.eval "rel_diffmean32 = diffmean32/sum_diffmean"
            #R.eval "rel_diffmean43 = diffmean43/sum_diffmean"
            diffmean21 = R.pull "diffmean21"
            diffmean32 = R.pull "diffmean32"
            #diffmean43 = R.pull "diffmean43"
            rel_diffmean21 = R.pull "rel_diffmean21"
            rel_diffmean32 = R.pull "rel_diffmean32"
            #rel_diffmean43 = R.pull "rel_diffmean43"
            STDOUT.puts "#{variable}\t#{diffmean21}\t#{diffmean32}\t#{rel_diffmean21}\t#{rel_diffmean32}"

            #STDERR.puts kendall_medians
            #STDERR.puts kendall_means
            #R.eval "points(c(median(dvar1),median(dvar2),median(dvar3),median(dvar4)), pch=17, col=\"blue\")"
            #R.eval "points(c(m1,m2,m3,m4), pch=23, col='black', bg = 'yellow')"
        elsif cohorttype == 5
            for j in 1..9 do 
	            R.assign "e#{j}",coh_v2hash2[j]
            end
            if plottype == "boxplot"
                R.eval "boxplot(e1,e2,e3,e4,e5,e6,e7,e8,e9, main = \"#{variable.encode("windows-1252")}\", varwidth = TRUE, names = c(\"-52\",\"-57\",\"-62\",\"-67\",\"-72\",\"-77\",\"-82\",\"-87\",\"-92\"),cex.axis=0.75)"
            elsif plottype == "stripchart"
                R.eval "stripchart(list(e1,e2,e3,e4,e5,e6,e7,e8,e9), main = \"#{variable.encode("windows-1252")}\", group.names = c(\"-52\",\"-57\",\"-62\",\"-67\",\"-72\",\"-77\",\"-82\",\"-87\",\"-92\"), vertical = TRUE, method=\"jitter\", pch=15, col=rgb(0, 0, 0, 0.2), ylim = c(#{ylimrq1l[variable]}, #{ylimrq1u[variable]}))"
                R.eval "medians = c(median(e1),median(e2),median(e3),median(e4),median(e5),median(e6),median(e7),median(e8),median(e9))"
                R.eval "points(medians, pch=21, col = 'black', bg='orange')"
            end
	        R.eval "means = c(mean(e1),mean(e2),mean(e3),mean(e4),mean(e5),mean(e6),mean(e7),mean(e8),mean(e9)) "
            R.eval "points(means, pch=24, col='black', bg = 'green')"
            R.eval "ref = c(1,2,3,4,5,6,7,8,9)"
            kendall_medians = R.pull "cor.test(medians,ref,method='kendall')$estimate"
            kendall_means = R.pull "cor.test(means,ref,method='kendall')$estimate"
            STDERR.puts kendall_medians
            STDERR.puts kendall_means
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
    mode = "" #"_deviances"
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

        mad = [m_absolute_deviation(rq2["försöka"], avar_community["försöka"], "mean"), m_absolute_deviation(rq2["fortsätta"], avar_community["fortsätta"], "mean"), m_absolute_deviation(rq2["glömma"], avar_community["glömma"], "mean"), m_absolute_deviation(rq2["komma"], avar_community["komma"], "mean"), m_absolute_deviation(rq2["slippa"], avar_community["slippa"], "mean"), m_absolute_deviation(rq2["sluta"], avar_community["sluta"], "mean"), m_absolute_deviation(rq2["vägra"], avar_community["vägra"], "mean")]

        R.assign "mad", mad
        R.assign "medians", [median(rq2["försöka"]), median(rq2["fortsätta"]), median(rq2["glömma"]), median(rq2["komma"]), median(rq2["slippa"]), median(rq2["sluta"]), median(rq2["vägra"])]
        R.assign "means", [mean(rq2["försöka"]), mean(rq2["fortsätta"]), mean(rq2["glömma"]), mean(rq2["komma"]), mean(rq2["slippa"]), mean(rq2["sluta"]), mean(rq2["vägra"])]
        
    end
    
    

    if plottype == "boxplot"
        if part == "allverbs"
            R.eval "boxplot(list(d1,d2,d3,d4,d5,d6,d7), names = plotnames, varwidth = TRUE)" 
            R.eval "points(community, pch=21, col = 'black', bg=\"orange\")"
        end

    elsif plottype == "stripchart"
        if part == 1
            R.eval "stripchart(list(d1,d2,d3,d4), group.names = plotnames, jitter = 0.3, vertical = TRUE, method=\"jitter\")" #main = \"#{variable.encode("windows-1252")}\",
            R.eval "points(community, pch=15, col=\"orange\")"
        elsif part == 2
            R.eval "stripchart(list(d1,d2,d3), group.names = plotnames, jitter = 0.3, vertical = TRUE, method=\"jitter\")" 
            R.eval "points(community, pch=15, col=\"orange\")"
        elsif part == "allverbs"
            R.eval "stripchart(list(d1,d2,d3,d4,d5,d6,d7), group.names = plotnames, jitter = 0.3, vertical = TRUE, method=\"jitter\", pch=15, col=rgb(0, 0, 0, 0.2))" 

# median: orange circle
# macroave: green triangle up
# microave: blue diamond
# mad from median: yellow triange down
            
            R.eval "points(community, pch=23, col = 'black', bg=\"blue\")"
            R.eval "points(medians, pch=21, col = 'black', bg='orange')"
            R.eval "x <- 1:7"
            R.eval "arrows(x, community-mad/2, x, community+mad/2, col='red', lwd = 2, length=0.05, angle=90, code=3)"
            #R.eval "points(mad, pch=25, col = 'black', bg=\"yellow\")"
            R.eval "points(means, pch=24, col='black', bg = 'green')"
            #STDERR.puts mad.join(" ")
            variables.each do |variable|
                STDERR.puts "#{variable}\t#{(rq2[variable].count(1).to_f + rq2[variable].count(0).to_f)/rq2[variable].length}"
            end
        end
    end
    
    
    
    R.eval "dev.off()"
end


cohort_coherence = Hash.new{|hash, key| hash[key] = Array.new}

correl_what = ""


if plotrq3
    if plotrq3a
        o = File.open("coherence_t2_#{t2}_verbs#{variables3.length}.tsv","w:utf-8")
        o.puts "speaker\tyob\tcohort10\tcohort5\t#{variables3.join("\t")}\tcoherence"
    end
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
        #coherence = entropy([innovative / (innovative + conservative),conservative / (innovative + conservative)])
        coherence = (((2 * innovative ) / variables3.length) - 1).abs
        cohort_coherence[cohort] << coherence
        oline << "\t#{coherence}"
        if plotrq3a
            o.puts oline
        end
    end
    if plotrq3b
        plottype = "stripchart"
        R.eval "pdf(file='#{plottype}_rq3b_coherence_t2#{t2}_#{year}_verbs#{variables3.length}.pdf')"
   
        for i in 1..4 do 
            R.assign "d#{i}",cohort_coherence[i]
        end
            if plottype == "boxplot"
                R.eval "boxplot(d1,d2,d3,d4, varwidth = TRUE, names = c(\"47-62\",\"-72\",\"-82\",\"-92\"))"
            elsif plottype == "stripchart"
                R.eval "stripchart(list(d1,d2,d3,d4), group.names = c(\"47-62\",\"-72\",\"-82\",\"-92\"), vertical = TRUE, method=\"jitter\", pch=15, col=rgb(0, 0, 0, 0.2))"
                R.eval "points(c(median(d1),median(d2),median(d3),median(d4)), pch=21, col = 'black', bg='orange')"
            end
            R.eval "points(c(mean(d1),mean(d2),mean(d3),mean(d4)), pch=24, col='black', bg = 'green')"
            #R.eval "points(means, pch=24, col='black', bg = 'green')"
        R.eval "dev.off()"
    end
    if plotrq3c or plotrq3d
        method = "pearson"
        vectors = {}
        R.eval "df = data.frame(matrix(nrow = #{intersection.length}, ncol = 0))"
        variables3.each do |variable|
        
            vector = []
            intersection.each do |speaker|
                #arrayfordf[variable] << speaker_properties[variable][speaker][1]
                if correl_what == "relative"
                    vector << (speaker_properties[variable][speaker][1] - avar_community[variable])
                else
                    vector << speaker_properties[variable][speaker][1]
                end
                
            end
            vectors[variable] = vector
            R.assign "vector", vector
            STDERR.puts "#{variable} #{vector.join(",")}"
            R.eval "df['#{variable.encode("windows-1252")}'] = vector"
        end

    end
    if plotrq3c
        R.eval "library('GGally')"
        
        #STDERR.puts "Started 3c"
        #arrayfordf = Hash.new{|hash,key|hash[key] = Array.new}
        
        
        #STDERR.puts "Finished 3c"
        #R.eval "sink('rq3c.txt')"
        #STDERR.puts "calculating corr"
        #R.eval "cor(df,method = 'kendall')"
        #STDERR.puts "done"
        #R.eval "sink()"
        R.eval "pdf(file='rq3c_coherence_t2#{t2}_#{year}_verbs#{variables3.length}_#{method}#{correl_what}.pdf')"
        #R.eval "plot(df)"
        R.eval "ggpairs(df,upper = list(continuous = wrap('cor', method = '#{method}', stars = FALSE)),axisLabels = 'none')"
        R.eval "warnings()"
        R.eval "dev.off()"
    end
    
    if plotrq3d
        
    
        vardata = File.open("variable_stats.tsv","r:utf-8")
        freq = {}
        trend = {}
        sclass = {}
        vardata.each_line.with_index do |line,index|
            if index > 0
                line2 = line.strip.split("\t")
                variable = line2[0]
                if variables3.include?(variable)
                    freq[variable] = line2[3].to_f
                    trend[variable] = line2[4]
                    sclass[variable] = line2[5]
                end
            end
        end
        used_pairs = []
        dfreqs = []
        dtrends = []
        dclasses = []
        dinnovs = []
        taus = []
        variables3.each do |variable1|
            variables3.each do |variable2|
                if variable1 != variable2
                    pair = [variable1, variable2].sort
                    
                    if !used_pairs.include?(pair)
                        dfreq = (freq[variable1] - freq[variable2]).abs
                        if trend[variable1] == trend[variable2]
                            dtrend = 0
                        else
                            dtrend = 1
                        end
                        if sclass[variable1] == sclass[variable2]
                            dclass = 0
                        else
                            dclass = 1
                        end
                        dinnov = (avar_community[variable1] - avar_community[variable2]).abs
                        R.assign "v1", vectors[variable1]
                        R.assign "v2", vectors[variable2]
                        tau = R.pull "cor.test(v1,v2,method='#{method}')$estimate"
                        #STDERR.puts "#{pair.join("-")}\t#{dfreq}\t#{dtrend}\t#{dclass}\t#{dinnov}\t#{tau}"
                        dfreqs << dfreq
                        dtrends << dtrend
                        dclasses << dclass
                        dinnovs << dinnov
                        taus << tau
                        used_pairs << pair
                    end
                end
            end
        end
        R.assign "dfreqs", dfreqs
        R.assign "dtrends", dtrends
        R.assign "dclasses", dclasses
        R.assign "dinnovs", dinnovs
        R.assign "taus", taus
        STDERR.puts 1
        R.eval "print(summary(lm(taus ~ dfreqs * dtrends * dclasses * dinnovs)))" 
        STDERR.puts 2
        R.eval "print(summary(lm(taus ~ dfreqs + dtrends + dclasses + dinnovs)))" 
        STDERR.puts 3
        R.eval "print(summary(lm(taus ~ dfreqs + dtrends + dclasses)))" 
        STDERR.puts 4
        R.eval "print(summary(lm(taus ~ dfreqs + dtrends + dinnovs)))" 
        STDERR.puts 5
        R.eval "print(summary(lm(taus ~ dfreqs + dclasses + dinnovs)))" 
        STDERR.puts 6
        R.eval "print(summary(lm(taus ~ dtrends + dclasses + dinnovs)))" 
        STDERR.puts 7
        R.eval "print(summary(lm(taus ~ dtrends)))"
        STDERR.puts 8
        R.eval "print(summary(lm(taus ~ dfreqs)))"
        STDERR.puts 9
        R.eval "print(summary(lm(taus ~ dinnovs)))"
        STDERR.puts 10
        R.eval "print(summary(lm(taus ~ dclasses)))"
        STDERR.puts 11
        R.eval "print(summary(lm(taus ~ dfreqs * dtrends * dclasses)))" 
        STDERR.puts 12
        R.eval "print(summary(lm(taus ~ dfreqs * dtrends * dinnovs)))" 
        STDERR.puts 13
        R.eval "print(summary(lm(taus ~ dfreqs *  dclasses * dinnovs)))" 
        STDERR.puts 14
        R.eval "print(summary(lm(taus ~ dtrends * dclasses * dinnovs)))" 
        STDERR.puts 15
        R.eval "print(summary(lm(taus ~ dtrends * dinnovs)))" 
        STDERR.puts 16
        R.eval "print(summary(lm(taus ~ dtrends * dclasses)))" 
        STDERR.puts 17
        R.eval "print(summary(lm(taus ~ dclasses * dinnovs)))" 
    
    end
    
    
end
