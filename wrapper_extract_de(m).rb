require_relative "corpus_tools"
require_relative 'net_tools.rb'
require_relative 'read_cmd.rb'

corpus_and_label = ARGV[0]
corpora = read_corpus_label(corpus_and_label,outputmode="array")
granularity = "n"
variable = "de(m)_filtered"
#limit = 2

corpora.each do |corpus|
    STDERR.puts corpus
    system "ruby api_extract_universal.rb --variable #{variable} --corpus #{corpus} --granularity #{granularity}" # --limit #{limit}

end