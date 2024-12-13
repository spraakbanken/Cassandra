verblist = ["försöka", "fortsätta", "glömma", "komma", "slippa", "sluta", "vägra", "behaga", "lova", "planera", "riskera"]
total_threshold = 0

threshold_per_year = 4


verblist.each do |verb|
    STDERR.puts verb
    #authoryear_v2 = Hash.new{|hash, key| hash[key] = Hash.new}
    #authoryear_total = Hash.new{|hash, key| hash[key] = Hash.new}
    #per_year = {}
    per_year_total = Hash.new(0)
    per_year_abs2 = Hash.new(0.0)
    STDERR.puts "Reading"
    f = File.open("familjeliv_#{verb}_t#{total_threshold}.tsv","r:utf-8")
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            year = line2[0].to_i
            #author = line2[1]
            total = line2[4].to_f
            #STDERR.puts year, author, total
            #sleep(1)
            v2abs = line2[-3].to_f
            if total >= threshold_per_year
                #STDERR.puts "CHECK!"
                #authoryear_v2[author][year] = v2rel
                #authoryear_total[author][year] = total
                per_year_total[year] += total
                per_year_abs2[year] += v2abs
            end
        end
    end
    f.close
    STDERR.puts "Writing"
    o = File.open("aggregate\\#{verb}_aggregate_#{threshold_per_year}.tsv", "w:utf-8")
    o.puts "year\tv2abs\tv2rel\ttotal"
    for year in 2003..2022 do
        total = per_year_total[year]
        v2abs = per_year_abs2[year]
        if total == 0
            v2rel = "NA"
        else
            v2rel = v2abs/total
        end
	
        o.puts "#{year}\t#{v2abs}\t#{v2rel}\t#{total}"
    end
    o.close
    
end