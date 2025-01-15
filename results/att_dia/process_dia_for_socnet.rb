verblist = ["försöka", "fortsätta", "glömma", "komma", "slippa", "sluta", "vägra", "behaga", "lova", "planera", "riskera"]
total_threshold = 0

corpus = "familjeliv"
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



verblist.each do |verb|
    STDERR.puts verb
    
    o = File.open("#{corpus}-all_#{verb}_t#{total_threshold}.tsv","w:utf-8")
    o.puts "period	username	total	v1abs	v2abs	v1rel	v2rel"
    
    f = File.open("familjeliv_#{verb}_t#{total_threshold}.tsv","r:utf-8")
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            year = line2[0].to_i
            author = line2[1]
            an_author = userhash[author]
            total = line2[4].to_f
            #STDERR.puts year, author, total
            #sleep(1)
            v1abs = line2[5]
            v2abs = line2[6]
            v1rel = line2[7]
            v2rel = line2[-1]
            if total >= total_threshold
                o.puts "#{year}\t#{an_author}\t#{total}\t#{v1abs}\t#{v2abs}\t#{v1rel}\t#{v2rel}"
            end
        end
    end
    f.close
    o.close
    
end