f = File.open("C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\age\\all_age_1000_merged.tsv","r:utf-8")
agehash = {}
threshold = 10000
tokenhash = {}
age_threshold = 18
firstlasthash = Hash.new{|hash,key| hash[key] = [100,0]}




f.each_line.with_index do |line,index|
    line1 = line.strip.split("\t")
    if index > 0 
        if line1[1].to_i >= threshold
            tokenhash[line1[0]] = line1[1].to_i
            agehash[line1[0]] = line1[2].to_i
        else
            break
        end
    end
end
f.close

f2 = File.open("familjeliv_start_end.tsv","r:utf-8")
firstagehash = {}
f2.each_line.with_index do |line,index|
    line1 = line.strip.split("\t")
    
    firstagehash[line1[0]] = line1[1].to_i
    
end
f2.close

o = File.open("C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\age\\age_#{threshold}_firstage#{age_threshold}.tsv","w:utf-8")
o.puts "author\tntokens\tyear_of_birth"

agehash.each_pair do |speaker,age|

    firstage = firstagehash[speaker].to_i
    if firstage == 0
        STDERR.puts speaker
    end

    if firstage >= age_threshold
        o.puts "#{speaker}\t#{tokenhash[speaker]}\t#{age}"
    end
end
