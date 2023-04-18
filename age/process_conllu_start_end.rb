f = File.open("C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\age\\all_age_1000_merged.tsv","r:utf-8")
agehash = {}
threshold = 10000
age_threshold = 0
firstlasthash = Hash.new{|hash,key| hash[key] = [100,0]}




f.each_line.with_index do |line,index|
    line1 = line.strip.split("\t")
    if index > 0 
        if line1[1].to_i >= threshold
            agehash[line1[0]] = line1[2].to_i
        else
            break
        end
    end
end


f.close
#STDOUT.puts agehash.keys
#STDOUT.puts ""

current_year = nil
current_user = nil

PATHC = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\"
#PATHC = "C:\\Sasha\\D\\CassandraTemp\\SMCorpora\\"
subforum = "kansliga"
f = File.open("#{PATHC}familjeliv-#{subforum}_sentence.conllu","r:utf-8")

o2 = File.open("familjeliv-#{subforum}_start_end.tsv","w:utf-8")
o2.puts "username\tstartage\tendage"

authorhash = {}
array = []
tokens = 0
f.each_line do |line|
    line1 = line.strip
    #STDERR.puts line1
    if line1 == ""
        if !agehash[current_user].nil?
            current_age = current_year - agehash[current_user]

            if current_age < firstlasthash[current_user][0]
                firstlasthash[current_user][0] = current_age
            end
            if current_age > firstlasthash[current_user][1]
                firstlasthash[current_user][1] = current_age
            end

        end

    elsif line1[0] == "#"
        
        if line1.include?("# username")
            current_user = line1.split(" = ")[1]
        elsif line1.include?("# post_date")
            current_year = line1.split("=")[1].strip.split("-")[0].to_i
        end

    else
    end

end


firstlasthash.each_pair do |user,years|
    o2.puts "#{user}\t#{years[0]}\t#{years[1]}"
end

