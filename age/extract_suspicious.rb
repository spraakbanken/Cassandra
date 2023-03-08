PATHC = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\"
subforum = ARGV[0]
threshold = 10000
age_threshold = 0

f0 = File.open("C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\age\\all_age_1000_merged.tsv","r:utf-8")
birthyearhash = {}


f0.each_line.with_index do |line,index|
    line1 = line.strip.split("\t")
    if index > 0 
        if line1[1].to_i >= threshold
            birthyearhash[line1[0]] = line1[2].to_i
        else
            break
        end
    end
end


f = File.open("familjeliv-#{subforum}_start_end.tsv", "r:utf-8")
ages = [16, 17, 18, 19, 20]
maxage = ages.max
nperage = 10
agehash = Hash.new{|hash,key| hash[key] = Array.new}
f.each_line.with_index do |line, index|
    if index > 0
        line2 = line.strip.split("\t")
        startage = line2[1].to_i
        
        if startage > maxage
            break
        end
        user = line2[0]
        if !birthyearhash[user].nil?
            agehash[startage] << line2[0]
        end
    end
end
STDERR.puts agehash


extracted = {}

ages.each do |startage|
    STDERR.puts startage
    userarray = agehash[startage].sample(nperage)
    STDERR.puts userarray
    userarray.each do |user|
        extracted[user] = startage
    end
end
#extracted.flatten!
STDERR.puts extracted

f2 = File.open("#{PATHC}familjeliv-#{subforum}_sentence_age#{threshold}_#{age_threshold}.conllu","r:utf-8")
lines_per_user = Hash.new{|hash,key| hash[key] = Array.new}
current_user = ""
pre = []
do_pre = true
f2.each_line do |line|
    line1 = line.strip
    
    if line1[0] == "#"
        if line1.include?("# username")
            current_user = line1.split(" = ")[1]
            if !extracted[current_user].nil?
                lines_per_user[current_user] << pre.clone
            end
            do_pre = false
            pre = []
        elsif line1.include?("# age = ")
            do_pre = true
        end
    end
    if do_pre
        pre << line1
    else 
        if !extracted[current_user].nil?
            lines_per_user[current_user] << line1
        end
    end

end

if !Dir.exist?(subforum)
    Dir.mkdir(subforum)
end

lines_per_user.each_pair do |user,lines|
    startage = extracted[user]
    lines.flatten!
    o = File.open("#{subforum}\\familjeliv-#{subforum}_#{user}_#{startage}.conllu","w:utf-8")
    o.puts lines
end