o = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\de(m)_filtered_familjeliv_age.tsv","w:utf-8")
o.puts "unique_id\ttoken_id\tsentence\tmaincorpus\tsubcorpus" #\tyear\tspeaker\tage\tyob\tgeneration"
#subforums = ["pappagrupp"]

subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn","expert", "medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn","expert","gravid","kansliga"]


subforums.each do |subforum|
    f = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-#{subforum}_sentence_age10000_18.conllu","r:utf-8")
    STDERR.puts subforum
    sentences = []
    sentence = []
    flag = false
    #age = nil
    #yob = nil
    #speaker = nil
    post_year = nil
    #generation = nil
    #subcorpus = nil
    sentence_counter = 0 
    tokens = []
    f.each_line do |line|
        line1 = line.strip
        if line1 != ""
            #sentence << line1
            if line1[0] == "#"
                
            else
                id = line1.split("\t")[0]
                token = line1.split("\t")[1]
                pos = line1.split("\t")[3]
                if (token.downcase == "de" or token == "dem") and (pos == "PN" or pos == "DT")
                    flag = true
                end
                sentence << token
                tokens << id
            end
            
            
        else
            if flag
                tokens.each do |token_id|
                    sentence_counter += 1
                #STDERR.puts sentence_counter
                    sentences << "#{sentence_counter}\t#{token_id}\t#{sentence.join(" ")}\tfamiljeliv\t#{subforum}"#\t#{post_year}\t#{speaker}\t#{age}\t#{yob}\t#{generation}"

#"#{speaker}\t#{post_year}\t#{age}\t#{yob}\t#{generation}\t}"
                #o.puts "#{speaker}\t#{post_year}\t#{age}\t#{yob}\t#{sentence.join(" ")}"
                end
                flag = false
                tokens = []
                
            end
            sentence = []

            if sentences.length % 10000 == 0 and sentences.length > 0
                 sentences.shuffle!
                 o.puts sentences
                 sentences = []
            end
        end
    end    
end