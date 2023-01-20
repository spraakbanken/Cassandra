#Restart from the beginning to MissLilo
#merge all and all2, rerun on all that were not in all2

corpus = ARGV[0]
maincorpus = corpus.split("-")[0]
subcorpus = corpus.split("-")[1..-1].join("-")
require 'open-uri'

f = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\KorpApi\\authors\\#{maincorpus}\\#{subcorpus}temp.tsv", "r:utf-8")
threshold = 1000
o = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\KorpApi\\authors\\#{maincorpus}\\#{subcorpus}_age_#{threshold}.tsv", "w:utf-8")
o.puts "author\tntokens\tyear_of_birth"


f.each_line.with_index do |line, index|
    if index > 0 
        line1 = line.strip.split("\t")
        nickname = line1[0]
        ntokens = line1[1].to_i
        if ntokens < threshold
            break
        end
        if !nickname.include?("Anonym") and !nickname.include?("/")
            STDERR.puts nickname
            nickname2 = nickname.gsub(" ","_")
            nickname2 = nickname2.gsub("ä","a")
            nickname2 = nickname2.gsub("å","a")
            nickname2 = nickname2.gsub("ö","o")
            nickname2 = nickname2.gsub("Ä","A")
            nickname2 = nickname2.gsub("Å","A")
            nickname2 = nickname2.gsub("Ö","O")


            file = open(URI.escape("https://www.familjeliv.se/user/presentation/view/#{nickname2}"))
            
            birthyear = "unknown"
            flag1 = false
            flag2 = false
            file.each_line do |line|
                line1 = line.strip
                if flag2
                    birthyear = 2021 - line1.split(" ")[0].to_i
                    break
                end
            
                if flag1 and line1 == "<div class=\"inner clearfix\">"
                    flag2 = true
                end
                if line1 == "<h3>Ålder</h3>"
                    flag1 = true
                end
            
            end
            
            if birthyear != "unknown"
                o.puts "#{nickname}\t#{ntokens}\t#{birthyear}"
            end

            #STDERR.puts nickname2
            
            
        end
    end
end