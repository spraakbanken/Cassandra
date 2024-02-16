corpora = ["dator", "droger", "ekonomi", "flashback", "fordon", "hem", "kultur", "livsstil", "mat", "ovrigt", "politik", "samhalle", "sex", "sport", "vetenskap"]
corpora.each do |corpus|
    STDERR.puts corpus
    system "ruby query_conllu.rb kommer_att 10 #{corpus}"
end