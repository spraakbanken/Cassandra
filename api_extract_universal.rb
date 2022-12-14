require_relative 'net_tools.rb'
require_relative 'corpus_tools.rb'
require_relative 'read_cmd.rb'

def execute_query(show, context, cqp, gran_spec, structs, filename, corpus, errorlist, limit, sort, searchyear="", searchmonth="")
    dirty_query = "https://ws.spraakbanken.gu.se/ws/korp/v8/query?corpus=#{corpus}&end=#{limit}&default_within=sentence&default_context=#{context}&cqp=#{cqp}&show=#{show}&show_struct=#{structs}#{sort}"
    run_api_query(dirty_query, filename, corpus, errorlist, searchyear, searchmonth)
end



outhash = process_cmd
corpus_and_label = outhash["corpus_and_label"]
#STDERR.puts corpus_and_label
maincorpus = corpus_and_label.split("-")[0]
#STDERR.puts maincorpus
query = outhash["query"]
variable = outhash["variable"]
#username = outhash["username"]
#nvariants = outhash["nvariants"] 
only_process_local = outhash["only_process_local"]
granularity = outhash["granularity"]
variable_source = outhash["variable_source"]
var_output = outhash["var_output"]
context = outhash["context"]
limit = outhash["var_output"]
show = outhash["show"]
structs = outhash["structs"]
sort = outhash["sort"]
granularity = outhash["granularity"]


#variable = ARGV[0]
#STDERR. puts ARGV[0], ARGV[1]

corpora = read_corpus_label(corpus_and_label,outputmode="array")
#STDERR.puts corpora
#corpora = read_corpus_label(ARGV[1],"array")#read_corpus_label("flashback-all") #["twitter", "twitter-2015",#"twitter-2016","twitter-2017"] 
#STDERR.puts corpora
output_dir = "#{var_output}#{variable}\\Jsons_#{maincorpus}"

if !Dir.exist?("#{var_output}#{variable}\\")
    Dir.mkdir("#{var_output}#{variable}\\")
end

if !Dir.exist?(output_dir)
    Dir.mkdir(output_dir)
end


useradd = ""
variant1 = read_in_variable(variable,useradd,1)[0]
filename = "#{output_dir}\\#{variable}"

#limit = 1 #
errorlist = File.open("errorlist_#{maincorpus}.tsv", "w:utf-8")
#granularity = "none"
#gran_spec = ""

if maincorpus == "twitter"
    datespec = "text_datetime"
else
    datespec = "text_date"
end

breakpoint = variant1.index("]")
cqp1 = variant1[0..breakpoint-1] 
cqp2 = variant1[breakpoint..-1] 

show = "msd,lemma,pos,ref,lex,deprel,dephead" 

corpora.each do |corpus|
    STDERR.puts corpus
    structs = get_structs(corpus)

    if granularity == "n"
        
        gran_spec = ""
        cqp = "#{cqp1}#{gran_spec}#{cqp2}"
        execute_query(show, context, cqp, gran_spec, structs, filename, corpus, errorlist, limit, sort)
        
    elsif granularity == "y"
        start, finish = get_years(corpus)
        
        years = (start..finish).to_a
      

        years.each do |searchyear|
            STDERR.puts searchyear
            gran_spec = " & _.#{datespec} = '#{searchyear}.*'"
            cqp = "#{cqp1}#{gran_spec}#{cqp2}"
            execute_query(show, context, cqp, gran_spec, structs, filename, corpus, errorlist, limit, sort, searchyear)
        end #years 
    elsif granularity == "m"
        start, finish = get_years(corpus)
        
        years = (start..finish).to_a
        years.each do |searchyear|
            STDERR.puts searchyear
            
            months = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
        
            months.each do |searchmonth|
                STDERR.puts searchyear, searchmonth 
                gran_spec = " & _.#{datespec} = '#{searchyear}-#{searchmonth}.*'"
                cqp = "#{cqp1}#{gran_spec}#{cqp2}"
                execute_query(show, context, cqp, gran_spec, structs, filename, corpus, errorlist, limit, sort, searchyear, searchmonth)
            end #months
        end #years 
    else
        abort("Cassandra says: Granularity is not defined!")
    end
end    



