
f = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-adoption_sentence_age100000.conllu","r:utf-8")

current_agebin = ""

prev_tokenc = ""
prev_pos = ""
prevprev_deprel = ""
prev_deprel = ""

agebinhash_v1 = Hash.new(0.0)
agebinhash_v2 = Hash.new(0.0)

f.each_line do |line|
    line1 = line.strip

    if line1 == ""
    elsif line1[0] == "#"
        if line1.include?("# agebin")
            current_agebin = line1.split(" = ")[1]
        end
    else
        line2 = line1.split("\t")
        id = line2[0]
        token = line2[1]
        tokenc = token.downcase
        lemma = line2[2]
        pos = line2[3]
        msd = line2[5]
        dephead = line2[6]
        deprel = line2[7]
        if (tokenc == "de" or tokenc == "dem") and (pos == "PN" or pos == "DT")
            agebinhash_v1[current_agebin] += 1
        elsif (tokenc == "dom") and (pos == "PN" or pos == "DT") and (prev_deprel != "DT" and prev_deprel != "AT")
            agebinhash_v2[current_agebin] += 1
        end
        prev_deprel = deprel.clone
    end
end

["<20","20--29","30--39","40--49","50--59",">60"].each do |agebin|
    STDOUT.puts "#{agebin}\t#{agebinhash_v1[agebin]}\t#{agebinhash_v2[agebin]}\t#{agebinhash_v1[agebin]+agebinhash_v2[agebin]}\t#{agebinhash_v2[agebin]/(agebinhash_v1[agebin]+agebinhash_v2[agebin])}"
end