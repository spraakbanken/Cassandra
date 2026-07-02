load 'wellander_vars.rb'
generate_inf_queries = false
run_inf_queries = false
generate_half_queries = false
run_half_queries = false
compare_queries = false
w_plot_retriever = true
corpus = "pressfull"
timecorpus = "svt-all"
coverage = 0.5

#$verblist.each do |verb|
#STDERR.puts verb
if generate_inf_queries
    system "ruby w_generate_inf_queries.rb"
end

if run_inf_queries
    system "ruby w_run_inf_queries.rb #{corpus}"
end

if generate_half_queries
    system "ruby w_generate_half_queries.rb #{corpus} #{coverage}"
end

if run_half_queries
    system "ruby w_run_half_queries.rb #{timecorpus}"
end

if compare_queries
    system "ruby w_compare_queries.rb #{timecorpus} #{coverage}"
end

if w_plot_retriever
    system "ruby w_plot_retriever.rb #{coverage}"
end
#end