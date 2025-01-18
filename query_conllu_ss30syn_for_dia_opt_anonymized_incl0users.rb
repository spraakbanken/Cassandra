#year_of_interest = 2009
#years_of_interest = [ARGV[0].to_i]
#require_relative "queries\\#{variable}.rb"
require_relative "queries\\query_tools.rb"

#subforums = ["adoption"]
subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn","expert"]
an_path = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\"
corpus = "familjeliv"
an_file = File.open("#{an_path}#{corpus}_usernames.tsv","r:utf-8")

"Reading in userhash..."
userhash = {}
an_file.each_line.with_index do |line,index|
    if index % 10000 == 0
        STDERR.puts index
    end
    if index > 0
        line2 = line.strip.split("\t")
        userhash[line2[0]] = line2[1]
    end
end
an_file.close

with_age = false
if with_age
    PATH = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
    #PATH = "D:\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
else
    PATH = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
    #PATH = "D:\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
end
token_threshold = 10000
firstage = 18
total_threshold = 0


#agebinhash_v1 = Hash.new(0.0)
#agebinhash_v2 = Hash.new(0.0)
#agebinhash_v3 = Hash.new(0.0)
    
authorhash = {}

for year in 2003..2022 do 
    authorhash[year] = Hash.new{|hash,key| hash[key] = Hash.new{|hash1,key1| hash1[key1] = Hash.new(0.0)}}
end

#authorhash_gen = {}
tokencounter = 0
    
#verblist = ["komma","anse"]
#verblist = ["komma", "anse", "avse", "behaga", "behöva", "besluta", "bruka", "börja", "fortsätta", "förefalla", "förmå", "försöka", "glömma", "hinna", "hota", "idas", "lova", "lyckas", "låtsas", "orka", "planera", "riskera", "råka", "slippa", "sluta", "tendera", "våga", "vägra", "ämna", "önska"]


verblist = ["försöka", "fortsätta", "glömma", "komma", "slippa", "sluta", "vägra", "behaga", "lova", "planera", "riskera"]

    

#verblist.each do |verb_of_interest|
#    STDERR.puts "#{years_of_interest} #{verb_of_interest}"
    #require_relative "queries\\#{variable}.rb"
    
    
    #subforums = ["kansliga"]
    
    
    #agebinhash_v1 = Hash.new(0.0)
    #agebinhash_v2 = Hash.new(0.0)
    #agebinhash_v3 = Hash.new(0.0)
    #yearhash = Hash.new(0.0)
    #yearhash_v2 = Hash.new(0.0)
        
    #authorhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
    #authorhash_gen = {}
    #tokencounter = 0
    
subforums.each do |subforum|
    STDERR.puts "#{subforum}"
    if with_age
        f = File.open("#{PATH}familjeliv-#{subforum}_sentence_age#{token_threshold}_#{firstage}.conllu","r:utf-8")
    else
        f = File.open("#{PATH}#{corpus]}-#{subforum}_sentence.conllu","r:utf-8")
    end
    
    current_age = ""
    current_agebin = ""
    current_username = ""
    current_year = ""
    yob = ""
    
    prevprev_tokenc = ""
    prev_tokenc = ""
    prev_pos = ""
    prevprev_pos = ""
    prevprev_deprel = ""
    prev_deprel = ""
    prev_lemma = []
    prevprev_lemma = []
    prevprevprev_lemma = []

    prev_msd = ""
    prevprev_msd = ""
    prevprevprev_msd = ""

    
    f.each_line do |line|
        line1 = line.strip
    
        if line1 == "" #not necessary to reset all variables, but may be worth it for safety's sake
            current_age = ""
            current_agebin = ""
            current_username = ""
            current_year = ""
            yob = ""
            prevprev_tokenc = ""
            prev_tokenc = ""
            prev_pos = ""
            prevprev_pos = ""
            prevprev_deprel = ""
            prev_deprel = ""
        elsif line1[0] == "#"
            if line1.include?("# agebin")
                current_agebin = line1.split(" = ")[1]
            elsif line1.include?("# age")
                current_age = line1.split(" = ")[1]
            elsif line1.include?("# yob")
                yob = line1.split(" = ")[1].to_i
            elsif line1.include?("# username")
                current_username = line1.split(" = ")[1]
                current_username = userhash[current_username]
                verblist.each do |verb_of_interest|
                    authorhash[current_year][verb_of_interest][[current_username,yob]]["total"] = authorhash[current_year][verb_of_interest][[current_username,yob]]["total"]
                end
            elsif line1.include?("# post_date")
                current_year = line1.split(" = ")[1].split("-")[0].to_i
            
                #authorhash[current_username] = true
            end
        else
            if yob != 1970 #and years_of_interest.include?(current_year)
                tokencounter += 1
                line2 = line1.split("\t")
                id = line2[0]
                token = line2[1]
                tokenc = token.downcase
                lemma = line2[2][1..-2].split("|")
                pos = line2[3]
                msd = line2[5]
                dephead = line2[6]
                deprel = line2[7]
                verblist.each do |verb_of_interest|
                    condition = apply_criteria_ss30(tokenc, lemma, prev_lemma, prevprev_lemma, prevprevprev_lemma, pos, msd, prev_msd, prevprev_msd, prevprevprev_msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel, verb_of_interest)
                        if condition == 1
                            #yearhash[current_year] += 1
                            #agebinhash_v1[current_agebin] += 1
                            authorhash[current_year][verb_of_interest][[current_username,yob]]["v1"] += 1
                            authorhash[current_year][verb_of_interest][[current_username,yob]]["total"] += 1
                        elsif condition == 2
                            #yearhash_v2[current_year] += 1
                            #yearhash[current_year] += 1
                            #agebinhash_v2[current_agebin] += 1
                            authorhash[current_year][verb_of_interest][[current_username,yob]]["v2"] += 1
                            authorhash[current_year][verb_of_interest][[current_username,yob]]["total"] += 1
                        end
                end
                prevprev_tokenc = prev_tokenc.clone
                prev_tokenc = tokenc.clone
                prevprev_pos = prev_pos.clone
                prev_pos = pos.clone
                prevprev_deprel = prev_deprel.clone
                prev_deprel = deprel.clone
                prevprevprev_lemma = prevprev_lemma.clone
                prevprev_lemma = prev_lemma.clone
                prev_lemma = lemma.clone
                prevprevprev_msd = prevprev_msd.clone
                prevprev_msd = prev_msd.clone
                prev_msd = msd.clone


            end
        end
    end


