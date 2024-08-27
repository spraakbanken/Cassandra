corpus = "flashback"
path = "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\results\\infravis\\"

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

"Anonymizing files..."
Dir.each_child(path) do |child|
    STDERR.puts child
    f = File.open("#{path}#{child}","r:utf-8")
    o = File.open("#{path[0..-2]}_anonymized\\#{child}","w:utf-8")
    
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            username = line2[1]
            replacement = userhash[username]
            line2[1] = replacement
            if !replacement.nil?
                o.puts line2.join("\t")
            else
                STDOUT.puts "#{username} not found in the file #{child}"
            end
        else
            o.puts line.strip
        end
    end

end
