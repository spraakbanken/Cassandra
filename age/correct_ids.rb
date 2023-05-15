f = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\de(m)_filtered_familjeliv_age.tsv","r:utf-8")
o = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\de(m)_filtered_familjeliv_age2.tsv","w:utf-8")

f.each_line.with_index do |line, index|
    if index > 0
        line2 = line.strip.split("\t")
        id = line2[1].to_i - 1
        line3 = [line2[0],id,line2[2..-1]].flatten.join("\t")
    else
        line3 = line.strip
    end
    o.puts line3
end