end

STDERR.puts "Printing results..."

nprolific = 0.0
sum_v2rel = 0.0
totaltotal = 0.0
totaltotal_all = 0.0
v2abstotal = 0.0
v2abstotal_all = 0.0
nspeakers = authorhash.keys.length

if with_age
    outdir = "att_dia2"
else
    outdir = "att_dia2_all"
end

for year in 2003..2022 do 
    #oo = File.open("results\\att_dia\\summary_#{year}_t#{total_threshold}.tsv","w:utf-8")
    #oo.puts "verb\tnprolific_speakers\ttotal_prolific\tmicroave_v2rel_prolific\tnspeakers\ttotal\tmicroave_v2rel" 
    

    yearhash = authorhash[year]
    yearhash.each_pair do |verb,verbhash|
        o = File.open("results\\#{outdir}\\familjeliv_#{verb}_t#{total_threshold}.tsv","a:utf-8")
        if year == 2003
            if with_age
                o.puts "period\tusername\tyob\tagebin\ttotal\tv1abs\tv2abs\tv1rel\tv2rel"
            else
                o.puts "period\tusername\ttotal\tv1abs\tv2abs\tv1rel\tv2rel"
            end
        end

        verbhash.each_pair do |key,value|
            username = key[0]
            yob = key[1]
            
            total = value["total"]
            v2abs = value["v2"]
            if total >= total_threshold
                nprolific += 1
                v1abs = value["v1"]
                v1rel = div_by_zero_marked(v1abs,total)
                v2rel = div_by_zero_marked(v2abs,total)
                if with_age
                    o.puts "#{year}\t#{username}\t#{yob}\t\t#{total}\t#{v1abs}\t#{v2abs}\t#{v1rel}\t#{v2rel}"
                else
                    o.puts "#{year}\t#{username}\t#{total}\t#{v1abs}\t#{v2abs}\t#{v1rel}\t#{v2rel}"
                end
                #totaltotal += total
                #v2abstotal += v2abs
            end
            #totaltotal_all += total
            #v2abstotal_all += v2abs
        end
        o.close
    end
end

STDERR.puts tokencounter

#o.close

#oo.puts "#{verb_of_interest}\t#{nprolific}\t#{totaltotal}\t#{v2abstotal/totaltotal}\t#{nspeakers}\t#{totaltotal_all}\t#{v2abstotal_all/totaltotal_all}"
#if nprolific >= 10 and sum_v2rel/nprolific >= 0.01 and  sum_v2rel/nprolific <= 0.90
#    File.rename("results\\ss30_#{year_of_interest}\\familjeliv_#{variable}_t#{total_threshold}_#{year_of_interest}.tsv", "results\\ss30_#{year_of_interest}\\familjeliv_#{variable}_t#{total_threshold}_#{year_of_interest}_a.tsv")
#end

#end