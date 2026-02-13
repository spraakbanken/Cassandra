require 'fileutils'

dirs = Dir.children("C:\\D\\DGU\\Repos\\Cassandra\\variables")

["familjeliv","flashback","forum"].each do |corpus|

    dirs.each do |dir|
        
        if dir.include?("att2026_") and !dir.include?("-----m")
            tsvname = "C:\\D\\DGU\\Repos\\Cassandra\\variables\\#{dir}\\#{corpus}\\all\\all_users.tsv"
            FileUtils.cp(tsvname,"C:\\D\\DGU\\Repos\\Cassandra\\results\\att2026\\#{corpus}\\#{dir}.tsv")
        end
    end

end