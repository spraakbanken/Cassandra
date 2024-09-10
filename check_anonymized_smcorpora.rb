corpus = "flashback"
path = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\"

if corpus == "flashback"
    subforums = ["dator", "droger", "ekonomi", "flashback", "fordon", "hem", "kultur", "livsstil", "mat", "ovrigt", "politik", "resor", "samhalle", "sex", "sport", "vetenskap"]
    subforums = ["resor"]
elsif corpus == "familjeliv"
    subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn","expert"]
end

usernames = {}
counter = 0
acounter = 0
subforums.each do |subforum|
    f = File.open("#{path}#{corpus}-#{subforum}_post_anonymized.conllu","r:utf-8")
    #o = File.open("#{path}#{corpus}-#{subforum}_post_anonymized.conllu","w:utf-8")
    current_user = ""
    post_id = ""
    STDERR.puts subforum
    

    flag = false
    f.each_line do |line|
        line1 = line.strip
        #if line1 != ""
        
        if line1.include?("post_date")
            flag =  true
        elsif line1.include?("# post_id")
            post_id = line1.split(" = ")[1]
        elsif line1.include?("# username")
            if line1.split(" = ")[1].nil? or line1.split(" = ")[1] == ""
                STDERR.puts "fdsfsf", post_id
                abort
            end
            flag = false
        else
            if flag
                STDERR.puts "aa", post_id
                abort
            end
            
            
        end
        #end
    end
    f.close
end