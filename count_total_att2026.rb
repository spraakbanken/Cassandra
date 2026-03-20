verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]


corpus = "familjeliv"
total = 0
counter = 0
@startyear = 2004

path = "C:\\D\\DGU\\Repos\\Cassandra\\results\\att2026\\#{corpus}"

files = Dir.children(path)

files.each do |file|
    verb = file.split(".")[0].split("_")[1]
    
    if verblist.include?(verb)
        counter += 1
        f = File.open("#{path}\\#{file}","r:utf-8")
        f.each_line.with_index do |line,index|
            if index > 0
                line2 = line.strip.split("\t")
                year = line2[0].to_i
                if year >= @startyear
                    total += line2[1].to_i
                end
            end
        end
    end
end
STDERR.puts total,counter