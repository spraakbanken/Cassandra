#input
#total_threshold
#condition on threshold

require 'rinruby'


#create a read-in tool?
#total_threshold = 5
total_threshold = 20
if !ARGV.include?("--qtype")
    abort "Cassandra says: qtype not specified, must be \"time\" or \"authors\""
elsif !ARGV.include?("--corpus")
    abort "Cassandra says: corpus not specified"
else
    query = ARGV[ARGV.index("--qtype") + 1]
    corpus_and_label = ARGV[ARGV.index("--corpus") + 1]
    if ARGV.include?("--corpus2")
        corpus_and_label2 = ARGV[ARGV.index("--corpus2") + 1]
    end

    
    #if query == "authors"
        
    if query == "time"

        if !ARGV.include?("--variable")
            abort "Cassandra says: variable not specified, must be specified if qtype == time"
        else    
            variable = ARGV[ARGV.index("--variable") + 1]
            if !ARGV.include?("--user")
                username = "all_users"
            else
                username = ARGV[ARGV.index("--user") + 1]
            end

            if !ARGV.include?("--nvariants")
                nvariants = 2
            else
                nvariants = ARGV[ARGV.index("--nvariants") + 1].to_i
            end

            if !ARGV.include?("--whattoplot")
                if nvariants == 2
                    whattoplot = "v2rel"
                elsif nvariants == 1
                    whattoplot = "v1ipm"
                end
            else
                whattoplot = ARGV[ARGV.index("--whattoplot") + 1]
            end

            if !ARGV.include?("--max")
                max_predef = nil
            else
                max_predef = ARGV[ARGV.index("--max") + 1].to_f
            end

            if !ARGV.include?("--dir")
                dir = "all_plots"
            else
                dir = ARGV[ARGV.index("--dir") + 1]
            end

            if ARGV.include?("--nyl_year")
                nyl_year = ARGV[ARGV.index("--nyl_year") + 1].to_i
            end

        end
    elsif query == "authors"
        if ARGV.include?("--year")
            year_for_authors = ARGV[ARGV.index("--year") + 1].to_i
        end
    else
        abort "Cassandra says: unknown qtype, must be \"time\" or \"authors\""
    end
    #if ARGV.include?("--local")
    #    only_process_local = true
    #end
end
maincorpus = corpus_and_label.split("-")[0]
subcorpus = corpus_and_label.split("-")[1]

R.eval "setwd('C:/Sasha/D/DGU/CassandraMy/KorpApi/#{dir}')"


#if nvariants == 1
#    value_index = 1
#elsif nvariants == 2
#    if whattoplot == "v2rel"
#       value_index = 5
#    elsif whattoplot == "total"
#       value_index = 1
#    end
#end

if ARGV.include?("nyordslistor")
    inputdir = "variables\\nyordslistor2"
else
    inputdir = "variables"
end


file = File.open("#{inputdir}\\#{variable}\\#{maincorpus}\\#{subcorpus}\\#{username}.tsv","r:utf-8")
#file = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\hbt_authors\\Varnagel.tsv","r:utf-8")
header = []
years = []
values = []
whattoplot_id = nil
file.each_line.with_index do |line,index|
    #line1 = line.strip.gsub("#","")
    #STDERR.puts line1
    if index > 0
        line1 = line.split("\t")
        years << line1[0].to_i
        #STDERR.puts line
        if nvariants == 1 or (nvariants == 2 and line1[1].to_i >= total_threshold)
        #if nvariants == 1 or (nvariants == 2 and line1[1].to_i + line1[2].to_i >= total_threshold)
            values << line1[whattoplot_id].to_f
        else
            values << "NA"
        end
        #year = year_hash[nyord]
    else
        header = line.strip.split("\t")
        whattoplot_id = header.index(whattoplot)
        #STDERR.puts whattoplot
        #STDERR.puts header
        #STDERR.puts whattoplot_id
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
    #values_temp = values.clone
    #values_temp.delete("NA")
    #if !values_temp.empty?
        #o.puts "#{nyord}\t#{values_temp.max - values_temp.min}"
        
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
    R.eval "plot(years, values, type='b',xlab = 'years', ylab = '#{ylab}', ylim = c(0,maxvalue))"
    if !corpus_and_label2.nil?
        R.eval "lines(years2, values2, type='b', col = 'blue', lwd = 2)"
    end
    if !nyl_year.nil?
        R.eval "abline(v=#{nyl_year}, col = 'red', lwd = 2)"
    end
	
	
    
    R.eval "dev.off()"
    #end
end
