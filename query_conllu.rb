variable = ARGV[0]
if variable.to_s == ""
    STDERR.puts "Specify variable!"
    exit
end
token_threshold = 10000
firstage = 18
total_threshold = ARGV[1].to_i
corpus = "flashback"

with_age = false
year_of_interest = 2009

#require_relative "queries\\#{variable}.rb"
require_relative "queries\\query_tools.rb"

#subforums = ["adoption"]
#subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn"]
subforum = ARGV[2]
subforums = [subforum]


#subforums = ["resor"]
#subforums = ["dator"]
#subforums = ["dator", "droger", "ekonomi", "flashback", "fordon", "hem", "kultur", "livsstil", "mat", "ovrigt", "politik", "resor", "samhalle", "sex", "sport", "vetenskap"]

#subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn","expert"]


if with_age
    #PATH = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
    #PATH = "D:\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
else
    #PATH = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\"
    PATH = "D:\\DGU\\CassandraMy\\SMCorpora\\"
end



agebinhash_v1 = Hash.new(0.0)
agebinhash_v2 = Hash.new(0.0)
agebinhash_v3 = Hash.new(0.0)
    
authorhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
authorhash_gen = {}
tokencounter = 0

authorhash_new = Hash.new{|hash,key| hash[key] = Hash.new{|hash1,key1| hash1[key1] = Hash.new(0.0)}}
#authorhash_hbtq = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
    

subforums.each do |subforum|
    STDERR.puts subforum
    if with_age
        f = File.open("#{PATH}familjeliv-#{subforum}_sentence_age#{token_threshold}_#{firstage}.conllu","r:utf-8")
    else
        f = File.open("#{PATH}#{corpus}-#{subforum}_sentence.conllu","r:utf-8")
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
            elsif line1.include?("# post_date")
                current_year = line1.split(" = ")[1].split("-")[0].to_i
            
                #authorhash[current_username] = true
            end
        else
            if (with_age and (current_year == year_of_interest and yob != 1970)) or !with_age
                tokencounter += 1
                line2 = line1.split("\t")
                id = line2[0]
                token = line2[1]
                tokenc = token.to_s.downcase
                lemma = line2[2][1..-2].split("|")
                pos = line2[3]
                msd = line2[5]
                dephead = line2[6]
                deprel = line2[7]
    
    
                condition = apply_criteria_hbtq2(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
#apply_criteria_kommer_att
#apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
                if condition == 1
                    if with_age
                        agebinhash_v1[current_agebin] += 1
                        authorhash[[current_username,current_age,current_agebin,current_year]]["v1"] += 1
                        authorhash[[current_username,current_age,current_agebin,current_year]]["total"] += 1
                    else
                        authorhash_new[current_year][current_username]["v1"] += 1
                        authorhash_new[current_year][current_username]["total"] += 1
                    end
                elsif condition == 2
                    if with_age
                        agebinhash_v2[current_agebin] += 1
                        authorhash[[current_username,current_age,current_agebin,current_year]]["v2"] += 1
                        authorhash[[current_username,current_age,current_agebin,current_year]]["total"] += 1
                    else
                        authorhash_new[current_year][current_username]["v2"] += 1
                        authorhash_new[current_year][current_username]["total"] += 1
                    end
                end
                prevprev_tokenc = prev_tokenc.clone
                prev_tokenc = tokenc.clone
                prevprev_pos = prev_pos.clone
                prev_pos = pos.clone
                prevprev_deprel = prev_deprel.clone
                prev_deprel = deprel.clone
            end
        end
    end


end

corpus2 = "#{corpus}-#{subforum}"

if with_age
    o = File.open("results\\familjeliv_#{variable}_t#{total_threshold}_#{year_of_interest}.tsv","w:utf-8")
    o.puts "period\tusername\tage\tagebin\ttotal\tv1abs\tv2abs\tv1rel\tv2rel"
else
    o = File.open("results\\#{corpus2}_#{variable}.tsv","w:utf-8")
    o.puts "period\tusername\ttotal\tv1abs\tv2abs\tv1rel\tv2rel"
end



nprolific = 0.0
sum_v2rel = 0.0

if with_age
    authorhash.each_pair do |key,value|
        year = key[3]
        username = key[0]
        age = key[1]
        #bin = key[2]
        total = value["total"]
        if total >= total_threshold
            nprolific += 1
            v1abs = value["v1"]
            v2abs = value["v2"]
            v3abs = value["v3"]
            v1rel = v1abs/total
            v2rel = v2abs/total
            sum_v2rel += v2rel
            v3rel = v3abs/total
            #o.puts "#{year}\t#{username}\t#{age}\t#{bin}\t#{total}\t#{v1abs}\t#{v2abs}\t#{v3abs}\t#{v1rel}\t#{v2rel}\t#{v3rel}"
            #o.puts "#{year}\t#{username}\t#{age}\t#{bin}\t#{total}\t#{v1abs}\t#{v2abs}\t#{v1rel}\t#{v2rel}"
            o.puts "#{year}\t#{username}\t#{age}\t\t#{total}\t#{v1abs}\t#{v2abs}\t#{v1rel}\t#{v2rel}"
        end
    
    end
    o.close
    
    STDERR.puts "#{variable} #prolific speakers: #{nprolific} Average v2rel: #{sum_v2rel/nprolific}"
    if nprolific >= 10 and sum_v2rel/nprolific >= 0.01 and  sum_v2rel/nprolific <= 0.90
        File.rename("results\\ss30_#{year_of_interest}\\familjeliv_#{variable}_t#{total_threshold}_#{year_of_interest}.tsv", "results\\ss30_#{year_of_interest}\\familjeliv_#{variable}_t#{total_threshold}_#{year_of_interest}_a.tsv")
    end
else
    authorhash_new.each_pair do |year,value|
        value.each_pair do |username,varhash|
            total = varhash["total"]
            v1abs = varhash["v1"]
            v2abs = varhash["v2"]
            v1rel = v1abs/total
            v2rel = v2abs/total
            o.puts "#{year}\t#{username}\t#{total}\t#{v1abs}\t#{v2abs}\t#{v1rel}\t#{v2rel}"
        end
    
    end
    o.close
    
end
