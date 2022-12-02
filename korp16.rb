#fix the corpus reader
#add default for qtype
#plot: several graphs

require_relative 'corpus_tools.rb'
require_relative 'read_cmd.rb'
#CONSIDER:
#adding timespan: 

#CHECK WHETHER DONE:
#fix empty usernames when querying "authors"
#filter out "Anonym"

require 'uri'
require 'net/http'
require 'json'

#STDERR.puts nvariants


outhash = process_cmd
corpus_and_label = outhash["corpus_and_label"]
query = outhash["query"]
variable = outhash["variable"]
username = outhash["username"]
nvariants = outhash["nvariants"] 
only_process_local = outhash["only_process_local"]
granularity = outhash["granularity"]
variable_source = outhash["variable_source"]
var_output = outhash["var_output"]

maincorpus = corpus_and_label.split("-")[0]
label = corpus_and_label.split("-")[1..-1].join("-")




#STDERR.puts corpus_and_label
if !ARGV.include?("--nolabel")
    corpus = read_corpus_label(corpus_and_label)
    nolabel = false
else
    corpus = corpus_and_label
    nolabel = true
end


if ARGV.include?("nyordslistor")
    outputdir = "#{var_output}variables\\nyordslistor2"
else
    outputdir = "#{var_output}variables"
end

if !Dir.exist?(outputdir)
    Dir.mkdir(outputdir)
end

if variable.to_s != ""
    variable_as_dirname = variable.gsub(":","_colon_")
    if granularity != "y"
        variable_as_dirname = "#{variable_as_dirname}-----#{granularity}"
    end
    
    if !Dir.exist?("#{outputdir}\\#{variable_as_dirname}") 
        Dir.mkdir("#{outputdir}\\#{variable_as_dirname}")
    end
    if !Dir.exist?("#{outputdir}\\#{variable_as_dirname}\\#{maincorpus}") 
        Dir.mkdir("#{outputdir}\\#{variable_as_dirname}\\#{maincorpus}")
    end
    if !Dir.exist?("#{outputdir}\\#{variable_as_dirname}\\#{maincorpus}\\#{label}") 
        Dir.mkdir("#{outputdir}\\#{variable_as_dirname}\\#{maincorpus}\\#{label}")
    end
end


if query == "time"
    if label != ""
        filename = "#{outputdir}\\#{variable_as_dirname}\\#{maincorpus}\\#{label}\\#{username}"
    else
        filename = "#{outputdir}\\#{variable_as_dirname}\\#{maincorpus}\\#{username}"
    end
elsif query == "authors"
    if !Dir.exist?("#{query}\\#{maincorpus}") 
        Dir.mkdir("#{query}\\#{maincorpus}") 
    end
    #if !Dir.exist?("#{query}\\#{maincorpus}\\#{label}") 
    #    Dir.mkdir("#{query}\\#{maincorpus}\\#{label}") 
    #end
    if !year_for_authors.nil?
        filename = "#{query}\\#{maincorpus}\\#{label}_by_date"
    else
        filename = "#{query}\\#{maincorpus}\\#{label}"
    end
end


start_to_finish = get_years(corpus_and_label,nolabel)
STDERR.puts start_to_finish
__END__


useradd = ""
if username != "" and username != "all_users"
    if variable != "total" and variable != "empty" and variable != "authors" #all posts of the same user
        useradd = "+&+_.text_username+=+'#{username}'"
    else
        useradd = "_.text_username+=+'#{username}'"
    end
    #STDERR.puts useradd
end

gran_addendum = {"y" => "", "m" => "&granularity=m"}


if query == "time"
    if variable != "total"
        #if ARGV.include?("nyordslistor")
        #    variant1 = "[word = '#{variable}']"
        #else
            variant1, variant2 = read_in_variable(variable,useradd,nvariants, variable_source)
            STDERR.puts variant1 
        #end
        #variant1.gsub!("\"","\'") 
        variant1.gsub!(" ","+")
        if nvariants == 2
            variant2.gsub!("\"","\'") 
            variant2.gsub!(" ","+")
            safe_uri = URI.escape("https://ws.spraakbanken.gu.se/ws/korp/v8/count_time?cqp=((#{variant1})+|+(#{variant2}))#{gran_addendum[granularity]}&corpus=#{corpus}&subcqp0=#{variant1}&subcqp1=#{variant2}")
        elsif nvariants == 1
            safe_uri = URI.escape("https://ws.spraakbanken.gu.se/ws/korp/v8/count_time?cqp=(#{variant1})#{gran_addendum[granularity]}&corpus=#{corpus}")
        end
    else
        variant1 = "[#{useradd}]"
        safe_uri = URI.escape("https://ws.spraakbanken.gu.se/ws/korp/v8/count_time?cqp=((#{variant1}))&corpus=#{corpus}&subcqp0=#{variant1}")
    end

elsif query == "authors"
    if year_for_authors.nil?
        safe_uri = URI.escape("https://ws.spraakbanken.gu.se/ws/korp/v8/struct_values?corpus=#{corpus}&struct=text_username&count=true")
    else
        safe_uri = URI.escape("https://ws.spraakbanken.gu.se/ws/korp/v8/struct_values?corpus=#{corpus}&struct=text_username>text_date&count=true")
    end

    
end

safe_uri.gsub!("+&+","+%26+")
STDERR.puts safe_uri

