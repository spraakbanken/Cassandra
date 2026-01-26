require 'fileutils'

dirs = Dir.children("C:\\D\\DGU\\Repos\\Cassandra\\variables")

dirs.each do |dir|
    
    if dir.include?("ss90_") and !dir.include?("-----m")
        tsvname = "C:\\D\\DGU\\Repos\\Cassandra\\variables\\#{dir}\\familjeliv\\all\\all_users.tsv"
        FileUtils.cp(tsvname,"C:\\D\\DGU\\Repos\\Cassandra\\results\\ss90_2026\\#{dir}.tsv")
    end
end