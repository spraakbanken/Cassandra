f = File.open("C:\\Sasha\\D\\DGU\\Resources\\Embeddings\\w2v_SwedishCONLL17embeddings\\swe_w2v.embed","r:utf-8")
#o = File.open("swe_w2v.txt","w:utf-8")
list = ["fortsätta", "försöka", "glömma", "komma", "planera", "riskera", "slippa", "sluta", "vägra", "behaga", "lova"]
f.each_line.with_index do |line, index|
  if index > 0
    word = line.strip.split(" ")[0]
    if list.include?(word)
        STDOUT.puts line.gsub(" ", "\t")
        list.delete(word)
        STDERR.puts list.length
        if list.length == 0
            break
        end
    end
    if index % 100000 == 0
        STDERR.puts index
    end
  end
end
