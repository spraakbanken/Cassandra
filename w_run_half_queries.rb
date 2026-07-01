load 'wellander_vars.rb'

corpus = ARGV[0]

$verblist.each.with_index do |verb,index|
    system "ruby korp16.rb --qtype time --corpus #{corpus} --variable #{verb}_whalf --variable_source w_half_queries.txt wellander"
    system "ruby korp16.rb --qtype time --corpus #{corpus} --variable #{verb}_wfull --variable_source w_half_queries.txt wellander"
end



