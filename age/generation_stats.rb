f1 = File.open("familjeliv_start_end.tsv","r:utf-8")
startage = {}

f1.each_line.with_index do |line,index|
    if index > 0 
        line2 = line.strip.split("\t")
        startage[line2[0]] = line2[1].to_i
    end
end


f2 = File.open("all_age_1000_merged.tsv","r:utf-8")
generations_persons = Hash.new(0)
generations_tokens =  Hash.new(0)

def generation(year)
    if year < 1970
        agebin = "Gen1"
    elsif year < 1980
        agebin = "Gen2"
    elsif year < 1990 
        agebin = "Gen3"
    else
        agebin = "Gen4"
    end
    agebin
end

f2.each_line.with_index do |line,index|
    if index > 0 
        line2 = line.strip.split("\t")
        name = line2[0]
        ntokens = line2[1].to_i
        yob = line2[2].to_i
        if ntokens >= 10000
            if startage[name].nil?
                STDERR.puts name
            end
            if startage[name].to_i >= 18 
                gen = generation(yob)
                generations_persons[gen] += 1
                generations_tokens[gen] += ntokens
            end
        end
    end
end


STDERR.puts "#{generations_persons}"
STDERR.puts "#{generations_tokens}"