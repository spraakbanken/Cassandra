#incorporate standard tools
corpus = ARGV[0]
maincorpus = corpus.split("-")[0]
subcorpus = corpus.split("-")[1] #Won't work for single subcorpora
if ARGV[3].to_s != ""
   subcorpus = corpus.split("-")[1..-1].join("-")
end
variable = ARGV[1]
type = ARGV[2]
subforumtype = ARGV[3] #"single" if not using a label

#type = ""
addendum = ""
if type == "age"
    addendum = "_age_edited"
    threshold2 = 10
    years = (2003..2021).to_a
    filehash = {}
    years.each do |year|
        filehash[year] = File.open("variables\\#{variable}\\age_corr\\#{corpus}_#{year}.tsv", "w:utf-8")
        filehash[year].puts "author\tbirthyear\tv2rel"
    end
    
end


f = File.open("authors\\#{maincorpus}\\#{subcorpus}#{addendum}.tsv", "r:utf-8")
usercounter = 0

f.each_line.with_index do |line, index|
    if index > 0 
        line1 = line.strip.split("\t")
        nickname = line1[0]
        
        if !nickname.include?("Anonym") 
            usercounter += 1
            nickname2 = nickname.gsub(" ","+%+")
            
            STDERR.puts nickname2
            
          
            if type == "age"
                birthyear = line1[2]
                if !File.exist?("variables\\#{variable}\\#{maincorpus}\\#{subcorpus}\\#{nickname2}.tsv")
                    #system("ruby korp4b.rb time #{maincorpus}-#{subcorpus} #{variable} #{nickname2}")
                    system("ruby korp10.rb --qtype time --corpus #{maincorpus}-#{subcorpus} --variable #{variable} --user #{nickname2}")
                end
                indfile = File.open("variables\\#{variable}\\#{maincorpus}\\#{subcorpus}\\#{nickname2}.tsv")
                indfile.each_line.with_index do |iline, iindex|
                    if iindex > 0
                        iline2 = iline.strip.split("\t")
                        if iline2[1].to_i > threshold2 and iline2[0].to_i <= 2021
                            filehash[iline2[0].to_i].puts "#{nickname}\t#{birthyear}\t#{iline2[5]}"
                            #STDERR.puts iline2[0]
                            #STDERR.puts "#{nickname}\t#{birthyear}\t#{iline2[5]}"
                        end
                    end
                end
                indfile.close
            else
                if !File.exist?("variables\\#{variable}\\#{maincorpus}\\#{subcorpus}\\#{nickname2}.tsv")
                    system("ruby korp10b.rb --qtype time --corpus #{maincorpus}-#{subcorpus} --variable #{variable} --user #{nickname2}")
                end
            end
            
            if usercounter >= 300 and type != "age"
                break
            end
        end
    end
end