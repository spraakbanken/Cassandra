dirs = Dir.children("C:\\D\\DGU\\Repos\\Cassandra\\variables\\att2026kommer")
#STDERR.puts "#{dirs}"

totals = Hash.new(0)
v2abss = Hash.new(0)

dirs.each do |dir|
    if dir != "SVT" and dir != "kubhist2"
        f = File.open("C:\\D\\DGU\\Repos\\Cassandra\\variables\\att2026kommer\\#{dir}\\all_users.tsv","r:utf-8")
        f.each_line.with_index do |line,index|
            if index > 0
                line2 = line.strip.split("\t")
                year = line2[0].to_i
                total = line2[1].to_i
                v2abs = line2[3].to_i
                totals[year] += total
                v2abss[year] += v2abs
            end
         
        end
        
    end
end


o = File.open("att2026kommer.tsv","w:utf-8")
o.puts "year\ttotal\tv2abs\tv2rel"
totals.keys.sort.each do |year|
    o.puts "#{year}\t#{totals[year]}\t#{v2abss[year]}\t#{v2abss[year].to_f/totals[year]}"
end