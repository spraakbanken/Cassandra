
forum = "flashback"
authorhash = Hash.new{|hash,key| hash[key] = Hash.new}
#authorfile = File.open("results\\flashback_hbt(q)_resor.tsv","r:utf-8")
authorfile = File.open("results\\flashback_hbt(q).tsv","r:utf-8")
authors = {}
yearhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
authorfile.each_line.with_index do |line,index|
    if index > 0
        line2 = line.strip.split("\t")
        year = line2[0].to_i
        username = line2[1]
        #authors[username] = true
        v1rel = line2[-2].to_f
        v2rel = line2[-1].to_f
        if v2rel > v1rel
            authorhash[year][username] = "innovative"
            yearhash[year]["innovative"] += 1
        else
            authorhash[year][username] = "conservative"
            yearhash[year]["conservative"] += 1
        end
    end
end


STDOUT.puts "year\tc\ti"

authorhash.each_pair do |year,users|
    c = 0
    i = 0
    users.each_pair do |user,status|
        if status == "conservative"
            c += 1
            
        elsif status == "innovative"
            i += 1
        end
    end   
    STDOUT.puts "#{year}\t#{c}\t#{i}"
end

