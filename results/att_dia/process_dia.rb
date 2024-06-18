verblist = ["försöka", "fortsätta", "glömma", "komma", "slippa", "sluta", "vägra", "behaga", "lova", "planera", "riskera"]
total_threshold = 0

threshold_per_year = 4
threshold_years = 4

verblist.each do |verb|
    STDERR.puts verb
    authoryear_v2 = Hash.new{|hash, key| hash[key] = Hash.new(0.0)}
    authoryear_total = Hash.new{|hash, key| hash[key] = Hash.new(0.0)}
    
    STDERR.puts "Reading"
    f = File.open("familjeliv_#{verb}_t#{total_threshold}.tsv","r:utf-8")
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            year = line2[0].to_i
            author = line2[1]
            total = line2[3].to_f
            v2rel = line2[-1].to_f
            if total >= threshold_per_year
                authoryear_v2[author][year] = v2rel
                authoryear_total[author][year] = total
            end
        end
    end
    f.close
    STDERR.puts "Writing"
    authoryear_v2.each_pair do |author,authorhash|
        if authorhash.keys.length >= threshold_years
            o = File.open("individuals\\#{verb}_#{author}_#{threshold_per_year}_#{threshold_years}.tsv"
            for year in 2003..2022 do
                o.puts "#{year}\t#{authorhash[year].to_f}\t#{authoryear_total[author][year].to_f}"
            end
        end
    end
    o.close
end