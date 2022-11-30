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
more_corpora_and_labels = outhash["more_corpora_and_labels"].to_s.split(",")

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

def extract_data(corpus_and_label,inputdir,variable,username,gran_addendum,whattoplot,nvariants,total_threshold)
    maincorpus = corpus_and_label.split("-")[0]
    subcorpus = corpus_and_label.split("-")[1]
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
            if gran_addendum.nil?
                years << line1[period_id].to_i
            elsif gran_addendum == "-----m"
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
    return [years,values,labels,maincorpus,subcorpus]
end

more_years = []
more_values = []
#more_labels = []
colors = ["blue","green","yellow","gray","magenta","brown","orange"]

plot_data = extract_data(corpus_and_label,inputdir,variable,username,gran_addendum,whattoplot,nvariants,total_threshold)
years = plot_data[0]
values = plot_data[1]
labels = plot_data[2]
maincorpus = plot_data[3]
subcorpus = plot_data[4]

if !years.empty?
       

    
    R.assign "years", years
    R.assign "values", values
    R.assign "labels",labels
    all_names = ["#{maincorpus}_#{subcorpus}"]
    all_values = []
    all_years = [years]
    
    if !more_corpora_and_labels.empty?
        all_values = [values]
        
        
        more_corpora_and_labels.each.with_index do |extra_corpus_and_label,index|
            plot_data = extract_data(extra_corpus_and_label,inputdir,variable,username,gran_addendum,whattoplot,nvariants,total_threshold)
            more_years[index] = plot_data[0]
            more_values[index] = plot_data[1]
            #more_labels[index] = plot_data[2]
            all_values << plot_data[1]
            all_years << plot_data[0]
            all_names << "#{plot_data[3]}_#{plot_data[4]}"
        end
        all_values.flatten!
    end
    all_years.flatten!
    all_years.uniq!
    
    minyear = all_years.min
    maxyear = all_years.max
    #STDERR.puts minyear
    #STDERR.puts maxyear
    R.assign "minyear",minyear
    R.assign "maxyear",maxyear
 
    namelist = all_names.join("_")
    
    if max_predef != nil
        max = max_predef
    elsif (nvariants == 1 or whattoplot == "total") and more_corpora_and_labels.empty?
        max = values.max
    elsif (nvariants == 1 or whattoplot == "total") and !more_corpora_and_labels.empty?
        max = [all_values].max
    elsif nvariants == 2
        max = 1
    end

    R.assign "maxvalue", max
    R.eval "jpeg(file='#{variable.gsub(":","_colon_")}_#{namelist}_#{username.gsub(":","_colon_")}_#{whattoplot}.jpg')"
    if nvariants == 1
        ylab = "ipm"
    else
        ylab = "proportion incoming"
    end
    if granularity == "y"
        #R.eval "plot(0,0,xlab = 'HEY', ylab = '#{ylab}', xlim = c(minyear,maxyear), ylim = c(0,maxvalue),frame.plot=FALSE)"
        R.eval "plot(values~years, type='b',xlab = 'time', ylab = '#{ylab}', xlim = c(minyear,maxyear), ylim = c(0,maxvalue))"
    elsif granularity == "m"
        R.eval "plot(years, values, type='l',xaxt='n', ylab = '#{ylab}', xlim = c(minyear,maxyear),ylim = c(0,maxvalue))"
        
        R.eval "axis(1, at=years,labels = labels)"
    end
    
    if !more_corpora_and_labels.empty?
        for i in 0..more_corpora_and_labels.length-1
            R.assign "years2", more_years[i]
            R.assign "values2", more_values[i]
            color = colors[i]
            if granularity == "y"
                type = "b"
            elsif granularity == "m"
                type = "l" 
            end

            R.eval "lines(years2, values2, type='#{type}', col = '#{color}', lwd = 2)"
        end
        R.assign "namelist",all_names
        R.assign "colors",colors
        R.eval "legend('topleft', legend=namelist,col=colors,lty=1,bty='n')"

    end

    if !nyl_year.nil?
        R.eval "abline(v=#{nyl_year}, col = 'red', lwd = 2)"
    end
	
	
    
    R.eval "dev.off()"
    
end
