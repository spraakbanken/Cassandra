f = File.open("C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\age\\all_age_1000_merged.tsv","r:utf-8")
agehash = {}
threshold = 10000
firstlasthash = Hash.new{|hash,key| hash[key] = [100,0]}
age_threshold = 0



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
f = File.open("#{PATHC}familjeliv-kansliga_sentence.conllu","r:utf-8")

###o = File.open("#{PATHC}familjeliv-kansliga_sentence_age#{threshold}_#{age_threshold}_inverted.conllu","w:utf-8")
o2 = File.open("#{PATHC}familjeliv-kansliga_start_end.tsv","w:utf-8")
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

            #if current_age >=  age_threshold
            if current_age < age_threshold
                authorhash[current_user] = true
                ###o.puts "# age = #{current_age}"
                if current_age < 20
                    agebin = "<20"
                elsif current_age < 30
                    agebin = "20--29"
                elsif current_age < 40
                    agebin = "30--39"
                elsif current_age < 50
                    agebin = "40--49"
                elsif current_age < 60
                    agebin = "50--59"
                else
                    agebin = ">60"
                end
                ###o.puts "# agebin = #{agebin}"

                ###o.puts array
                ###o.puts ""
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
        tokens += 1
        array << line1
    end

end

firstlasthash.each_pair do |user,years|
    o2.puts "#{user}\t#{years[0]}\t#{years[1]}"
end

__END__
STDERR.puts authorhash.keys.length
STDERR.puts tokens