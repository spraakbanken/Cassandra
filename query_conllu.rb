
f = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-kansliga_sentence_age100000.conllu","r:utf-8")

current_agebin = ""

prev_tokenc = ""
prev_pos = ""
prevprev_deprel = ""
prev_deprel = ""

agebinhash_v1 = Hash.new(0.0)
agebinhash_v2 = Hash.new(0.0)
agebinhash_v3 = Hash.new(0.0)

authorhash = {}
tokencounter = 0

f.each_line do |line|
    line1 = line.strip

    if line1 == ""
    elsif line1[0] == "#"
        if line1.include?("# agebin")
            current_agebin = line1.split(" = ")[1]
        elsif line1.include?("# username")
            current_username = line1.split(" = ")[1]
            authorhash[current_username] = true
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
        #if (tokenc == "de" or tokenc == "dem") and (pos == "PN" or pos == "DT")
        #if (prev_tokenc == "de") and (prev_pos == "PN") and (prev_deprel == "SS" or prev_deprel == "FS" or prev_deprel == "ES") and tokenc != "som"
        if (prev_tokenc == "de") and (prev_pos == "PN") and (prev_deprel == "OO" or prev_deprel == "IO" or prev_deprel == "PA") and tokenc != "som"
            agebinhash_v1[current_agebin] += 1
        #elsif (tokenc == "dom") and (pos == "PN" or pos == "DT") and (prev_deprel != "DT" and prev_deprel != "AT")
        #elsif (prev_tokenc == "dem") and (prev_pos == "PN") and (prev_deprel == "SS" or prev_deprel == "FS" or prev_deprel == "ES") and tokenc != "som"
        elsif (prev_tokenc == "dem") and (prev_pos == "PN") and (prev_deprel == "OO" or prev_deprel == "IO" or prev_deprel == "PA") and tokenc != "som"
            agebinhash_v2[current_agebin] += 1
        #elsif (prevprev_deprel != "DT" and prevprev_deprel != "AT") and (prev_tokenc == "dom") and (prev_pos == "PN") and (prev_deprel == "SS" or prev_deprel == "FS" or prev_deprel == "ES") and tokenc != "som"
        elsif (prevprev_deprel != "DT" and prevprev_deprel != "AT") and (prev_tokenc == "dom") and (prev_pos == "PN") and (prev_deprel == "OO" or prev_deprel == "IO" or prev_deprel == "PA") and tokenc != "som"
            agebinhash_v3[current_agebin] += 1
        end
        prev_tokenc = tokenc.clone
        prev_pos = pos.clone
        prevprev_deprel = prev_deprel.clone
        prev_deprel = deprel.clone
    end
end

#STDOUT.puts "agebin\ttotal\tv1abs\tv2abs\tv1rel\tv2rel"
STDOUT.puts "agebin\ttotal\tv1abs\tv2abs\tv3abs\tv1rel\tv2rel\tv3rel"
["<20","20--29","30--39","40--49","50--59",">60"].each do |agebin|
    #total = agebinhash_v1[agebin]+agebinhash_v2[agebin]
    #STDOUT.puts "#{agebin}\t#{total}\t#{agebinhash_v1[agebin]}\t#{agebinhash_v2[agebin]}\t#{agebinhash_v1[agebin]/total}\t#{agebinhash_v2[agebin]/total}"
    total = agebinhash_v1[agebin]+agebinhash_v2[agebin]+agebinhash_v3[agebin]
    STDOUT.puts "#{agebin}\t#{total}\t#{agebinhash_v1[agebin]}\t#{agebinhash_v2[agebin]}\t#{agebinhash_v3[agebin]}\t#{agebinhash_v1[agebin]/total}\t#{agebinhash_v2[agebin]/total}\t#{agebinhash_v3[agebin]/total}"
    
end

o = File.open("kansliga100000authors.tsv","w:utf-8")
o.puts authorhash.keys
STDERR.puts tokencounter