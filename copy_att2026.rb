require 'fileutils'

dirs = Dir.children("C:\\D\\DGU\\Repos\\Cassandra\\variables")

#["familjeliv","flashback","forum"].each do |corpus|
["familjeliv-1","familjeliv-2"].each do |corpusf|
    corpus = corpusf.split("-")[0]
    subcorpus = corpusf.split("-")[1]
    dirs.each do |dir|
        
        if dir.include?("att2026_") and !dir.include?("-----m")
            tsvname = "C:\\D\\DGU\\Repos\\Cassandra\\variables\\#{dir}\\#{corpus}\\#{subcorpus}\\all_users.tsv"
            FileUtils.cp(tsvname,"C:\\D\\DGU\\Repos\\Cassandra\\results\\att2026\\#{corpusf}\\#{dir}.tsv")
        end
    end

end