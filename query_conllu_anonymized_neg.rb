
corpus = "familjeliv"

require_relative "queries\\query_tools.rb"

subforums = ["pappagrupp"]
#subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn"]
#subforum = ARGV[2]
#subforums = [subforum]

=begin
an_path = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\"
an_file = File.open("#{an_path}#{corpus}_usernames.tsv","r:utf-8")

"Reading in userhash..."
userhash = {}
an_file.each_line.with_index do |line,index|
    if index % 10000 == 0
        STDERR.puts index
    end
    if index > 0
        line2 = line.strip.split("\t")
        userhash[line2[0]] = line2[1]
    end
end
an_file.close
=end

PATH = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\"
#PATH = "D:\\D\\DGU\\CassandraMy\\SMCorpora\\"




cachethreshold = 10
missing_usernames = {}


subforums.each do |subforum|
    STDERR.puts subforum
    f = File.open("#{PATH}#{corpus}-#{subforum}_sentence.conllu","r:utf-8")
    o = File.open("#{corpus}-#{subforum}_vadmenardumed.conllu","w:utf-8") 
    prevprevprev_tokenc = ""
    prevprev_tokenc = ""
    prev_tokenc = ""
    prev_pos = ""
    prevprev_pos = ""
    prevprev_deprel = ""
    prev_deprel = ""
    
    cache = []
    #STDERR.puts "A", cache.nil?
    cachecounter = 0
    post_id = ""
    post_contents = []
    prev_post_id = ""
    outputflag = false

    f.each_line do |line|
        line1 = line.strip
        post_contents << line1
        #STDERR.puts "B", cache.nil?
        if line1 == "" #not necessary to reset all variables, but may be worth it for safety's sake
            prevprevprev_tokenc = ""
            prevprev_tokenc = ""
            prev_tokenc = ""
            prev_pos = ""
            prevprev_pos = ""
            prevprev_deprel = ""
            prev_deprel = ""
            
            
        elsif line1[0] == "#"
            #STDERR.puts "C", cache.nil?
            if line1.include?("# post_id")
                prev_post_id = post_id.clone
                post_id = line1.split(" = ")[1]
                if post_id != prev_post_id
                    #cachecounter += 1
                    cache << post_contents
                    post_contents = []
                    if outputflag
                        o.puts cache
                        outputflag = false
                        break
                    end
                end
                if cache.length > cachethreshold
                    #STDERR.puts cache.length
                    cache = cache[1..cachethreshold-1]
                end
            end
        else
            
            line2 = line1.split("\t")
            if line2.length == 5
                msd = line2[4]
            else
                msd = line2[5]
            end
			
            id = line2[0]
            token = line2[1]
            tokenc = token.to_s.downcase
            lemma = line2[2][1..-2].split("|")
            pos = line2[3]
            
            dephead = line2[6]
            deprel = line2[7]
			
			#if post_id == "61424883" and tokenc == "med"
            #    STDERR.puts tokenc, prev_tokenc, prevprev_tokenc, prevprevprev_tokenc
            #        if tokenc == "med" and prev_tokenc == "du" and prevprev_tokenc == "menar" and prevprevprev_tokenc == "vad"
            #            STDERR.puts "TRUE"
            #            condition = apply_criteria_vadmenardumed(tokenc, prev_tokenc, prevprev_tokenc, prevprevprev_tokenc, true)
            #        end

            #end
            condition = apply_criteria_vadmenardumed(tokenc, prev_tokenc, prevprev_tokenc, prevprevprev_tokenc, false)
			
            if condition == 1
                STDERR.puts "Hello!"
                outputflag = true
                STDERR.puts post_id
            end
            prevprevprev_tokenc = prevprev_tokenc.clone
            prevprev_tokenc = prev_tokenc.clone
            prev_tokenc = tokenc.clone
            prevprev_pos = prev_pos.clone
            prev_pos = pos.clone
            prevprev_deprel = prev_deprel.clone
            prev_deprel = deprel.clone
            
        end
    end
end

