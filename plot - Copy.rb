#input
#total_threshold
#condition on threshold

require 'rinruby'
require_relative 'read_cmd.rb'
require_relative 'date_tools.rb'


gran_hash = {"m" => "-----m"}

qtype = "time"
query = "time"

outhash = process_cmd
corpus_and_label = outhash["corpus_and_label"]
corpus_and_label2 = outhash["corpus_and_label2"] 
whattoplot = outhash["whattoplot"] 
max_predef = outhash["max"]
dir = outhash["dir"]
nyl_year = outhash["nyl_year"]
variable = outhash["variable"]
username = outhash["username"]
nvariants = outhash["nvariants"] 
only_process_local = outhash["only_process_local"]
granularity = outhash["granularity"]
total_threshold = outhash["total_threshold"]
var_output = outhash["var_output"]

maincorpus = corpus_and_label.split("-")[0]
subcorpus = corpus_and_label.split("-")[1]

if !Dir.exist?(dir)
    Dir.mkdir(dir)
end
R.eval "setwd('#{dir}')"

if ARGV.include?("nyordslistor")
    inputdir = "#{var_output}variables\\nyordslistor2"
else
    inputdir = "#{var_output}variables"
end


gran_addendum = gran_hash[granularity]

file = File.open("#{inputdir}\\#{variable}#{gran_addendum}\\#{maincorpus}\\#{subcorpus}\\#{username}.tsv","r:utf-8")
#file = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\hbt_authors\\Varnagel.tsv","r:utf-8")
header = []
years = []
labels = []
values = []
whattoplot_id = nil
period_id = nil
#absmonth_id = nil
file.each_line.with_index do |line,index|
    if index > 0
        line1 = line.split("\t")
        if granularity == "y"
            years << line1[period_id].to_i
        elsif granularity == "m"
            labels << line1[period_id]
            years << absmonth(line1[period_id])
        end
        
        if nvariants == 1 or (nvariants == 2 and line1[1].to_i >= total_threshold)
        
            values << line1[whattoplot_id].to_f
        else
            values << "NA"
        end
        
    else
        header = line.strip.split("\t")
        whattoplot_id = header.index(whattoplot)
        period_id = header.index("period")
        #absmonth_id = header.index("absmonth")
    end
end
file.close

if !corpus_and_label2.nil?
    maincorpus2 = corpus_and_label2.split("-")[0]
    subcorpus2 = corpus_and_label2.split("-")[1]
    file = File.open("#{inputdir}\\#{variable}\\#{maincorpus2}\\#{subcorpus2}\\#{username}.tsv","r:utf-8")
    header = []
    years2 = []
    values2 = []
    #whattoplot_id = nil
    file.each_line.with_index do |line,index|
        #line1 = line.strip.gsub("#","")
        #STDERR.puts line1
        if index > 0
            line1 = line.split("\t")
            years2 << line1[0].to_i
            #STDERR.puts line
            if nvariants == 1 or (nvariants == 2 and line1[1].to_i >= total_threshold)
                values2 << line1[whattoplot_id].to_f
            else
                values2 << "NA"
            end
            #year = year_hash[nyord]
        else
            #header = line.strip.split("\t")
            #whattoplot_id = header.index(whattoplot)
            #STDERR.puts whattoplot
            #STDERR.puts header
            #STDERR.puts whattoplot_id
        end
    end

end



if !years.empty?
        
    R.assign "years", years
    R.assign "values", values
    
    if !corpus_and_label2.nil?
        R.assign "years2", years2
        R.assign "values2", values2 
        
    end
    
    
    if max_predef != nil
        max = max_predef
    elsif (nvariants == 1 or whattoplot == "total") and corpus_and_label2.nil?
        max = values.max
    elsif (nvariants == 1 or whattoplot == "total") and !corpus_and_label2.nil?
        max = [values.max, values2.max].max
    elsif nvariants == 2
        max = 1
    end
    R.assign "maxvalue", max
    R.eval "jpeg(file='#{variable.gsub(":","_colon_")}_#{maincorpus}_#{subcorpus}_#{maincorpus2}_#{subcorpus2}_#{username.gsub(":","_colon_")}_#{whattoplot}.jpg')"
    if nvariants == 1
        ylab = "ipm"
    else
        ylab = "proportion incoming"
    end
    if granularity == "y"
        R.eval "plot(years, values, type='b',xlab = 'time', ylab = '#{ylab}', ylim = c(0,maxvalue))"
    elsif granularity == "m"
        R.eval "plot(years, values, type='l',xaxt='n', ylab = '#{ylab}', ylim = c(0,maxvalue))"
        R.assign "labels",labels
        R.eval "axis(1, at=years,labels = labels)"
    end
    
    if !corpus_and_label2.nil?
        R.eval "lines(years2, values2, type='b', col = 'blue', lwd = 2)"
    end
    if !nyl_year.nil?
        R.eval "abline(v=#{nyl_year}, col = 'red', lwd = 2)"
    end
	
	
    
    R.eval "dev.off()"
    
end
