variable = ARGV[0]
if variable.to_s == ""
    STDERR.puts "Specify variable!"
    exit
end

year_of_interest = 2009

require_relative "queries\\#{variable}.rb"

#subforums = ["kansliga"]
subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn","expert"]


#PATH = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\"
PATH = "D:\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
#subforum = "kansliga"
token_threshold = 10000
firstage = 18
total_threshold = ARGV[1].to_i


agebinhash_v1 = Hash.new(0.0)
agebinhash_v2 = Hash.new(0.0)
agebinhash_v3 = Hash.new(0.0)
    
authorhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
authorhash_gen = {}
tokencounter = 0
    

subforums.each do |subforum|
    STDERR.puts subforum
    f = File.open("#{PATH}familjeliv-#{subforum}_sentence_age#{token_threshold}_#{firstage}.conllu","r:utf-8")
    
    current_age = ""
    current_agebin = ""
    current_username = ""
    current_year = ""
    
    prevprev_tokenc = ""
    prev_tokenc = ""
    prev_pos = ""
    prevprev_pos = ""
    prevprev_deprel = ""
    prev_deprel = ""
    
    
    f.each_line do |line|
        line1 = line.strip
    
        if line1 == ""
        elsif line1[0] == "#"
            if line1.include?("# agebin")
                current_agebin = line1.split(" = ")[1]
            elsif line1.include?("# age")
                current_age = line1.split(" = ")[1]
            elsif line1.include?("# username")
                current_username = line1.split(" = ")[1]
            elsif line1.include?("# post_date")
                current_year = line1.split(" = ")[1].split("-")[0].to_i
            
                #authorhash[current_username] = true
            end
        else
            if current_year == year_of_interest
                tokencounter += 1
                line2 = line1.split("\t")
                id = line2[0]
                token = line2[1]
                tokenc = token.downcase
                lemma = line2[2]
                pos = line2[3]
                msd = line2[5]
                dephead = line2[6]
                deprel = line2[7]
    
    
                condition = apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
                if condition == 1
                    agebinhash_v1[current_agebin] += 1
                    authorhash[[current_username,current_age,current_agebin,current_year]]["v1"] += 1
                    authorhash[[current_username,current_age,current_agebin,current_year]]["total"] += 1
                elsif condition == 2
                    agebinhash_v2[current_agebin] += 1
                    authorhash[[current_username,current_age,current_agebin,current_year]]["v2"] += 1
                    authorhash[[current_username,current_age,current_agebin,current_year]]["total"] += 1
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

o = File.open("results\\familjeliv_#{variable}_t#{total_threshold}_#{year_of_interest}.tsv","w:utf-8")

o.puts "period\tusername\tage\tagebin\ttotal\tv1abs\tv2abs\tv1rel\tv2rel"

authorhash.each_pair do |key,value|
    year = key[3]
    username = key[0]
    age = key[1]
    bin = key[2]
    total = value["total"]
    if total >= total_threshold
        v1abs = value["v1"]
        v2abs = value["v2"]
        v3abs = value["v3"]
        v1rel = v1abs/total
        v2rel = v2abs/total
        v3rel = v3abs/total
        #o.puts "#{year}\t#{username}\t#{age}\t#{bin}\t#{total}\t#{v1abs}\t#{v2abs}\t#{v3abs}\t#{v1rel}\t#{v2rel}\t#{v3rel}"
        o.puts "#{year}\t#{username}\t#{age}\t#{bin}\t#{total}\t#{v1abs}\t#{v2abs}\t#{v1rel}\t#{v2rel}"
    end

end