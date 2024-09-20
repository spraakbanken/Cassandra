corpus = "familjeliv"
path = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\"

if corpus == "flashback"
    subforums = ["dator", "droger", "ekonomi", "flashback", "fordon", "hem", "kultur", "livsstil", "mat", "ovrigt", "politik", "resor", "samhalle", "sex", "sport", "vetenskap"]
    #subforums = ["resor"]
elsif corpus == "familjeliv"
    subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn","expert"]
end

usernames = {}
counter = 0
acounter = 0
subforums.each do |subforum|
    f = File.open("#{path}#{corpus}-#{subforum}_post.conllu","r:utf-8")
    o = File.open("#{path}#{corpus}-#{subforum}_post_anonymized.conllu","w:utf-8")
    current_user = ""
    post_id = ""
    
    STDERR.puts subforum
    
    cache = []
    f.each_line do |line|
        line1 = line.strip
        #line1 = line2.gsub("\n","")
        #if line1 != ""
        #if line1.include?("# post_id")
        #    post_id = line1.split(" = ")[1]
        if line1.include?("# username")
            current_user = line1.split(" = ")[1]
            if !current_user.nil?
                #if !current_user.nil?
                    if usernames[current_user].nil?
                        if corpus == "familjeliv" and current_user.downcase.include?("anonym")
                            acounter += 1
                            zeroes = "0000000"[acounter.to_s.length..-1]  
                            usernames[current_user] = "usera#{zeroes}#{acounter}"
                        else
                            counter += 1
                            zeroes = "00000000"[counter.to_s.length..-1]  
                            usernames[current_user] = "user#{zeroes}#{counter}"
                        end
                    end
                    o.puts cache
                    o.puts "# username = #{usernames[current_user]}"
                    cache = []
                #end
            else
                STDOUT.puts "Nil right part! #{subforum} #{post_id}"
                cache = []
                #abort
            end
        else
            if line1.include?("# post_id")
                post_id = line1.split(" = ")[1]
            end
            cache << line1
        end
        #end
    end
    o.puts ""
    o.close
    f.close
end

oo = File.open("#{path}#{corpus}_usernames.tsv","w:utf-8")
oo.puts "original\tanonymized"
usernames.each_pair do |key, value|
    oo.puts "#{key}\t#{value}"
end