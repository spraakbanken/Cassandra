f = File.open("all_age_1000_merged.tsv","r:utf-8")
o = File.open("sample_with_bys.tsv","w:utf-8")

hash = {}
f.each_line do |line|
    line2 = line.strip.split("\t")
    hash[line2[0]] = line2[2]
end

["StephanieH", "ostbåge", "mica", "fågeln", "apriltjej", "Happyme", "MammaTillTindra", "FruFrank", "Ofeliaa", "fluu", "Aiwendil", "Hmpf", "Jannie", "chariots", "MammaTillNeoh", "Ellieott", "Felicia111", "KristallSplitter", "Beloved", "Chessy", "CuteElliz", "Pusselbiten86", "ÖnskarHoppas", "Johannah", "sannamamma", "Tjatte", "Puppan", "Merle", "Snurran", "Tokstollen", "supermamman", "Mach", "Johje", "Moder Jord", "Karlin", "nelli", "copycat", "TypeONegative", "Nanna", "Lizzan", "äppelmos", "nummerfem", "Jeenkan", "123321", "Denise87", "Lily of the valley", "loveisintheair", "Melwinsmamma", "Lellehs", "Mamman88"].each do |user|
    o.puts "#{user}\t#{hash[user]}"
end

