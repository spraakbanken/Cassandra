#year_of_interest = 2009
years_of_interest = [2008, 2009, 2010]
#require_relative "queries\\#{variable}.rb"
require_relative "queries\\query_tools.rb"

#subforums = ["adoption"]
subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn","expert"]


PATH = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
#PATH = "D:\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
token_threshold = 10000
firstage = 18
total_threshold = 10


agebinhash_v1 = Hash.new(0.0)
agebinhash_v2 = Hash.new(0.0)
agebinhash_v3 = Hash.new(0.0)
    
authorhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
authorhash_gen = {}
tokencounter = 0
    
#verblist = ["komma","anse"]
#verblist = ["komma", "anse", "avse", "behaga", "behöva", "besluta", "bruka", "börja", "fortsätta", "förefalla", "förmå", "försöka", "glömma", "hinna", "hota", "idas", "lova", "lyckas", "låtsas", "orka", "planera", "riskera", "råka", "slippa", "sluta", "tendera", "våga", "vägra", "ämna", "önska"]
verblist = ["försöka", "fortsätta", "glömma", "komma", "slippa", "sluta", "vägra", "anse", "behaga", "lova", "planera", "riskera"]

oo = File.open("results\\ss30_#{years_of_interest.join(",")}\\summary_t#{total_threshold}_temp.tsv","w:utf-8")
oo.puts "verb\tnspeakers" 
    

verblist.each do |verb_of_interest|
    STDERR.puts verb_of_interest
    #require_relative "queries\\#{variable}.rb"
    
    
    #subforums = ["kansliga"]
    
    
    agebinhash_v1 = Hash.new(0.0)
    agebinhash_v2 = Hash.new(0.0)
    agebinhash_v3 = Hash.new(0.0)
    yearhash = Hash.new(0.0)
    yearhash_v2 = Hash.new(0.0)
        
    authorhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
    #authorhash_gen = {}
    tokencounter = 0
    
    subforums.each do |subforum|
        STDERR.puts subforum
        f = File.open("#{PATH}familjeliv-#{subforum}_sentence_age#{token_threshold}_#{firstage}.conllu","r:utf-8")
        
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
                elsif line1.include?("# post_date")
                    current_year = line1.split(" = ")[1].split("-")[0].to_i
                
                    #authorhash[current_username] = true
                end
            else
                if yob != 1970 and years_of_interest.include?(current_year)
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
                    condition = apply_criteria_ss30(tokenc, lemma, prev_lemma, prevprev_lemma, prevprevprev_lemma, pos, msd, prev_msd, prevprev_msd, prevprevprev_msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel, verb_of_interest)
                    if condition == 1
                        #yearhash[current_year] += 1
                        #agebinhash_v1[current_agebin] += 1
                        authorhash[[current_username,yob]]["v1"] += 1
                        authorhash[[current_username,yob]]["total"] += 1
                    elsif condition == 2
                        #yearhash_v2[current_year] += 1
                        #yearhash[current_year] += 1
                        #agebinhash_v2[current_agebin] += 1
                        authorhash[[current_username,yob]]["v2"] += 1
                        authorhash[[current_username,yob]]["total"] += 1
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
    
    #o = File.open("results\\ss30_#{years_of_interest.join(",")}\\familjeliv_#{verb_of_interest}_t#{total_threshold}_#{years_of_interest.join(",")}.tsv","w:utf-8")
    
    #o.puts "period\tusername\tyob\tagebin\ttotal\tv1abs\tv2abs\tv1rel\tv2rel"
    
    nspeakers = authorhash.keys.length
    
    oo.puts "#{verb_of_interest}\t#{nspeakers}"
    #if nprolific >= 10 and sum_v2rel/nprolific >= 0.01 and  sum_v2rel/nprolific <= 0.90
    #    File.rename("results\\ss30_#{year_of_interest}\\familjeliv_#{variable}_t#{total_threshold}_#{year_of_interest}.tsv", "results\\ss30_#{year_of_interest}\\familjeliv_#{variable}_t#{total_threshold}_#{year_of_interest}_a.tsv")
    #end

end