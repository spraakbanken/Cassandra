dir = "D:\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age"

filelist = Dir.children(dir)
ntokens = 0

filelist.each do |filename|
    f = File.open("#{dir}\\#{filename}", "r:utf-8")
    STDERR.puts filename
    f.each_line do |line|
        line1 = line.strip
        if line1 != "" 
            if line1[0] != "#"
                ntokens += 1
            end
        end
    end
    f.close
    STDERR.puts ntokens
end
#STDERR.puts ntokens

