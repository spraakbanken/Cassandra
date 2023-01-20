corpus = ARGV[0]
maincorpus = corpus.split("-")[0]
subcorpus = corpus.split("-")[1..-1].join("-")
variable = ARGV[1]
path = "C:\\Sasha\\D\\DGU\\CassandraMy\\KorpApi\\variables\\#{variable}\\age_corr\\"
o = File.open("#{path}#{corpus}.tsv","w:utf-8")
o.puts "author\tage\tv2rel\tyear\tbin\tbinlabel"
o2 = File.open("#{path}#{corpus}_change.tsv","w:utf-8")
o2.puts "author\tage\tchange\tstart_year\tbin\tbinlabel"
o_mean = File.open("#{path}#{corpus}_mean.tsv","w:utf-8")
o_mean.puts "age\tv2rel\tiqr\tbin\tbinlabel"
o2_mean = File.open("#{path}#{corpus}_change_mean.tsv","w:utf-8")
o2_mean.puts "age\tchange\tiqr\tbin\tbinlabel"
o3 = File.open("#{path}#{corpus}_change_range.tsv","w:utf-8")
o3.puts "author\tage_at_start\tspeed\trange\tbin\tbinlabel"

author_year = Hash.new{|hash, key| hash[key] = Hash.new}
age_v2rel = Hash.new{|hash, key| hash[key] = Array.new}
age_change = Hash.new{|hash, key| hash[key] = Array.new}
author_age = Hash.new{|hash, key| hash[key] = Hash.new}
blacklist = {}


def bin(age)
    if age < 20
        bin = 1
        label = "<20"
    elsif age < 30
        bin = 2
        label = "20--29"
    elsif age < 40
        bin = 3
        label = "30--39"
    elsif age < 50
        bin = 4
        label = "40--49"
    elsif age < 60
        bin = 5
        label = "50--59"
    else
        bin = 6
        label = "60+"
    end
    return bin, label
end


def stats(input, type)
    if type == "hash"
        sent_array = input.values
    elsif type == "array"
        sent_array = input
    end
    sent_sum = 0.0
    sent_array.each do |sent|
        sent_sum += sent
    end
    mean = sent_sum/sent_array.length
    
    sumsq = 0.0
    sent_array.each do |sent|
        sumsq += (mean - sent)*(mean - sent)
    end
    sd = Math.sqrt(sumsq/sent_array.length)
    return mean, sd
end

require "rinruby"


for year in 2003..2021 do
    f = File.open("#{path}#{corpus}_#{year}.tsv","r:utf-8")
    f.each_line.with_index do |line, index|
        if index > 0
            line1 = line.strip.split("\t")
            
            if !blacklist[line1[0]]
                age = year - line1[1].to_i
                if age < 15 or age > 80
                    blacklist[line1[0]] = true
                else
                    author_year[line1[0]][year] = line1[2].to_f
                    author_age[line1[0]][year] = age
                    age_v2rel[age] << line1[2].to_f
                    agebin, label = bin(age)
                    o.puts "#{line1[0]}\t#{age}\t#{line1[2]}\t#{year}\t#{agebin}\t#{label}"
                    
                    
                end
            end

        end
    end
end

#STDERR.puts "#{author_age}"

author_year.each_pair do |author, yearhash|
    #STDERR.puts author
    if yearhash.keys.length > 1
        #STDERR.puts "#{yearhash}"
        #STDERR.puts "#{author_age}"
        #total_delta = 0.0
        prev_v2rel = ""
        yearhash.each_pair do |year, v2rel|
            if prev_v2rel != ""
                #total_delta += v2rel - prev_v2rel
                age_change[author_age[author][year]] <<  v2rel - prev_v2rel
                agebin, label = bin(author_age[author][year])
                o2.puts "#{author}\t#{author_age[author][year]}\t#{v2rel - prev_v2rel}\t#{year}\t#{agebin}\t#{label}"
            end
            prev_v2rel = v2rel
        end
        ave_delta = (yearhash[yearhash.keys.max] - yearhash[yearhash.keys.min])/(yearhash.keys.max - yearhash.keys.min + 1)
        agebin, label = bin(author_age[author][yearhash.keys.min])
        o3.puts "#{author}\t#{author_age[author][yearhash.keys.min]}\t#{ave_delta}\t#{yearhash.keys.max - yearhash.keys.min + 1}\t#{agebin}\t#{label}"
        #STDERR.puts "#{author_age}"
        
        #age_change[author_age[author][yearhash.keys.min]] << ave_delta

        #o2.puts "#{author}\t#{author_age[author][yearhash.keys.min]}\t#{ave_delta}\t#{range}\t#{agebin}\t#{label}"
    end

end

age_v2rel.each_pair do |age, array|
    R.assign "array", array
    iqr = R.pull "IQR(array)"
    mean = stats(array,"array")[0]
    agebin, label = bin(age)
    o_mean.puts "#{age}\t#{mean}\t#{iqr}\t#{agebin}\t#{label}"
end

age_change.each_pair do |age, array|
    R.assign "array", array
    iqr = R.pull "IQR(array)"
    mean = stats(array,"array")[0]
    agebin, label = bin(age)
    o2_mean.puts "#{age}\t#{mean}\t#{iqr}\t#{agebin}\t#{label}"
end