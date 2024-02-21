def find_intersection(years_of_interest, total_threshold, list)
    
    #list = ["komma", "försöka", "slippa", "vägra", "sluta", "fortsätta"]#, "glömma"]
    
    #7: 10
    #6: 26
    #5: 43
    
    arrays = Hash.new{|hash,key| hash[key] = Array.new}
    
    list.each do |verb|
        f = File.open("ss30_#{years_of_interest}\\familjeliv_#{verb}_t#{total_threshold}_#{years_of_interest}.tsv","r:utf-8")
    
        f.each_line.with_index do |line,index|
            if index > 0
                speaker = line.split("\t")[1]
                arrays[verb] << speaker
            end
        end
    end
    
    intersection = arrays.values[0]
    #STDERR.puts intersection.join("\t")
    for i in 1..arrays.values.length-1 do
        intersection = intersection.intersection(arrays.values[i])
        #STDERR.puts intersection.join("\t")
    end
    #STDERR.puts intersection.join("\t")
    
    return intersection
end