f = File.open("C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\age\\all_age_1000_merged2.tsv","r:utf-8")
agehash = {}

f.each_line.with_index do |line,index|
    line1 = line.strip.split("\t")
    if index > 0 
        if line1[1].to_i >= 500000
            agehash[line1[0]] = line1[2].to_i
        else
            break

        end

    end
    
end


f.close
STDOUT.puts agehash.keys
STDOUT.puts ""

current_year = nil
current_user = nil

f = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-adoption_sentence.conllu","r:utf-8")
o = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-adoption_sentence_age.conllu","w:utf-8")
authorhash = {}
array = []
f.each_line do |line|
    line1 = line.strip
    #STDERR.puts line1
    if line1 == ""
        #STDERR.puts current_user
        #STDERR.puts current_year
        authorhash[current_user] = true
        if !agehash[current_user].nil?
            current_age = agehash[current_user] - current_year
            if current_age >=  18
                o.puts "# age = #{current_age}"
                o.puts array
                o.puts ""
            end
        end
        array = []
    elsif line1[0] == "#"
        #STDERR.puts "fdg"
        if line1.include?("# username")
            current_user = line1.split(" = ")[1]
        elsif line1.include?("# post_date")
            current_year = line1.split("=")[1].strip.split("-")[0].to_i
        end
        array << line1
    else
        array << line1
    end

end
STDOUT.puts authorhash.keys