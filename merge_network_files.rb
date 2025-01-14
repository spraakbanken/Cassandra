corpus = "familjeliv"

PATH = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora"
filelist = Dir.children(PATH)

out = File.open("#{corpus}_all_post.conllu", "w:utf-8")

filelist.each do |filename|
    if filename.include?(corpus) and filename.include?("_post_anonymized.conllu")
        STDERR.puts filename
        f = File.open("#{PATH}\\#{filename}","r:utf-8")
        f.each_line do |line|
            out.puts line
        end
        f.close
    end
end