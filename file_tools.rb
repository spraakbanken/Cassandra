def forbidden_symbol(username)
    username2 = username.clone
    ["<", ">", ":", "\"", "/", "\\", "|", "?","*"].each.with_index do |sym, index|
        username2.gsub!(sym, "_forbidden_symbol#{index}_")
    end
    return username2
end



def find_relevant_column(input,type,line)
    hash2 = {}
    if type == "header"
        input.each do |key|
            hash2[key] = line.index(key)
        end
    elsif type == "line"
        input.each_pair do |key,value|
            #STDERR.puts key, value, line[value]
            hash2[key] = line[value]
        end
    end
    hash2
end

#header = {}
#f.each_line.with_index do |line, index| 
#    line1 = line.split("\t")
#    if index > 0
#        id_values = find_relevant_column(header,"line",line1) 
#    else 
#        header = find_relevant_column(array,"header",line1) 
#    end
#end