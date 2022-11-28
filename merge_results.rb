require_relative 'read_cmd.rb'

outhash = process_cmd
corpora_and_labels = outhash["corpus_and_label"]
variable = outhash["variable"]
username = outhash["username"]
nvariants = outhash["nvariants"]
var_output = outhash["var_output"]
granularity = outhash["granularity"]
gran_hash = {"m" => "-----m"}
gran_addendum = gran_hash[granularity]

corpus_size = Hash.new(0)
v1abs = Hash.new(0)
v2abs = Hash.new(0)
v1rel = Hash.new(0)
v2rel = Hash.new(0)
v1ipm = Hash.new(0)
v2ipm = Hash.new(0)



corpora_and_labels.split(",").each do |corpus_and_label|
    maincorpus = corpus_and_label.split("-")[0]
    subcorpus = corpus_and_label.split("-")[1]
    file = File.open("#{inputdir}\\#{variable}#{gran_addendum}\\#{maincorpus}\\#{subcorpus}\\#{username}.tsv","r:utf-8")
    period_id = nil
    v1abs_id = nil
    v2abs_id = nil
    v1rel_id = nil
    v2rel_id = nil
    v1ipm_id = nil
    v2ipm_id = nil

    file.each_line.with_index do |line,index|
        line2 = line.strip.split("\t")
        if index == 0
            period_id = line2.include?("period")
            v1abs_id = line2.include?("v1abs")
            v2abs_id = line2.include?("v2abs")
            v1rel_id = line2.include?("v1rel")
            v2rel_id = line2.include?("v2rel")
            v1ipm_id = line2.include?("v1ipm")
            v2ipm_id = line2.include?("v2ipm")
        else
            if nvariants == 1

            elsif nvariants == 2

            end
        end
    end

    file.close
end