require_relative 'read_cmd.rb'

outhash = process_cmd
corpora_and_labels = outhash["corpus_and_label"]
variable = outhash["variable"]
username = outhash["username"]
nvariants = outhash["nvariants"]
var_output = outhash["var_output"]
granularity = outhash["granularity"]
merged_label = outhash["merged_label"]

gran_hash = {"m" => "-----m"}
gran_addendum = gran_hash[granularity]

if ARGV.include?("nyordslistor")
    inputdir = "#{var_output}variables\\nyordslistor2"
else
    inputdir = "#{var_output}variables"
end


#convert to hashes of hashes
corpus_sizes = Hash.new(0) #Hash.new{|hash,key| hash[key] = Hash.new(0)}
v1abss = Hash.new(0)#Hash.new{|hash,key| hash[key] = Hash.new(0)}
v2abss = Hash.new(0)#Hash.new{|hash,key| hash[key] = Hash.new(0)}
#v1rel = Hash.new(0)
#v2rel = Hash.new(0)
#v1ipm = Hash.new(0)
#v2ipm = Hash.new(0)
periods = {}




corpora_and_labels.split(",").each do |corpus_and_label|
    maincorpus = corpus_and_label.split("-")[0]
    subcorpus = corpus_and_label.split("-")[1]
    file = File.open("#{inputdir}\\#{variable}#{gran_addendum}\\#{maincorpus}\\#{subcorpus}\\#{username}.tsv","r:utf-8")
    period_id = nil
    v1abs_id = nil
    v2abs_id = nil
    #v1rel_id = nil
    #v2rel_id = nil
    v1ipm_id = nil
    v2ipm_id = nil

    file.each_line.with_index do |line,index|
        line2 = line.strip.split("\t")
        if index == 0
            period_id = line2.include?("period")
            v1abs_id = line2.include?("v1abs")
            v2abs_id = line2.include?("v2abs")
            #v1rel_id = line2.include?("v1rel")
            #v2rel_id = line2.include?("v2rel")
            v1ipm_id = line2.include?("v1ipm")
            #v2ipm_id = line2.include?("v2ipm")
        else
            period = line2[period_id]
            periods[period] = true
            v1abs = line2[v1abs_id]
            v1ipm = line2[v1ipm_id]
            corpus_size = (v1abs.to_f/v1ipm*1000000).round
            corpus_sizes[period] += corpus_size
            v1abss[period] += v1abs
            if nvariants == 1
                
            elsif nvariants == 2
                v2abs = line2[v2abs_id]
                v2abss[period] += v2abs
                #v2ipm = line2[v2ipm_id]
            
            end
        end
    end

    file.close
end

o = File.open("#{inputdir}\\#{variable}#{gran_addendum}\\#{merged_label}\\all\\#{username}.tsv","w:utf-8")
if nvariants == 1
    o.puts "period\tv1ipm\tv1abs"
elsif nvariants == 2
    o.puts "period\ttotal\tv1abs\tv2abs\tv1rel\tv2rel\tv1ipm\tv2ipm"
end

periods.each_key do |period|
    v1abs = v1abss[period]
    v1ipm = v1abs/corpus_sizes[period]*1000000
    if nvariants == 1
        o.puts "#{period}\t#{v1ipm}\t#{v1abs}"
    elsif nvariants == 2
        v2abs = v2abss[period]
        v2ipm = v2abs.to_f/corpus_sizes[period]*1000000
        v1rel = v1abs.to_f/(v1abs + v2abs)
        v2rel = v2abs.to_f/(v1abs + v2abs)
        total = v1abs + v2abs
        o.puts "#{period}\t#{total}\t#{v1abs}\t#{v2abs}\t#{v1rel}\t#{v2rel}\t#{v1ipm}\t#{v2ipm}"
    end
end
