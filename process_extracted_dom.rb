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
predictor_file = File.open("#{var_output}#{variable}.tsv","w:utf-8")
header = "unique_id\tmaincorpus\tsubcorpus\tword\tpos\tdeprel"
predictor_file.puts header
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
            
                output_array = []
                output_array << unique_id
                corpus_from_json = hit["corpus"]
                output_array << corpus_from_json
                if maincorpus != "gp" and maincorpus != "bloggmix" and maincorpus != "twitter"
                    date = hit["structs"]["text_date"].split(date_sep[maincorpus])[0]
                    time = hit["structs"]["text_date"].split(date_sep[maincorpus])[1]
                elsif maincorpus == "twitter"
                    date = hit["structs"]["text_datetime"].split(date_sep[maincorpus])[0]
                    time = hit["structs"]["text_datetime"].split(date_sep[maincorpus])[1]
                else
                    date = hit["structs"]["text_date"]
                    time = nil
                end
                year = date.split("-")[0]
                month = date.split("-")[1]
                output_array << year
                output_array << month
                if maincorpus == "familjeliv" or maincorpus == "flashback"
                    username = hit["structs"]["text_username"]
                    thread_id = hit["structs"]["thread_id"]
                elsif maincorpus == "svt"
                    username = hit["structs"]["text_authors"]
                    section = hit["structs"]["text_section"]
                elsif maincorpus == "gp"
                    username = hit["structs"]["text_author"]
                    section = hit["structs"]["text_section"]
                    shortsection = hit["structs"]["text_sectionshort"]
                elsif maincorpus == "da"
                    username = hit["structs"]["text_author"]
                elsif maincorpus == "twitter"
                    username = hit["structs"]["user_username"]
                elsif maincorpus == "bloggmix"
                    username = hit["structs"]["blog_title"]
                end
                
                if maincorpus == "gp" 
                    message_id = hit["structs"]["text_title"]
                elsif maincorpus == "bloggmix"
                    message_id = "#{hit["structs"]["text_title"]}___#{hit["structs"]["text_url"]}"
                else
                    message_id = hit["structs"]["text_id"]
                end
                if maincorpus == "flashback"
                    userid = hit["structs"]["text_userid"]
                end
                output_array << cleant(username)
                birthyear = age_hash[username]
                gender = gender_hash[username]

                if maincorpus == "bloggmix" and !hit["structs"]["blog_age"].nil? and hit["structs"]["blog_age"] != ""and !hit["structs"]["blog_age"].include?("-")
                    if !(hit["structs"]["blog_age"].to_i > 80 or hit["structs"]["blog_age"].to_i < 12)
                        birthyear = year.to_i - hit["structs"]["blog_age"].to_i
                        birthyears << birthyear
                    end
                end
                
                
                output_array << gender
                output_array << birthyear
                output_array << cleant(message_id)
                output_array << cleant(thread_id)
                
                tokens = hit["tokens"]
                
                trigram1 = []
                trigram2 = []
                trigram3 = []
                postrigram1 = []
                postrigram2 = []
                postrigram3 = []
                
                pos = ""
                msd = ""
                token_array = []
                pos_array = []
                key_index = 0
                tokens.each.with_index do |token, tindex|
                    token_array << token["word"].downcase
                    pos_array << token["pos"]
                   
                    #lexlist.each do |lemgram| #will be a problem if there are several instances of the same lemgram in the example (googlar och googlar) or "twittrar och kvittrar" ***change to identification by match
                    #    if token["lex"].gsub("|","") == lemgram
                    #        key_index = tindex
                        if tindex == match_start
                            pos = token["pos"]
                            msd = token["msd"]
                        end
                    #        break
                    #    end
                    #end
                end
                key_index = match_start
            
                if key_index == 2
                    trigram1 = cleant([token_array[0],token_array[1],token_array[2]].join(" "))
                    trigram2 = cleant([token_array[1],token_array[2],token_array[3]].join(" "))
                    trigram3 = cleant([token_array[2],token_array[3],token_array[4]].join(" "))
                    postrigram1 = cleant([pos_array[0],pos_array[1],pos_array[2]].join(" "))
                    postrigram2 = cleant([pos_array[1],pos_array[2],pos_array[3]].join(" "))
                    postrigram3 = cleant([pos_array[2],pos_array[3],pos_array[4]].join(" "))

                elsif key_index == 1
                    trigram1 = cleant(["SPECSTART",token_array[0],token_array[1]].join(" "))
                    trigram2 = cleant([token_array[0],token_array[1],token_array[2]].join(" "))
                    trigram3 = cleant([token_array[1],token_array[2],token_array[3]].join(" "))
                    postrigram1 = cleant(["SPEC",pos_array[0],pos_array[1]].join(" "))
                    postrigram2 = cleant([pos_array[0],pos_array[1],pos_array[2]].join(" "))
                    postrigram3 = cleant([pos_array[1],pos_array[2],pos_array[3]].join(" "))
                elsif key_index == 3
                    trigram1 = cleant([token_array[1],token_array[2],token_array[3]].join(" "))
                    trigram2 = cleant([token_array[2],token_array[3],token_array[4]].join(" "))
                    trigram3 = cleant([token_array[3],token_array[4],"SPECEND"].join(" "))
                    postrigram1 = cleant([pos_array[1],pos_array[2],pos_array[3]].join(" "))
                    postrigram2 = cleant([pos_array[2],pos_array[3],pos_array[4]].join(" "))
                    postrigram3 = cleant([pos_array[3],pos_array[4],"SPEC"].join(" "))
                elsif key_index == 0
                    trigram1 = cleant(["SPECSTART","SPECSTART",token_array[0]].join(" "))
                    trigram2 = cleant(["SPECSTART",token_array[0],token_array[1]].join(" "))
                    trigram2 = cleant([token_array[0],token_array[1],token_array[2]].join(" "))
                    postrigram1 = cleant(["SPEC","SPEC",pos_array[0]].join(" "))
                    postrigram2 = cleant(["SPEC",pos_array[0],pos_array[1]].join(" "))
                    postrigram2 = cleant([pos_array[0],pos_array[1],pos_array[2]].join(" "))
                elsif key_index == 4
                    trigram1 = cleant([token_array[2],token_array[3],token_array[4]].join(" "))
                    trigram2 = cleant([token_array[3],token_array[4],"SPECEND"].join(" "))
                    trigram3 = cleant([token_array[4],"SPECEND","SPECEND"].join(" "))
                    postrigram1 = cleant([pos_array[2],pos_array[3],pos_array[4]].join(" "))
                    postrigram2 = cleant([pos_array[3],pos_array[4],"SPEC"].join(" "))
                    postrigram3 = cleant([pos_array[4],"SPEC","SPEC"].join(" "))
                end
                output_array << pos
                output_array << msd
                output_array << trigram1
                output_array << trigram2
                output_array << trigram3
                output_array << postrigram1
                output_array << postrigram2
                output_array << postrigram3
                
                
                
                
                predictor_file.puts output_array.join("\t")
                
            end
                
        else
            STDERR.puts "Error! #{filename2}\t#{searchyear}\t#{searchmonth}"
            #errorlist.puts "#{corpus}\t#{searchyear}\t#{searchmonth}"
        end
        
    end #corpora
end
#    STDERR.puts "Discarded:#{discarded}"
    
#end

