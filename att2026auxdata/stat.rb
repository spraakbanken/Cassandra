noatt = {}
f = File.open("korp-statistics_svt_2017.tsv","r:utf-8")

f.each_line.with_index do |line,index|
    if index > 1
        line.gsub!("\"","")
        line2 = line.strip.split("\t")
        verb = line2[0]
        freq = line2[1].to_f
        noatt[verb] = freq
    end
end

#STDERR.puts "#{noatt}"
att = {}
f = File.open("korp-statistics_att_svt_2017.tsv","r:utf-8")

f.each_line.with_index do |line,index|
    if index > 1
        line.gsub!("\"","")
        line2 = line.strip.split("\t")
        verb = line2[0]
        freq = line2[1].to_f
        att[verb] = freq
    end
end

noatt.each_pair do |verb,fomission|
    fatt = att[verb]
    if !fatt.nil? and (fomission+fatt) >= 10
        ratio = fomission / (fomission+fatt)
        STDOUT.puts "#{verb}\t#{ratio}\t#{fomission+fatt}"
    end
end