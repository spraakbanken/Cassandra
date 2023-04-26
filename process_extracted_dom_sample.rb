#***

require_relative "corpus_tools"
require_relative 'net_tools.rb'
require_relative 'read_cmd.rb'

outhash = process_cmd
corpus_and_label = outhash["corpus_and_label"]
maincorpus = corpus_and_label.split("-")[0]

query = outhash["query"]
variable = outhash["variable"]
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

corpora = read_corpus_label(corpus_and_label,outputmode="array")

def cleant(parameter)
    
    if !parameter.nil?
        parameter.gsub!("\t","")
    end
    return parameter
end

conll_file = File.open("#{var_output}#{variable}.txt","w:utf-8")
sample_file = File.open("#{var_output}#{variable}.tsv","w:utf-8")
header = "unique_id\ttoken_id\tword\tpos\tpos_correct\tdeprel\tdeprel_correct\tdephead_correct\tlemma_correct\tcomment\tmaincorpus\tsubcorpus"


sample_file.puts header
input_dir = "#{var_output}Jsons\\#{variable}\\Jsons_#{maincorpus}"
filelist = Dir.children(input_dir) 

#corpora.each do |corpus|
    
    
    
    #output_dir = "#{var_output}Tsvs\\#{variable}\\Tsvs_#{maincorpus}"

    #if !Dir.exist?("#{var_output}Tsvs\\#{variable}\\")
    #    Dir.mkdir("#{var_output}Tsvs\\#{variable}\\")
    #end

    #if !Dir.exist?(output_dir)
    #    Dir.mkdir(output_dir)
    #end


    
    #date_sep = {"familjeliv" => " ", "svt" => "T", "da" => " ", "flashback" => " ", "twitter" => " "}
    
unique_id = 0
filelist.each do |filename2|
    filename2 = filename2.encode('utf-8')
    if filename2.split(".")[1] == "json"
        STDERR.puts filename2
        STDERR.puts "Processing Korp's output..."
        
       
        file = File.read("#{input_dir}\\#{filename2}")
        data_hash = JSON.parse(file)
        if data_hash["ERROR"].nil?
              
            hits = data_hash["kwic"]
                    
            #if maincorpus == "familjeliv"
            #    gender_hash = extract_gender
            #    age_hash = extract_age
            #end
             
            hits.each do |hit|
                #if hit["tokens"][0]["ref"].to_i == 1 
                unique_id += 1
                match_start = hit["match"]["start"].to_i
                match_end = hit["match"]["end"].to_i
            
                #output_array = []
                #output_array << unique_id
                corpus_from_json = hit["corpus"]
                #output_array << corpus_from_json
                maincorpus = get_maincorpus(corpus_from_json)
                conll_file.puts "#sent_id = #{unique_id}; de-dem-dom_id = #{match_end-1}"
                tokens = hit["tokens"]
                dword = ""
                dpos = ""
                ddeprel = ""
                
                tokens.each.with_index do |token, tindex|
                    id = token["ref"].to_i
            
                    word = token["word"]
                    pos = token["pos"]
                    msd = token["msd"]
                    lemma = token["lemma"]
                    deprel = token["deprel"]
                    dephead = token["dephead"].to_i
                    conll_file.puts "#{id}\t#{word}\t#{lemma}\t#{pos}\t#{msd}\t#{deprel}\t#{dephead}"
                    if id == match_end - 1
                        dword = word
                        dpos = pos
                        ddeprel = deprel
                    end
                end
                conll_file.puts ""
                sample_file.puts "#{unique_id}\t#{match_end-1}\t#{dword}\t#{dpos}\t\t#{ddeprel}\t\t\t\t\t#{maincorpus}\t#{corpus_from_json}"
                
                
                
                
                
            end
                
        else
            STDERR.puts "Error! #{filename2}"
            #errorlist.puts "#{corpus}\t#{searchyear}\t#{searchmonth}"
        end
        
    end #corpora
end
#    STDERR.puts "Discarded:#{discarded}"
    
#end

