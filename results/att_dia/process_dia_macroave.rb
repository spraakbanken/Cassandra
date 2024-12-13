verblist = ["försöka", "fortsätta", "glömma", "komma", "slippa", "sluta", "vägra", "behaga", "lova", "planera", "riskera"]
total_threshold = 0

threshold_per_year = 4
threshold_years = 4
threshold_authors = 4

verblist.each do |verb|
    STDERR.puts verb
    authoryear_v2 = Hash.new{|hash, key| hash[key] = Hash.new}
    authoryear_total = Hash.new{|hash, key| hash[key] = Hash.new}
    
    STDERR.puts "Reading"
    f = File.open("familjeliv_#{verb}_t#{total_threshold}.tsv","r:utf-8")
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            year = line2[0].to_i
            author = line2[1]
            total = line2[4].to_f
            #STDERR.puts year, author, total
            #sleep(1)
            v2rel = line2[-1].to_f
            if total >= threshold_per_year
                #STDERR.puts "CHECK!"
                authoryear_v2[author][year] = v2rel
                authoryear_total[author][year] = total
            end
        end
    end
    f.close
    STDERR.puts "Writing"
    o = File.open("macroave\\#{verb}_#{threshold_per_year}_#{threshold_years}.tsv", "w:utf-8")
    o.puts "year\tv2rel_macroave\ttotal_occurrences\ttotal_authors"
    
    
        #STDERR.puts author,authorhash.keys.length
        
    for year in 2003..2022 do
        sum_occurrences = 0.0
        sum_authors = 0.0
        sum_v2rel = 0.0

        authoryear_v2.each_pair do |author,authorhash|
            total = authoryear_total[author][year].to_f
            if total == 0 #safety check. Unneccessary if threshold_per_year > 0
                v2rel = "NA"
            else
                v2rel = authorhash[year].to_f
                sum_occurrences += total
                sum_v2rel += v2rel
                sum_authors += 1
            end
        end
        #o.puts "#{year}\t#{v2rel}\t#{total}"
        if sum_authors > threshold_authors
            macroave = sum_v2rel / sum_authors
            o.puts "#{year}\t#{macroave}\t#{sum_occurrences}\t#{sum_authors}"
        end
    end
    

    
    o.close    
end