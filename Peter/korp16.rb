#fix the corpus reader
#add default for qtype
#plot: several graphs

require_relative 'corpus_tools.rb'
#require_relative 'read_cmd.rb'
#CONSIDER:
#adding timespan: 

#CHECK WHETHER DONE:
#fix empty usernames when querying "authors"
#filter out "Anonym"

require 'uri'
require 'net/http'
require 'json'

#STDERR.puts nvariants


#outhash = process_cmd
corpus_and_label = "flashback-dator"#outhash["corpus_and_label"]
query = "time"#outhash["query"]
#variable = outhash["variable"]
username = "all_users" #outhash["username"]
#nvariants = outhash["nvariants"] 
only_process_local = false # outhash["only_process_local"]
granularity = "y"#outhash["granularity"]
variable_source = "korp_queries.rb"#outhash["variable_source"]
#var_output = outhash["var_output"]

maincorpus = corpus_and_label.split("-")[0]
corpus = corpus_and_label
label = corpus_and_label.split("-")[1..-1].join("-")
useradd = ""



STDOUT.puts "variable\tnvariants\tquery"

start_to_finish = get_years(corpus_and_label,true)
gran_addendum = {"y" => "", "m" => "&granularity=m"}

f = File.open("korp_queries.rb","r:utf-8")

flag = 0
nvariants = 0
variable = ""

f.each_line do |line| 
    line1 = line.strip
    
    
    if flag == 0 and line1.include?("#label = ")
        flag = 1
        variable = line1.split(" = ")[1]
        STDERR.puts variable
    elsif flag == 1 
        if line1.split(" = ")[0] == "variant1"
            nvariants = 1
        elsif line1.split(" = ")[0] == "variant2"
            nvariants = 2
        elsif line1 == ""
            flag = 2
        end
    end
    
    if flag == 2
        if query == "time"
            if variable != "total"
                variant1, variant2 = read_in_variable(variable,useradd,nvariants,variable_source)
                variant1.gsub!(" ","+")
                if nvariants == 2
                    variant2.gsub!("\"","\'") 
                    variant2.gsub!(" ","+")
                    p = URI::Parser.new
                    safe_uri = p.escape("https://ws.spraakbanken.gu.se/ws/korp/v8/count_time?cqp=((#{variant1})+|+(#{variant2}))#{gran_addendum[granularity]}&corpus=#{corpus}&subcqp0=#{variant1}&subcqp1=#{variant2}")
                    #STDERR.puts safe_uri
                elsif nvariants == 1
                    p = URI::Parser.new
                    safe_uri = p.escape("https://ws.spraakbanken.gu.se/ws/korp/v8/count_time?cqp=(#{variant1})#{gran_addendum[granularity]}&corpus=#{corpus}")
                end
            end
            
        end
        
        safe_uri.gsub!("+&+","+%26+")
        STDOUT.puts "#{variable}\t#{nvariants}\t#{safe_uri}"
        flag = 0
        
    end
end