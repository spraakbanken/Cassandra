corpora = ["flashback", "dator", "droger", "ekonomi", "fordon", "hem", "kultur", "livsstil", "mat", "ovrigt", "politik", "samhalle", "sex", "sport", "vetenskap"]
corpora.each do |corpus|
    STDERR.puts corpus
    system "ruby query_conllu.rb hbt(q) 0 #{corpus}"
end