jsonflag = false
for attempt_counter in 1..5
    STDERR.puts "Attempt #{attempt_counter}"
    uri = URI(safe_uri)
    if !only_process_local
        res = Net::HTTP.get_response(uri)
        j = File.open("#{filename}.json", "w:utf-8")
        j.puts res.body if res.is_a?(Net::HTTPSuccess)
        j.close
    end

    file = File.read("#{filename}.json")
    data_hash = JSON.parse(file)
    if data_hash["ERROR"].nil?
        jsonflag = true
    end
    if jsonflag
        break
    end
end 


o = File.open("#{filename}.tsv", "w:utf-8")
STDERR.puts filename
if query == "time"
    if variable != "total"
        if nvariants == 2
            o.puts "period\ttotal\tv1abs\tv2abs\tv1rel\tv2rel\tv1ipm\tv2ipm"
            totalh = data_hash["combined"][0]["absolute"]
            variant1h = data_hash["combined"][1]["absolute"]
            variant2h = data_hash["combined"][2]["absolute"]
            variant1h_ipm = data_hash["combined"][1]["relative"]
            variant2h_ipm = data_hash["combined"][2]["relative"]
            periods = [variant1h.keys, variant2h.keys].flatten.uniq.sort
            #for i in (start..finish) do 
            for i in start_to_finish do 
            #for i in periods
                
                if granularity == "y"
                    period = i.to_s  
                    v1rel = sprintf("%.10f",variant1h[period].to_f/totalh[period].to_f)
                    v2rel = sprintf("%.10f",variant2h[period].to_f/totalh[period].to_f)
                    o.puts "#{period}\t#{totalh[period].to_i}\t#{variant1h[period].to_i}\t#{variant2h[period].to_i}\t#{v1rel}\t#{v2rel}\t#{variant1h_ipm[period].to_f}\t#{variant2h_ipm[period].to_f}"
                elsif granularity == "m"
                    for m in 1..12 do
                        if m < 10 
                            mm = "0#{m}"
                        else
                            mm = m
                        end
                        period = "#{i}#{mm}"
                        v1rel = sprintf("%.10f",variant1h[period].to_f/totalh[period].to_f)
                        v2rel = sprintf("%.10f",variant2h[period].to_f/totalh[period].to_f)
                        o.puts "#{period}\t#{totalh[period].to_i}\t#{variant1h[period].to_i}\t#{variant2h[period].to_i}\t#{v1rel}\t#{v2rel}\t#{variant1h_ipm[period].to_f}\t#{variant2h_ipm[period].to_f}"
                    end
                end
            end
        elsif nvariants == 1
            o.puts "period\tv1ipm\tv1abs"
            variant1h = data_hash["combined"]["relative"]
            variant1h_abs = data_hash["combined"]["absolute"]
            periods = [variant1h.keys].flatten.uniq.sort
            #for i in (start..finish) do 
            for i in start_to_finish do 
            #for i in periods
                
                if granularity == "y"
                    period = i.to_s
                    v1rel = variant1h[period]
                    v1abs = variant1h_abs[period]
                    o.puts "#{period}\t#{v1rel}\t#{v1abs}"
                elsif granularity == "m"
                    for m in 1..12 do
                        if m < 10 
                            mm = "0#{m}"
                        else
                            mm = m
                        end
                        period = "#{i}#{mm}"
                        v1rel = variant1h[period]
                        v1abs = variant1h_abs[period]
                        o.puts "#{period}\t#{v1rel}\t#{v1abs}"
                    end
                end
            end
        end
    else
        o.puts "period\ttotal"
        totalh = data_hash["combined"][0]["absolute"]
        #for i in (start..finish) do 
        for i in start_to_finish do 
            period = i.to_s
            o.puts "#{period}\t#{totalh[period].to_i}"
        end
    end
elsif query == "authors" and 
    if period_for_authors.nil?
        o.puts "author\tntokens"
        totalh = data_hash["combined"]["text_username"]
        totalh = totalh.transform_values!(&:to_i)
        totalh_sorted = totalh.sort_by{ |k, v| v }.reverse! 
        totalh_sorted.each do |pair|
            o.puts "#{pair[0]}\t#{pair[1]}"
        end
    else
        o.puts "author\tperiod\tntokens"
        totalh = data_hash["combined"]["text_username>text_date"]
        totalh2 = Hash.new{|hash, key| hash[key] = Hash.new(0)}
        totalh.each_pair do |author,datehash|
            datehash.each_pair do |date,ntokens|
                totalh2[author][date.gsub("\"","").split("-")[0].to_i] += ntokens.to_i
            end
        end
        hash_given_period = Hash.new(0)
        totalh2.each_pair do |author,periodhash|
            periodhash.each_pair do |period,ntokens|
                if period == period_for_authors
                    hash_given_period[author] += ntokens
                end
                o.puts "#{author}\t#{period}\t#{ntokens}"
            end
        end
        o.close
        o2 = File.open("#{query}\\#{maincorpus}\\#{label}#{period_for_authors}.tsv", "w:utf-8")
        o2.puts "author\tntokens"
        
        sorted = hash_given_period.sort_by{ |k, v| v }.reverse! 
        sorted.each do |pair|
            o2.puts "#{pair[0]}\t#{pair[1]}"
        end
    end
end

