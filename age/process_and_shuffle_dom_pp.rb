o = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\pp_de(m)_som_familjeliv_age.tsv","w:utf-8")
o.puts "unique_id\ttoken_id\tsentence\tmaincorpus\tsubcorpus\tyear\tspeaker\tage\tyob\tgeneration"
#subforums = ["kansliga"]

subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn","expert"]


subforums.each do |subforum|
    f = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-#{subforum}_sentence_age10000_18.conllu","r:utf-8")
    STDERR.puts subforum
    sentences = []
    sentence = []
    flag = false
    age = nil
    yob = nil
    speaker = nil
    post_year = nil
    generation = nil
    #subcorpus = nil
    sentence_counter = 0 
    tokens = []
    prev_tokenc = ""
    prev_pos = ""
    prevprev_pos = ""
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
                id = line1.split("\t")[0].to_i - 1
                token = line1.split("\t")[1]
                tokenc = token.downcase
                pos = line1.split("\t")[3]
                if (prevprev_pos == "PP") and (prev_pos == "PN" or prev_pos == "DT") and (prev_tokenc == "dem") and tokenc == "som"
                    flag = true
                    tokens << id
                end
                sentence << token
                prev_tokenc = tokenc.clone
                prevprev_pos = prev_pos.clone
                prev_pos = pos.clone
            end
            
            
        else
            if flag
                tokens.each do |token_id|
                    sentence_counter += 1
                #STDERR.puts sentence_counter
                    sentences << "#{sentence_counter}\t#{token_id}\t#{sentence.join(" ")}\tfamiljeliv\t#{subforum}\t#{post_year}\t#{speaker}\t#{age}\t#{yob}\t#{generation}"

#"#{speaker}\t#{post_year}\t#{age}\t#{yob}\t#{generation}\t}"
                #o.puts "#{speaker}\t#{post_year}\t#{age}\t#{yob}\t#{sentence.join(" ")}"
                end
                flag = false
                tokens = []
                
            end
            sentence = []
        end
    end
    
    sentences.shuffle!
    o.puts sentences
end