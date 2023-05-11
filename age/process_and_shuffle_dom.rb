o = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv_sentence_10000_18_dem.tsv","w:utf-8")
o.puts "speaker\tpost_year\tage\tyob\tgeneration\tsentence"


subforums.each do |subforum|
    f = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-#{subforum}_sentence_age10000_18.conllu","r:utf-8")
    sentences = []
    sentence = []
    flag = false
    age = nil
    yob = nil
    speaker = nil
    post_year = nil
    generation = nil
    sentence_counter = 0
    f.each_line do |line|
        line1 = line.strip
        if line1 != ""
            #sentence << line1
            if line1[0] == "#"
                if line1.include?("# age = ")
                    age = line1.split(" = ")[1]
                elsif line1.include?("# yob = ")
                    yob = line1.split(" = ")[1]
                elsif line1.include?("# post_date = ")
                    post_year = line1.split(" = ")[1].split("-")[0]
                elsif line1.include?("# username = ")
                    speaker = line1.split(" = ")[1]
                elsif line1.include?("# agebin = ")
                    generation = line1.split(" = ")[1]
                end
    
            else
                token = line1.split("\t")[1]
                if token.downcase == "de" or token == "dem"
                    flag = true
                end
                sentence << token
            end
            
            
        else
            if flag
                sentence_counter += 1
                STDERR.puts sentence_counter
                sentences << "#{speaker}\t#{post_year}\t#{age}\t#{yob}\t#{generation}\t#{sentence.join(" ")}"
                #o.puts "#{speaker}\t#{post_year}\t#{age}\t#{yob}\t#{sentence.join(" ")}"
                flag = false
            end
            sentence = []
        end
    end
    
    sentences.shuffle!
    o.puts sentences
end