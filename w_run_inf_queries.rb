load 'wellander_vars.rb'

corpus = ARGV[0]

$verblist.each.with_index do |verb,index|
    system "ruby korp16.rb --qtype statistics --corpus #{corpus} --variable #{verb}_att_infstat --variable_source w_inf_queries.txt wellander"
    system "ruby korp16.rb --qtype statistics --corpus #{corpus} --variable #{verb}_noatt_infstat --variable_source w_inf_queries.txt wellander"
end



