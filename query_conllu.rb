PATH = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\"
subforum = "kansliga"
token_threshold = 10000
firstage = 20


f = File.open("#{PATH}familjeliv-#{subforum}_sentence_#{token_threshold}_firstage#{firstage}.conllu","r:utf-8")
variable = ARGV[0]
if variable.to_s == ""
    STDERR.puts "Specify variable!"
    halt
end

total_threshold = 10

current_age = ""
current_agebin = ""
current_username = ""
current_year = ""

prev_tokenc = ""
prev_pos = ""
prevprev_deprel = ""
prev_deprel = ""

agebinhash_v1 = Hash.new(0.0)
agebinhash_v2 = Hash.new(0.0)
agebinhash_v3 = Hash.new(0.0)

authorhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
authorhash_gen = {}
tokencounter = 0

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
            current_year = line1.split(" = ")[1].split("-")[0]
        
            #authorhash[current_username] = true
        end
    else
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
        if (tokenc == "de") and (pos == "PN" or pos == "DT")
        #if (prev_tokenc == "de") and (prev_pos == "PN") and (prev_deprel == "SS" or prev_deprel == "FS" or prev_deprel == "ES") and tokenc != "som"
        #if (prev_tokenc == "de") and (prev_pos == "PN") and (prev_deprel == "OO" or prev_deprel == "IO" or prev_deprel == "PA") and tokenc != "som"
            agebinhash_v1[current_agebin] += 1
            authorhash[[current_username,current_age,current_agebin,current_year]]["v1"] += 1
            authorhash[[current_username,current_age,current_agebin,current_year]]["total"] += 1
        elsif (tokenc == "dem") and (pos == "PN" or pos == "DT")
        #elsif (prev_tokenc == "dem") and (prev_pos == "PN") and (prev_deprel == "SS" or prev_deprel == "FS" or prev_deprel == "ES") and tokenc != "som"
        #elsif (prev_tokenc == "dem") and (prev_pos == "PN") and (prev_deprel == "OO" or prev_deprel == "IO" or prev_deprel == "PA") and tokenc != "som"
            agebinhash_v2[current_agebin] += 1
            authorhash[[current_username,current_age,current_agebin,current_year]]["v2"] += 1
            authorhash[[current_username,current_age,current_agebin,current_year]]["total"] += 1
        elsif (tokenc == "dom") and (pos == "PN" or pos == "DT") and (prev_deprel != "DT" and prev_deprel != "AT")
        #elsif (prevprev_deprel != "DT" and prevprev_deprel != "AT") and (prev_tokenc == "dom") and (prev_pos == "PN") and (prev_deprel == "SS" or prev_deprel == "FS" or prev_deprel == "ES") and tokenc != "som"
        #elsif (prevprev_deprel != "DT" and prevprev_deprel != "AT") and (prev_tokenc == "dom") and (prev_pos == "PN") and (prev_deprel == "OO" or prev_deprel == "IO" or prev_deprel == "PA") and tokenc != "som"
            agebinhash_v3[current_agebin] += 1
            authorhash[[current_username,current_age,current_agebin,current_year]]["v3"] += 1
            authorhash[[current_username,current_age,current_agebin,current_year]]["total"] += 1
        end
        prev_tokenc = tokenc.clone
        prev_pos = pos.clone
        prevprev_deprel = prev_deprel.clone
        prev_deprel = deprel.clone
    end
end


o = File.open("familjeliv-#{subforum}_sentence_#{token_threshold}_firstage#{firstage}_#{variable}.tsv","w:utf-8")

o.puts "post_year\tusername\tage\tagebin\ttotal\tv1abs\tv2abs\tv3abs\tv1rel\tv2rel\tv3rel"

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
        o.puts "#{year}\t#{username}\t#{age}\t#{bin}\t#{total}\t#{v1abs}\t#{v2abs}\t#{v3abs}\t#{v1rel}\t#{v2rel}\t#{v3rel}"
    end

end

__END__
STDOUT.puts "agebin\ttotal\tv1abs\tv2abs\tv3abs\tv1rel\tv2rel\tv3rel"
["<20","20--29","30--39","40--49","50--59",">60"].each do |agebin|
    #total = agebinhash_v1[agebin]+agebinhash_v2[agebin]
    #STDOUT.puts "#{agebin}\t#{total}\t#{agebinhash_v1[agebin]}\t#{agebinhash_v2[agebin]}\t#{agebinhash_v1[agebin]/total}\t#{agebinhash_v2[agebin]/total}"
    total = agebinhash_v1[agebin]+agebinhash_v2[agebin]+agebinhash_v3[agebin]
    STDOUT.puts "#{agebin}\t#{total}\t#{agebinhash_v1[agebin]}\t#{agebinhash_v2[agebin]}\t#{agebinhash_v3[agebin]}\t#{agebinhash_v1[agebin]/total}\t#{agebinhash_v2[agebin]/total}\t#{agebinhash_v3[agebin]/total}"
    
end

#o = File.open("kansliga100000authors.tsv","w:utf-8")
#o.puts authorhash.keys
STDERR.puts tokencounter